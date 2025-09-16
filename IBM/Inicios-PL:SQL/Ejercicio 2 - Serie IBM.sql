-- Ejercicio 2 - Serie IBM
SET SERVEROUTPUT ON;
DECLARE
    -- Almacena el rut paciente consultado
    rut_consulta NUMBER;
    -- Almacena el nombre completo del paciente
    nombre_completo VARCHAR2(210);
    -- Almacena el total de atenciones del paciente
    total_atenciones NUMBER;
BEGIN
    -- Asignar el rut que se consulta
    rut_consulta := 13770506;
    -- Obtiene el nombre completo del paciente
    SELECT pnombre || ' ' || snombre || ' ' || 
        apaterno || ' ' || amaterno
    INTO nombre_completo
    FROM paciente
    WHERE pac_run = rut_consulta;
    -- Obtiene el total de atenciones del paciente
    SELECT COUNT(ate_id) INTO total_atenciones
    FROM atencion
    WHERE pac_run = rut_consulta;
    -- Imprime resultados
    DBMS_OUTPUT.PUT_LINE('Nombre completo : ' || 
            UPPER(nombre_completo));
    DBMS_OUTPUT.PUT_LINE('Total atenciones : ' || total_atenciones);
END;