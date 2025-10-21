CREATE TABLE resultado(
    total_medicos NUMBER NOT NULL,
    total_antiguos NUMBER NOT NULL,
    porcentaje NUMBER NOT NULL
);

-- Funcion almacenada
CREATE OR REPLACE FUNCTION fn_total_antiguos
RETURN NUMBER
IS
    -- Almacena el total de médicos antiguos
    total NUMBER;
BEGIN
    -- Obtiene la cantidad de médicos antiguos
    SELECT COUNT(med_run) INTO total
    FROM medico
    WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, fecha_contrato)/12) >= 5;

    RETURN total;
END;

CREATE OR REPLACE PROCEDURE sp_insertar
IS
    -- Almacena el total de médicos registrados
    total_registrados NUMBER;
    -- Almacena el total de médicos antiguos
    total_antiguos NUMBER;
    -- Almacena el porcentaje calculado
    porcentaje NUMBER;
BEGIN
    -- Obtiene el total de médicos registrados
    total_registrados := fn_total_medicos();
    -- Obtiene el total de médicos antiguos
    total_antiguos := fn_total_antiguos();
    -- Calcula el porcentaje de los antiguos respecto del total general
    porcentaje := ROUND(total_antiguos/total_registrados, 2)*100;
    -- Insertar
    INSERT INTO resultado
    VALUES(total_registrados, total_antiguos, porcentaje);
END;

EXEC sp_insertar;

SELECT * FROM resultado;
