-- 
CREATE OR REPLACE FUNCTION fn_total(p_profesion NUMBER, 
    p_comuna NUMBER)
RETURN NUMBER
IS
    -- Almacena el total de sueldos de los profesionales
    total NUMBER;
BEGIN
    SELECT NVL(SUM(sueldo),0) INTO total
    FROM profesional
    WHERE cod_profesion = p_profesion AND cod_comuna = p_comuna;

    RETURN total;
END;

-- SP insertar
CREATE OR REPLACE PROCEDURE sp_registro(p_profesion NUMBER,
p_nombre_prof VARCHAR2, p_comuna NUMBER,
p_nom_comuna VARCHAR2, p_totales NUMBER)
IS
    msg_oracle errores_p.ora_msg%TYPE;
BEGIN
    INSERT INTO resumen_a
    VALUES(p_profesion, p_nombre_prof, p_comuna, p_nom_comuna, 
    p_totales);
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
    msg_oracle := SQLERRM;
    INSERT INTO errores_p
    VALUES(SQ_ERROR.NEXTVAL, msg_oracle, USER);
END;

-- SP principal
CREATE OR REPLACE PROCEDURE sp_informe
IS
    -- Almacenar las profesiones a procesar
    CURSOR c_profesiones IS
        SELECT cod_profesion, nombre_profesion
        FROM profesion;
    -- Almacenar las comunas a procesar
    CURSOR c_comunas IS
        SELECT cod_comuna, nom_comuna
        FROM comuna;
    -- Almacena el total de sueldos
    total_sueldos NUMBER;
BEGIN
    -- Procesa las profesiones una a una
    FOR reg_profesion IN c_profesiones LOOP
        -- Procesa las comunas UNA a UNA
        FOR reg_comuna IN c_comunas LOOP
            -- Obtiene el total de sueldos de los profesionales
            total_sueldos := fn_total(reg_profesion.cod_profesion,
                reg_comuna.cod_comuna);
            -- Insertar el resultado
            sp_registro(reg_profesion.cod_profesion, 
            reg_profesion.nombre_profesion, reg_comuna.cod_comuna,
            reg_comuna.nom_comuna, total_sueldos);
        END LOOP;
    END LOOP;
END;

-- Llamada al SP principal
EXEC sp_informe;

SELECT * FROM resumen_a;
SELECT * FROM errores_p;