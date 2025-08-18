/*
Imprimir la cantidad de poderes cuyo puntaje sea superior a 3
e 
Imprimir un mensaje informativo para saber si esa cantidad supera
el 50% de los poderes registrados
*/

/* Tabla necesaria : poder */
SET SERVEROUTPUT ON;
DECLARE
    -- Almacena el total de poderes con puntaje superior a 3
    total_poderes_seleccionados NUMBER;
    -- Almacena el total de poderes registrados
    total_registros NUMBER;
BEGIN
    -- Obtener la cantidad de poderes con puntaje superior a 3
    SELECT COUNT(cod_poder) INTO total_poderes_seleccionados
    FROM poder
    WHERE puntaje > 3;

    -- Imprimir la cantidad de poderes con puntaje superior a 3
    DBMS_OUTPUT.PUT_LINE('Poderes con puntaje superior a 3 son ' || total_poderes_seleccionados);
    -- Obtener el total de poderes registrados
    SELECT COUNT(cod_poder) INTO total_registros
    FROM poder;
    -- Imprime el mensaje informativo verificando la condición
    IF total_poderes_seleccionados > total_registros*0.5 THEN
        DBMS_OUTPUT.PUT_LINE('Poderes con puntaje superior a 3 supera el 50%');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Poderes con puntaje superior a 3 NO supera el 50%');
    END IF;
END;