-- REFORZAMIENTO 06.04.2024
-- MDY3131
-- Tablas necesarias: arriendo_camion, camion
-- Tabla recorrer: camion

VAR porcentaje_rebaja NUMBER;
EXEC :porcentaje_rebaja := 0.225;
DECLARE
    -- Almacena el id minimo y maximo de los camiones
    minimo_id NUMBER;
    maximo_id NUMBER;
    -- Almacena el id del camion que proceso
    codigo_camion NUMBER;
    -- Almacena los datos del camion
    patente camion.nro_patente%TYPE;
    arriendo_dia NUMBER;
    garantia_dia NUMBER;
    -- Almacena el total de arriendos
    total_arriendos NUMBER;
BEGIN
    -- Truncar las tablas para ejecutar el bloque varias veces
    EXECUTE IMMEDIATE 'TRUNCATE TABLE hist_arriendo_anual_camion';
    -- Obtener el minimo y maximo ID
    SELECT MIN(id_camion), MAX(id_camion)
    INTO minimo_id, maximo_id
    FROM camion; 
    -- Procesar cada uno de los camiones
    codigo_camion := minimo_id;
    WHILE codigo_camion <= maximo_id LOOP
        -- Obtener patente, valor de arriendo y garantia del camion
        SELECT nro_patente, valor_arriendo_dia, valor_garantia_dia
        INTO patente, arriendo_dia, garantia_dia
        FROM camion
        WHERE id_camion = codigo_camion;
        -- Obtener la cantidad de veces que fue arrendado en el anio anterior
        SELECT COUNT(id_arriendo)
        INTO total_arriendos
        FROM arriendo_camion
        WHERE id_camion = codigo_camion AND 
            EXTRACT(YEAR FROM fecha_ini_arriendo) = EXTRACT(YEAR FROM SYSDATE) - 1;
        -- Verifica si corrresponde rebaja
        IF total_arriendos < 4 THEN
            arriendo_dia := arriendo_dia * (1 - :porcentaje_rebaja);
            garantia_dia := garantia_dia - garantia_dia*:porcentaje_rebaja;
            -- Actualizar la tabla camion
            UPDATE camion
            SET valor_arriendo_dia = arriendo_dia,
            VALOR_GARANTIA_DIA = garantia_dia
            WHERE id_camion = codigo_camion;
        END IF;
        -- Insertar resultado en la tabla
        INSERT INTO hist_arriendo_anual_camion
        VALUES(EXTRACT(YEAR FROM SYSDATE) - 1, codigo_camion,
        patente, arriendo_dia, garantia_dia, total_arriendos);
        -- Incrementa el valor del codigo
        codigo_camion := codigo_camion + 1;
    END LOOP;
    COMMIT;
END;

-- VERSION USANDO CICLO FOR Y LEYENDO DESDE TECLADO
DECLARE
    -- Almacena el id minimo y maximo de los camiones
    minimo_id NUMBER;
    maximo_id NUMBER;

    -- Almacena los datos del camion
    patente camion.nro_patente%TYPE;
    arriendo_dia NUMBER;
    garantia_dia NUMBER;
    -- Almacena el total de arriendos
    total_arriendos NUMBER;

    -- Almacena el % leido desde teclado
    porcentaje_rebaja NUMBER := &porcentaje;
BEGIN
    -- Truncar las tablas para ejecutar el bloque varias veces
    EXECUTE IMMEDIATE 'TRUNCATE TABLE hist_arriendo_anual_camion';
    -- Obtener el minimo y maximo ID
    SELECT MIN(id_camion), MAX(id_camion)
    INTO minimo_id, maximo_id
    FROM camion; 
    -- Procesar cada uno de los camiones
    FOR codigo_camion IN minimo_id .. maximo_id LOOP
        -- Obtener patente, valor de arriendo y garantia del camion
        SELECT nro_patente, valor_arriendo_dia, valor_garantia_dia
        INTO patente, arriendo_dia, garantia_dia
        FROM camion
        WHERE id_camion = codigo_camion;
        -- Obtener la cantidad de veces que fue arrendado en el anio anterior
        SELECT COUNT(id_arriendo)
        INTO total_arriendos
        FROM arriendo_camion
        WHERE id_camion = codigo_camion AND 
            EXTRACT(YEAR FROM fecha_ini_arriendo) = EXTRACT(YEAR FROM SYSDATE) - 1;
        -- Verifica si corrresponde rebaja
        IF total_arriendos < 4 THEN
            arriendo_dia := arriendo_dia * (1 - porcentaje_rebaja);
            garantia_dia := garantia_dia - garantia_dia*porcentaje_rebaja;
            -- Actualizar la tabla camion
            UPDATE camion
            SET valor_arriendo_dia = arriendo_dia,
            VALOR_GARANTIA_DIA = garantia_dia
            WHERE id_camion = codigo_camion;
        END IF;
        -- Insertar resultado en la tabla
        INSERT INTO hist_arriendo_anual_camion
        VALUES(EXTRACT(YEAR FROM SYSDATE) - 1, codigo_camion,
        patente, arriendo_dia, garantia_dia, total_arriendos);
    END LOOP;
    COMMIT;
END;

-- La pregunta que me hicieron al iniciar la sesion:
-- "Como extraer partes de un texto"
-- Respuesta: usando el substr y aca hay un ejemplo
SELECT appaterno_cli "apellido", 
    SUBSTR(appaterno_cli, 1,3) "los primeros 3", 
    SUBSTR(appaterno_cli, -3) "los ultimos 3"
FROM cliente;