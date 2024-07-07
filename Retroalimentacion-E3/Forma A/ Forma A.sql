-- Forma A
-- Encabezado
CREATE OR REPLACE PACKAGE pkg_ventas IS
    -- Variable
    PERIODO_CONSULTA VARCHAR2(7);
    -- Funcion publica
    FUNCTION fn_total_boletos(p_categoria NUMBER) RETURN NUMBER;
    -- Procedimiento publico
    PROCEDURE sp_inertar(p_categoria NUMBER, p_cantidad NUMBER,
    p_proporcion NUMBER, p_observacion VARCHAR2);
END;
-- Cuerpo del package
CREATE OR REPLACE PACKAGE BODY pkg_ventas IS
    -- Funcion publica
    FUNCTION fn_total_boletos(p_categoria NUMBER) RETURN NUMBER
    IS
        -- Almacena el total de boletos
        total NUMBER;
    BEGIN
        SELECT NVL(SUM(cantidad),0) INTO total
        FROM detalleventa a JOIN boleto b ON(a.id_boleto = b.id_boleto)
        JOIN venta c ON(c.id_venta = a.ID_VENTA)
        WHERE id_categoria = p_categoria AND 
            TO_CHAR(fecha_venta, 'MM-YYYY') = PERIODO_CONSULTA;

        RETURN total;
    END;
    -- Procedimiento publico
    PROCEDURE sp_inertar(p_categoria NUMBER, p_cantidad NUMBER,
    p_proporcion NUMBER, p_observacion VARCHAR2)
    IS
        -- Almacena la descripcion del error
        mensaje_error errores_proceso.mensaje_tecnico%TYPE;
    BEGIN
        INSERT INTO cx_informe
        VALUES(p_categoria, PERIODO_CONSULTA, p_cantidad,
        p_proporcion, p_observacion);
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
    -- Almacena el total de boletos vendidos
    total NUMBER;
BEGIN
    -- Obtiene el total de boletos vendidos
    SELECT NVL(SUM(cantidad), 0) INTO total
    FROM detalleventa a JOIN venta b ON(a.id_venta = b.id_venta)
    WHERE TO_CHAR(fecha_venta, 'MM-YYYY') = p_periodo;

    RETURN total;
END;
-- Funcion almacenada 2
CREATE OR REPLACE FUNCTION fn_categoria(p_venidos NUMBER)
RETURN VARCHAR2
IS
    -- Almacena la categoria a retornar
    categoria_c categoria_cx.categoria%TYPE;
    -- Almacena la descripcion del error
    mensaje_error errores_proceso.mensaje_tecnico%TYPE;    
BEGIN
    SELECT categoria INTO categoria_c
    FROM categoria_cx
    WHERE p_venidos BETWEEN minimo AND maximo;
    RETURN categoria_c;
EXCEPTION WHEN TOO_MANY_ROWS OR NO_DATA_FOUND THEN
    mensaje_error := SQLERRM;
    INSERT INTO errores_proceso
    VALUES(SEQ_ERROR.NEXTVAL, USER, mensaje_error, 
            'ERROR AL RECUPERAR CATEGORIA');
    RETURN 'INDEFINIDA';
END;

-- Procedimiento principal
CREATE OR REPLACE PROCEDURE sp_informe(p_periodo VARCHAR2)
IS
    -- Almacena las categorias a procesar
    CURSOR c_categorias IS
        SELECT id_categoria
        FROM categoria_boleto;
    -- Almacena el total de boletos de la categoria
    total_boletos NUMBER;
    -- Almacena el total de boletos vendidos en el periodo
    total_periodo NUMBER;
    -- Almacena la proporcion
    proporcion cx_informe.total_b%TYPE;
    -- Almacena la observacion
    observacion cx_informe.observacion%TYPE;
BEGIN
    -- Setea el periodo de consulta
    pkg_ventas.PERIODO_CONSULTA := p_periodo;
    -- Obtiene el total d boletos vendidos en el periodo
    total_periodo := fn_total_periodo(p_periodo);
    -- Procesa una a una cada categoria
    FOR reg_categoria IN c_categorias LOOP
        -- Obtiene la cantidad de boletos vendidos en el periodo
        total_boletos := pkg_ventas.fn_total_boletos(reg_categoria.id_categoria);
        -- Obtiene la proporcion
        BEGIN
            proporcion := ROUND(total_boletos/total_periodo, 2);
        EXCEPTION WHEN ZERO_DIVIDE THEN
            proporcion := 0;
        END;
        -- Obtiene la observacion
        observacion := fn_categoria(total_boletos);
        -- Insertar resulatdo
        pkg_ventas.sp_inertar(reg_categoria.id_categoria, total_boletos,
        proporcion, observacion);
    END LOOP;
END;

CREATE OR REPLACE TRIGGER trg_forma_a
AFTER INSERT ON cx_informe
FOR EACH ROW
DECLARE
    -- Almacena la calificacion
    calificacion cx_resumen.rango%TYPE;
BEGIN
    -- Obtiene la calificacion de acuerdo con la regla de negocio
    calificacion := CASE
        WHEN :NEW.total_b <= 0.2 THEN 'POR MEJORAR'
        WHEN :NEW.total_b >= 0.21 AND :NEW.total_b < 0.5 THEN 'EN PROCESO'
        ELSE 'IDEAL'
    END;
    INSERT INTO cx_resumen
    VALUES(:NEW.id_a, :NEW.id_b, :NEW.total_a, calificacion);
END;

EXEC sp_informe('04-2023');

SELECT * FROM cx_informe;
SELECT * FROM cx_resumen;
