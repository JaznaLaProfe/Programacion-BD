/*
Objetivo
Cursores explicitos 
Excepciones predfinidas y definidas por el usuario

Tablas necesarias: embarcacion, amarres, rango_consumo
Cursor explicito
1. Embarcaciones
2. Amarres (detalle de la embarcacion) -> parámetro que contiene la matricula de la 
embarcacion 
*/
DECLARE
    -- Almacena las embarcaciones
    CURSOR c_embarcaciones IS
        SELECT a.matriculaembarcacion,
            COUNT(numeroamarre) total_amarres
        FROM embarcacion a JOIN amarre b 
        ON(a.matriculaembarcacion = b.matriculaembarcacion)
        GROUP BY a.matriculaembarcacion
        HAVING  COUNT(numeroamarre) >= 2
        ORDER BY 1;
    -- Almacena los ammares de una embarcacion
    CURSOR c_amarres(p_embarcacion VARCHAR2, p_year NUMBER) IS
        SELECT numeroamarre, lecturaagua, lecturaluz,
            EXTRACT(YEAR FROM fechaasignacion) year_asignacion
        FROM amarre
        WHERE matriculaembarcacion = p_embarcacion AND
            EXTRACT(YEAR FROM fechaasignacion) = p_year;
    -- Almacena el rango de la embarcacion
    rango_e rango_embarcacion.rango%TYPE;
    -- Almacena el anio de consulta
    year_consulta NUMBER := &ANIO_CONSULTA;
    -- Almacena el nivel de gastos del amarre
    nivel_amarre rango_gastos.nivel_gastos%TYPE;
    -- Almacena la descripcion del error oracle
    msg_oracle error_proceso.descripcion%TYPE;
    -- Almacena el factor de luz
    factor_luz NUMBER := &FACTOR_DE_LUZ;
    -- Almacena el factor de agua
    factor_agua NUMBER := &FACTOR_DE_AGUA;
    -- Almacena el consumo
    consumo NUMBER;
    -- Almacena la excepcion para la regla de negocio
    error_consumo EXCEPTION;
    -- Almacena los limites
    limite_agua NUMBER := &LIMITE_AGUA;
    limite_luz NUMBER := &LIMITE_LUZ;
BEGIN
    -- Procesa una a una cada embarcacion
    FOR reg_embarcacion IN c_embarcaciones LOOP
        -- Obtiene el rango de la embarcacion
        BEGIN
            SELECT rango INTO rango_e
            FROM rango_embarcacion
            WHERE reg_embarcacion.total_amarres BETWEEN amarres_minimo AND amarres_maximo;
        EXCEPTION WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
            -- Inserta informacion del error
            msg_oracle := SQLERRM;
            INSERT INTO error_proceso
            VALUES(SEQ_ERROR.NEXTVAL, msg_oracle);
            rango_e := '-';
        END;
        -- Procesa el detalle de la embarcacion (amarres)
        FOR reg_amarre IN c_amarres(reg_embarcacion.matriculaembarcacion, year_consulta) LOOP
            -- Obtiene el nivel de gastos del amarre
            BEGIN
                SELECT nivel_gastos INTO nivel_amarre
                FROM rango_gastos
                WHERE reg_amarre.lecturaagua + reg_amarre.lecturaluz BETWEEN gasto_minimo AND
                gasto_maximo;
            EXCEPTION WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                -- Inserta informacion del error
                msg_oracle := SQLERRM;
                INSERT INTO error_proceso
                VALUES(SEQ_ERROR.NEXTVAL, msg_oracle);  
                nivel_amarre := 'POR DEFINIR';              
            END;
            -- Calcula el consumo de acuerdo con la formula
            consumo := reg_amarre.lecturaagua*factor_agua +
                        reg_amarre.lecturaluz*factor_luz;
            -- Verifica la regla de negocio del consumo
            BEGIN
                IF reg_amarre.lecturaagua > limite_agua OR 
                        reg_amarre.lecturaluz > limite_luz THEN
                    RAISE error_consumo;
                END IF;
            EXCEPTION WHEN error_consumo THEN
                INSERT INTO error_proceso
                VALUES(SEQ_ERROR.NEXTVAL, 'Exceso de consumo de agua o luz');                
            END;
            -- Inserta resultado en tabla de detalle
            BEGIN
                INSERT INTO resumen_amarre
                VALUES(reg_embarcacion.matriculaembarcacion,
                    reg_amarre.numeroamarre, 
                    reg_amarre.year_asignacion,
                    reg_amarre.lecturaagua, reg_amarre.lecturaluz,
                    nivel_amarre, consumo);
            EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
                -- Inserta informacion del error
                msg_oracle := SQLERRM;
                INSERT INTO error_proceso
                VALUES(SEQ_ERROR.NEXTVAL, msg_oracle);               
            END;
        END LOOP;
        -- Insertar resultado en la tabla de resumen
        BEGIN
            INSERT INTO resumen_embarcacion
            VALUES(reg_embarcacion.matriculaembarcacion,
            reg_embarcacion.total_amarres, rango_e);
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
            -- Inserta informacion del error
            msg_oracle := SQLERRM;
            INSERT INTO error_proceso
            VALUES(SEQ_ERROR.NEXTVAL, msg_oracle);               
        END;
    END LOOP;
END;

select * from RESUMEN_EMBARCACION;
select * from RESUMEN_AMARRE;
select * from ERROR_PROCESO;