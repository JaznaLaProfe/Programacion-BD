-- Forma C
CREATE OR REPLACE PACKAGE pkg_eventos IS
    -- Variable 
    PERIODO_CONSULTA VARCHAR2(7);
    -- Funcion publica
    FUNCTION fn_total_boletos(p_evento NUMBER) RETURN NUMBER;
    -- Procedimiento publico
    PROCEDURE sp_insertar(p_evento NUMBER, p_total NUMBER,
    p_proporcion NUMBER, p_observacion VARCHAR2);
END;

-- Cuerpo del package
CREATE OR REPLACE PACKAGE BODY pkg_eventos IS
    -- Funcion publica
    FUNCTION fn_total_boletos(p_evento NUMBER) RETURN NUMBER
    IS
        -- Almacena el total de boletos
        total NUMBER;
    BEGIN
        -- obtiene el total de boletos reservados del evento en el periodo
        SELECT NVL(SUM(cantidad), 0) INTO total
        FROM reserva a JOIN boleto b ON(a.id_boleto = b.id_boleto)
        WHERE id_evento = p_evento AND 
        TO_CHAR(fecha_reserva, 'MM-YYYY') = PERIODO_CONSULTA;

        RETURN total;
    END;
    -- Procedimiento publico
    PROCEDURE sp_insertar(p_evento NUMBER, p_total NUMBER,
    p_proporcion NUMBER, p_observacion VARCHAR2)
    IS
        -- Almacena la descripcion tecnica del error
        mensaje_oracle errores_proceso.mensaje_tecnico%TYPE;
    BEGIN
        INSERT INTO bx_informe
        VALUES(p_evento, PERIODO_CONSULTA, p_total, p_proporcion,
        p_observacion);
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
        mensaje_oracle := SQLERRM;
        INSERT INTO errores_proceso
        VALUES(SEQ_ERROR.NEXTVAL, USER, mensaje_oracle, 
            'ERROR AL INSERTAR RESULTADO');
    END;    
END;

-- Funcion almacenada 1
CREATE OR REPLACE FUNCTION fn_total_periodo(p_periodo VARCHAR2)
RETURN NUMBER
IS
    -- Almacena el total de boletos reservados en el periodo
    total NUMBER;
BEGIN
    -- Obtiene la cantidad de boletos reservados en el periodo
    SELECT NVL(SUM(cantidad), 0) INTO total
    FROM reserva
    WHERE TO_CHAR(fecha_reserva, 'MM-YYYY') = p_periodo;

    RETURN total;
END;
-- Funcion almaccenada 2
CREATE OR REPLACE FUNCTION fn_categoria(p_reservados NUMBER)
RETURN VARCHAR2
IS
    -- Almacena la categoria
    categoria_x categoria_bx.categoria%TYPE;
    -- Almacena la descripcion tecnica del error
    mensaje_oracle errores_proceso.mensaje_tecnico%TYPE;    
BEGIN
    -- Obtiene la categoria 
    SELECT categoria INTO categoria_x
    FROM categoria_bx 
    WHERE p_reservados BETWEEN minimo AND maximo;

    RETURN categoria_x;
EXCEPTION WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
    mensaje_oracle := SQLERRM;
    INSERT INTO errores_proceso
    VALUES(SEQ_ERROR.NEXTVAL, USER, mensaje_oracle, 
            'ERROR AL RECUPERAR CATEGORIA');
    RETURN 'INDEFINIDA';
END;

-- Procedimiento principal
CREATE OR REPLACE PROCEDURE sp_informe_c(p_periodo VARCHAR2)
IS
    -- Almacena los eventos a procesar
    CURSOR c_eventos IS
        SELECT id_evento
        FROM evento;
    -- Almacena el total de boletos
    total_boletos NUMBER;
    -- Almacena el total del periodo
    total_periodo NUMBER;
    -- Almacena la proprocion
    proporcion bx_informe.total_b%TYPE;
    -- Almacena la clasificacion
    clasificacion bx_informe.observacion%TYPE;
BEGIN
    -- Setea la variable del package
    pkg_eventos.PERIODO_CONSULTA := p_periodo;
    -- Otiene el total de boletos del periodo
    total_periodo := fn_total_periodo(p_periodo);
    -- Procesar uno a uno cada evento
    FOR reg_evento IN c_eventos LOOP
        -- Obtiene el total de boletos del evento en el periodo
        total_boletos := pkg_eventos.fn_total_boletos(reg_evento.id_evento);
        -- Calcula la proporcion
        BEGIN
            proporcion := ROUND(total_boletos/total_periodo, 2);
        EXCEPTION WHEN ZERO_DIVIDE THEN
            proporcion := 0;
        END;
        -- Obtiene la clasificacion
        clasificacion := fn_categoria(total_boletos);
        -- Insertar resultado
        pkg_eventos.sp_insertar(reg_evento.id_evento, total_boletos,
        proporcion, clasificacion);
    END LOOP;
END;

-- Crea el trigger
CREATE OR REPLACE TRIGGER trg_informe_c
AFTER INSERT ON bx_informe
FOR EACH ROW
DECLARE
    -- Almacena la calificacion
    calificacion cx_resumen.rango%TYPE;
BEGIN
    -- Obtiene la calificacion
    calificacion := CASE
        WHEN :NEW.total_b <= 0.2 THEN 'POR MEJORAR'
        WHEN :NEW.total_b >= 0.21 AND :NEW.total_b <= 0.5 THEN 'EN PROCESO'
        ELSE 'IDEAL'
    END;
    INSERT INTO cx_resumen
    VALUES(:NEW.id_a, :NEW.id_b, :NEW.total_a, calificacion);
END;

SELECT * FROM bx_informe;
SELECT * FROM cx_resumen;

EXEC sp_informe_c('04-2023');