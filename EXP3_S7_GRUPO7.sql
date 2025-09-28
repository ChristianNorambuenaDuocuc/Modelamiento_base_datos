
--BORRAR TABLAS---
DROP TABLE DOMINIO CASCADE CONSTRAINTS;
DROP TABLE TITULACION CASCADE CONSTRAINTS;
DROP TABLE PERSONAL CASCADE CONSTRAINTS;
DROP TABLE COMPANIA CASCADE CONSTRAINTS;
DROP TABLE IDIOMA CASCADE CONSTRAINTS;
DROP TABLE TITULO CASCADE CONSTRAINTS;
DROP TABLE ESTADO_CIVIL CASCADE CONSTRAINTS;
DROP TABLE GENERO CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;

--creacion de las tablas--
CREATE TABLE REGION (
id_region NUMBER(2) GENERATED ALWAYS AS IDENTITY (START WITH 7 INCREMENT BY 2) PRIMARY KEY,
nombre_region VARCHAR2(25) NOT NULL
);

CREATE TABLE COMUNA (
id_comuna NUMBER(5) NOT NULL,
comuna_nombre VARCHAR2(25) NOT NULL,
cod_region NUMBER(2) NOT NULL,

CONSTRAINT PK_COMUNA PRIMARY KEY (id_comuna, cod_region),
CONSTRAINT fk_comuna_region FOREIGN KEY (cod_Region) REFERENCES REGION(id_region)
);

CREATE TABLE GENERO(
id_genero VARCHAR2(3) PRIMARY KEY,
descripcion_genero VARCHAR2(25) NOT NULL
);

CREATE TABLE ESTADO_CIVIL (
id_estado_civil VARCHAR2(2) PRIMARY KEY,
descripcion_est_civil VARCHAR2(25) NOT NULL
);

CREATE TABLE TITULO (
id_titulo VARCHAR2(3) PRIMARY KEY,
descripcion_titulo VARCHAR2(60) NOT NULL
);

CREATE TABLE IDIOMA (
id_idioma NUMBER(3) GENERATED ALWAYS AS IDENTITY(START WITH 25 INCREMENT BY 3) PRIMARY KEY,
nombre_idioma VARCHAR2(30) NOT NULL
);

CREATE TABLE COMPANIA (
id_empresa NUMBER(2) PRIMARY KEY,
nombre_empresa VARCHAR2(25) NOT NULL,
calle VARCHAR2(50) NOT NULL,
numeracion NUMBER(5) NOT NULL,
renta_promedio NUMBER(10) NOT NULL,
pct_aumento NUMBER(4,3) ,
cod_comuna NUMBER(5) NOT NULL,
cod_region NUMBER(2) NOT NULL,

CONSTRAINT fk_compania_comuna FOREIGN KEY (cod_comuna,cod_region) REFERENCES COMUNA (id_comuna,cod_region),
CONSTRAINT unique_compania UNIQUE (nombre_empresa)
);

CREATE TABLE PERSONAL (
rut_persona NUMBER(8) PRIMARY KEY,
dv_persona CHAR(1) NOT NULL,
primer_nombre VARCHAR2(25) NOT NULL,
segundo_nombre VARCHAR2(25),
primer_apellido VARCHAR2(25) NOT NULL,
segundo_apellido VARCHAR2(25) NOT NULL,
fecha_contratacion DATE NOT NULL,
fecha_nacimiento DATE NOT NULL,
email VARCHAR2(100),
calle VARCHAR2(50) NOT NULL,
numeracion NUMBER(5) NOT NULL,
sueldo NUMBER(5) NOT NULL,
cod_comuna NUMBER(5) NOT NULL,
cod_region NUMBER(2) NOT NULL,
cod_genero VARCHAR2(3),
cod_estado_civil VARCHAR2(2),
cod_empresa NUMBER(2) NOT NULL,
encargado_rut NUMBER(8),

CONSTRAINT fk_personal_comuna FOREIGN KEY (cod_comuna,cod_region) REFERENCES COMUNA (id_comuna,cod_region),
CONSTRAINT fk_personal_genero FOREIGN KEY (cod_genero) REFERENCES GENERO (id_genero),
CONSTRAINT fk_personal_estado_civil FOREIGN KEY (cod_estado_civil) REFERENCES ESTADO_CIVIL (id_estado_civil),
CONSTRAINT fk_personal_compania FOREIGN KEY (cod_empresa) REFERENCES COMPANIA (id_empresa),
CONSTRAINT fk_personal_personal FOREIGN KEY (encargado_rut) REFERENCES PERSONAL (rut_persona)
);

CREATE TABLE TITULACION (
cod_titulo VARCHAR2(3) NOT NULL,
persona_rut NUMBER(8) NOT NULL,
fecha_titulacion DATE NOT NULL,

CONSTRAINT pk_titulacion PRIMARY KEY (cod_titulo, persona_rut),
CONSTRAINT fk_titulacion_personal FOREIGN KEY (persona_rut) REFERENCES PERSONAL (rut_persona),
CONSTRAINT fk_titulacion_titulo FOREIGN KEY (cod_titulo) REFERENCES TITULO (id_titulo)
);

CREATE TABLE DOMINIO (
id_idioma NUMBER(3) NOT NULL,
persona_rut NUMBER(8) NOT NULL,
nivel VARCHAR2(25) NOT NULL,

CONSTRAINT PK_DOMINIO PRIMARY KEY (id_idioma, persona_rut),
CONSTRAINT fk_dominio_idioma FOREIGN KEY (id_idioma) REFERENCES IDIOMA(id_idioma),
CONSTRAINT fk_dominio_personal FOREIGN KEY (persona_rut) REFERENCES PERSONAL (rut_persona)
);

--Modificaciones a las tablas---
--email de la tabla personal tiene solo datos unicos.
ALTER TABLE PERSONAL
ADD CONSTRAINT uk_personal UNIQUE (email);

--dv-personal tiene restricciones para el valor de o a 9 y k.
ALTER TABLE PERSONAL
ADD CONSTRAINT chk_DV_PERSONAL CHECK (dv_persona IS NULL OR 
dv_persona IN('1','2','3','4','5','6','7','8','9','0','K','k'))
;

--Restriccion a sueldo debe ser mayor a $450.000
ALTER TABLE PERSONAL
ADD CONSTRAINT chk_sueldo_personal CHECK ((sueldo >450000));

--Se modifica la cantidad de numeros de sueldo, ya que los datos a insertar
-- tienen al menos 6 datos no 5.
ALTER TABLE PERSONAL
MODIFY sueldo NOMBER(7);

-- INSERTAR DATOS---
--Se insertan datos a la tabla region
INSERT INTO REGION(nombre_region)
VALUES('ARICA Y PARINACOTA');
INSERT INTO REGION(nombre_region)
VALUES('METROPOLITANA');
INSERT INTO REGION(nombre_region)
VALUES('ARAUCANIA');

--Se insertan datos a la tabla comuna
INSERT INTO COMUNA(id_comuna,comuna_nombre,cod_region)
VALUES(1101,'ARICA',7);
INSERT INTO COMUNA(id_comuna,comuna_nombre,cod_region)
VALUES(1107,'Santiago',9);
INSERT INTO COMUNA(id_comuna,comuna_nombre,cod_region)
VALUES(1113,'Temuco',11);

--Se insertan valores a la tabla compania.
INSERT INTO COMPANIA (id_empresa,nombre_empresa,calle,numeracion,renta_promedio,pct_aumento,cod_comuna,cod_region)
VALUES (10,'CCyRojas','Amapolas',506,1857000,0.5,1101,7);
INSERT INTO COMPANIA (id_empresa,nombre_empresa,calle,numeracion,renta_promedio,pct_aumento,cod_comuna,cod_region)
VALUES (15,'SenTTY','Los Alamos',3490,897000,0.025,1101,7);
INSERT INTO COMPANIA (id_empresa,nombre_empresa,calle,numeracion,renta_promedio,pct_aumento,cod_comuna,cod_region)
VALUES (20,'Praxia LTDA','Las Camelias',11098,2157000,0.035,1107,9);
INSERT INTO COMPANIA (id_empresa,nombre_empresa,calle,numeracion,renta_promedio,pct_aumento,cod_comuna,cod_region)
VALUES (25,'TIC spa','FLORES S.A.',4357,857000,NULL,1107,9);
INSERT INTO COMPANIA (id_empresa,nombre_empresa,calle,numeracion,renta_promedio,pct_aumento,cod_comuna,cod_region)
VALUES (30,'SANTANA LTDA','AVDA. VIC. MACKENA',106,757000,0.015,1101,7);
INSERT INTO COMPANIA (id_empresa,nombre_empresa,calle,numeracion,renta_promedio,pct_aumento,cod_comuna,cod_region)
VALUES (35,'FLORES Y ASOCIADOS','PEDRO LATORRE',557,589000,0.015,1107,9);
INSERT INTO COMPANIA (id_empresa,nombre_empresa,calle,numeracion,renta_promedio,pct_aumento,cod_comuna,cod_region)
VALUES (40,'J.A. HOFFMAN','LATINA D. 32',509,1857000,0.025,1113,11);
INSERT INTO COMPANIA (id_empresa,nombre_empresa,calle,numeracion,renta_promedio,pct_aumento,cod_comuna,cod_region)
VALUES (45,'CAGLIARI D.','ALAMEDA',206,1857000,NULL,1107,9);
INSERT INTO COMPANIA (id_empresa,nombre_empresa,calle,numeracion,renta_promedio,pct_aumento,cod_comuna,cod_region)
VALUES (50,'Rojas HNOS LTDA','SUCRE',106,957000,0.005,1113,11);
INSERT INTO COMPANIA (id_empresa,nombre_empresa,calle,numeracion,renta_promedio,pct_aumento,cod_comuna,cod_region)
VALUES (55,'FRIENDS P. S.A.','SUECIA',506,857000,0.015,1113,11);

--Se insertan valores a la tabla idioma.
INSERT INTO IDIOMA(nombre_idioma)
VALUES('Ingles');
INSERT INTO IDIOMA(nombre_idioma)
VALUES('Chino');
INSERT INTO IDIOMA(nombre_idioma)
VALUES('Aleman');
INSERT INTO IDIOMA(nombre_idioma)
VALUES('Espanol');
INSERT INTO IDIOMA(nombre_idioma)
VALUES('Frances');

--Informes---

--informe 1---
SELECT nombre_empresa AS "Nombre Empresa", calle ||' '|| numeracion AS "Direccion",
renta_promedio AS "Renta Promedio",(renta_promedio*pct_aumento)+renta_promedio AS "Simulacion de Renta"
FROM COMPANIA
ORDER BY renta_promedio DESC,"Nombre Empresa" ASC;

--informe 2---
SELECT id_empresa AS "CODIGO",nombre_empresa AS "EMPRESA",
renta_promedio AS "PROM RENTA ACTUAL",(pct_aumento+0.15) AS "PCT AUMENTADO EN 15%",
(renta_promedio*(pct_aumento+0.15)) AS "RENTA AUMENTADA"
FROM COMPANIA
ORDER BY "PROM RENTA ACTUAL" ASC, "CODIGO" DESC;



