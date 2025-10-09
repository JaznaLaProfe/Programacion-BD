-- MDY3131 - IBM - Serie 6
CREATE OR REPLACE FUNCTION fn_total_medicos_esp(p_id_esp NUMBER)
RETURN NUMBER
IS
    -- Almacena el total de medicos
    total_medicos NUMBER;
BEGIN
    -- Obtiene el total de medicos de la especialidad
    SELECT COUNT(med_run) INTO total_medicos
    FROM especialidad_medico
    WHERE esp_id = p_id_esp;

    RETURN total_medicos;
END;

-- Prueba de la funcion
DECLARE
    -- Almacena el total de medicos
    total NUMBER;
BEGIN
    total := fn_total_medicos_esp(700);
    DBMS_OUTPUT.PUT_LINE('Total medicos es ' || total);
END;

-- Llamar a la función para cada una de las especialidades
DECLARE
    -- Almacena las especialidades
    CURSOR c_especialidades IS
        SELECT esp_id, nombre
        FROM especialidad
        ORDER BY 2;
    -- Almacena el total de medicos
    total NUMBER;
BEGIN
    FOR reg_especialidad IN c_especialidades LOOP
        -- Obtiene el total de medicos de la especialidad
        total := fn_total_medicos_esp(reg_especialidad.esp_id);
        -- Imprime los datos
        DBMS_OUTPUT.PUT_LINE(reg_especialidad.nombre || ' tiene ' || 
            total || ' especialistas');
    END LOOP;
END;

-- Obtiene el listado ahora ORDENADO POR CANTIDAD DE ESPECIALISTAS
DECLARE
    -- Almacena las especialidades
    CURSOR c_especialidades IS
        SELECT nombre, fn_total_medicos_esp(esp_id) total_medicos
        FROM especialidad
        ORDER BY 2 DESC;
    -- Almacena el total de medicos
    total NUMBER;
BEGIN
    FOR reg_especialidad IN c_especialidades LOOP
        -- Obtiene el total de medicos de la especialidad
        total := reg_especialidad.total_medicos;
        -- Imprime los datos
        DBMS_OUTPUT.PUT_LINE(reg_especialidad.nombre || ' tiene ' || 
            total || ' especialistas');
    END LOOP;
END;