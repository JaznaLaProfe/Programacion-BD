-- Ejercicio 1 - Canal
-- Imprimir el total de medicos registrados
SET SERVEROUTPUT ON;
DECLARE
    -- Almacena el total de médicos registrados
    total_medicos NUMBER;
BEGIN
    -- Obtiene el total de registros de la tabla
    SELECT COUNT(med_run) INTO total_medicos
    FROM medico;  
    -- Imprime el total de médicos registrados
    DBMS_OUTPUT.PUT_LINE('Total médicos es : ' || 
    total_medicos);  
END;


