-- Pacakage
-- Encabezado 
CREATE OR REPLACE PACKAGE pkg_reporte_unidad IS
    -- Función pública
    FUNCTION fn_total_medicos(p_unidad NUMBER) RETURN NUMBER;
    -- Procedimiento público
    PROCEDURE sp_inserta_resultado(p_unidad NUMBER,
    p_nombre VARCHAR2, p_medicos NUMBER, p_promedio NUMBER);
END;
-- Cuerpo
CREATE OR REPLACE PACKAGE BODY pkg_reporte_unidad IS
    -- Función pública
    FUNCTION fn_total_medicos(p_unidad NUMBER) RETURN NUMBER
    IS
        -- Almacena el total de medicos de la unidad
        total NUMBER;
    BEGIN
        -- Obtiene el total de medicos de la unidad
        SELECT COUNT(med_run) 
        INTO total
        FROM medico
        WHERE uni_id = p_unidad;

        RETURN total;
    END;
    -- Procedimiento público
    PROCEDURE sp_inserta_resultado(p_unidad NUMBER,
    p_nombre VARCHAR2, p_medicos NUMBER, p_promedio NUMBER)
    IS
        -- Almacena el código del error
        codigo_error error_proceso_unidad.codigo_oracle%TYPE;
        -- Almacena el mensaje del error
        msg_error error_proceso_unidad.mensaje_oracle%TYPE;
    BEGIN
        -- Inserta registro en la tabla de resultados
        INSERT INTO reporte_unidad
        VALUES(p_unidad, p_nombre,p_medicos, p_promedio);
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
        -- Obtiene los datos del error
        codigo_error := SQLCODE();
        msg_error := SQLERRM();
        -- Inserta el error
        INSERT INTO error_proceso_unidad
        VALUES(SEQ_ERROR_UNIDAD.NEXTVAL, codigo_error,
        msg_error, SYSDATE, $$PLSQL_UNIT);
    END;
END;
-- Función almacenada
CREATE OR REPLACE FUNCTION fn_promedio_sueldos(p_unidad NUMBER)
RETURN NUMBER
IS
    -- Almacena el promedio de sueldos
    promedio NUMBER;
BEGIN
    -- Obtiene el promedio de sueldos de la unidad
    SELECT NVL(ROUND(AVG(sueldo_base)), 0)
    INTO promedio
    FROM medico
    WHERE uni_id = p_unidad;

    RETURN promedio;
END;
-- Procedimiento almacenado
CREATE OR REPLACE PROCEDURE sp_genera_reporte
IS
    -- Almacena las unidades a procesar
    CURSOR c_unidades IS
        SELECT uni_id, nombre
        FROM unidad
        ORDER BY 2;
    -- Almacena el total de médicos
    total_m NUMBER;
    -- Almacena el promedio de sueldos
    promedio NUMBER;
BEGIN
    -- Procesa una a una cada unidad
    FOR reg_unidad IN c_unidades LOOP
        -- Obtiene el total de médicos
        total_m := pkg_reporte_unidad.fn_total_medicos(reg_unidad.uni_id);
        -- Obtiene el promedio del sueldos
        promedio := fn_promedio_sueldos(reg_unidad.uni_id);
        -- Insertar en la tabla de resultados
        pkg_reporte_unidad.sp_inserta_resultado(reg_unidad.uni_id, reg_unidad.nombre,
        total_m, promedio);
    END LOOP;
    COMMIT;
END;

EXEC sp_genera_reporte;

SELECT * FROM reporte_unidad;
SELECT * FROM error_proceso_unidad;
