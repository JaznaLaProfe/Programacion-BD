-- Mejora del procedimiento para manejar el error

-- Nueva tabla necesaria para guadrar los errores
CREATE TABLE error_proceso_especialidad
(
    id_error NUMBER PRIMARY KEY,
    codigo_oracle VARCHAR2(50) NOT NULL,
    mensaje_oracle VARCHAR2(250) NOT NULL,
    fecha_error DATE NOT NULL,
    unidad_responsable VARCHAR2(50) NOT NULL
);

-- Crea la secuencia mencionada en el enunciado
CREATE SEQUENCE seq_error_especialidad START WITH 1;

SELECT * FROM reporte_especialidad_2025;

-- Borra el contenido de la tabla para poder probar
DELETE FROM reporte_especialidad_2025;

-- Ejecuta el procedimiento que genera el informe
EXEC sp_genera_reporte;

-- Versión mejorada para manejar la excepción
CREATE OR REPLACE PROCEDURE sp_inserta_resultado
(p_codigo NUMBER, p_nombre VARCHAR2, p_total NUMBER,
p_proporcion NUMBER)
IS
    -- Almacena el código del error de ORACLE
    codigo_oracle error_proceso_especialidad.codigo_oracle%TYPE;
    -- Almacena la descripción del error
    mensaje_oracle error_proceso_especialidad.mensaje_oracle%TYPE;
BEGIN
    -- Insertar registro en tabla resultado
    INSERT INTO reporte_especialidad_2025
    VALUES(p_codigo, p_nombre, p_total, p_proporcion);
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
    -- Obtener la información del error
    codigo_oracle := SQLCODE();
    mensaje_oracle := SQLERRM();
    -- Inserta el error en la tabla indicada
    INSERT INTO error_proceso_especialidad
    VALUES(SEQ_ERROR_ESPECIALIDAD.nextval, codigo_oracle,
        mensaje_oracle, SYSDATE, $$PLSQL_UNIT);
END;

-- Inspecciona la tabla de errores
SELECT * FROM error_proceso_especialidad;

