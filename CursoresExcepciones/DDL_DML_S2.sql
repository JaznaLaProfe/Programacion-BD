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


create table socio(
rutSocio varchar2(12) not null,
nombreSocio varchar2(50),
apellidoSocio varchar2(50),
direccionSocio varchar2(50),
telefonoSocio varchar2(10),
fechaIngreso date,
constraint socios_pk primary key(rutSocio)
);



create table empleado(
codigoEmpleado NUMBER not null,
nombreEmpleado varchar2(50),
apellidoEmpleado varchar2(50),
direccionEmpleado varchar2(50),
telefonoEmpleado varchar2(10),
especialidad varchar2(20),
constraint empl_pk primary key(codigoEmpleado)
);
create table zona(
letraZona varchar2(2) not null,
tipoBarco varchar2(50),
numeroBarcos number,
profundidadZona number,
anchoZona number,
constraint zonas_pk primary key(letraZona)
);

create table embarcacion(
matriculaEmbarcacion varchar2(7) not null,
nombreEmbarcacion varchar2(50),
tipoEmbarcacion varchar2(50),
dimensionesEmbarcacion number,
rutSocio varchar2(12),
constraint emb_pk primary key(matriculaEmbarcacion),
constraint embsocio_fk foreign key(rutSocio) references socio(rutSocio)
);



create table amarre(
numeroAmarre NUMBER not null,
lecturaAgua number,
lecturaLuz  number,
mantenimiento varchar2(2),
fechaAsignacion date,
FechaCompra date,
letraZona varchar2(2),
rutSocio varchar2(12),
matriculaEmbarcacion varchar2(7),
constraint amarres_pk primary key(numeroAmarre),
constraint amazona_fk foreign key(letraZona) references zona(letraZona),
constraint amasocios_fk foreign key (rutSocio) references socio(rutSocio),
constraint amaemb_fk foreign key (matriculaEmbarcacion) references embarcacion(matriculaEmbarcacion)
);

Create table EmpleadoZona(
codigoEmpleado NUMBER not null,
letraZona varchar2(2) not null,
numeroBarcosAcargo number,
constraint codigoEmpleado_fk foreign key(codigoEmpleado) references empleado(codigoEmpleado),
constraint letraZona_fk foreign key (letraZona) references zona(letraZona),
constraint encarZona_pk primary key(codigoEmpleado,letraZona)
);

-- Inicio Tablas evaluación 2
DROP TABLE resumen_embarcacion;
CREATE TABLE resumen_embarcacion
(
      matricula VARCHAR2(7) NOT NULL PRIMARY KEY,
      total_amarres NUMBER NOT NULL,
      rango VARCHAR2(1) NOT NULL
);

DROP TABLE resumen_amarre;
CREATE TABLE resumen_amarre
(
      matricula VARCHAR2(7) NOT NULL,
      numeroAmarre NUMBER NOT NULL,
      year_asignacion NUMBER NOT NULL,
      lecturaAgua NUMBER NOT NULL,
      lecturaLuz NUMBER NOT NULL,
      nivel VARCHAR2(40) NOT NULL,
      consumo NUMBER NOT NULL
);
ALTER TABLE resumen_amarre ADD CONSTRAINT resumen_amarre_pk PRIMARY KEY(matricula, numeroAmarre);

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

DROP TABLE rango_gastos;
CREATE TABLE rango_gastos
(
      id_rango NUMBER PRIMARY KEY,
      gasto_minimo NUMBER NOT NULL,
      gasto_maximo NUMBER NOT NULL,
      nivel_gastos VARCHAR2(40) NOT NULL
);
INSERT INTO rango_gastos VALUES(1,100,300,'NORMAL');
INSERT INTO rango_gastos VALUES(2,300,500,'EXCESO');
INSERT INTO rango_gastos VALUES(3,600,800,'SUPER EXCESO');
INSERT INTO rango_gastos VALUES(4,900,1500, 'SOBRE CONSUMO');

DROP SEQUENCE seq_error;
CREATE SEQUENCE seq_error;
DROP TABLE error_proceso;
CREATE TABLE error_proceso
(
      id_error NUMBER PRIMARY KEY,
      descripcion VARCHAR2(500) NOT NULL
);
-- Fin Tablas evaluación 2

ALTER SESSION SET nls_date_format='dd-mm-yyyy';
/* Socios  */
insert into socio values('4697572','Jasmin','Gutierrez','Freire 333','222222',TO_DATE('12-10-2000'));
insert into socio values('4545958','Fabian','Herrera','Coronel 1','333333', TO_DATE('09-09-2000'));
insert into socio values('4585539','Alejandro','Inostroza','Prat 224','444444', TO_DATE('08-01-2000'));
insert into socio values('4674391','Maria','Millapan','Linares 651','4444445', TO_DATE('09-05-2000'));
insert into socio values('4634678','Romina','Navarro','Calle 7','5555556', TO_DATE('09-05-2000'));

/* Empleados  */

insert into empleado values(SEQ_EMPLEADO.NEXTVAL,'Pedro','Torres','Calle 1','5555556', 'GASFITERIA');
insert into empleado values(SEQ_EMPLEADO.NEXTVAL,	'Javier',	'Campos',  	'Prat 2345',	'7777765',	'VARIOS');
insert into empleado values(SEQ_EMPLEADO.NEXTVAL,	'Ana','Cifuentes',	'San Martin 314',	'345678',	'GASFITERIA');
insert into empleado values(SEQ_EMPLEADO.NEXTVAL,	'Nuria',	'Fierro' ,	'Tucapel 1234',	'322345',	'ELECTRICISTA');
insert into empleado values(SEQ_EMPLEADO.NEXTVAL,	'Teresa',	'Galindo', 	'Colo Colo 312',	'2222222',	'ELECTRICISTA');

/* Embarcaciones */

insert into embarcacion values ('4642379','Luz','barco',12,'4697572');
insert into embarcacion values ('4556739','La Luna','Lancha',5,'4545958');
insert into embarcacion values ('4759885','El Rayo','barco',20,'4585539');
insert into embarcacion values ('4575691','Los Amigos','barco',16,'4674391');
insert into embarcacion values ('4556787','Cometa','Lancha',4,'4634678');

/* Zonas */
insert into zona values ('A','BARCO',24,50,80);
insert into zona values ('B','LANCHA',13,25,25);
insert into zona values ('C','OTROS',9,7,10);

/* Amares */

insert into amarre values (seq_amarre.NEXTVAL,123,18,'si',
TO_DATE('12-10-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)) ,
TO_DATE('12-10-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)) ,'A','4697572','4642379');
insert into amarre values (seq_amarre.NEXTVAL,2345,16,'si',
TO_DATE('12-9-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),
TO_DATE('9-9-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)) ,'B','4545958','4556739');
insert into amarre values (seq_amarre.NEXTVAL,234,12,'si',
TO_DATE('5-3-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),
TO_DATE('4-3-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),'A','4585539','4759885');
insert into amarre values (seq_amarre.NEXTVAL,564,34,'no',
TO_DATE('8-1-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),
TO_DATE('8-1-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),'A','4674391','4575691');
insert into amarre values (seq_amarre.NEXTVAL,123,14,'no',
TO_DATE('12-5-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),
TO_DATE('9-5-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),'B','4634678','4556787');

-- Nuevos ammares
insert into amarre values (seq_amarre.NEXTVAL,345,26,'si',
TO_DATE('12-10-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),
TO_DATE('9-10-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)) ,'B','4545958','4556739');

insert into amarre values (seq_amarre.NEXTVAL,110,15,'no',
TO_DATE('12-6-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),
TO_DATE('9-4-' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)-3)),'B','4634678','4556787');


/* EmpleadosZona */
insert into EmpleadoZona values (100,'A',8);
insert into EmpleadoZona values (110,'B',7);
insert into EmpleadoZona values (120,'A',8);
insert into EmpleadoZona values (130,'C',9);
insert into EmpleadoZona values (140,'A',8);
insert into EmpleadoZona values (100,'B',6);


