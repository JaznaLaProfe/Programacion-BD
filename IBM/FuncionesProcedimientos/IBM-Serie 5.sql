-- MDY3131 - IBM - Serie 5
CREATE OR REPLACE FUNCTION fn_total_medicos
RETURN NUMBER
IS
    -- Almacena el total de medicos
    total NUMBER;
BEGIN
    -- Obtiene la cantidad de medicos registrados
    SELECT COUNT(med_run) INTO total
    FROM medico;
    -- Retornar el valor
    RETURN total;
END;

-- Llamar a la función
DECLARE
    -- Almacena el total de médicos
    total_medicos NUMBER;
BEGIN
    -- Llamada a la función
    total_medicos := fn_total_medicos();
    -- Imprimir el total de médicos
    DBMS_OUTPUT.PUT_LINE('Total médicos registrados ' || total_medicos);
END;