-- Reforzamiento ET
-- Encabezado package
CREATE OR REPLACE PACKAGE pkg_obras IS
    -- Variable para la fecha de simulacion
    FECHA_SIMULACION DATE;
    -- Variable para la cantidad de asientos por artista
    CANTIDAD_ASIENTOS NUMBER;
    -- Funcion publica 1
    FUNCTION fn_cantidad_errores(p_obra NUMBER) RETURN NUMBER;
    -- Funcion publica 2
    FUNCTION fn_nivel_error(p_errores NUMBER) RETURN VARCHAR2;
END;
-- Cuerpo del package
CREATE OR REPLACE PACKAGE BODY pkg_obras IS
    -- Funcion publica 1
    FUNCTION fn_cantidad_errores(p_obra NUMBER) RETURN NUMBER
    IS
        -- Almacena el total de p_errores
        total_errores NUMBER;
    BEGIN
        SELECT COUNT(c.id_artista) INTO total_errores
        FROM obra a JOIN elenco b ON(a.id_obra = b.id_obra)
        JOIN artista c ON(b.id_artista = c.id_artista)
        WHERE a.id_obra = p_obra AND EXTRACT(YEAR FROM fecha_nacimiento) >= anio;

        RETURN total_errores;
    END;
    -- Funcion publica 2
    FUNCTION fn_nivel_error(p_errores NUMBER) RETURN VARCHAR2
    IS
        -- Almacena el nivel de error
        nivel_x nivel_error.nivel%TYPE;
        -- Almacena la descripcion del error
        mensaje_oracle errores.descripcion_oracle%TYPE;
    BEGIN
        -- Obtiene el nivel de error de acuerdo con lo que indica la regla
        SELECT nivel INTO nivel_x
        FROM nivel_error
        WHERE p_errores BETWEEN valor_minimo AND valor_maximo;
        RETURN nivel_x; 
    EXCEPTION WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
        mensaje_oracle := SQLERRM;
        INSERT INTO errores
        VALUES(SEQ_ERROR.NEXTVAL, $$PLSQL_UNIT, USER,
        mensaje_oracle);
        RETURN 'INDEFINIDA';
    END;    
END;

-- Funcion almacenada 1
CREATE OR REPLACE FUNCTION fn_rango_edad(p_obra NUMBER, p_fecha DATE)
RETURN NUMBER
IS
    -- Almacena la edad maypr
    edad_mayor NUMBER;
    -- Almacena la edad menpr
    edad_menor NUMBER;
BEGIN
    -- Obtiene el rango de edad
    -- Edad del mas viejo
    SELECT MAX(TRUNC(MONTHS_BETWEEN(p_fecha, fecha_nacimiento)/12)) 
    INTO edad_mayor
    FROM artista a JOIN elenco b ON(a.id_artista = b.id_artista)
    WHERE id_obra = p_obra;
    
    -- Edad del mas joven
    SELECT MIN(TRUNC(MONTHS_BETWEEN(p_fecha, fecha_nacimiento)/12)) INTO edad_menor
    FROM artista a JOIN elenco b ON(a.id_artista = b.id_artista)
    WHERE id_obra = p_obra;    

    RETURN edad_mayor - edad_menor;
END;

-- Funcion almacenada 2
CREATE OR REPLACE FUNCTION fn_cantidad_prereserva(p_obra NUMBER,
p_cantidad NUMBER)
RETURN NUMBER
IS
    -- Almacena el total de prereserva
    total NUMBER;
BEGIN
    -- Obtiene la cantidad de artistas de la obra
    SELECT COUNT(id_artista)*p_cantidad INTO total
    FROM elenco
    WHERE id_obra = p_obra;

    RETURN total;
END;

-- Procedimiento principal
CREATE OR REPLACE PROCEDURE sp_informe(p_fecha DATE, p_cantidad_asientos NUMBER)
IS
    -- Almacena las obras a procesar
    CURSOR c_obras IS
        SELECT id_obra, anio
        FROM obra;
    -- Almacena la antiguedad
    antiguedad NUMBER;
    -- Almacena el total de errores
    total_errores NUMBER;
    -- Almacena el total de artistas
    total_artistas NUMBER;
    -- Almacena el nivel de error de la obra
    nivel_error_obra obras_a_revisar.nivel_error%TYPE;
    -- Almacena el rango de edad
    rango_edad NUMBER;
    -- Almacena la cantidad de asientos
    cantidad_a NUMBER;
BEGIN
    -- Setea las variables del package
    pkg_obras.FECHA_SIMULACION := p_fecha;
    pkg_obras.CANTIDAD_ASIENTOS := p_cantidad_asientos;
    -- Truncar las tablas de resultado segun lo indica el RQ
    EXECUTE IMMEDIATE 'TRUNCATE TABLE obras_a_revisar';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_errores_obra';
    -- Procesa una a una cada obra
    FOR reg_obra IN c_obras LOOP
        -- Calcula la antiguedad a la fecha del proceso
        antiguedad := EXTRACT(YEAR FROM p_fecha) - reg_obra.anio;
        -- Obtiene la cantidad de artistas con error
        total_errores := pkg_obras.fn_cantidad_errores(reg_obra.id_obra);
        -- Obtiene el total de artistas de la obra
        SELECT COUNT(id_artista) INTO total_artistas
        FROM elenco
        WHERE id_obra = reg_obra.id_obra;
        nivel_error_obra := 'OBRA SIN ERRORES';
        IF total_errores > 0 THEN
            -- Obtiene el nivel de error
            nivel_error_obra := pkg_obras.fn_nivel_error(total_errores);
        END IF;
        -- Obtiene el rango de edad
        rango_edad := fn_rango_edad(reg_obra.id_obra, pkg_obras.FECHA_SIMULACION);
        -- Obtiene la cantidad de asientos pre reservados
        cantidad_a := fn_cantidad_prereserva(reg_obra.id_obra, pkg_obras.CANTIDAD_ASIENTOS);
        -- Insertar resultados
        INSERT INTO obras_a_revisar
        VALUES(reg_obra.id_obra, antiguedad, total_errores,
        total_artistas, nivel_error_obra, rango_edad, cantidad_a);
    END LOOP;
END;

-- Crear trigger
CREATE OR REPLACE TRIGGER trg_obras
AFTER INSERT ON OBRAS_A_REVISAR
FOR EACH ROW
DECLARE
    -- Almacena la proporcionn
    proporcion resumen_errores_obra.proporcion_error%TYPE;
    -- Almacena la descripcion
    descripcion_obra resumen_errores_obra.descripcion%TYPE;
BEGIN
    -- Calcula la proporcion
    BEGIN
        proporcion := ROUND(:NEW.total_errores/:NEW.total_artistas, 2);
    EXCEPTION WHEN ZERO_DIVIDE THEN
        proporcion := 0;
    END;
    -- Obtiene la descripcion
    descripcion_obra := CASE
        WHEN proporcion <= 0.3 THEN 'NIVEL ERROR MODERADO'
        ELSE 'A REVISIÓN URGENTE' 
    END;
    -- Insertar en la tabla de resumen
    INSERT INTO resumen_errores_obra
    VALUES(:NEW.id_obra, proporcion, descripcion_obra);
END;

-- Prueba del SP
EXEC sp_informe(TO_DATE('29/06/24', 'DD/MM/RR'), 5);

SELECT * FROM obras_a_revisar;
SELECT * FROM resumen_errores_obra;