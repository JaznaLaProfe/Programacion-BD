-- ELIMINACIÓN DE OBJETOS
DROP SEQUENCE SQ_LOG_PRECIO;
DROP SEQUENCE SQ_ERROR;
DROP SEQUENCE SQ_RESULTADO;

DROP TABLE VIGENCIA_PRECIO;
DROP TABLE ESPECIFICACION_TECNICA;
DROP TABLE BOLETA_PRODUCTO;
DROP TABLE PRODUCTO;
DROP TABLE PROVEEDOR;
DROP TABLE BOLETA;
DROP TABLE VENDEDOR;
DROP TABLE DIRECCION_DESPACHO;
DROP TABLE CLIENTE;
DROP TABLE LOG_MODIFICACION_PRECIO;
DROP TABLE RESULTADO_BOLETAS;
DROP TABLE LOG_ERRORES;
DROP TABLE CATEGORIZACION_DIFERENCIA;
DROP TABLE COMUNA;
DROP TABLE REGION;
DROP TABLE SUCURSAL;
DROP TABLE TIPO_VENTA;
DROP TABLE CATEGORIA;
DROP TABLE PAIS_ORIGEN;

-- CREACIÓN DE SECUENCIAS
CREATE SEQUENCE SQ_ERROR
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SQ_LOG
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SQ_RESULTADO
START WITH 1
INCREMENT BY 1;

-- CREACIÓN DE TABLAS
CREATE TABLE PAIS_ORIGEN (
    PO_CODIGO VARCHAR2(3),
    PO_NOMBRE VARCHAR2(75),
    CONSTRAINT PK_PAIS PRIMARY KEY(PO_CODIGO)
);

CREATE TABLE CATEGORIA (
    CAT_ID NUMBER(6),
    CAT_NOMBRE VARCHAR2(30) NOT NULL,
    CAT_DESCRIPCION VARCHAR2(250) NOT NULL,
    CONSTRAINT PK_CATEGORIA PRIMARY KEY(CAT_ID)
);

CREATE TABLE TIPO_VENTA (
    TIP_ID NUMBER(6),
    TIP_NOMBRE VARCHAR2(30) NOT NULL,
    CONSTRAINT PK_TIPO_VENTA PRIMARY KEY(TIP_ID)
);

CREATE TABLE SUCURSAL (
    SUC_ID NUMBER(6),
    SUC_NOMBRE VARCHAR2(75) NOT NULL,
    SUC_DIRECCION VARCHAR2(100) NOT NULL,
    CONSTRAINT PK_SUCURSAL PRIMARY KEY(SUC_ID)
);

CREATE TABLE REGION (
    REG_COD VARCHAR2(6),
    REG_NOMBRE VARCHAR(75) NOT NULL,
    CONSTRAINT PK_REGION PRIMARY KEY(REG_COD)
);

CREATE TABLE COMUNA (
    COM_ID NUMBER(6),
    COM_NOMBRE VARCHAR2(75),
    REG_COD VARCHAR2(6),
    CONSTRAINT PK_COMUNA PRIMARY KEY(COM_ID),
    CONSTRAINT FK_COMUNA_REGION FOREIGN KEY(REG_COD) REFERENCES REGION(REG_COD)
);

CREATE TABLE CATEGORIZACION_DIFERENCIA (
    CD_VALOR_MINIMO NUMBER(6),
    CD_VALOR_MAXIMO NUMBER(6),
    CD_CATEGORIA VARCHAR2(20)
);

CREATE TABLE LOG_ERRORES (
    LE_ID NUMBER(6),
    LE_PROGRAMA VARCHAR2(50) NOT NULL,
    LE_DESCRIPCION_SQL VARCHAR2(250) NOT NULL,
    LE_DESCRIPCION_REAL VARCHAR2(250) NOT NULL,
    CONSTRAINT PK_LOG_ERRORES PRIMARY KEY(LE_ID)
);

CREATE TABLE RESULTADO_BOLETAS (
    RB_ID NUMBER(6),
    RB_FECHA_EJECUCION DATE NOT NULL,
    BOL_NUMERO VARCHAR2(10) NOT NULL,
    BOL_FECHA DATE NOT NULL,
    BOL_TOTAL NUMBER(10) NOT NULL,
    BOL_TOTAL_CALCULADO NUMBER(10) NULL,
    TIP_NOMBRE VARCHAR2(30) NOT NULL,
    VEN_NOMBRE VARCHAR2(120) NOT NULL,
    CLI_CORREO VARCHAR2(75) NOT NULL,
    DIFERENCIA_TOTALES NUMBER(10) NOT NULL,
    CATEGORIA VARCHAR2(20) NOT NULL,
    CONSTRAINT PK_RES_BOLETA PRIMARY KEY(RB_ID)
);

CREATE TABLE LOG_BOLETAS (
    LOG_ID NUMBER(6) NOT NULL,
    LOG_USUARIO VARCHAR2(75) NOT NULL,
    LOG_FECHA DATE NOT NULL,
    LOG_BOLETA NUMBER NOT NULL,
    LOG_TOTAL_BOLETA NUMBER NOT NULL,
    LOG_DIFERENCIA_BOL NUMBER NOT NULL,
    CONSTRAINT PK_LOG_BOL PRIMARY KEY(LOG_ID)
);

CREATE TABLE CLIENTE (
    CLI_RUT VARCHAR2(8),
    CLI_DV VARCHAR2(1) NOT NULL,
    CLI_PNOMBRE VARCHAR2(30) NOT NULL,
    CLI_SNOMBRE VARCHAR2(30) NOT NULL,
    CLI_APATERNO VARCHAR2(30) NOT NULL,
    CLI_AMATERNO VARCHAR2(30) NOT NULL,
    CLI_CORREO VARCHAR2(75) NOT NULL,
    CONSTRAINT PK_CLIENTE PRIMARY KEY(CLI_RUT)
);

CREATE TABLE DIRECCION_DESPACHO (
    DD_ID NUMBER(6),
    DD_DIRECCION VARCHAR2(250) NOT NULL,
    DD_INFORMACION_ADICIONAL VARCHAR2(250),
    COM_ID NUMBER(6) NOT NULL,
    CLI_RUT VARCHAR2(8) NOT NULL,
    CONSTRAINT PK_DIRECCION_DESPACHO PRIMARY KEY(DD_ID),
    CONSTRAINT FK_DD_CLIENTE FOREIGN KEY(CLI_RUT) REFERENCES CLIENTE(CLI_RUT)
);

CREATE TABLE VENDEDOR (
    VEN_RUT VARCHAR2(8),
    VEN_DV VARCHAR2(1) NOT NULL,
    VEN_PNOMBRE VARCHAR2(30) NOT NULL,
    VEN_SNOMBRE VARCHAR2(30),
    VEN_APATERNO VARCHAR2(30) NOT NULL,
    VEN_AMATERNO VARCHAR2(30) NOT NULL,
    VEN_FECHA_NACIMIENTO DATE NOT NULL,
    VEN_SUELDO NUMBER(10) NOT NULL,
    SUC_ID NUMBER(6) NOT NULL,
    CONSTRAINT PK_VENDEDOR PRIMARY KEY(VEN_RUT),
    CONSTRAINT FK_VENDEDOR_SUCURSAL FOREIGN KEY(SUC_ID) REFERENCES SUCURSAL(SUC_ID)
);

CREATE TABLE BOLETA (
    BOL_NUMERO VARCHAR2(10),
    BOL_FECHA DATE NOT NULL,
    BOL_TOTAL NUMBER(10) NOT NULL,
    TIP_ID NUMBER(6) NOT NULL,
    CLI_RUT VARCHAR2(8) NOT NULL,
    VEN_RUT VARCHAR2(8) NOT NULL,
    CONSTRAINT PK_BOLETA PRIMARY KEY(BOL_NUMERO),
    CONSTRAINT FK_BOLETA_TIPO FOREIGN KEY(TIP_ID) REFERENCES TIPO_VENTA(TIP_ID),
    CONSTRAINT FK_BOLETA_CLIENTE FOREIGN KEY(CLI_RUT) REFERENCES CLIENTE(CLI_RUT),
    CONSTRAINT FK_BOLETA_VENDEDOR FOREIGN KEY(VEN_RUT) REFERENCES VENDEDOR(VEN_RUT)
);

CREATE TABLE PROVEEDOR (
    PROV_ID NUMBER(6),
    PROV_NOMBRE VARCHAR2(30) NOT NULL,
    PO_CODIGO VARCHAR2(3) NOT NULL,
    CONSTRAINT PK_PROVEEDOR PRIMARY KEY(PROV_ID),
    CONSTRAINT FK_PROVEEDOR_PAIS FOREIGN KEY(PO_CODIGO) REFERENCES PAIS_ORIGEN(PO_CODIGO)
);

CREATE TABLE PRODUCTO (
    PRO_CODIGO VARCHAR(12),
    PRO_NOMBRE VARCHAR2(30) NOT NULL,
    PRO_DESCRIPCION VARCHAR(4000),
    CAT_ID NUMBER(6) NOT NULL,
    PROV_ID NUMBER(6) NOT NULL,
    CONSTRAINT PK_PRODUCTO PRIMARY KEY(PRO_CODIGO),
    CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY(CAT_ID) REFERENCES CATEGORIA(CAT_ID),
    CONSTRAINT FK_PRODUCTO_PROVEEDOR FOREIGN KEY(PROV_ID) REFERENCES PROVEEDOR(PROV_ID)
);

CREATE TABLE BOLETA_PRODUCTO (
    BP_ID NUMBER(6),
    BP_PRODUCTO_CANTIDAD NUMBER(6) NOT NULL,
    BOL_NUMERO VARCHAR2(10) NOT NULL,
    PRO_CODIGO VARCHAR2(12) NOT NULL,
    CONSTRAINT PK_BOLETA_PRODUCTO PRIMARY KEY(BP_ID),
    CONSTRAINT FK_BP_BOLETA FOREIGN KEY(BOL_NUMERO) REFERENCES BOLETA(BOL_NUMERO),
    CONSTRAINT FK_BP_PRODUCTO FOREIGN KEY(PRO_CODIGO) REFERENCES PRODUCTO(PRO_CODIGO)
);

CREATE TABLE ESPECIFICACION_TECNICA (
    ET_ID NUMBER(6),
    ET_DESCRIPCION VARCHAR2(500) NOT NULL,
    PRO_CODIGO VARCHAR2(12) NOT NULL,
    CONSTRAINT PK_ESP PRIMARY KEY(ET_ID),
    CONSTRAINT FK_ESP_PRODUCTO FOREIGN KEY(PRO_CODIGO) REFERENCES PRODUCTO(PRO_CODIGO)
);

CREATE TABLE VIGENCIA_PRECIO (
    VP_ID NUMBER(6),
    VP_FECHA_INICIO_VIGENCIA DATE NOT NULL,
    VP_FECHA_TERMINO_VIGENCIA DATE NOT NULL,
    VP_PRECIO NUMBER(10) NOT NULL,
    PRO_CODIGO VARCHAR2(12) NOT NULL,
    CONSTRAINT PK_VIGENCIA PRIMARY KEY(VP_ID),
    CONSTRAINT FK_VIGENCIA_PRODUCTO FOREIGN KEY(PRO_CODIGO) REFERENCES PRODUCTO(PRO_CODIGO)
);


-- INSERT DATOS
INSERT INTO PAIS_ORIGEN VALUES('CL', 'Chile');
INSERT INTO PAIS_ORIGEN VALUES('CH', 'China');
INSERT INTO PAIS_ORIGEN VALUES('USA', 'Estados Unidos');

INSERT INTO PROVEEDOR VALUES(1, 'Proveedor Chile', 'CL');
INSERT INTO PROVEEDOR VALUES(2, 'Proveedor China', 'CH');
INSERT INTO PROVEEDOR VALUES(3, 'Proveedor Estados Unidos', 'USA');

INSERT INTO CATEGORIA VALUES(1, 'Categoría 1', 'Descripción Categoría 1');
INSERT INTO CATEGORIA VALUES(2, 'Categoría 2', 'Descripción Categoría 2');
INSERT INTO CATEGORIA VALUES(3, 'Categoría 3', 'Descripción Categoría 3');

INSERT INTO TIPO_VENTA VALUES(1, 'Interna');
INSERT INTO TIPO_VENTA VALUES(2, 'En Tienda');
INSERT INTO TIPO_VENTA VALUES(3, 'Online');

INSERT INTO SUCURSAL VALUES(1, 'Sucursal 1', 'Dirección Sucursal 1');
INSERT INTO SUCURSAL VALUES(2, 'Sucursal 2', 'Dirección Sucursal 2');
INSERT INTO SUCURSAL VALUES(3, 'Sucursal 3', 'Dirección Sucursal 3');

INSERT INTO VENDEDOR VALUES('12136287', '4', 'PNombre 1', 'SNombre 1', 'APaterno 1', 'AMaterno 1', TO_DATE('01/01/1987', 'DD/MM/YYYY'), 650000, 1);
INSERT INTO VENDEDOR VALUES('13694555', '2', 'PNombre 2', 'SNombre 2', 'APaterno 2', 'AMaterno 2', TO_DATE('01/01/1987', 'DD/MM/YYYY'), 670000, 2);
INSERT INTO VENDEDOR VALUES('12563987', '8', 'PNombre 3', 'SNombre 3', 'APaterno 3', 'AMaterno 3', TO_DATE('01/01/1987', 'DD/MM/YYYY'), 670000, 3);

INSERT INTO REGION VALUES('RM', 'Región Metropolitana');

INSERT INTO COMUNA VALUES(1, 'Santiago Centro', 'RM');
INSERT INTO COMUNA VALUES(2, 'Providencia', 'RM');
INSERT INTO COMUNA VALUES(3, 'Las Condes', 'RM');

INSERT INTO CLIENTE VALUES('12664124', '1', 'PNombre 1', 'SNombre 1', 'APaterno 1', 'AMaterno 1', 'correo1@cliente.com');
INSERT INTO CLIENTE VALUES('13375112', '3', 'PNombre 2', 'SNombre 2', 'APaterno 2', 'AMaterno 2', 'correo2@cliente.com');
INSERT INTO CLIENTE VALUES('14897334', '5', 'PNombre 3', 'SNombre 3', 'APaterno 3', 'AMaterno 3', 'correo3@cliente.com');
INSERT INTO CLIENTE VALUES('15843551', '7', 'PNombre 4', 'SNombre 4', 'APaterno 4', 'AMaterno 4', 'correo4@cliente.com');
INSERT INTO CLIENTE VALUES('11766223', '9', 'PNombre 5', 'SNombre 5', 'APaterno 5', 'AMaterno 5', 'correo5@cliente.com');

INSERT INTO DIRECCION_DESPACHO VALUES(1, 'Dirección 1', 'Información Adicional 1', 1, '12664124');
INSERT INTO DIRECCION_DESPACHO VALUES(2, 'Dirección 2', 'Información Adicional 2', 2, '13375112');
INSERT INTO DIRECCION_DESPACHO VALUES(3, 'Dirección 3', 'Información Adicional 3', 3, '14897334');
INSERT INTO DIRECCION_DESPACHO VALUES(4, 'Dirección 4', 'Información Adicional 4', 1, '15843551');
INSERT INTO DIRECCION_DESPACHO VALUES(5, 'Dirección 5', 'Información Adicional 5', 1, '11766223');

INSERT INTO PRODUCTO VALUES('111111111111', 'Producto 1', 'Descripción Producto 1', 1, 1);
INSERT INTO PRODUCTO VALUES('222222222222', 'Producto 2', 'Descripción Producto 2', 1, 1);
INSERT INTO PRODUCTO VALUES('333333333333', 'Producto 3', 'Descripción Producto 3', 1, 1);
INSERT INTO PRODUCTO VALUES('444444444444', 'Producto 4', 'Descripción Producto 4', 1, 1);
INSERT INTO PRODUCTO VALUES('555555555555', 'Producto 5', 'Descripción Producto 5', 1, 1);

INSERT INTO VIGENCIA_PRECIO VALUES(1, TO_DATE('01/06/2022', 'DD/MM/YYYY'), TO_DATE('30/06/2022', 'DD/MM/YYYY'), 5000, '111111111111');
INSERT INTO VIGENCIA_PRECIO VALUES(2, TO_DATE('01/06/2022', 'DD/MM/YYYY'), TO_DATE('30/06/2022', 'DD/MM/YYYY'), 6000, '222222222222');
INSERT INTO VIGENCIA_PRECIO VALUES(3, TO_DATE('01/06/2022', 'DD/MM/YYYY'), TO_DATE('30/06/2022', 'DD/MM/YYYY'), 7000, '333333333333');
INSERT INTO VIGENCIA_PRECIO VALUES(4, TO_DATE('01/06/2022', 'DD/MM/YYYY'), TO_DATE('30/06/2022', 'DD/MM/YYYY'), 8000, '444444444444');
INSERT INTO VIGENCIA_PRECIO VALUES(5, TO_DATE('01/06/2022', 'DD/MM/YYYY'), TO_DATE('30/06/2022', 'DD/MM/YYYY'), 9000, '555555555555');

INSERT INTO BOLETA VALUES('0000000001', TO_DATE('01/06/2022', 'DD/MM/YYYY'), 5000, 2, '12664124', '12136287');
INSERT INTO BOLETA_PRODUCTO VALUES(1, 1, '0000000001', '111111111111');
INSERT INTO BOLETA VALUES('0000000002', TO_DATE('01/06/2022', 'DD/MM/YYYY'), 5000, 2, '13375112', '12136287');
INSERT INTO BOLETA_PRODUCTO VALUES(2, 1, '0000000002', '222222222222');
INSERT INTO BOLETA VALUES('0000000003', TO_DATE('01/06/2022', 'DD/MM/YYYY'), 8000, 2, '14897334', '12136287');
INSERT INTO BOLETA_PRODUCTO VALUES(3, 1, '0000000003', '333333333333');
INSERT INTO BOLETA VALUES('0000000004', TO_DATE('01/06/2022', 'DD/MM/YYYY'), 12000, 2, '15843551', '12136287');
INSERT INTO BOLETA_PRODUCTO VALUES(4, 1, '0000000004', '444444444444');
INSERT INTO BOLETA VALUES('0000000005', TO_DATE('01/06/2022', 'DD/MM/YYYY'), 15000, 2, '15843551', '12136287');
INSERT INTO BOLETA_PRODUCTO VALUES(5, 1, '0000000005', '555555555555');

--
INSERT INTO BOLETA VALUES('0000000006', TO_DATE('01/06/2022', 'DD/MM/YYYY'), 15000, 2, '15843551', '12136287');
INSERT INTO BOLETA_PRODUCTO VALUES(6, 2, '0000000006', '444444444444');
INSERT INTO BOLETA_PRODUCTO VALUES(7, 3, '0000000006', '555555555555');
--

INSERT INTO ESPECIFICACION_TECNICA VALUES(1, 'Descripción ET 1', '111111111111');
INSERT INTO ESPECIFICACION_TECNICA VALUES(2, 'Descripción ET 2', '222222222222');
INSERT INTO ESPECIFICACION_TECNICA VALUES(3, 'Descripción ET 3', '333333333333');
INSERT INTO ESPECIFICACION_TECNICA VALUES(4, 'Descripción ET 4', '444444444444');
INSERT INTO ESPECIFICACION_TECNICA VALUES(5, 'Descripción ET 5', '555555555555');

INSERT INTO CATEGORIZACION_DIFERENCIA VALUES(1000, 25000, 'Categoría Baja');
INSERT INTO CATEGORIZACION_DIFERENCIA VALUES(25001, 50000, 'Categoría Media');
INSERT INTO CATEGORIZACION_DIFERENCIA VALUES(50001, 100000, 'Categoría Alta');

COMMIT;