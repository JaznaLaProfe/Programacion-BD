
CONNECT ref_duoc/duoc@localhost:1521/XE;
/* BORRADO DE LAS TABLAS SI YA ESTÁN CREADAS */
DROP TABLE ARRIENDO_CAMION CASCADE CONSTRAINTS;
DROP TABLE CAMION CASCADE CONSTRAINTS;
DROP TABLE CLIENTE CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE MARCA CASCADE CONSTRAINTS;
DROP TABLE TIPO_CLIENTE	CASCADE CONSTRAINTS;
DROP TABLE TIPO_CAMION CASCADE CONSTRAINTS;
DROP TABLE TIPO_SALUD CASCADE CONSTRAINTS;
DROP TABLE AFP CASCADE CONSTRAINTS;
DROP TABLE EMPLEADO CASCADE CONSTRAINTS;
DROP TABLE ESTADO_CIVIL CASCADE CONSTRAINTS;
DROP TABLE PROY_MOVILIZACION CASCADE CONSTRAINTS;
DROP TABLE USUARIO_CLAVE CASCADE CONSTRAINTS;
DROP TABLE HIST_ARRIENDO_ANUAL_CAMION CASCADE CONSTRAINTS;
DROP TABLE INFO_SII CASCADE CONSTRAINTS;
DROP TABLE BONIF_POR_UTILIDAD CASCADE CONSTRAINTS;
DROP TABLE TRAMO_ANTIGUEDAD CASCADE CONSTRAINTS;

/* BORRADO DE SECUENCIAS */
DROP SEQUENCE SEQ_PROVINCIA;
DROP SEQUENCE SEQ_ESTCIVIL;
DROP SEQUENCE SEQ_MARCA;
DROP SEQUENCE SEQ_ARRIENDO;
DROP SEQUENCE SEQ_ID_CLIENTE;
DROP SEQUENCE SEQ_ID_EMP;
DROP SEQUENCE SEQ_ID_CAMION;

/* CREACION DE SECUENCIAS */
CREATE SEQUENCE SEQ_PROVINCIA START WITH 80;
CREATE SEQUENCE SEQ_ESTCIVIL START WITH 10 INCREMENT BY 10;
CREATE SEQUENCE SEQ_MARCA START WITH 10 INCREMENT BY 10;
CREATE SEQUENCE SEQ_ARRIENDO;
CREATE SEQUENCE SEQ_ID_CLIENTE START WITH 10 INCREMENT BY 5;
CREATE SEQUENCE SEQ_ID_EMP START WITH 100 INCREMENT BY 10;
CREATE SEQUENCE SEQ_ID_CAMION START WITH 1000 INCREMENT BY 1;

/* CREACIÓN DE TABLAS */
CREATE TABLE TRAMO_ANTIGUEDAD
( SEC_TRAMO_ANTIGUEDAD NUMBER(2) GENERATED  ALWAYS AS IDENTITY MINVALUE 1 
MAXVALUE 999999999 INCREMENT BY 1 START WITH 1 NOT NULL ENABLE,
  ANNO_VIG NUMBER(4) NOT NULL,
  TRAMO_INF NUMBER(2) NOT NULL,
  TRAMO_SUP NUMBER(2) NOT NULL, 
  PORCENTAJE NUMBER(2) NOT NULL,
  CONSTRAINT PK_TRAMO_ANTIGUEDAD PRIMARY KEY (SEC_TRAMO_ANTIGUEDAD,ANNO_VIG));
  
CREATE TABLE ARRIENDO_CAMION 
(id_arriendo NUMBER(7) NOT NULL CONSTRAINT PK_ARRIENDO_CAMION PRIMARY KEY,
 id_camion NUMBER(6) NOT NULL,
 id_cli NUMBER(10) NOT NULL,
 fecha_ini_arriendo DATE NOT NULL,
 dias_solicitados NUMBER(6),
 fecha_devolucion DATE);

CREATE TABLE TIPO_SALUD  
(cod_tipo_sal  VARCHAR2(3) NOT NULL CONSTRAINT PK_TIPO_SALUD PRIMARY KEY ,
desc_salud VARCHAR2 (100) NOT NULL,
porc_descto_salud  NUMBER(3,1) NOT NULL);

CREATE TABLE AFP  
(cod_afp  NUMBER(3) NOT NULL CONSTRAINT PK_AFP PRIMARY KEY ,
desc_afp VARCHAR2 (100) NOT NULL,
porc_descto_afp  NUMBER(3,1) NOT NULL);

CREATE TABLE CLIENTE
(id_cli NUMBER(6) GENERATED  ALWAYS AS IDENTITY MINVALUE 10 
MAXVALUE 999999999 INCREMENT BY 5 START WITH 10 NOT NULL ENABLE,
numrun_cli NUMBER(10) NOT NULL,
 dvrun_cli VARCHAR2(1) NOT NULL,
 appaterno_cli VARCHAR2(30) NOT NULL,
 apmaterno_cli VARCHAR2(30) NOT NULL,
 pnombre_cli VARCHAR2(30) NOT NULL,
 snombre_cli VARCHAR2(30),
 direccion VARCHAR2(60) NOT NULL,
 celular_cli NUMBER(15),
 fono_fijo_cli NUMBER(15), 
 renta NUMBER(7) NOT NULL,
 fecha_nac_cli DATE,
 id_comuna NUMBER(3),
 id_tipo_cli VARCHAR2(1) NOT NULL,
 id_estado_civil NUMBER(2) NOT NULL,
 CONSTRAINT PK_CLIENTE PRIMARY KEY(id_cli));

CREATE TABLE COMUNA
(id_comuna NUMBER(3) NOT NULL CONSTRAINT PK_COMUNA PRIMARY KEY,
 nombre_comuna VARCHAR2(30) NOT NULL CONSTRAINT UN_COMUNA_NOMCOMUNA UNIQUE);

CREATE TABLE EMPLEADO
(id_emp NUMBER(6) GENERATED  ALWAYS AS IDENTITY MINVALUE 100 
MAXVALUE 999999999 INCREMENT BY 10 START WITH 100 NOT NULL ENABLE,
numrun_emp NUMBER(10) NOT NULL,
 dvrun_emp VARCHAR2(1) NOT NULL,
 appaterno_emp VARCHAR2(30) NOT NULL,
 apmaterno_emp VARCHAR2(30) NOT NULL,
 pnombre_emp VARCHAR2(25) NOT NULL,
 snombre_emp VARCHAR2(25),
 direccion_emp VARCHAR2(60) NOT NULL,
 sexo CHAR(1) NOT NULL CONSTRAINT CHK_SEXO CHECK (sexo IN ('F','M')),
 celular_emp NUMBER(15),
 fono_fijo_emp NUMBER(15),
 fecha_nac DATE NOT NULL,
 fecha_contrato DATE NOT NULL,
 sueldo_base NUMBER(7) NOT NULL,
 id_comuna NUMBER(3),
 cod_tipo_sal  VARCHAR2(3)  NOT NULL,
 cod_afp NUMBER(3) NOT NULL,
 id_estado_civil NUMBER(2) NOT NULL,
  CONSTRAINT PK_EMPLEADO PRIMARY KEY(id_emp));

CREATE TABLE MARCA
(id_marca NUMBER(2) NOT NULL CONSTRAINT PK_MARCA PRIMARY KEY,
 nombre_marca VARCHAR2(20) NOT NULL);


CREATE TABLE TIPO_CLIENTE
(id_tipo_cli VARCHAR2(1) NOT NULL CONSTRAINT PK_TIPO_CLIENTE PRIMARY KEY ,
 nombre_tipo_cli VARCHAR2(15) NOT NULL);

CREATE TABLE TIPO_CAMION
(id_tipo_camion VARCHAR2(1) NOT NULL CONSTRAINT PK_TIPO_CAMION PRIMARY KEY,
 nombre_tipo_camion VARCHAR2(40) NOT NULL);

CREATE TABLE CAMION 
(id_camion NUMBER(6) GENERATED  ALWAYS AS IDENTITY MINVALUE 1000 
MAXVALUE 999999999 INCREMENT BY 1 START WITH 1000 NOT NULL ENABLE,
 nro_patente VARCHAR2(6) NOT NULL,
 color VARCHAR2(15) NOT NULL,
 motor VARCHAR2(5) NOT NULL,
 anio  NUMBER(4),
 valor_arriendo_dia NUMBER(7) NOT NULL,
 valor_garantia_dia NUMBER(6),
 id_tipo_camion VARCHAR2(1) NOT NULL,
 id_emp NUMBER(6) NOT NULL,
 id_marca NUMBER(2) NOT NULL,
 CONSTRAINT PK_CAMION PRIMARY KEY(id_camion));

CREATE TABLE ESTADO_CIVIL 
(id_estado_civil NUMBER(2) NOT NULL CONSTRAINT ESTADO_CIVIL_PK PRIMARY KEY,
 nombre_estado_civil VARCHAR2(25) NOT NULL);
 
 
CREATE TABLE PROY_MOVILIZACION
(anno_proceso NUMBER(4) NOT NULL,
 id_emp NUMBER(6) NOT NULL,
 numrun_emp NUMBER(10) NOT NULL,
 dvrun_emp VARCHAR2(1) NOT NULL,
 nombre_empleado VARCHAR2(60) NOT NULL,
 nombre_comuna VARCHAR2(30) NOT NULL,
 sueldo_base NUMBER(7) NOT NULL,
 porc_movil_normal NUMBER(2) NOT NULL,
 valor_movil_normal NUMBER(6) NOT NULL,
 valor_movil_extra NUMBER(6) NOT NULL,
 valor_total_movil NUMBER(6) NOT NULL,
 CONSTRAINT PK_PROY_MOVIL PRIMARY KEY(anno_proceso,id_emp));

CREATE TABLE BONIF_POR_UTILIDAD
(anno_proceso NUMBER(4) NOT NULL,
 id_emp NUMBER(6) NOT NULL,
 sueldo_base NUMBER(7) NOT NULL,
 valor_bonif_utilidad NUMBER(10) NOT NULL,
 CONSTRAINT PK_BONIF_POR_UTILIDAD PRIMARY KEY(anno_proceso,id_emp));

CREATE TABLE USUARIO_CLAVE
(id_emp NUMBER(6) NOT NULL,
 numrun_emp NUMBER(10) NOT NULL,
 dvrun_emp VARCHAR2(1) NOT NULL,
 nombre_empleado VARCHAR2(60) NOT NULL,
 nombre_usuario VARCHAR2(20) NOT NULL,
 clave_usuario VARCHAR2(20) NOT NULL,
 CONSTRAINT PK_USUARIO_CLAVE PRIMARY KEY(id_emp));

 CREATE TABLE HIST_ARRIENDO_ANUAL_CAMION
(anno_proceso NUMBER(4) NOT NULL,
 id_camion NUMBER(6) NOT NULL,
 nro_patente VARCHAR2(6) NOT NULL,
 valor_arriendo_dia NUMBER(8) NOT NULL,
 valor_garactia_dia NUMBER(8),
 total_veces_arrendado NUMBER(4) NOT NULL,
 CONSTRAINT PK_ARRIENDO_ANUAL_CAMION PRIMARY KEY(anno_proceso,id_camion));
 
 CREATE TABLE INFO_SII
 (anno_tributario NUMBER(4) NOT NULL,
 id_emp NUMBER(6) NOT NULL,
 run_empleado VARCHAR2(20) NOT NULL,
 nombre_empleado VARCHAR2(60) NOT NULL,
 cargo VARCHAR2(30) NOT NULL,
 meses_trabajados NUMBER(2) NOT NULL,
 annos_trabajados NUMBER(2) NOT NULL,
 sueldo_base_mensual NUMBER(15) NOT NULL,
 sueldo_base_anual NUMBER(15) NOT NULL,
 bono_annos_anual NUMBER(15) NOT NULL,
 bono_especial_anual NUMBER(15) NOT NULL,
 movilizacion_anual NUMBER(8) NOT NULL,
 colacion_anual NUMBER(8) NOT NULL,
 desctos_legales NUMBER(8) NOT NULL,
 sueldo_bruto_anual NUMBER(8) NOT NULL,
 renta_imponible_anual NUMBER(10),
 CONSTRAINT PK_INFO_SII PRIMARY KEY(anno_tributario,id_emp));

ALTER TABLE arriendo_camion
    ADD CONSTRAINT fk_arriendocamion_cliente FOREIGN KEY (id_cli)
        REFERENCES cliente (id_cli);

ALTER TABLE arriendo_camion
    ADD CONSTRAINT fk_arriendocamion_camion FOREIGN KEY(id_camion)
        REFERENCES camion(id_camion);

ALTER TABLE cliente
    ADD CONSTRAINT fk_cliente_comuna FOREIGN KEY (id_comuna)
        REFERENCES comuna (id_comuna);

ALTER TABLE cliente
    ADD CONSTRAINT fk_cliente_tipocliente FOREIGN KEY (id_tipo_cli)
        REFERENCES tipo_cliente(id_tipo_cli);

ALTER TABLE cliente
    ADD CONSTRAINT fk_cliente_estado_civil FOREIGN KEY (id_estado_civil)
        REFERENCES estado_civil(id_estado_civil);

ALTER TABLE empleado
    ADD CONSTRAINT fk_empleado_comuna FOREIGN KEY (id_comuna)
        REFERENCES comuna(id_comuna);

ALTER TABLE empleado
    ADD CONSTRAINT fk_empleado_estado_civil FOREIGN KEY (id_estado_civil)
        REFERENCES estado_civil(id_estado_civil);
        
ALTER TABLE empleado
    ADD CONSTRAINT fk_empleado_cod_salud FOREIGN KEY (cod_tipo_sal)
        REFERENCES tipo_salud(cod_tipo_sal);        

ALTER TABLE empleado
    ADD CONSTRAINT fk_empleado_cod_afp FOREIGN KEY (cod_afp)
        REFERENCES afp(cod_afp);  

ALTER TABLE camion
    ADD CONSTRAINT fk_camion_empleado FOREIGN KEY (id_emp)
        REFERENCES empleado(id_emp);

ALTER TABLE camion
    ADD CONSTRAINT fk_camion_marca FOREIGN KEY (id_marca)
        REFERENCES marca (id_marca);

ALTER TABLE camion
    ADD CONSTRAINT fk_camion_tipo_camion_fk FOREIGN KEY (id_tipo_camion)
        REFERENCES tipo_camion(id_tipo_camion);
        
ALTER TABLE proy_movilizacion
    ADD CONSTRAINT fk_proy_movil_emp FOREIGN KEY (id_emp)
        REFERENCES empleado(id_emp);
        
ALTER TABLE usuario_clave
    ADD CONSTRAINT fk_usuario_clave_emp FOREIGN KEY (id_emp)
        REFERENCES empleado(id_emp);   

ALTER TABLE hist_arriendo_anual_camion
    ADD CONSTRAINT fk_arriendo_anual_cam_camion FOREIGN KEY (id_camion)
        REFERENCES camion(id_camion);   

ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY';
INSERT INTO TRAMO_ANTIGUEDAD(ANNO_VIG,TRAMO_INF,TRAMO_SUP,PORCENTAJE) VALUES((EXTRACT(YEAR FROM SYSDATE)-1),1,9,4);
INSERT INTO TRAMO_ANTIGUEDAD(ANNO_VIG,TRAMO_INF,TRAMO_SUP,PORCENTAJE) VALUES((EXTRACT(YEAR FROM SYSDATE)-1),10,15,6);
INSERT INTO TRAMO_ANTIGUEDAD(ANNO_VIG,TRAMO_INF,TRAMO_SUP,PORCENTAJE) VALUES((EXTRACT(YEAR FROM SYSDATE)-1),16,25,7);
INSERT INTO TRAMO_ANTIGUEDAD(ANNO_VIG,TRAMO_INF,TRAMO_SUP,PORCENTAJE) VALUES((EXTRACT(YEAR FROM SYSDATE)-1),26,40,10);
INSERT INTO TRAMO_ANTIGUEDAD(ANNO_VIG,TRAMO_INF,TRAMO_SUP,PORCENTAJE) VALUES((EXTRACT(YEAR FROM SYSDATE)),1,9,5);
INSERT INTO TRAMO_ANTIGUEDAD(ANNO_VIG,TRAMO_INF,TRAMO_SUP,PORCENTAJE) VALUES((EXTRACT(YEAR FROM SYSDATE)),10,15,7);
INSERT INTO TRAMO_ANTIGUEDAD(ANNO_VIG,TRAMO_INF,TRAMO_SUP,PORCENTAJE) VALUES((EXTRACT(YEAR FROM SYSDATE)),16,25,8);
INSERT INTO TRAMO_ANTIGUEDAD(ANNO_VIG,TRAMO_INF,TRAMO_SUP,PORCENTAJE) VALUES((EXTRACT(YEAR FROM SYSDATE)),26,40,11);

INSERT INTO AFP VALUES(1,'CAPITAL',10);
INSERT INTO AFP VALUES(2,'CUPRUM',12);
INSERT INTO AFP VALUES(3,'HABITAT',14);
INSERT INTO AFP VALUES(4,'MODELO',8);
INSERT INTO AFP VALUES(5,'PLANVITAL',15);
INSERT INTO AFP VALUES(6,'PROVIDA',13);

INSERT INTO  TIPO_SALUD VALUES('F','Fonasa', 7.2);
INSERT INTO  TIPO_SALUD VALUES('I','Isapre', 8.3);
INSERT INTO  TIPO_SALUD VALUES('FA','Fuerzas Armada', 4.5);
INSERT INTO  TIPO_SALUD VALUES('C','Carabineros y PDI', 5.3);
INSERT INTO  TIPO_SALUD VALUES('P','Particular', 11.3);

INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Las Condes');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Providencia');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Santiago');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Ñuñoa');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Vitacura');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'La Reina');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'La Florida');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Maipú');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Lo Barnechea');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Macul');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'San Miguel');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Peñalolén');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Puente Alto');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Recoleta');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Estación Central');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'San Bernardo');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Independencia');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'La Cisterna');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Quilicura');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Quinta Normal');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Conchalí');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'San Joaquín');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Huechuraba');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'El Bosque');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Cerrillos');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Cerro Navia');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'La Granja');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'La Pintana');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Lo Espejo');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Lo Prado');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Pedro Aguirre Cerda');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Pudahuel');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Renca');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'San Ramón');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Melipilla');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'San Pedro');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Alhué');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'María Pinto');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Curacaví');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Talagante');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'El Monte');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Buin');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Paine');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Peñaflor');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Isla de Maipo');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Colina');
INSERT INTO comuna VALUES (SEQ_PROVINCIA.NEXTVAL,'Pirque');

INSERT INTO tipo_camion  VALUES ('A','Tradicional 6 Toneladas');
INSERT INTO tipo_camion  VALUES ('B','Frigorífico');
INSERT INTO tipo_camion  VALUES ('C','Camión 3/4');
INSERT INTO tipo_camion  VALUES ('D','Trailer');
INSERT INTO tipo_camion  VALUES ('E','Tolva');

INSERT INTO tipo_cliente VALUES ('A','Socio');
INSERT INTO tipo_cliente VALUES ('B','VIP');
INSERT INTO tipo_cliente VALUES ('C','Nacional');
INSERT INTO tipo_cliente VALUES ('D','Extranjero');

INSERT INTO ESTADO_CIVIL VALUES (SEQ_ESTCIVIL.NEXTVAL,'CASADO');
INSERT INTO ESTADO_CIVIL VALUES (SEQ_ESTCIVIL.NEXTVAL,'DIVORCIADO');
INSERT INTO ESTADO_CIVIL VALUES (SEQ_ESTCIVIL.NEXTVAL,'SOLTERO');
INSERT INTO ESTADO_CIVIL VALUES (SEQ_ESTCIVIL.NEXTVAL,'VIUDO');
INSERT INTO ESTADO_CIVIL VALUES (SEQ_ESTCIVIL.NEXTVAL,'SEPARADO');
INSERT INTO ESTADO_CIVIL VALUES (SEQ_ESTCIVIL.NEXTVAL,'ACUERDO DE UNION CIVIL');

INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(11649964,'0','GALVEZ','CASTRO','MARTA','PATRICIA','CLOVIS MONTERO 0260 D/202','F',52710253,'23417556','2008' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-48),'0108' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),350000,120,'F',1,30);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(12113369,'4','ROMERO','DIAZ','NANCY',NULL,'TENIENTE RAMON JIMENEZ 4753','F',55212406,'25631567','0901' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-51),'3108' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-30),2710153,81,'FA',2,40);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(12456905,'1','CANALES','BASTIAS','JORGE','FERNANDO','GENERAL CONCHA PEDREGAL #885','M',77413705,'27779827','2107' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-62),'1208' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-38),2945675,81,'FA',3,10);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(12466553,'2','VIDAL','PEREZ','MARIA','TERESA','FCO. DE CAMARGO 14515 D/14','F',92853737,NULL,'0510' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-52),'1308' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-25),1202614,82,'I',3,20);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(11745244,'3','VENEGAS','SOTO','KARINA','SOFIA','ARICA 3850','F',52794874,'27790734','2308' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-56),'1408' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-33),1439042,83,'I',4,30);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(11999100,'4','CONTRERAS','CASTILLO','CLAUDIO',NULL,'ISABEL RIQUELME 6075','M',85450443,'27764142','2412' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-53),'1508' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-27),364163,119,'F',5,10);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(12888868,'5','PAEZ','MACMILLAN','JOSE','PATRICIO','FERNANDEZ CONCHA 500','M',55341874,'22399493','2508' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-55),'1608' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-30),1896155,85,'F',6,20);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(12811094,'6','MOLINA','GONZALEZ','PAULA','ANDREA','PJE.TIMBAL 1095 V/POMAIRE','F',62737281,'25313830','2612' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-41),'1708' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-18),1757577,86,'I',1,40);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(14255602,'7','MUÑOZ','ROJAS','CARLOTA','MARINA','TERCEIRA 7426 V/LIBERTAD','F',97773749,'26490093','2708' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-37),'1808' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-15),2658577,87,'F',2,30);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(11630572,'8','ARAVENA','HERBAGE','GUSTAVO','ESTEBAN','FERNANDO DE ARAGON 8420','M',88122441,'25588481','0603' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-50),'1908' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-20),1957095,88,'F',2,20);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(11636534,'9','ADASME','ZUÑIGA','LUIS','ALFREDO','LITTLE ROCK 117 V/PDTE.KENNEDY','M',56434256,'26483081','2912' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-46),'2008' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-25),1614934,89,'F',3,30);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(12272880,'K','LAPAZ','SEPULVEDA','MARCO',NULL,'GUARDIA MARINA. RIQUELME 561','M',75631102,'26038967','2008' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-50),'2108'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-20),1352596,121,'I',4,10);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(11846972,'5','OGAZ','VARAS','MARCO','ANTONIO','OVALLE Nº5798 V/ OHIGGINS','M',76432652, NULL,'3112' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-60),'2208'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-36),325590,118,'F',5,20);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(14283083,'6','MONDACA','COLLAO','PEDRO','HERNAN','NUEVA COLON Nº1152','M',67416145,NULL,'2107' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-30),'0108'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),1144245,95,'F',5,40);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(14541837,'7','ALVAREZ','RIVERA','MARCO','LUIS','HONDURAS B/8908 D/102 L.BRISAS','M',65582082,'22875902','0201' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-49),'2408'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-25),1541418,97,'FA',6,30);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(12482036,'8','OLAVE','CASTILLO','ADRIAN',NULL,'ELISA CORREA 188','M',52811129,'22888897','1007' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-63),'2508'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-35),1068086,98,'F',6,10);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(12468081,'9','SANCHEZ','GONZALEZ','PAOLA','ANDREA','AV.OSSA 01240 V/MI VIÑITA','F',56832705,'25273328','0401' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-32),'2608'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-9),1330355,99,'F',3,20);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(12260812,'0','RIOS','ZUÑIGA','RAFAEL','ALFONSO','LOS CASTAÑOS 1427 VILLA C.C.U.','M',96255762,'26410462','2507' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-28),'2708'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-8),367056,118,'F',4,40);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(12899759,'1','CACERES','JIMENEZ','ERIKA',NULL,'PJE.NAVARINO 15758 V/P.DE OÑA','F',82936654,NULL,'2308' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-51),'2808'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-27),2281415,107,'F',5,30);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(12868553,'2','CHACON','AMAYA','PATRICIA','ROMINA','LO ERRAZURIZ 530 V/EL SENDERO','F',76442200,'25577963','0701' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-34),'2908'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-15),1723055,117,'F',2,10);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(12648200,'3','NARVAEZ','MUÑOZ','LUIS','ANTONIO','AMBRIOSO OHIGGINS  2010','M',65351928,NULL,'0807' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-26),'3008'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-7),1966613,80,'I',1,20);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(11670042,'5','GONGORA','DEVIA','VALESKA','ANDREA','PASAJE VENUS 2765','F',67765258,'23244270','1007' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-51),'0109'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-23),1635086,82,'P',3,30);
INSERT INTO EMPLEADO(numrun_emp,dvrun_emp,appaterno_emp,apmaterno_emp,pnombre_emp,snombre_emp,direccion_emp,sexo,celular_emp,fono_fijo_emp,fecha_nac,fecha_contrato,sueldo_base,id_comuna,cod_tipo_sal,cod_afp,id_estado_civil) VALUES(12642309,'K','NAVARRO','SANTIBAÑEZ','JUAN','ESTEBAN','SANTA ELENA 300 V/LOS ALAMOS','F',52893123,'27441530','1101' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-33),'0111'|| TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),1659230,83,'F',5,10);

INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('10639521','0','UVAL','RIQUELME','MIGUEL','ANGEL','SAN PABLO 7545 B/2 DPTO. 12','55285702','26439756','300000','18/08/1971','85','A','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13074837','1','AMENGUAL','SALDIAS','CESAR','MAURICIO','PJE.CODORNICES 1550 V/EL RODEO','8491680','22168405','400000','31/08/1989','86','B','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12251882','2','MORICE','DONOSO','CLAUDIO',null,'CHACALLUTA 9519','95292190','22814948','200000','18/08/1957','87','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('10238830','3','SOTO','ARMAZAN','JUAN','MIGUEL','LOS MORELOS 803',null,'25237022','200000','17/08/1966','88','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12777063','4','VILLENA','CAVERO','PABLO',null,'NAVIDAD 1345 SEC.LA PALMILLA','8152298','26234565','600000','17/08/1963','89','A','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12467572','5','RIQUELME','BRIGNARDELLO','MIGUEL','ARTURO','AMERICO VESPUCIO 1505 V/MEXICO','85286676','25381416','500000','19/08/1964','92','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12866487','6','STOLLER','VARGAS','LORENA','ANDREA','PASCUAL BABURIZZA 655','77764463','22773144','250000','18/08/1978','94','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13463138','7','BRAVO','HENRIQUEZ','PABLO',null,'FLACO MARIN #107 V/ C. NORTE','67783253','27766349','380000','15/08/1982','95','B','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('11657132','8','ACUÑA','BARRERA','RONNY','ABEL','OBS.ASTRONOMICO UC PAR.METROP.','65296851','27370770','420000','06/03/1969','97','A','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12487147','9','MARIN','ARAVENA','JUAN','ANDRES','LAS PALMAS 134 V/CALIFORNIA','55417672','27780321','560000','20/08/1968','98','B','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12817700','K','VARGAS','GARAY','CLAUDIA',null,'PJE.BELEN Nº8 P/GERALDINE','68111801',null,'400000','28/08/1968','99','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('9499044','5','ROJAS','ACHA','CLAUDIO','ROBERTO','DR LUIS BISQUERT 2924 DPTO. 4','78172323','22380333','300000','17/10/1967','106','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('11996940','6','ORELLANA','SAAVEDRA','JUAN','ANTONIO','SANTA MARTA 9415 P/STA. TERESA','88111254','56434256','200000','14/08/1969','107','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('14558221','7','PASTEN','JORQUERA','ALAN','MAURICIO','BALMACEDA Nº15','96469095','28421196','180000','16/08/1967','108','C','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12459100','8','POBLETE','FUENTES','SERGIO',null,'TINGUIRIRICA 3553 V/FORESTA',null,'27464857','340000','21/09/1969','80','A','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('8716085','9','HORMAZABAL','SAGREDO','VICTOR','HUGO','DORSAL 5912 V/MANUEL RODRIGUEZ',null,'27789260','260000','29/08/1973','81','B','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12503185','0','SILVA','GONZALEZ','JEAN','PAUL','CALLE HOLANDA 073 V/PORVENIR','85289043','28509240','300000','27/08/1968','82','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('10586995','1','MUÑOZ','FERNANDEZ','JOSE','LUIS','AV.LAS TORRES 152','98725363',null,'1200000','06/03/1968','83','D','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('11949670','2','CONTRERAS','MIRANDA','CLAUDIO',null,'VISTA HERMOSA 2126 P/H.ALTO','68546237','28310255','500000','15/08/1989','84','A','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('9771046','3','ZAMORANO','ELIZONDO','LUIS','ALFREDO','ALAMEDA 301','72940059','26332876','320000','23/10/1967','85','B','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12095272','4','ROJAS','RODRIGUEZ','DAMASO',null,'URMENETA 1124 D.302','66213729','26210614','160000','15/08/1969','86','C','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('14632410','5','VILLANUEVA','YEPES','MONICA','DEL CARMEN','GASPAR DE LA BARRERA 2815','95586941','26830779','240000','18/10/1971','87','B','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('15353262','K','BARRIOS','HIDALGO','LUIS',null,'BALMACEDA 966','95596474','28213310','260000','05/09/1974','88','A','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('4604866','0','AGUIRRE','MUñOZ','LUIS','ALFONSO','VICHUQUEN 1462','88582729','26238494','300000','06/07/1945','89','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('14148957','1','MARTIN','DONOSO','JUAN','ENRIQUE','PJE. LOS FLORENTINOS 1804','72850346','25428017','400000','25/08/1984','92','B','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12831482','2','ORELLANA','GARRIDO','PATRICIO','ALONSO','LOS GUAITECAS 1751','66228120','28572849','200000','11/07/1968','94','A','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12186256','3','FUENTES','MORENO','MANUEL',null,'HANOI 7474',null,'26493855','200000','13/06/1969','95','B','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('11976208','4','OPAZO','AGUILERA','MARIA','DE LOS ANGELES','LOS TILOS 8924 P/LUIS BELTRAN',null,'26442611','600000','16/07/1968','97','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12998853','5','TRINKE','TRINKE','CRISTIAN',null,'MANCO CAPAC 1756','97417379','27461014','500000','04/08/1967','98','B','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12947165','6','HISI','DIAZ','ROSA','AMELIA','ICARO 3580 V/SANTA INES','72950789','27360251','250000','05/08/1969','99','A','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13043565','7','AGUILERA','ROMAN','WILLIBALDO','ANTONIO','ANDES 4717','62895758','27748105','380000','16/08/1969','106','B','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13072743','8','ORELLANA','SERQUEIRA','JAIME','MAURICIO','AV. 5 DE ABRIL 5693 A DPTO. 42','58214142',null,'420000','19/08/1986','107','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('16960649','9','RIQUELME','CHAVEZ','ROCIO',null,'BALMACEDA 1070','57813075','28598452','560000','06/08/1979','108','B','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12468646','K','ALVAREZ','MUÑOZ','MANUEL','EDUARDO','EDUARDO MATTE 2180','67813075','25557973','400000','07/08/1969','80','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12656375','5','SALDIAS','ROJAS','DAVID','JESUS','LOS TURISTAS 0735 P/EL SALTO','67813075','26224280','300000','08/08/1970','81','B','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('11635470','6','RAMIREZ','GUTIERREZ','JOEL',null,'SIERRA BELLA 1687','65428513','25225838','200000','09/08/0068','82','A','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('14415848','7','MACHUCA','ADONIS','MIGUEL','ROBERTO','LOS JAZMINES 1537 DPTO. 41 V.O','77446858','22383938','180000','10/08/1975','83','C','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12241168','8','RAMIREZ','GUTIERREZ','RODRIGO',null,'GUIDO RENNI 4225',null,'25225838','340000','11/08/1969','84','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('9798044','9','MALTRAIN','CORTES','JUAN','ANTONIO','ENZO PINZA 3330','92796904','25554298','260000','12/08/1968','85','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12832359','0','SALAS','TORO','CARLOS','ANTONIO','PJE.LLEUQUE 0861 V/EL PERAL 3','95281124','22959031','300000','13/08/1970','86','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12302426','1','ALVARADO','ARAUNA','ALEX',null,'PJE.CHONCHI 6678 V/LOS TRONCOS','85283675','25230195','1200000','14/08/1969','87','D','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12859931','2','CESPEDES','LANDEROS','CRISTIAN','ALBERTO','BAUTISTA IBARRAL 277','82886471','27765868','500000','15/08/1968','88','A','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12467533','3','HERNANDEZ','DIAZ','JUAN','BAUTISTA','VARGAS SALCEDO 1541','68153576','25332923','320000','16/08/1967','89','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12470801','4','SANCHEZ','RIVERA','JACQUELINE','CAROLINA','LUIS INFANTE CERDA 5315','55212127','27412764','160000','17/08/1968','92','C','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13035746','5','LARA','LECAROS','DANIEL','MAURICIO','FRANCISCO ESCALONA 3790','55212127',null,'240000','18/08/1970','94','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12866998','K','AVILA','RETAMALES','CRISTIAN','ALEJANDRO','TURMALINA 1495 V/LA SALUD','62562637','25457317','260000','19/08/1969','95','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('11872936','0','VIDAL','OSSES','LUIS',null,'C.NUEVA IMPERIAL 1045 B/1 DEPTO. 25','56813593','25293595','300000','20/08/1967','97','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('14526736','1','VALENZUELA','MONTOYA','ROSA','EMILIA','GENARO PRIETO 910 P/EL TRANQUE','56812350','28503179','400000','21/08/1976','98','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('9964101','2','MENESES','RUBIO','CARLOS','RAUL','SANTA MARTA 0713','68500893','25293285','200000','22/08/1966','99','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12495120','3','RUIZ','BRIONES','CRISTIAN','RAUL','PJE. FREIRINA 3630','57762111','23243232','200000','23/08/1969','106','B','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13050707','4','VALLE','CASTRIZELO','FREDY','GUILLERMO','PALERMO P/LA RAZON 2023',null,'27378107','600000','24/08/1969','107','A','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12415220','5','CASTRO','TOBAR','ALEJANDRA',null,'RODR. DE ARAYA 4651B B/11 DEPTO. 42',null,'22763621','500000','25/08/1969','108','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12459400','6','PICHIHUINCA','JORQUERA','RAFAEL','MATIAS','INGENIERO GIROZ 6035',null,'27783484','250000','26/08/1969','80','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12649413','7','MANZANO','QUINTANILLA','JESSICA','EUGENIA','PJE. LAMPA 1391 V/LOS MINERALE','92894026','26259699','380000','27/08/1967','81','B','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12610458','8','BARTLAU','VARGAS','MACARENA',null,'MARIA VIAL 8028','95412144','25273848','420000','28/08/1970','82','A','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12364085','9','ARAYA','CAMUS','FREDDY','RODOLFO','CARRERA 027','88721366','28461589','560000','29/08/1968','83','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12460769','K','DAZA','GUERRERO','ERIC','ANTONIO','HERRERA 618','86966329','26813742','400000','30/08/1969','84','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13072796','5','MEDINA','CAMUS','WANDA','ANDREA','ICTINOS 1162 VILLA PEDRO LAGOS','86229671','22797176','300000','31/08/1969','85','B','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12649650','6','CUADRA','DISSI','DIEGO','ALBERTO','PJE.OLGA DONOSO 4047 P/E.GONEL','57788381','26251788','450000','08/01/1993','86','A','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13078214','7','CONCHA','MONTECINOS','KATHERINE','ANDREA','AV. GRECIA 5055 BL/2 DPTO. 22','67415270','22724039','180000','01/09/1970','87','C','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12189232','8','DELGADO','GALLEGOS','XIMENA','MARGARITA','LUXEMBURGO Nº9609','57719055','22202264','340000','02/09/1967','88','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('8533901','9','QUEZADA','VILLENA','CRISTIAN',null,'P. LOS INCAS 1734 V/OLIMPO II','76814737','25321876','260000','03/09/1972','89','B','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12871924','0','VENEGAS','TORRES','JESSICA','RAFAELA','GARCIA REYES Nº55C','77735367','26817651','300000','04/09/1970','92','A','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13072368','1','JORQUERA','VERA','ALEX','RAUL','SENDA 12 B/1157 DEPTO. A V/C.18 NOR','67356222','22424598','1200000','25/08/1960','94','D','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('11226732','2','CAVANELA','ORTEGA','JUAN','MAURICIO','PJE BATUCO #9457 V/OHIGGINS','52710253','22816328','500000','05/09/1968','95','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('11695597','3','BASOALTO','ARANGUIZ','JUAN','EMILIO','SANTA FILOMENA DE NOS','55212406','28575175','320000','06/09/1966','97','B','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13082881','4','FUENTES','FAUNDEZ','FELIPE','SANTIAGO','GUAYACAN # 063 V/FABERIO','77413705','28510780','160000','07/09/1970','98','C','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('14319321','5','SALVO','GUTIERREZ','PATRICIA','XIMENA','PJE # 1 Nº675 P/ANTUPILLAN','92853737','28587242','240000','01/08/1945','99','B','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('10268208','K','REYES','MORALES','LUIS','ALBERTO','BUENOS AIRES #429','52794874','28586286','260000','08/09/1965','106','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13050258','0','SALAS','CORNEJO','CARLOS',null,'VALLE DEL SOL Nº4028','85450443','22773144','300000','09/09/1977','107','A','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13057574','1','CORNEJO','GONZALEZ','ALEJANDRO',null,'CIENCIAS #8442 P/BIAUT',null,'25586841','400000','24/08/1965','108','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13264443','2','GODOY','SALINAS','MARIA','DEL PILAR','ALAMEDA #4272 DPTO. 104','55341874',null,'200000','09/09/1976','80','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12861354','3','CADIZ','SANDOVAL','FERNANDO','OSVALDO','CALLE LUGO 4671 P.10 PAJARITO','97773749','27445878','200000','22/08/1955','81','B','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12959989','4','JEREZ','CHACON','PAMELA','ANDREA','INES DE SUARES 220','88122441','209388532','600000','20/08/1967','82','A','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12721101','5','JORQUERA','SANCHEZ','LEONEL',null,'ALMIRANTE RIVEROS #9653','62278556','25580425','500000','21/08/1969','83','B','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('10711069','6','CISTERNAS','SAAVEDRA','VICTOR','VLADIMIR','LAGO GRIS 4673 V/EL ALBA','75631102','26983708','250000','22/08/1963','84','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12871979','7','RODRIGUEZ','LEMUS','PAOLA','NICOLE','JOAQUIN EDWARDS BELLO #10529','76432652','25410073','380000','23/08/1967','85','B','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('10320840','8','DURAN','REBOLLEDO','JAIME','GUILLERMO','AV.3 PONIENTE 1548 V/VIENA','67416145','25327648','420000','24/08/1964','86','A','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13034352','9','MUñOZ','ASCORRA','CLAUDIA','DELFINA','LOS ÑANDUES #509 V/PAJARITOS','65582082','22570673','560000','25/08/1971','87','B','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('10539484','K','OSORIO','MELLA','JUAN','CRISTOBAL','LO SALINAS 1695','52811129','28213010','400000','26/08/1965','88','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12000035','5','ROJAS','ROJAS','MARIO',null,'AV.I.CARRERA PINTO 1041','56832705','29988654','300000','26/08/1969','89','B','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('7108724','6','QUILODRAN','GARCIA','MARIA','GRACIA','PJE.VARSOVIA 1439 V/ESQUINA B.','96255762','25382800','200000','27/08/1959','92','A','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13083936','7','QUINTANA','MARDONES','RUTH','ANTONIA','PASAJE LA RAIZ Nº10591','82936654',null,'180000','28/08/1970','94','C','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12158268','8','ERICES','MOLINA','ELIGIO','RAUL','PJE.COLORADO 5528 DEPTO. 302','76442200','25230176','340000','29/08/1969','95','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12946000','9','CASTILLO','VALENCIA','PAULA','LUCIA','LAS AMAPOLAS 1931 P/PEDRO MONT','55311880','26833380','260000','30/08/1970','97','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13085998','0','SUAZO','RIQUELME','OSCAR','IGNACIO','PJE.PAULINA 1678 V/BLANCA','65351928','25111798','300000','23/08/1948','98','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13032090','1','GONZALEZ','JOFRE','JUAN','EDUARDO','PJE.LOS TILOS 8926 P/L.BELTRAN','67765258','26446917','1200000','31/08/1972','99','D','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('10293552','2','FRITIS','CHAMBLAS','JOSE',null,'PEDRO AGUIRRE CERDA 5962',null,'26252858','500000','01/09/1967','106','A','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12960006','3','MARILLANCA','CARVAJAL','JOSE','ANTONIO','SITIO 37B PINTUE LAGUNA ACULEO',null,'28249080','320000','24/08/1955','107','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('10776845','4','NAVARRO','VELASQUEZ','HECTOR','MAURICIO','PJE. CAPRI 909 B/5 DEPTO. 103','52893123',null,'160000','21/08/1971','108','C','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12407575','5','GONZALEZ','LILLO','MARCELA','CAROLINA','RODRIGO DE ARAYA 4871 DEPTO. 14','55285702',null,'240000','02/09/1971','80','B','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('14319236','K','ARRIARAN','ROJAS','OSCAR','RAUL','12 DE FEBRERO 850','8491680','28580076','260000','03/09/1979','81','A','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('11339557','0','BUSTOS','MARTINEZ','IVONNE',null,'ALDUNATE 1932','92871989','25540604','560000','04/09/1968','82','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('11749379','1','MORALES','ZAMORANO','FABIOLA','MELINA','EL QUETZAL 675','95292190','25557973','400000','05/09/1967','83','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12270989','2','RAMIREZ','CARDENAS','MAURICIO','ANTONIO','CALLE LOS NOGALES 9583','66431810','25271068','300000','06/09/1969','84','B','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('14254526','3','MARTINEZ','RODRIGUEZ','ERIC','FELIPE','PJE.LAGO RAPEL 1297 V/SENDERO','58152298','22919311','200000','07/09/1977','85','A','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12820018','4','ACEVEDO','SANDOVAL','ALEXANDER',null,'LAS CODORNICES 2963-H DPTO. 21','85286676','22836901','180000','08/09/1967','86','C','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12468736','5','GONZALEZ','MUÑOZ','OSVALDO','ALEXIS','MARIA LUISA BOMBAL 384','95577263','27414835','340000','09/09/1972','87','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13088742','6','CID','PADILLA','CAROLINA','ANDREA','AV.FRATERNAL 3910','77764463','25225759','260000','10/09/1967','88','B','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13455413','7','JIMENEZ','PINILLA','CRISTIAN',null,'RICARDO CUMMING 1346 CASA 13','67783253','86966329','300000','23/08/1970','89','A','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12685035','8','PEREZ','PINTO','NELSON','RUBEN','EL CARMEN 10364 V/STA.MARIA','65296851','22825520','1200000','22/08/1967','92','D','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('11514737','9','MORENO','GONZALEZ','CLAUDIA',null,'GRACIOSA 7815 CERRO NAVIA','55417672','26491988','500000','02/09/1968','94','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13072851','K','SUAREZ','GONZALEZ','KARINA','MARIELA','PAUL HARRIS 901',null,'22012371','320000','22/04/1978','95','B','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('11540908','5','BARRERA','RIOS','MARIA','LUISA','PASAJE 36 Nº4789 V/EYZAGUIRRE',null,'22097186','160000','26/05/1968','97','C','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13269751','6','VALLE','DIAZ','ALEXIS',null,'CUATRO REMOS 580 V/ANT. VARAS','68111801','27782342','240000','04/09/1974','98','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12684459','7','CARVAJAL','REYES','JUAN','PABLO','VICTORIA 615','78172323','25558281','260000','07/06/1969','99','A','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('9969366','8','FUENTES','CORTES','LUIS',null,'IGNACIO CARRERA PINTO 6013','88111254','26232094','600000','26/03/1941','106','A','20');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('10917199','9','ACUÑA','OLIVARES','ELIZABETH','FABIOLA','CERRO HUEMUL 1052','96469095','57736141','500000','23/08/1965','107','B','40');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13098962','0','SALAZAR','DIAZ','MARIA',null,'AV.KENNEDY B/16 DEPTO. 31 P/MANSO','85289043','2253899','250000','02/08/1968','108','A','30');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('12672729','1','BARRAZA','LOBOS','EDUARDO','PATRICIO','TRICAO 460 P/ EUGENIPO MATTE','98725363','28512060','380000','03/08/1969','80','B','10');
INSERT INTO CLIENTE(numrun_cli,dvrun_cli,appaterno_cli,apmaterno_cli,pnombre_cli,snombre_cli,direccion,celular_cli,fono_fijo_cli,renta,fecha_nac_cli,id_comuna,id_tipo_cli,id_estado_civil) VALUES('13041711','2','ITURRIETA','GONZALEZ','JUAN','PABLO','AV. TRANSITO 5291','66213729','27753384','420000','21/08/1993','81','A','20');

INSERT INTO marca VALUES (SEQ_MARCA.NEXTVAL,'Toyota');
INSERT INTO marca VALUES (SEQ_MARCA.NEXTVAL,'WMW');
INSERT INTO marca VALUES (SEQ_MARCA.NEXTVAL,'Mercedes Benz');
INSERT INTO marca VALUES (SEQ_MARCA.NEXTVAL,'Citroen');
INSERT INTO marca VALUES (SEQ_MARCA.NEXTVAL,'Nissan');
INSERT INTO marca VALUES (SEQ_MARCA.NEXTVAL,'Ford');
INSERT INTO marca VALUES (SEQ_MARCA.NEXTVAL,'DFM');
INSERT INTO marca VALUES (SEQ_MARCA.NEXTVAL,'Kia');
INSERT INTO marca VALUES (SEQ_MARCA.NEXTVAL,'Lada');

INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('AA1001','Rojo','2.6',EXTRACT(YEAR FROM SYSDATE)-3,'23000',null,'D',140,'10');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('BC1002','Azul','3.4',EXTRACT(YEAR FROM SYSDATE)-8,'24000','200000','B',110,'10');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('VV1003','Verde','2.7',EXTRACT(YEAR FROM SYSDATE)-5,'35000','250000','A',120,'20');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('FFDD23','Blanco','2.3',EXTRACT(YEAR FROM SYSDATE)-3,'60000','300000','B',140,'30');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('ASEW11','Pardo','2.1',EXTRACT(YEAR FROM SYSDATE),'14500',145000,'C',140,'40');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('AZ1001','Negro','2.6',EXTRACT(YEAR FROM SYSDATE)-3,'23000','300000','A',160,'40');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('EC1002','Azul','3.4',EXTRACT(YEAR FROM SYSDATE)-8,'24000','150000','B',110,'50');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('AXDD23','Blanco','2.3',EXTRACT(YEAR FROM SYSDATE)-2,'60000','150000','B',140,'60');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('AS4411','Pardo','2.1',EXTRACT(YEAR FROM SYSDATE),'14500','130000','C',170,'70');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('FG1001','Rojo','2.6',EXTRACT(YEAR FROM SYSDATE)-3,'23000','135000','A',140,'80');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('BE1002','Azul','3.4',EXTRACT(YEAR FROM SYSDATE)-8,'24000','140000','B',110,'90');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('VY1003','Verde','2.7',EXTRACT(YEAR FROM SYSDATE)-5,'35000','170000','A',190,'40');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('FDDD23','Blanco','2.3',EXTRACT(YEAR FROM SYSDATE)-2,'60000','50000','B',140,'20');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('ASEE11','Pardo','2.1',EXTRACT(YEAR FROM SYSDATE),'14500',145000,'C',140,'40');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('FR1001','Rojo','2.6',EXTRACT(YEAR FROM SYSDATE)-3,'23000','135000','A',140,'60');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('WE1002','Azul','3.4',EXTRACT(YEAR FROM SYSDATE)-7,'24000','140000','B',110,'80');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('TY1003','Verde','2.7',EXTRACT(YEAR FROM SYSDATE)-4,'35000','170000','A',120,'90');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('FXDD23','Blanco','2.3',EXTRACT(YEAR FROM SYSDATE)-2,'60000','150000','B',100,'20');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('ASEZ11','Pardo','2.1',EXTRACT(YEAR FROM SYSDATE),'14500',null,'C',190,'10');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('GG1001','Rojo','2.6',EXTRACT(YEAR FROM SYSDATE)-3,'23000','135000','A',140,'10');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('BT1002','Azul','3.4',EXTRACT(YEAR FROM SYSDATE)-6,'24000','140000','B',110,'20');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('VR1003','Verde','2.7',EXTRACT(YEAR FROM SYSDATE)-5,'35000','170000','A',210,'30');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('AQDD04','Platino','3.1',EXTRACT(YEAR FROM SYSDATE)-2,'37500','145000','A',130,'50');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('OPDD23','Blanco','2.3',EXTRACT(YEAR FROM SYSDATE)-3,'60000',null,'B',140,'60');
INSERT INTO CAMION(nro_patente,color,motor,anio,valor_arriendo_dia,valor_garantia_dia,id_tipo_camion,id_emp,id_marca) VALUES('AHEW11','Pardo','2.1',EXTRACT(YEAR FROM SYSDATE),'14500','130000','D',160,'80');

INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1000,10,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),1,'07/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1000,50,'05/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),5,'10/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1000,50,'13/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),8,'23/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1020,10,'23/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),7,'30/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1001,25,'25/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),11,'05/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1010,30,'03/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),1,'04/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,35,'08/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),3,'18/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1024,40,'13/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),4,'17/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,50,'24/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),9,'14/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1001,55,'18/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),2,'20/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,55,'03/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),8,'13/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1010,60,'11/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),11,'22/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1009,65,'17/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),1,'18/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1015,70,'07/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),2,'09/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1021,75,'13/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),3,'16/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1021,80,'03/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),4,'07/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1015,85,'08/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),5,'13/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1024,90,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),6,'09/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1009,90,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),7,'10/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1010,95,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),8,'11/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1015,100,'01/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),9,'13/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,105,'03/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),3,'13/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,110,'03/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),5,'08/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1024,115,'13/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),7,'20/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1015,120,'03/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),8,'11/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1015,150,'13/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),11,'24/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1009,135,'03/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),13,'16/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,140,'03/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),11,'14/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1021,145,'03/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),1,'04/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1018,150,'03/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),2,'08/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1005,155,'03/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),2,'08/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,160,'03/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),3,'06/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,165,'11/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),3,'14/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1021,175,'03/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),3,'06/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1010,180,'03/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),5,'09/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1005,185,'03/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),5,'08/09/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,190,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),6,'09/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1018,195,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),6,'09/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1024,200,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),6,'19/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1010,205,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),7,'10/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,210,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),7,'13/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,220,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),7,'23/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1018,225,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),8,'23/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1022,230,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),4,'07/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1024,230,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),3,'09/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,235,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),2,'05/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1021,240,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),1,'04/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1005,245,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),6,'10/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1005,250,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),5,'08/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1021,295,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),4,'07/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1022,295,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),3,'06/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1022,295,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),2,'05/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1005,300,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),1,'04/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1022,305,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),1,'04/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1021,310,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),1,'04/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1024,315,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1),1,'04/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-1));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1000,10,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),1,'07/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1000,50,'05/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),5,'10/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1000,50,'13/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),8,'23/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1020,10,'23/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),7,'30/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1001,25,'25/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),11,'05/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1010,30,'03/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),1,'04/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,35,'08/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),3,'18/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1024,40,'13/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),4,'17/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,50,'24/04/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),9,'14/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1001,55,'18/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),2,'20/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,55,'03/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),8,'13/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1010,60,'11/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),11,'22/05/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1009,65,'17/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),1,'18/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1015,70,'07/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),2,'09/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1021,75,'13/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),3,'16/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1021,80,'03/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),4,'07/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1015,85,'08/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),5,'13/06/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1024,90,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),6,'09/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1009,90,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),7,'10/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1010,95,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),8,'11/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1015,100,'01/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),9,'13/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,105,'03/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),3,'13/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,110,'03/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),5,'08/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1024,115,'13/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),7,'20/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1024,200,'03/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),6,'19/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1010,205,'03/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),7,'10/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,210,'03/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),7,'13/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,220,'03/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),7,'23/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1018,225,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),8,'23/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1022,230,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),4,'07/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1024,230,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),3,'09/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1016,235,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),2,'05/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1021,240,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),1,'04/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1005,245,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),6,'10/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1005,250,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),5,'08/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1021,295,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),4,'07/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1022,295,'03/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),3,'06/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1022,295,'03/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),2,'05/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1005,300,'03/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),1,'04/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1022,305,'03/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),1,'04/07/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1021,310,'03/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),1,'04/08/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
INSERT INTO arriendo_camion VALUES (SEQ_ARRIENDO.NEXTVAL,1024,315,'03/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)),1,'04/03/'||TO_CHAR(EXTRACT(YEAR FROM SYSDATE)));
COMMIT;