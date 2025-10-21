CREATE TABLE reporte_especialidad_2025
(
    codigo_esp NUMBER PRIMARY KEY,
    nombre_especialidad VARCHAR2(100) NOT NULL,
    total_medicos NUMBER NOT NULL,
    proporcion NUMBER NOT NULL
);

-- Función almacenada 1
CREATE OR REPLACE FUNCTION fn_medicos_esp(p_especialidad NUMBER)
RETURN NUMBER
IS
    -- Almacena el total de médicos de la especialidad
    total_medicos NUMBER;
BEGIN
    -- Obtiene el total de médicos de la especilidad
    SELECT COUNT(med_run) INTO total_medicos
    FROM especialidad_medico
    WHERE esp_id = p_especialidad;

    RETURN total_medicos;
END;
-- Función almacenada 2
CREATE OR REPLACE FUNCTION fn_total_medicos
RETURN NUMBER
IS
    -- Almacena el total de médicos registrados
    total_medicos NUMBER;
BEGIN
    -- Obtiene el total de médicos registrados
    SELECT COUNT(med_run) INTO total_medicos
    FROM medico;

    RETURN total_medicos;
END;
-- Procedimiento almacenado 1
CREATE OR REPLACE PROCEDURE sp_inserta_resultado
(p_codigo NUMBER, p_nombre VARCHAR2, p_total NUMBER,
p_proporcion NUMBER)
IS
BEGIN
    -- Insertar registro en tabla resultado
    INSERT INTO reporte_especialidad_2025
    VALUES(p_codigo, p_nombre, p_total, p_proporcion);
END;
-- Procedimiento almacenado 2
CREATE OR REPLACE PROCEDURE sp_genera_reporte
IS
    -- Almacena las especialidades a procesar
    CURSOR c_especialidades IS
        SELECT esp_id, nombre
        FROM especialidad
        ORDER BY 2;
    -- Almacena el total de médicos de la especialidad
    total_medicos_e NUMBER;
    -- Almacena el total general
    total_general NUMBER;
    -- Almacena la proporción
    proporcion NUMBER;
BEGIN
    -- Obtiene el total de médicos registrados
    total_general := fn_total_medicos();
    -- Procesa una a una cada especialidad
    FOR reg_especialidad IN c_especialidades LOOP
        -- Obtener el total de médicos de la especialidad
        total_medicos_e := fn_medicos_esp(reg_especialidad.esp_id);
        -- Calcular la proporción
        proporcion := ROUND(total_medicos_e/total_general,2);
        -- Guardar en la tabla de resultados
        sp_inserta_resultado(reg_especialidad.esp_id,
        reg_especialidad.nombre, total_medicos_e, proporcion);
    END LOOP;
    COMMIT;
END;

SELECT * FROM reporte_especialidad_2025;

EXEC sp_genera_reporte;