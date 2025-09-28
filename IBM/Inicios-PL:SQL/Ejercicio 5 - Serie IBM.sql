DROP TABLE reporte_cargos;
CREATE TABLE reporte_cargos
(
    id_cargo NUMBER PRIMARY KEY,
    nombre_cargo VARCHAR2(50) NOT NULL,
    total_medicos NUMBER NOT NULL,
    comentario VARCHAR2(100) NOT NULL
);

/*
Tablas necesarias: cargo, medico
Cursor explícito: cargo
*/
DECLARE
    -- Almacena los cargos a procesar
    CURSOR c_cargos IS
        SELECT car_id, nombre
        FROM cargo
        ORDER BY 2 DESC;
    -- Almacena el total de médicos del cargo
    total_medicos NUMBER;
    -- Almacena el comentario del cargo 
    comentario_cargo reporte_cargos.comentario%TYPE;
BEGIN
    -- Truncar la tabla resultado
    EXECUTE IMMEDIATE 'TRUNCATE TABLE reporte_cargos';
    -- Procesar uno a uno cada cargo
    FOR reg_cargo IN c_cargos LOOP
        -- Obtiene el total de médicos del cargo
        SELECT COUNT(med_run) INTO total_medicos
        FROM medico
        WHERE car_id = reg_cargo.car_id;
        -- Obtiene el comentario 
        IF total_medicos < 3 THEN
            comentario_cargo := 'REVISAR';
        ELSE
            comentario_cargo := 'ACEPTADO';
        END IF;
        -- Insertar el resiultado
        INSERT INTO reporte_cargos
        VALUES(reg_cargo.car_id, reg_cargo.nombre, total_medicos,
        comentario_cargo);
    END LOOP;
    COMMIT;    
END;

SELECT * FROM reporte_cargos;