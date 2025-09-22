-- Ejercicio 3 - Serie IBM
/* Tabla necesaria: ATENCION */
SET SERVEROUTPUT ON;
DECLARE
    -- Almacena el año inicial
    anio_inicio NUMBER;
    -- Almacena el año final
    anio_final NUMBER;
    -- Almacena el total de atenciones
    total_atenciones NUMBER;
    -- Almacena el costo promedio
    promedio NUMBER;
BEGIN
    -- Setear el valor del rango
    anio_inicio := 2020;
    anio_final := 2020;
    -- Obtener la cantidad de atenciones y el costo promedio en el rango de años
    SELECT COUNT(ate_id), NVL(TRUNC(AVG(costo)), 0) INTO total_atenciones, promedio
    FROM atencion
    WHERE EXTRACT(YEAR FROM fecha_atencion) BETWEEN anio_inicio AND anio_final;
    -- Imprimir el resultado
    DBMS_OUTPUT.PUT_LINE('Total atenciones ' || total_atenciones);
    DBMS_OUTPUT.PUT_LINE('Costo promedio ' || promedio);
END;