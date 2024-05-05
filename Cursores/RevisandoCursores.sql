CONNECT user_cursor/duoc@localhost:1521/XE;
-- Ejercicio 1
DECLARE
    -- Almacena las peliculas a procesar
    CURSOR c_peliculas(p_limite NUMBER) IS
        SELECT peliculaid, nombre, EXTRACT(YEAR FROM fechaestreno) estreno,
        TRUNC(MONTHS_BETWEEN(SYSDATE, fechaestreno)/12) antiguedad
        FROM pelicula
        WHERE EXTRACT(YEAR FROM fechaestreno) > p_limite;
    -- Almacena el limite de anio de estreno
    limite NUMBER := &LIMITE_ESTRENO;
    -- Almacena el promedio de antiguedad
    promedio_antiguedad NUMBER;
    -- Almacena la observacion de la pelicula
    obs resumen_a.observacion%TYPE;
BEGIN
    -- Truncar la tabla resultado para ejecutar el bloque varias veces
    EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_a';
    -- Obtiene la abtiguedad promedio general de todas las peliculas
    SELECT TRUNC(AVG(MONTHS_BETWEEN(SYSDATE, fechaestreno)/12)) 
    INTO promedio_antiguedad
    FROM pelicula;
    -- Procesando una a una cada pelicula
    FOR reg_pelicula IN c_peliculas(limite) LOOP
        -- Obtiene la observacion
        obs := CASE
            WHEN reg_pelicula.antiguedad > promedio_antiguedad THEN 'ANTIGUEDAD DE ' || 
                reg_pelicula.antiguedad || ' SUPERA AL PROMEDIO DE ' || promedio_antiguedad || ' ANIOS'
            ELSE 'ANTIGUEDAD DE ' || 
                reg_pelicula.antiguedad || ' ES INFERIOR AL PROMEDIO DE ' || promedio_antiguedad || ' ANIOS'
        END;
        -- Insertar resultados
        INSERT INTO resumen_a
        VALUES(reg_pelicula.peliculaid, reg_pelicula.nombre, reg_pelicula.estreno, reg_pelicula.antiguedad,
        obs);
    END LOOP;
END;

SELECT * FROM resumen_a;

-- Ejercicio 2
DECLARE
    -- Almacena las peliculas a procesar
    CURSOR c_peliculas(p_mes NUMBER) IS
        SELECT peliculaid, nombre, fechaestreno
        FROM pelicula
        WHERE TO_CHAR(fechaestreno, 'MM') BETWEEN p_mes - 1 AND p_mes + 1;
    -- Almacena el mes de filtro
    mes_limite NUMBER := &MES_FILTRO;
    -- Almacena el total de actores de la pelicula 
    total_actores NUMBER;
    -- Almacena el promedio de edad de los actores de la pelicula
    promedio_edad NUMBER;
    -- Almacena el limite de edad
    limite_edad NUMBER := &LIMITE_EDAD;
    -- Almacena el total de actores que cumplen el rango de edad
    total_actores_rango NUMBER;
    -- Almacena la observacion
    obs resumen_b.observacion%TYPE;
BEGIN
    -- Trunca la tabla resultado para ejecutar el bloque varias veces
    EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_b';
    -- Procesa las peliculas UNA A UNA
    FOR reg_pelicula IN c_peliculas(mes_limite) LOOP
        -- Obtiene la cantidad de actores que aparecen en la pelicula
        SELECT COUNT(personajeid) INTO total_actores
        FROM personajepelicula
        WHERE peliculaid = reg_pelicula.peliculaid;
        -- Obtiene el promedio de edad de los actores de la pelicula
        SELECT TRUNC(AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, fechanacimiento)/12)))
        INTO promedio_edad
        FROM personajepelicula a JOIN personaje b ON(a.personajeid = b.personajeid)
        JOIN actor c ON(b.actorid = c.actorid)
        WHERE reg_pelicula.peliculaid = peliculaid;
        -- Obiene la cantidad de actores menores a la edad ingresada
        SELECT COUNT(c.actorid) INTO total_actores_rango
        FROM personajepelicula a JOIN personaje b ON(a.personajeid = b.personajeid)
        JOIN actor c ON(b.actorid = c.actorid)
        WHERE reg_pelicula.peliculaid = peliculaid AND
        TRUNC(MONTHS_BETWEEN(SYSDATE, fechanacimiento)/12) < limite_edad;
        -- Obtiene la observacion
        obs := CASE
            WHEN total_actores_rango = 0 THEN 'SIN ACTORES MENORES DE ' 
            || limite_edad || ' ANIOS'
            ELSE 'HAY ' || total_actores_rango || ' MENORES DE ' || limite_edad || ' ANIOS'
        END;
        -- Insertar resultados en la tabla
        INSERT INTO resumen_b
        VALUES(reg_pelicula.peliculaid, reg_pelicula.nombre, 
        reg_pelicula.fechaestreno,
        total_actores, promedio_edad, obs);
    END LOOP;
END;

SELECT * FROM resumen_b;
