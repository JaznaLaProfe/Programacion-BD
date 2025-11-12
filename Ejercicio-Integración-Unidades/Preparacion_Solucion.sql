-- Package
-- Encabezado
CREATE OR REPLACE PACKAGE pkg_ventas IS
    -- Función pública
    FUNCTION fn_total_boleta(p_num_boleta NUMBER) RETURN NUMBER;
    -- Procedimiento público
    PROCEDURE sp_insertar_error(p_unidad VARCHAR2, p_desc_oracle VARCHAR2, p_desc_real VARCHAR2);
    -- Variables 
    DIFERENCIA NUMBER;
    TOTAL_BOLETA NUMBER;
END;
-- Cuerpo
CREATE OR REPLACE PACKAGE BODY pkg_ventas IS
    -- Procedimiento público
    PROCEDURE sp_insertar_error(p_unidad VARCHAR2, p_desc_oracle VARCHAR2, p_desc_real VARCHAR2)
    IS
    BEGIN
        INSERT INTO log_errores
        VALUES(sq_error.NEXTVAL, p_unidad, p_desc_oracle, p_desc_real);
    END;

    -- Función pública
    FUNCTION fn_total_boleta(p_num_boleta NUMBER) RETURN NUMBER
    IS
    BEGIN
        SELECT NVL(SUM(vp_precio*bp_producto_cantidad),0) INTO pkg_ventas.TOTAL_BOLETA
        FROM boleta a JOIN boleta_producto b ON(a.bol_numero = b.bol_numero)
            JOIN vigencia_precio c ON(b.pro_codigo = c.pro_codigo AND
            a.bol_fecha BETWEEN vp_fecha_inicio_vigencia AND vp_fecha_termino_vigencia)
        WHERE a.bol_numero = p_num_boleta;

        RETURN pkg_ventas.TOTAL_BOLETA;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        sp_insertar_error($$PLSQL_UNIT, SQLERRM, 'Error al calcular el total de la boleta');
        RETURN 0;
    END;

END;
/
-- Función almcenada
CREATE OR REPLACE FUNCTION fn_categorizacion(p_diferencia NUMBER)
RETURN VARCHAR2
IS
    -- Almacena la categoria
    categoria categorizacion_diferencia.cd_categoria%TYPE;
BEGIN
    -- Obtiene la categoria de acuerdo a la diferencia
    SELECT cd_categoria INTO categoria
    FROM categorizacion_diferencia
    WHERE p_diferencia BETWEEN cd_valor_minimo AND cd_valor_maximo;

    RETURN categoria;
EXCEPTION WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
    PKG_VENTAS.sp_insertar_error($$PLSQL_UNIT, SQLERRM, 'Problemas con la categorizacion');
    RETURN 'SIN CATEGORIA';
END;
/
-- Procedimiento almacenado
CREATE OR REPLACE PROCEDURE sp_informe IS
    -- Almacena las boletas a procesar
    CURSOR c_boletas IS
        SELECT bol_numero, bol_fecha, bol_total, tip_nombre,
        ven_pnombre || ' ' || ven_apaterno || ' ' || ven_amaterno nombre_vendedor,
        cli_correo 
        FROM boleta a JOIN vendedor b ON(a.ven_rut = b.ven_rut)
        JOIN tipo_venta c ON(a.tip_id = c.tip_id)
        JOIN cliente d ON(a.cli_rut = d.cli_rut)
        WHERE c.tip_id IN (2,3);
    -- Almacena el total calculado
    total_calculado NUMBER;
    -- Almacena la categoria de la diferencia
    categoria_d resultado_boletas.categoria%TYPE;
BEGIN
    -- Procesa una a una cada boleta
    FOR reg_boleta IN c_boletas LOOP
        -- Obtiene el total calculado
        total_calculado := pkg_ventas.fn_total_boleta(reg_boleta.bol_numero);
        -- Obtiene la diferencia
        pkg_ventas.DIFERENCIA := ABS(reg_boleta.bol_total - total_calculado);
        -- Obtiene la categoria
        categoria_d := fn_categorizacion(pkg_ventas.DIFERENCIA);

        -- Guarda resultado
        INSERT INTO resultado_boletas
        VALUES(SQ_RESULTADO.NEXTVAL, SYSDATE, reg_boleta.bol_numero,
        reg_boleta.bol_fecha, reg_boleta.bol_total, total_calculado,
        reg_boleta.tip_nombre, reg_boleta.nombre_vendedor,
        reg_boleta.cli_correo, pkg_ventas.DIFERENCIA, categoria_d
        );
    END LOOP;
    COMMIT;
END;
-- Trigger
CREATE OR REPLACE TRIGGER trg_boletas
AFTER INSERT ON resultado_boletas
FOR EACH ROW
BEGIN
    -- Inserta el registro en el log
    INSERT INTO log_boletas
    VALUES(sq_log.NEXTVAL, USER, SYSDATE, :NEW.bol_numero,
    :NEW.bol_total, :NEW.diferencia_totales);
END;

-- Llamada al procedimiento principal
EXEC sp_informe;

SELECT * FROM resultado_boletas;
SELECT * FROM log_boletas;