-- Ejercicio 4 - Serie ejercicios IBM
/* Tablas necesarias: CARGO */
DECLARE
    -- Almacena los cargos a procesar
    CURSOR c_cargos IS
        SELECT car_id, nombre
        FROM cargo;
BEGIN
    -- Procesar uno a uno cada cargo
    FOR reg_cargo IN c_cargos LOOP
        -- Imprimir los datos del cargo
        DBMS_OUTPUT.PUT_LINE('Identificador del cargo ' || reg_cargo.car_id);
        DBMS_OUTPUT.PUT_LINE('Nombre del cargo ' || reg_cargo.nombre);
        DBMS_OUTPUT.PUT_LINE('---');
    END LOOP;
END;