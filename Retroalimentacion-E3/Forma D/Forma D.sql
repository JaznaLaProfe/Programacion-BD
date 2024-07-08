-- Forma D
-- ENCABEZADO PACKAGE
CREATE OR REPLACE PACKAGE pkg_evento IS
    -- Variable
    PERIODO_CONSULTA VARCHAR2(7);
    -- Funcion publica
    FUNCTION fn_total_boletos(p_evento NUMBER) RETURN NUMBER;
    -- Procedimiento publico
    PROCEDURE sp_insertar(p_evento NUMBER, p_boletos NUMBER,
    p_proporcion NUMBER, p_observacion VARCHAR2);
END;
-- CUERPO PACKAGE
CREATE OR REPLACE PACKAGE BODY pkg_evento IS
    -- Funcion publica
    FUNCTION fn_total_boletos(p_evento NUMBER) RETURN NUMBER
    IS
        -- Almacena el total de boletos vendidos
        total NUMBER;
    BEGIN
        -- Obtiene el total de boletos vendidos del evento en el periodo
        SELECT NVL(SUM(cantidad),0) INTO total
        FROM detalleventa a JOIN boleto b ON(a.id_boleto = b.id_boleto)
        JOIN venta C ON(a.id_venta = c.id_venta)
        WHERE id_evento = p_evento AND
            TO_CHAR(fecha_venta, 'MM-YYYY') = PERIODO_CONSULTA;

        RETURN total;
    END;
    -- Procedimiento publico
    PROCEDURE sp_insertar(p_evento NUMBER, p_boletos NUMBER,
    p_proporcion NUMBER, p_observacion VARCHAR2)
    IS
        -- Almacena la descripcion tecnica del error 
        mensaje_error errores_proceso.mensaje_tecnico%TYPE;
    BEGIN
        INSERT INTO dx_informe
        VALUES(p_evento, PERIODO_CONSULTA, p_boletos, p_proporcion,
        p_observacion);
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
        mensaje_error := SQLERRM;
        INSERT INTO errores_proceso
        VALUES(SEQ_ERROR.NEXTVAL, USER, mensaje_error,
        'ERROR AL INSERTAR RESULTADO');
    END;
END;

-- Funcion almacenada 1
CREATE OR REPLACE FUNCTION fn_total_periodo(p_periodo VARCHAR2)
RETURN NUMBER
IS
    -- Almacena el total de boletos del periodo
    total NUMBER;
BEGIN
    -- Obtiene la cantidad de boletos vendidos en el periodo
    SELECT NVL(SUM(cantidad), 0) INTO total
    FROM detalleventa a JOIN venta b ON(a.id_venta = b.id_venta)
    WHERE TO_CHAR(fecha_venta, 'MM-YYYY') = p_periodo;

    RETURN total;
END;
-- Funcion almacenada 2
CREATE OR REPLACE FUNCTION fn_categoria(p_vendidos NUMBER)
RETURN VARCHAR2
IS
    -- Almacena la categoria a retornar
    categoria_x categoria_dx.categoria%TYPE;
    -- Almacena la descripcion tecnica del error 
    mensaje_error errores_proceso.mensaje_tecnico%TYPE;    
BEGIN
    -- Obtiene la categoria
    SELECT categoria INTO categoria_x
    FROM categoria_dx
    WHERE p_vendidos BETWEEN minimo AND maximo;

    RETURN categoria_x;
EXCEPTION WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
    mensaje_error := SQLERRM;
    INSERT INTO errores_proceso
    VALUES(SEQ_ERROR.NEXTVAL, USER, mensaje_error,
        'ERROR AL RECUPERAR LA CATEGORIA');
    RETURN 'INDEFINIDA';
END;

-- Procedimiento principal
CREATE OR REPLACE PROCEDURE sp_informe_d(p_periodo VARCHAR2)
IS
    -- Almacena los eventos a procesar
    CURSOR c_eventos IS
        SELECT id_evento
        FROM evento;
    -- Almacena el total de boletos vendidos
    total_vendidos NUMBER;
    -- Almacena el total de boletos del periodo
    total_periodo NUMBER;
    -- Almacena la proporcion
    proporcion dx_informe.total_b%TYPE;
    -- Almacena la categoria
    categoria dx_informe.observacion%TYPE;
BEGIN
    -- Setear el periodo de consulta en el package
    pkg_evento.PERIODO_CONSULTA := p_periodo;
    -- Obtiene el total de boletos del periodo
    total_periodo := fn_total_periodo(p_periodo);
    -- Procesar uno a uno cada evento
    FOR reg_evento IN c_eventos LOOP
        -- Obtiene el total de boletos vendidos
        total_vendidos := pkg_evento.fn_total_boletos(reg_evento.id_evento);
        BEGIN
            -- Calcula la proporcion 
            proporcion := ROUND(total_vendidos/total_periodo, 2);
        EXCEPTION WHEN ZERO_DIVIDE THEN
            proporcion := 0;
        END;
        -- Obtiene la categoria 
        categoria := fn_categoria(total_vendidos);
        -- Insertar resultado
        pkg_evento.sp_insertar(reg_evento.id_evento, total_vendidos, proporcion,
        categoria);
    END LOOP;
END;

-- Crear el trigger
CREATE OR REPLACE TRIGGER trg_informe_d
AFTER INSERT ON dx_informe
FOR EACH ROW
DECLARE
    -- Almacena la calificacion
    calificacion cx_resumen.rango%TYPE;
BEGIN
    -- Obtiene la calificacion
    calificacion := CASE
        WHEN :NEW.total_b <= 0.2 THEN 'POR MEJORAR'
        WHEN :NEW.total_b BETWEEN 0.21 AND 0.5 THEN 'EN PROCESO'
        ELSE 'IDEAL'
    END;
    INSERT INTO cx_resumen
    VALUES(:NEW.id_a, :NEW.id_b, :NEW.total_a, calificacion);
END;

SELECT * FROM dx_informe;
SELECT * FROM cx_resumen;

EXEC sp_informe_d('04-2024');