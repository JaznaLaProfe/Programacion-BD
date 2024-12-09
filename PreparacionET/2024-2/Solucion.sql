-- Package
CREATE OR REPLACE PACKAGE pkg_boletas IS
    -- Variables
    DIFERENCIA NUMBER;
    TOTAL_BOLETA NUMBER;
    -- Funcion publica
    FUNCTION fn_total_boleta(p_boleta VARCHAR2) RETURN NUMBER;
    -- Procedimiento publico
    PROCEDURE sp_erorres(p_programa VARCHAR2, p_desc_sql VARCHAR2, 
        p_desc_real VARCHAR2);
END;
-- Cuerpo del package
CREATE OR REPLACE PACKAGE BODY pkg_boletas IS
    FUNCTION fn_total_boleta(p_boleta VARCHAR2) RETURN NUMBER
    IS
        -- Almacena el total de la boleta de aceurdo con la RN
        total NUMBER;
    BEGIN
        SELECT NVL(SUM(c.VP_PRECIO*b.BP_PRODUCTO_CANTIDAD),0) INTO total
        FROM boleta a JOIN boleta_producto b ON(a.BOL_NUMERO = b.BOL_NUMERO)
        JOIN vigencia_precio c 
        ON(a.BOL_FECHA BETWEEN C.VP_FECHA_INICIO_VIGENCIA AND C.VP_FECHA_TERMINO_VIGENCIA
        AND c.PRO_CODIGO = b.PRO_CODIGO)
        WHERE a.BOL_NUMERO = p_boleta;
    
        RETURN total;
    END;
    PROCEDURE sp_erorres(p_programa VARCHAR2, p_desc_sql VARCHAR2, 
        p_desc_real VARCHAR2)
    IS
    BEGIN
        INSERT INTO log_errores
        VALUES(SQ_ERROR.NEXTVAL, p_programa, p_desc_sql, p_desc_real);
    END;
END;

-- Funcion almacenada
CREATE OR REPLACE FUNCTION fn_categorizacion(p_diferencia NUMBER)
RETURN VARCHAR2
IS
    -- Almacena la categoria
    categoria_boleta CATEGORIZACION_DIFERENCIA.CD_CATEGORIA%TYPE;
    -- Almacena la descripcion del error oracle
    msg_oracle log_errores.LE_DESCRIPCION_SQL%TYPE;
BEGIN
    SELECT cd_categoria INTO categoria_boleta 
    FROM CATEGORIZACION_DIFERENCIA
    WHERE p_diferencia BETWEEN CD_VALOR_MINIMO AND CD_VALOR_MAXIMO;

    RETURN categoria_boleta;
EXCEPTION WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
    msg_oracle := SQLERRM;
    pkg_boletas.sp_erorres($$PLSQL_UNIT, msg_oracle, 
        'Problema con obtener la categoria ');
    RETURN 'SIN CATEGORIA';
END;
-- Procedimiento almacenado
CREATE OR REPLACE PROCEDURE sp_informe 
IS
    -- Almacena las boletas a procesar
    CURSOR c_boletas IS
        SELECT bol_numero, bol_fecha, bol_total, B.TIP_NOMBRE, 
        c.VEN_PNOMBRE || ' ' || c.VEN_SNOMBRE || ' ' || c.VEN_APATERNO || ' '
        || c.VEN_AMATERNO nombre_vendedor, cli_correo
        FROM boleta a JOIN TIPO_VENTA b ON(a.TIP_ID = b.TIP_ID)
        JOIN vendedor c ON(a.VEN_RUT = c.VEN_RUT)
        JOIN cliente d ON(a.CLI_RUT = d.CLI_RUT)
        WHERE a.tip_id IN (2,3);
    -- Almacena la categoria
    categoria_b CATEGORIZACION_DIFERENCIA.CD_CATEGORIA%TYPE;
    -- Almacena la descripcion del error oracle
    msg_oracle log_errores.LE_DESCRIPCION_SQL%TYPE;    
BEGIN
    -- Recorrer las boletas a procesar
    FOR reg_boleta IN c_boletas LOOP
        -- Obtiene el total de acuerdo con la RN
        pkg_boletas.TOTAL_BOLETA := pkg_boletas.fn_total_boleta(reg_boleta.bol_numero);
        -- Calcula la diferencia
        pkg_boletas.DIFERENCIA := ABS(pkg_boletas.TOTAL_BOLETA  - reg_boleta.bol_total);
        -- Obtiene la categoria de acuerdo con la diferencia
        categoria_b := fn_categorizacion(pkg_boletas.DIFERENCIA);
        -- Inserta resultado en la tabla
        BEGIN
            INSERT INTO RESULTADO_BOLETAS
            VALUES(SQ_RESULTADO.NEXTVAL, SYSDATE, reg_boleta.bol_numero,
            reg_boleta.bol_fecha, reg_boleta.bol_total, pkg_boletas.TOTAL_BOLETA ,
            reg_boleta.tip_nombre, reg_boleta.nombre_vendedor,
            reg_boleta.cli_correo, pkg_boletas.DIFERENCIA, categoria_b);
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
            msg_oracle := SQLERRM;
            pkg_boletas.sp_erorres($$PLSQL_UNIT, msg_oracle, 
                'Problema AL INSERTAR RESULTADO');        
        END;
    END LOOP;
END;

CREATE OR REPLACE TRIGGER trg_boletas
AFTER INSERT ON resultado_boletas
FOR EACH ROW
BEGIN
    -- Inserta registro en la tabla log_errores
    INSERT INTO LOG_BOLETAS
    VALUES(SQ_LOG.NEXTVAL, USER, SYSDATE, :NEW.BOL_NUMERO,
    :NEW.bol_total, :NEW.DIFERENCIA_TOTALES);
END;

-- Prueba el proceso
SELECT * FROM RESULTADO_BOLETAS;
SELECT * FROM log_BOLETAS;

EXEC sp_informe;