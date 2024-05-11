-- Reforzamiento 2
-- https://github.com/JaznaLaProfe/Programacion-BD
/*
Cursor explicito 1
Peliculas
SIN PARAMETROS
Cursor explicito 2
Heroes de una pelicula
CON PARAMETROS, el parametro representa el ID de la pelicula
*/
DECLARE
    -- Almacena las peliculas
    CURSOR c_peliculas IS
        SELECT id_pelicula, nombre_pelicula,
        year_aparicion,
        EXTRACT(YEAR FROM SYSDATE) - year_aparicion antiguedad
        FROM pelicula
        ORDER BY 3;
    -- Almacena los heroes de una pelicula
    CURSOR c_heroes(p_pelicula NUMBER) IS
        SELECT a.cod_heroe, nomb_heroe, fecha_aparicion
        FROM elenco_heroes a JOIN superheroe b ON(a.cod_heroe = b.cod_heroe)
        WHERE id_pelicula = p_pelicula
        ORDER BY 2;
    -- Almacena el total de poderes
    total_poderes NUMBER;
    -- Almacena la antiguedad del heroe
    antiguedad NUMBER;
    -- Almacena el error de oracle
    msg_oracle error_proceso.descripcion%TYPE;
    -- Almacena la clasificacion del heroe
    clasificacion_h clasificacion.clasificacion%TYPE;
    -- Almacena el total de puntaje
    total_puntaje NUMBER;
    -- Almacena el total de heroes
    total_heroes NUMBER;
    -- Define el VARRAY de acuerdo con requerimiento
    TYPE VALORES IS VARRAY(2) OF NUMBER;
    limites VALORES;
    -- Almacena la excepcion de negocio
    error_negocio EXCEPTION;
BEGIN
    limites := VALORES(2,5);
    -- Procesa una a una cada pelicula
    FOR reg_pelicula IN c_peliculas LOOP
        total_heroes := 0;
        -- Obtiene el total de poderes
        SELECT COUNT(cod_poder) INTO total_poderes
        FROM elenco_heroes a JOIN heroe_poder b ON(a.cod_heroe = b.cod_heroe)
        WHERE id_pelicula = reg_pelicula.id_pelicula;
        -- Procesar los heroes de la pelicula
        FOR reg_heroe IN c_heroes(reg_pelicula.id_pelicula) LOOP
            -- Calcular el la antiguedad respecto de la pelicula
            antiguedad := reg_pelicula.year_aparicion -
            EXTRACT(YEAR FROM reg_heroe.fecha_aparicion);
            -- Obtiene la clasificacion del heroe de acuerdo con la RN
            BEGIN
                SELECT clasificacion INTO clasificacion_h
                FROM clasificacion
                WHERE antiguedad BETWEEN valor_minimo AND valor_maximo;
            EXCEPTION WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                -- Esta linea NO aparece en el vídeo y es para el caso de
                -- que no encuentre la clasificacion
                clasificacion_h := 'INDEFINIDA';
                msg_oracle := SQLERRM;
                INSERT INTO error_proceso
                VALUES(SEQ_ERROR.NEXTVAL, SYSDATE, 'EJECUCION', msg_oracle);
            END;
            -- Obtiene el puntaje total de los heroes de la pelicula
            SELECT NVL(SUM(puntaje),0) INTO total_puntaje
            FROM poder a JOIN heroe_poder b ON(a.cod_poder = b.cod_poder)
            WHERE cod_heroe = reg_heroe.cod_heroe;
            -- En caso de que NO ME DEJEN TRUNCAS LAS TABLAS DEBO MANEJAR UNA EXCEPCION 
            -- Inserta resultado
            BEGIN
                INSERT INTO detalle_pelicula
                VALUES(reg_pelicula.id_pelicula, reg_heroe.cod_heroe,
                reg_heroe.nomb_heroe, antiguedad, clasificacion_h, total_puntaje);
            EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
                msg_oracle := SQLERRM;
                INSERT INTO error_proceso
                VALUES(SEQ_ERROR.NEXTVAL, SYSDATE, 'EJECUCION', msg_oracle);
            END;
            total_heroes := total_heroes + 1;
        END LOOP;
        -- Verifica la regla de negocio
        BEGIN
            IF total_heroes NOT BETWEEN limites(1) AND limites(2) THEN
                RAISE error_negocio;
            END IF;
        EXCEPTION WHEN error_negocio THEN
            INSERT INTO error_proceso
            VALUES(SEQ_ERROR.NEXTVAL, SYSDATE, 'NEGOCIO',
            'PELICULA ' || reg_pelicula.nombre_pelicula || 
            ' NO CUMPLE CON EL ESTANDAR DE CANTIDAD DE HEROES. TIENE ' ||
            total_heroes || ' HEROES');
        END;
        -- Insertar resulatdo de la tabla resumen
        BEGIN
            INSERT INTO info_pelicula
            VALUES(reg_pelicula.id_pelicula, reg_pelicula.nombre_pelicula,
            reg_pelicula.year_aparicion, reg_pelicula.antiguedad,
            total_poderes, total_heroes);
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
            msg_oracle := SQLERRM;
            INSERT INTO error_proceso
            VALUES(SEQ_ERROR.NEXTVAL, SYSDATE, 'EJECUCION', msg_oracle);
        END;
    END LOOP;
END;

-- Por si quiere volver a ejecutar su bloque
DELETE FROM INFO_PELICULA;
DELETE FROM DETALLE_PELICULA;
DELETE FROM error_proceso;

-- Para probar si su bloque cumple con el requerimiento
SELECT * FROM info_pelicula;
SELECT * FROM detalle_pelicula;
SELECT * FROM error_proceso;