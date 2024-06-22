-- Reforzamiento E3

-- Construccion del package
-- Encabezado del package
CREATE OR REPLACE PACKAGE pkg_socios IS
    -- Variables
    PERIODO_CONSULTA VARCHAR2(7);
    -- Funciones publicas
    FUNCTION fn_total_amarres(p_rut VARCHAR2) RETURN NUMBER;
    -- Procedimientos publicos
    PROCEDURE sp_insertar(p_rut VARCHAR2, p_antiguedad NUMBER,
    p_embarcaciones NUMBER, p_amarres NUMBER, p_consumo NUMBER,
    p_relacion VARCHAR2);
END;
-- Cuerpo del package
CREATE OR REPLACE PACKAGE BODY pkg_socios IS
    FUNCTION fn_total_amarres(p_rut VARCHAR2) RETURN NUMBER
    IS
        -- Almacena el total de amarres
        total NUMBER;
    BEGIN
        -- Obtiene el total de ammares
        SELECT COUNT(numeroamarre) INTO total
        FROM amarre
        WHERE rutsocio = p_rut;

        RETURN total;
    END;
    -- Procedimientos publicos
    PROCEDURE sp_insertar(p_rut VARCHAR2, p_antiguedad NUMBER,
    p_embarcaciones NUMBER, p_amarres NUMBER, p_consumo NUMBER,
    p_relacion VARCHAR2) 
    IS
        -- Almacena la descripcion del error tecnico de oracle
        msg_oracle error_proceso.ERROR_TECNICO_ORACLE%TYPE; 
        -- Almacena la sentencia de error
        sentencia_error error_proceso.SENTENCIA_ERROR%TYPE;
    BEGIN
        INSERT INTO resumen_socio
        VALUES(p_rut, pkg_socios.PERIODO_CONSULTA, p_antiguedad,
        p_embarcaciones, p_amarres, p_consumo, p_relacion);
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
        msg_oracle := SQLERRM;
        sentencia_error := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        INSERT INTO error_proceso
        VALUES(SEQ_ERROR.NEXTVAL, msg_oracle, USER, 
        sentencia_error, 'Resumen socio ' || p_rut || 
        ' en el periodo ' || pkg_socios.PERIODO_CONSULTA ||
        ' ya ha sido emitido');
    END;    
END;

-- Funciones almacenadas
CREATE OR REPLACE FUNCTION fn_promedio(p_periodo VARCHAR2)
RETURN NUMBER
IS
    -- Almacena el promedio
    promedio NUMBER;
BEGIN
    -- Obtiene el promedio de consumo de agua y luz
    SELECT NVL(AVG(consumo_agua + consumo_luz),0) INTO promedio
    FROM consumo
    WHERE periodo = p_periodo;

    RETURN promedio;
END;

CREATE OR REPLACE FUNCTION fn_consumo(p_rut VARCHAR2, p_periodo VARCHAR2)
RETURN NUMBER
IS
    -- Almacena el total de consumo 
    total NUMBER;
BEGIN
    -- Obtiene el total de consumo de agua y de luz del socio en el periodo
    SELECT NVL(SUM(consumo_agua + consumo_luz),0) INTO total
    FROM consumo
    WHERE rutsocio = p_rut AND periodo = p_periodo;

    RETURN total;
END;

-- Procedimiento principal
CREATE OR REPLACE PROCEDURE sp_informe(p_periodo VARCHAR2)
IS
    -- Almacenar a los socios a procesar
    CURSOR c_socios IS
        SELECT rutsocio, TRUNC(MONTHS_BETWEEN(SYSDATE, fechaingreso)/12) antiguedad
        FROM socio;
    -- Almacena el total de embarcaciones
    total_em NUMBER;
    -- Almacena el total de ammares
    total_amarres NUMBER;
    -- Almacena el total de consumo
    consumo_total NUMBER;
    -- Almacena el promedio
    promedio NUMBER;
    -- Almacena la relacion con el promedio
    relacion_promedio resumen_socio.relacion_consumo_promedio%TYPE;
BEGIN
    -- Setea el periodo en la variable del package
    pkg_socios.PERIODO_CONSULTA := p_periodo;
    -- Procesar UNO a UNO a cada socio
    FOR reg_socio IN c_socios LOOP
        -- Obtiene la cantidad de embarcaciones del socio
        SELECT COUNT(matriculaembarcacion) INTO total_em
        FROM embarcacion
        WHERE rutsocio = reg_socio.rutsocio;
        -- Obtiene la cantidad de amarres del socio
        total_amarres := pkg_socios.fn_total_amarres(reg_socio.rutsocio);
        -- Obtiene el total de consumo
        consumo_total := fn_consumo(reg_socio.rutsocio, pkg_socios.PERIODO_CONSULTA);
        -- Obtiene la relacion con el promedio
        promedio := fn_promedio(pkg_socios.PERIODO_CONSULTA);
        relacion_promedio := CASE
            WHEN consumo_total > promedio THEN 'Mayor al promedio'
            WHEN consumo_total < promedio THEN 'Menor al promedio'
            ELSE 'Igual al promedio'
        END;
        -- Insertar el resultado en la tabla
        pkg_socios.sp_insertar(reg_socio.rutsocio, reg_socio.antiguedad,
        total_em, total_amarres, consumo_total, relacion_promedio);
    END LOOP;
END;

-- Trigger
CREATE OR REPLACE TRIGGER trg_socios
AFTER INSERT ON resumen_socio
FOR EACH ROW
DECLARE
    -- Almacena la calificacion del socio
    calificacion_s rango_consumo.CALIFICACION%TYPE;
BEGIN
    -- Determina la calificacion del socio
    SELECT calificacion INTO calificacion_s
    FROM rango_consumo
    WHERE :NEW.total_consumo_agua_luz BETWEEN consumo_minimo AND consumo_maximo;
    -- Inserta en la tabla de calificacion socio
    INSERT INTO calificacion_socio
    VALUES(:NEW.rut_socio, :NEW.periodo_consulta, :NEW.total_consumo_agua_luz,
    calificacion_s);
END;

-- Prueba del proceso
EXEC sp_informe('02-2024');

SELECT * FROM resumen_socio;
SELECT * FROM error_proceso;
SELECT * FROM calificacion_socio;

DELETE FROM resumen_socio;
DELETE FROM error_proceso;
DELETE FROM calificacion_socio;
