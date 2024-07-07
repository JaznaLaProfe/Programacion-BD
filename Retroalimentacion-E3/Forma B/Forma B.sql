-- Forma B
CREATE OR REPLACE PACKAGE pkg_reservas IS
    -- Variable del periodo
    PERIODO_CONSULTA VARCHAR2(7);
    -- Funcion publica
    FUNCTION fn_total_boletos(p_categoria NUMBER) RETURN NUMBER;
    -- Procedimiento publico
    PROCEDURE sp_insertar(p_categoria NUMBER, p_cantidad NUMBER,
    p_proporcion NUMBER, p_observacion VARCHAR2);
END;
-- Cuerpo package
CREATE OR REPLACE PACKAGE BODY pkg_reservas IS
    -- Funcion publica
    FUNCTION fn_total_boletos(p_categoria NUMBER) RETURN NUMBER
    IS
        -- Almacena el total de boletos reservados
        total NUMBER;
    BEGIN
        -- Obtiene el total de boletos reservados
        SELECT NVL(SUM(cantidad), 0) INTO total
        FROM reserva a JOIN boleto b ON(a.id_boleto = b.id_boleto)
        WHERE id_categoria = p_categoria AND 
            TO_CHAR(fecha_reserva, 'MM-YYYY') = PERIODO_CONSULTA;

        RETURN total;
    END;
    -- Procedimiento publico
    PROCEDURE sp_insertar(p_categoria NUMBER, p_cantidad NUMBER,
    p_proporcion NUMBER, p_observacion VARCHAR2)
    IS
        -- Almacena la descripcion tecnica del error
        mensaje_error errores_proceso.mensaje_tecnico%TYPE;
    BEGIN
        INSERT INTO ax_informe
        VALUES(p_categoria, PERIODO_CONSULTA, p_cantidad, 
            p_proporcion, p_observacion);
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
        mensaje_error := SQLERRM;
        INSERT INTO errores_proceso
        VALUES(SEQ_ERROR.NEXTVAL, USER, mensaje_error, 'ERROR AL INSERTAR RESULTADO');
    END;    
END;

-- Funcion almacenada 1
CREATE OR REPLACE FUNCTION fn_boletos_reservados(p_periodo VARCHAR2)
RETURN NUMBER
IS
    -- Almacena el total de boletos reservados
    total NUMBER;
BEGIN
    -- Obtiene el total de boletos reservados
    SELECT NVL(SUM(cantidad),0) INTO total
    FROM reserva a JOIN boleto b ON(a.id_boleto = b.id_boleto)
    WHERE TO_CHAR(fecha_reserva, 'MM-YYYY') = p_periodo;

    RETURN total;
END;
-- Funcion almacenada 2
CREATE OR REPLACE FUNCTION fn_categoria(p_reservados NUMBER)
RETURN VARCHAR2
IS
    -- Almacena la categoria
    categoria_x categoria_ax.categoria%TYPE;
    -- Almacena la descripcion tecnica del error
    mensaje_error errores_proceso.mensaje_tecnico%TYPE;    
BEGIN
    -- Obtiene la categoria
    SELECT categoria INTO categoria_x
    FROM categoria_ax
    WHERE p_reservados BETWEEN minimo AND maximo;

    RETURN categoria_x;
EXCEPTION WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
    mensaje_error := SQLERRM;
    INSERT INTO errores_proceso
    VALUES(SEQ_ERROR.NEXTVAL, USER, mensaje_error, 'ERROR AL RECUPERAR CATEGORIA');
    RETURN 'INDEFINIDA';
END;

-- Procedimiento principal
CREATE OR REPLACE PROCEDURE sp_informe_b(p_periodo VARCHAR2)
IS
    -- Almacena las categorias de boletos registradas
    CURSOR c_categorias IS
        SELECT id_categoria
        FROM categoria_boleto;
    -- Almacena la cantidad de boletos reservados
    total_reservados NUMBER;
    -- Almacena el total general
    total_general NUMBER;
    -- Almacena la proporcion
    proporcion ax_informe.total_b%TYPE;
    -- Almacena la observacion
    observacion ax_informe.observacion%TYPE;
BEGIN
    pkg_reservas.PERIODO_CONSULTA := p_periodo;
    -- Obtiene el total general de boletos reservados
    total_general := fn_boletos_reservados(p_periodo);
    -- Procesar una a una cada categoria
    FOR reg_categoria IN c_categorias LOOP
        -- Obtiene el total de boletos reservados de la categoria
        total_reservados := pkg_reservas.fn_total_boletos(reg_categoria.id_categoria);
        -- Calcula la proporcion
        BEGIN
            proporcion := ROUND(total_reservados/total_general, 2);
        EXCEPTION WHEN ZERO_DIVIDE THEN
            proporcion := 0;
        END;
        -- Obtiene la observacion
        observacion := fn_categoria(total_reservados);
        -- Inserta resultados
        pkg_reservas.sp_insertar(reg_categoria.id_categoria, total_reservados,
        proporcion, observacion);
    END LOOP;
END;

-- Crea trigger
CREATE OR REPLACE TRIGGER trg_informe_b
AFTER INSERT ON ax_informe
FOR EACH ROW
DECLARE
    -- Almacena la calificacion
    calificacion cx_resumen.rango%TYPE;
BEGIN
    -- Obtiene la calificacion
    calificacion := CASE
        WHEN :NEW.total_b <= 0.2 THEN 'POR MEJORAR'
        WHEN :NEW.total_b >= 0.21 AND :NEW.total_b < 0.5 THEN 'EN PROCESO'
        ELSE 'IDEAL'
    END;
    INSERT INTO cx_resumen 
    VALUES(:NEW.id_a, :NEW.id_b, :NEW.total_a, calificacion);
END;

-- Prueba del SP
EXEC sp_informe_b('04-2023');

SELECT * FROM ax_informe;
SELECT * FROM cx_resumen;