DROP TABLE consumo;
DROP TABLE resumen_socio;
DROP TABLE amarre;
DROP TABLE EmpleadoZona;
DROP TABLE embarcacion;
DROP TABLE socio;
DROP TABLE empleado;
DROP TABLE zona;

DROP SEQUENCE seq_amarre;
CREATE SEQUENCE seq_amarre;

DROP SEQUENCE seq_empleado;
CREATE SEQUENCE seq_empleado START WITH 100 INCREMENT BY 10;

CREATE TABLE socio(
rutSocio VARCHAR2(12) NOT NULL,
nombreSocio VARCHAR2(50),
apellidoSocio VARCHAR2(50),
direccionSocio VARCHAR2(50),
telefonoSocio VARCHAR2(10),
fechaIngreso DATE,
CONSTRAINT socios_pk PRIMARY KEY(rutSocio)
);

CREATE TABLE empleado(
codigoEmpleado NUMBER NOT NULL,
nombreEmpleado VARCHAR2(50),
apellidoEmpleado VARCHAR2(50),
direccionEmpleado VARCHAR2(50),
telefonoEmpleado VARCHAR2(10),
especialidad VARCHAR2(20),
CONSTRAINT empl_pk PRIMARY KEY(codigoEmpleado)
);
CREATE TABLE zona(
letraZona VARCHAR2(2) NOT NULL,
tipoBarco VARCHAR2(50),
numeroBarcos NUMBER,
profundidadZona NUMBER,
anchoZona NUMBER,
CONSTRAINT zonas_pk PRIMARY KEY(letraZona)
);

CREATE TABLE embarcacion(
matriculaEmbarcacion VARCHAR2(7) NOT NULL,
nombreEmbarcacion VARCHAR2(50),
tipoEmbarcacion VARCHAR2(50),
dimensionesEmbarcacion NUMBER,
rutSocio VARCHAR2(12),
CONSTRAINT emb_pk PRIMARY KEY(matriculaEmbarcacion),
CONSTRAINT embsocio_fk FOREIGN KEY(rutSocio) REFERENCES socio(rutSocio)
);

CREATE TABLE amarre(
numeroAmarre NUMBER NOT NULL,
lecturaAgua NUMBER,
lecturaLuz  NUMBER,
mantenimiento VARCHAR2(2),
fechaAsignacion DATE,
FechaCompra DATE,
letraZona VARCHAR2(2),
rutSocio VARCHAR2(12),
matriculaEmbarcacion VARCHAR2(7),
CONSTRAINT amarres_pk PRIMARY KEY(numeroAmarre),
CONSTRAINT amazona_fk FOREIGN KEY(letraZona) REFERENCES zona(letraZona),
CONSTRAINT amasocios_fk FOREIGN KEY (rutSocio) REFERENCES socio(rutSocio),
CONSTRAINT amaemb_fk FOREIGN KEY (matriculaEmbarcacion) REFERENCES embarcacion(matriculaEmbarcacion)
);

CREATE TABLE EmpleadoZona(
codigoEmpleado NUMBER NOT NULL,
letraZona VARCHAR2(2) NOT NULL,
numeroBarcosAcargo NUMBER,
CONSTRAINT codigoEmpleado_fk FOREIGN KEY(codigoEmpleado) REFERENCES empleado(codigoEmpleado),
CONSTRAINT letraZona_fk FOREIGN KEY (letraZona) REFERENCES zona(letraZona),
CONSTRAINT encarZona_pk PRIMARY KEY(codigoEmpleado,letraZona)
);

-- Inicio Tablas evaluación 3
CREATE TABLE consumo
(
      numeroamarre NUMBER NOT NULL,
      rutsocio VARCHAR2(12) NOT NULL,
      periodo VARCHAR2(7) NOT NULL,
      consumo_agua NUMBER NOT NULL,
      consumo_luz NUMBER NOT NULL
);
ALTER TABLE consumo ADD CONSTRAINT consumo_pk PRIMARY KEY(numeroamarre, rutsocio, periodo);
ALTER TABLE consumo ADD CONSTRAINT consumo_amarre_fk FOREIGN KEY(numeroamarre) REFERENCES amarre(numeroAmarre);
ALTER TABLE consumo ADD CONSTRAINT consumo_socio_fk 
FOREIGN KEY(rutsocio) REFERENCES socio(rutSocio);

CREATE TABLE resumen_socio
(
      rut_socio VARCHAR2(12) NOT NULL,
      periodo_consulta VARCHAR2(7) NOT NULL,
      antiguedad NUMBER NOT NULL,
      total_embarcaciones NUMBER NOT NULL,
      total_amarres NUMBER NOT NULL,
      total_consumo_agua_luz NUMBER NOT NULL,
      relacion_consumo_promedio VARCHAR2(50) NOT NULL      
);
ALTER TABLE resumen_socio ADD CONSTRAINT resumen_socio_pk PRIMARY KEY(rut_socio, periodo_consulta);

DROP TABLE calificacion_socio;
CREATE TABLE calificacion_socio
(
      rut_socio VARCHAR2(12) NOT NULL,
      periodo_consulta VARCHAR2(7) NOT NULL,
      total_consumo NUMBER NOT NULL,
      calificacion VARCHAR2(100) NOT NULL
);
ALTER TABLE calificacion_socio 
ADD CONSTRAINT calificacion_socio_pk PRIMARY KEY(rut_socio, periodo_consulta);
DROP TABLE rango_embarcacion;
CREATE TABLE rango_embarcacion(
      id_rango NUMBER PRIMARY KEY,
      amarres_minimo NUMBER NOT NULL,
      amarres_maximo NUMBER NOT NULL,
      rango VARCHAR2(1) NOT NULL
);
INSERT INTO rango_embarcacion VALUES(1,1,3,'A');
INSERT INTO rango_embarcacion VALUES(2,3,5,'B');
INSERT INTO rango_embarcacion VALUES(3,8,10,'C');

DROP TABLE rango_consumo;
CREATE TABLE rango_consumo
(
      id_rango NUMBER PRIMARY KEY,
      consumo_minimo NUMBER NOT NULL,
      consumo_maximo NUMBER NOT NULL,
      calificacion VARCHAR2(40) NOT NULL
);
INSERT INTO rango_consumo VALUES(1,0,300,'NORMAL');
INSERT INTO rango_consumo VALUES(2,301,500,'EXCESO');
INSERT INTO rango_consumo VALUES(3,501,800,'SUPER EXCESO');
INSERT INTO rango_consumo VALUES(4,801,1500, 'SOBRE CONSUMO');

DROP SEQUENCE seq_error;
CREATE SEQUENCE seq_error;
DROP TABLE error_proceso;
CREATE TABLE error_proceso
(
      id_error NUMBER PRIMARY KEY,
      error_tecnico_oracle VARCHAR2(500) NOT NULL,
      usuario_conectado VARCHAR2(100) NOT NULL,
      sentencia_error VARCHAR2(500) NOT NULL,
      descripcion_negocio VARCHAR2(500) NOT NULL

);

ALTER SESSION SET nls_DATE_format='dd-mm-yyyy';
/* Socios  */
INSERT INTO socio VALUES('4697572','Jasmin','Gutierrez','Freire 333','222222',TO_DATE('12-10-2000'));
INSERT INTO socio VALUES('4545958','Fabian','Herrera','Coronel 1','333333', TO_DATE('09-09-2000'));
INSERT INTO socio VALUES('4585539','Alejandro','Inostroza','Prat 224','444444', TO_DATE('08-01-2000'));
INSERT INTO socio VALUES('4674391','Maria','Millapan','Linares 651','4444445', TO_DATE('09-05-2000'));
INSERT INTO socio VALUES('4634678','Romina','Navarro','Calle 7','5555556', TO_DATE('09-05-2000'));

/* Empleados  */

INSERT INTO empleado VALUES(SEQ_EMPLEADO.NEXTVAL,'Pedro','Torres','Calle 1','5555556', 'GASFITERIA');
INSERT INTO empleado VALUES(SEQ_EMPLEADO.NEXTVAL,	'Javier',	'Campos',  	'Prat 2345',	'7777765',	'VARIOS');
INSERT INTO empleado VALUES(SEQ_EMPLEADO.NEXTVAL,	'Ana','Cifuentes',	'San Martin 314',	'345678',	'GASFITERIA');
INSERT INTO empleado VALUES(SEQ_EMPLEADO.NEXTVAL,	'Nuria',	'Fierro' ,	'Tucapel 1234',	'322345',	'ELECTRICISTA');
INSERT INTO empleado VALUES(SEQ_EMPLEADO.NEXTVAL,	'Teresa',	'Galindo', 	'Colo Colo 312',	'2222222',	'ELECTRICISTA');

/* Embarcaciones */

INSERT INTO embarcacion VALUES ('4642379','Luz','barco',12,'4697572');
INSERT INTO embarcacion VALUES ('4556739','La Luna','Lancha',5,'4545958');
INSERT INTO embarcacion VALUES ('4759885','El Rayo','barco',20,'4585539');
INSERT INTO embarcacion VALUES ('4575691','Los Amigos','barco',16,'4674391');
INSERT INTO embarcacion VALUES ('4556787','Cometa','Lancha',4,'4634678');

/* Zonas */
INSERT INTO zona VALUES ('A','BARCO',24,50,80);
INSERT INTO zona VALUES ('B','LANCHA',13,25,25);
INSERT INTO zona VALUES ('C','OTROS',9,7,10);

/* Amares */

INSERT INTO amarre VALUES (seq_amarre.NEXTVAL,123,18,'si',
TO_DATE('12-10-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)) ,
TO_DATE('12-10-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)) ,'A','4697572','4642379');
INSERT INTO amarre VALUES (seq_amarre.NEXTVAL,2345,16,'si',
TO_DATE('12-9-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),
TO_DATE('9-9-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)) ,'B','4545958','4556739');
INSERT INTO amarre VALUES (seq_amarre.NEXTVAL,234,12,'si',
TO_DATE('5-3-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),
TO_DATE('4-3-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),'A','4585539','4759885');
INSERT INTO amarre VALUES (seq_amarre.NEXTVAL,564,34,'no',
TO_DATE('8-1-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),
TO_DATE('8-1-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),'A','4674391','4575691');
INSERT INTO amarre VALUES (seq_amarre.NEXTVAL,123,14,'no',
TO_DATE('12-5-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),
TO_DATE('9-5-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),'B','4634678','4556787');

-- Nuevos ammares
INSERT INTO amarre VALUES (seq_amarre.NEXTVAL,345,26,'si',
TO_DATE('12-10-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),
TO_DATE('9-10-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)) ,'B','4545958','4556739');

INSERT INTO amarre VALUES (seq_amarre.NEXTVAL,110,15,'no',
TO_DATE('12-6-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),
TO_DATE('9-4-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),'B','4634678','4556787');

/* Consumo de los amarres */
INSERT INTO consumo VALUES(1,'4697572', '01-2024', 10, 150);
INSERT INTO consumo VALUES(1,'4697572', '02-2024', 20, 110);
INSERT INTO consumo VALUES(1,'4697572', '03-2024', 7, 90);

INSERT INTO consumo VALUES(2, '4545958', '01-2024', 40, 180);
INSERT INTO consumo VALUES(2, '4545958', '02-2024', 30, 100);
INSERT INTO consumo VALUES(2, '4545958', '03-2024', 17, 190);

INSERT INTO consumo VALUES(3, '4585539', '01-2024', 4, 18);
INSERT INTO consumo VALUES(3, '4585539', '02-2024', 3, 10);
INSERT INTO consumo VALUES(3, '4585539', '03-2024', 7, 19);

INSERT INTO consumo VALUES(4, '4674391', '01-2024', 45, 230);
INSERT INTO consumo VALUES(4, '4674391', '02-2024', 35, 120);
INSERT INTO consumo VALUES(4, '4674391', '03-2024', 70, 90);

INSERT INTO consumo VALUES(5, '4634678', '01-2024', 50, 280);
INSERT INTO consumo VALUES(5, '4634678', '02-2024', 60, 200);
INSERT INTO consumo VALUES(5, '4634678', '03-2024', 70, 290);

INSERT INTO consumo VALUES(6, '4545958', '01-2024', 14, 80);
INSERT INTO consumo VALUES(6, '4545958', '02-2024', 13, 101);
INSERT INTO consumo VALUES(6, '4545958', '03-2024', 17, 99);

INSERT INTO consumo VALUES(7, '4634678', '01-2024', 60, 150);
INSERT INTO consumo VALUES(7, '4634678', '02-2024', 90, 190);
INSERT INTO consumo VALUES(7, '4634678', '03-2024', 70, 200);

/* EmpleadosZona */
INSERT INTO EmpleadoZona VALUES (100,'A',8);
INSERT INTO EmpleadoZona VALUES (110,'B',7);
INSERT INTO EmpleadoZona VALUES (120,'A',8);
INSERT INTO EmpleadoZona VALUES (130,'C',9);
INSERT INTO EmpleadoZona VALUES (140,'A',8);
INSERT INTO EmpleadoZona VALUES (100,'B',6);


