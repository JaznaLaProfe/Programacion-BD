/*
https://github.com/JaznaLaProfe/Programacion-BD.git
*/

-- Funcion almacenada 1
CREATE OR REPLACE FUNCTION fn_categoria(p_promedio NUMBER)
RETURN VARCHAR2
IS
    -- Almacena la categoria de acuerdo con regla de negocio
    x_categoria resumen_por_periodo_ss.categoria%TYPE;
BEGIN
    -- Obtiene la categoria
    x_categoria := CASE
        WHEN p_promedio <= 5 THEN 'PRE-ESCOLAR'
        WHEN p_promedio BETWEEN 6 AND 12 THEN 'PRE-ADOLESCENCIA'
        WHEN p_promedio BETWEEN 13 AND 18 THEN 'ADOLESCENCIA' 
        ELSE 'ADULTO'
    END; 
    RETURN x_categoria;
END;
-- Funcion almacenada 2
CREATE OR REPLACE FUNCTION fn_total_pacientes(p_salud NUMBER,
p_periodo VARCHAR2)
RETURN NUMBER
IS
    -- Almacena el total de pacientes
    total NUMBER;
BEGIN
    -- Obtiene el total de pacientes del SS en el periodo
    SELECT COUNT(a.pac_run) INTO total
    FROM atencion a JOIN paciente b ON(a.pac_run = b.pac_run)
    WHERE TO_CHAR(fecha_atencion, 'MM-YYYY') = p_periodo AND
    sal_id = p_salud;

    RETURN total;
END;
-- Funcion almacenada 3
CREATE OR REPLACE FUNCTION fn_total_general(p_periodo VARCHAR)
RETURN NUMBER
IS
    -- Almacena el total de pacientes
    total NUMBER;
BEGIN
    -- Obtiene el total general de atenciones del periodo
    SELECT COUNT(pac_run) INTO total
    FROM atencion 
    WHERE TO_CHAR(fecha_atencion, 'MM-YYYY') = p_periodo;

    RETURN total;    
END;
-- Funcion almacenada 4
CREATE OR REPLACE FUNCTION fn_promedio(p_salud NUMBER, p_fecha DATE)
RETURN NUMBER
IS
    -- Almacena el promedio de edad
    promedio NUMBER;
BEGIN
    -- Obtiene el promedio de edad de los pacientes requeridos
    SELECT NVL(TRUNC(AVG(TRUNC(MONTHS_BETWEEN(p_fecha, fecha_nacimiento)/12))),0)
    INTO promedio
    FROM paciente a JOIN atencion b ON(a.pac_run = b.pac_run)
    WHERE TO_CHAR(fecha_atencion, 'MM-YYYY') = TO_CHAR(p_fecha, 'MM-YYYY')
        AND sal_id = p_salud;

    RETURN promedio;
END;

-- Procedimiento principal
CREATE OR REPLACE PROCEDURE sp_informe(p_fecha DATE, p_costo NUMBER)
IS
    -- Almacena los sistemas de salud
    CURSOR c_salud(p_costo_pago NUMBER) IS
        SELECT sal_id, descripcion
        FROM salud
        WHERE costo_pago >= p_costo_pago;
    -- Almacena el periodo de la fecha de consulta
    periodo VARCHAR2(7);
    -- Almacena el total de pacientes del periodo
    total_pacientes NUMBER;
    -- Almacena el total general
    total_general NUMBER;
    -- Almacena la proporcion
    proporcion resumen_por_periodo_ss.proporcion_total%TYPE;
    -- Almacena el promedio de edad
    promedio_edad NUMBER;
    -- Almacena la categoria
    categoria_ss resumen_por_periodo_ss.categoria%TYPE;
    -- Almacena la descripcion del error de oracle
    msg_oracle error_proceso.mensaje_error%TYPE;
BEGIN
    -- Obtiene el periodo
    periodo := TO_CHAR(p_fecha, 'MM-YYYY');
    -- Obtiene el total general para luego calcular la proporcion
    total_general := fn_total_general(periodo);    
    -- Procesa uno a uno cada sistema de salud
    FOR reg_salud IN c_salud(p_costo) LOOP
        -- Obtiene al cantidad de pacientes atendidos en el periodo
        total_pacientes := fn_total_pacientes(reg_salud.sal_id, periodo);
        BEGIN
            -- Calcula la proporcion
            proporcion := ROUND(total_pacientes/total_general);
        EXCEPTION WHEN ZERO_DIVIDE THEN
            proporcion := 0;
        END;
        -- Obtiene el promedio de edad
        promedio_edad := fn_promedio(reg_salud.sal_id, p_fecha);
        -- Obtiene la categoria
        categoria_ss := fn_categoria(promedio_edad);
        -- Inserta resultado
        BEGIN
            INSERT INTO resumen_por_periodo_ss
            VALUES(periodo, reg_salud.descripcion, total_pacientes,
            proporcion, promedio_edad, categoria_ss);
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
            msg_oracle := SQLERRM;
            INSERT INTO error_proceso
            VALUES(seq_error.NEXTVAL, 'EJECUCION', msg_oracle);
        END;
    END LOOP;
END;

-- Testear la solucion
DECLARE
    fecha_consulta DATE := TO_DATE('30-01-2023', 'dd-mm-YYYY');
    costo_pago NUMBER := 50;
BEGIN
    -- Llama al SP
    sp_informe(fecha_consulta, costo_pago);
END;