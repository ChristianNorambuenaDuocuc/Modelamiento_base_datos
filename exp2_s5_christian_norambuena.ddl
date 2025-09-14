-- Generado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   en:        2025-09-14 17:40:24 CLST
--   sitio:      Oracle Database 21c
--   tipo:      Oracle Database 21c



DROP TABLE afp CASCADE CONSTRAINTS;

DROP TABLE atenc_medica CASCADE CONSTRAINTS;

DROP TABLE c_medico CASCADE CONSTRAINTS;

DROP TABLE comuna CASCADE CONSTRAINTS;

DROP TABLE consulta CASCADE CONSTRAINTS;

DROP TABLE especialidad CASCADE CONSTRAINTS;

DROP TABLE ex_laboratorio CASCADE CONSTRAINTS;

DROP TABLE medico CASCADE CONSTRAINTS;

DROP TABLE paciente CASCADE CONSTRAINTS;

DROP TABLE pago_atencion CASCADE CONSTRAINTS;

DROP TABLE region CASCADE CONSTRAINTS;

DROP TABLE salud CASCADE CONSTRAINTS;

DROP TABLE sexo CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE afp (
    id_afp     NUMBER NOT NULL,
    nombre_afp VARCHAR2(30) NOT NULL
);

ALTER TABLE afp 
ADD CONSTRAINT afp_pk PRIMARY KEY ( id_afp );

ALTER TABLE afp 
ADD CONSTRAINT uk_afp_nombre_afp UNIQUE ( nombre_afp );

CREATE TABLE atenc_medica (
    id_atencion          NUMBER NOT NULL,
    fecha_atencion       DATE NOT NULL,
    paciente_id_paciente NUMBER NOT NULL,
    consulta_id_tipo     NUMBER NOT NULL,
    diagnostico          VARCHAR2(30) NOT NULL,
    examenes_solicitados VARCHAR2(30),
    medico_id_medico     NUMBER NOT NULL,
    tipo_atencion_medica VARCHAR2(30) NOT NULL,
    id_general           NUMBER,
    id_urgencia          NUMBER,
    id_preventiva        NUMBER
);

ALTER TABLE atenc_medica 
ADD CONSTRAINT pk_atencion_medica
PRIMARY KEY ( id_atencion );

CREATE TABLE c_medico (
    id_centro_m NUMBER NOT NULL,
    nombre_c_m  VARCHAR2(30) NOT NULL
);

ALTER TABLE c_medico 
ADD CONSTRAINT pk_centro_medico 
PRIMARY KEY ( id_centro_m );


 
ALTER TABLE c_medico 
ADD CONSTRAINT UK_centro_medico_nombre 
UNIQUE ( nombre_c_m );

CREATE TABLE comuna (
    id_comuna        NUMBER NOT NULL,
    nombre_comuna    VARCHAR2(30) NOT NULL,
    region_id_region NUMBER NOT NULL
);

ALTER TABLE comuna 
ADD CONSTRAINT pk_comuna 
PRIMARY KEY ( id_comuna );

ALTER TABLE comuna 
ADD CONSTRAINT uk_comuna_nombre_comuna
UNIQUE ( nombre_comuna );

CREATE TABLE consulta (
    id_tipo     NUMBER NOT NULL,
    nombre_tipo VARCHAR2(30) NOT NULL
);

ALTER TABLE consulta 
ADD CONSTRAINT pk_consulta
PRIMARY KEY ( id_tipo );

ALTER TABLE consulta 
ADD CONSTRAINT uk_consulta_nombre_tipo
UNIQUE ( nombre_tipo );

CREATE TABLE especialidad (
    id_esp     NUMBER NOT NULL,
    nombre_esp VARCHAR2(30) NOT NULL
);

ALTER TABLE especialidad 
ADD CONSTRAINT pk_especialidad 
PRIMARY KEY ( id_esp );



ALTER TABLE especialidad 
ADD CONSTRAINT uk_especialidad_nombre_espec 
UNIQUE ( nombre_esp );

CREATE TABLE ex_laboratorio (
    id_examen            NUMBER NOT NULL,
    nombre_ex            VARCHAR2(30) NOT NULL,
    tipo_muestra         VARCHAR2(30) NOT NULL,
    cond_preparacion     VARCHAR2(30) NOT NULL,
    medico_id_medico     NUMBER NOT NULL,
    paciente_id_paciente NUMBER NOT NULL
);

ALTER TABLE ex_laboratorio 
ADD CONSTRAINT pk_examen_laboratorio 
PRIMARY KEY ( id_examen );


 
ALTER TABLE ex_laboratorio 
ADD CONSTRAINT uk_ex_laboratorio_nombre_ex
UNIQUE ( nombre_ex );

CREATE TABLE medico (
    id_medico                 NUMBER NOT NULL,
    rut_medico                VARCHAR2(30) NOT NULL,
    digito                    VARCHAR2(30) NOT NULL,
    nombre_medico             VARCHAR2(30) NOT NULL,
    fecha_ingreso             VARCHAR2(30) NOT NULL,
    especialidad_id_esp       NUMBER NOT NULL,
    centro_medico_id_centro_m NUMBER NOT NULL,
    afp_id_afp                NUMBER NOT NULL,
    salud_id_salud            NUMBER NOT NULL,
    medico_id_medico          NUMBER,
    id_esp                    NUMBER NOT NULL
);

ALTER TABLE medico
    ADD CONSTRAINT 
    ck_medico_digito 
    CHECK ( digito IN ( '"1"', '"2"', '"3"', '"4"', '"5"',
                                                        '"6"', '"7"', '"8"', '"9"', '"K"' ) );

ALTER TABLE medico 
ADD CONSTRAINT pk_medico 
PRIMARY KEY ( id_medico );

CREATE TABLE paciente (
    id_paciente       NUMBER NOT NULL,
    rut_paciente      VARCHAR2(30) NOT NULL,
    digito            VARCHAR2(30) NOT NULL,
    nombre_paciente   VARCHAR2(30) NOT NULL,
    fecha_nacimiento  DATE NOT NULL,
    direccion         VARCHAR2(30) NOT NULL,
    comuna_id_comuna  NUMBER NOT NULL,
    historial         VARCHAR2(30),
    sexo_id_sexo      NUMBER NOT NULL,
    tipo_paciente     VARCHAR2(30) NOT NULL,
    id_estudiante     NUMBER,
    id_personal_acad  NUMBER,
    id_administrativo NUMBER
);

ALTER TABLE paciente
    ADD CONSTRAINT ck_paciente_digito 
    CHECK ( digito IN ( '"1"', '"2"', '"3"', '"4"', '"5"',
                                                          '"6"', '"7"', '"8"', '"9"', '"K"' ) );

ALTER TABLE paciente 
ADD CONSTRAINT pk_paciente 
PRIMARY KEY ( id_paciente );

CREATE TABLE pago_atencion (
    id_pago                  NUMBER NOT NULL,
    fecha_pago               DATE NOT NULL,
    monto                    NUMBER NOT NULL,
    atenc_medica_id_atencion NUMBER NOT NULL,
    tipo_pago_atencion       VARCHAR2(30) NOT NULL,
    id_efectivo              NUMBER,
    id_tarjeta               NUMBER,
    id_convenio              NUMBER
);

CREATE UNIQUE INDEX pago_atencion__idx ON
    pago_atencion (
        atenc_medica_id_atencion
    ASC );

ALTER TABLE pago_atencion 
ADD CONSTRAINT pk_pago_atencion 
PRIMARY KEY ( id_pago );

CREATE TABLE region (
    id_region     NUMBER NOT NULL,
    nombre_region VARCHAR2(30) NOT NULL
);

ALTER TABLE region 
ADD CONSTRAINT pk_region 
PRIMARY KEY ( id_region );

ALTER TABLE region 
ADD CONSTRAINT uk_region_nombre_region 
UNIQUE ( nombre_region );

CREATE TABLE salud (
    id_salud     NUMBER NOT NULL,
    nombre_salud VARCHAR2(30) NOT NULL
);

ALTER TABLE salud 
ADD CONSTRAINT pk_salud 
PRIMARY KEY ( id_salud );

ALTER TABLE salud 
ADD CONSTRAINT uk_salud_nombre_salud 
UNIQUE ( nombre_salud );

CREATE TABLE sexo (
    id_sexo     NUMBER NOT NULL,
    nombre_sexo VARCHAR2(30) NOT NULL
);

ALTER TABLE sexo 
ADD CONSTRAINT pk_sexo 
PRIMARY KEY ( id_sexo );

ALTER TABLE sexo 
ADD CONSTRAINT uk_sexo_nombre_sexo 
UNIQUE ( nombre_sexo );

ALTER TABLE atenc_medica
    ADD CONSTRAINT fk_atencion_medica_consulta FOREIGN KEY ( consulta_id_tipo )
        REFERENCES consulta ( id_tipo );

ALTER TABLE atenc_medica
    ADD CONSTRAINT fk_atencion_medica_medico FOREIGN KEY ( medico_id_medico )
        REFERENCES medico ( id_medico );

ALTER TABLE atenc_medica
    ADD CONSTRAINT fk_atencion_medica_paciente FOREIGN KEY ( paciente_id_paciente )
        REFERENCES paciente ( id_paciente );

ALTER TABLE comuna
    ADD CONSTRAINT fk_comuna_region FOREIGN KEY ( region_id_region )
        REFERENCES region ( id_region );

ALTER TABLE ex_laboratorio
    ADD CONSTRAINT fk_ex_laboratorio_medico FOREIGN KEY ( medico_id_medico )
        REFERENCES medico ( id_medico );

ALTER TABLE ex_laboratorio
    ADD CONSTRAINT fk_ex_laboratorio_paciente FOREIGN KEY ( paciente_id_paciente )
        REFERENCES paciente ( id_paciente );

ALTER TABLE medico
    ADD CONSTRAINT fk_medico_afp FOREIGN KEY ( afp_id_afp )
        REFERENCES afp ( id_afp );

ALTER TABLE medico
    ADD CONSTRAINT fk_medico_centro_medico FOREIGN KEY ( centro_medico_id_centro_m )
        REFERENCES c_medico ( id_centro_m );

ALTER TABLE medico
    ADD CONSTRAINT fk_medico_especialidad FOREIGN KEY ( especialidad_id_esp )
        REFERENCES especialidad ( id_esp );

ALTER TABLE medico
    ADD CONSTRAINT fk_medico_medico FOREIGN KEY ( medico_id_medico )
        REFERENCES medico ( id_medico );

ALTER TABLE medico
    ADD CONSTRAINT fk_medico_salud FOREIGN KEY ( salud_id_salud )
        REFERENCES salud ( id_salud );

ALTER TABLE paciente
    ADD CONSTRAINT fk_paciente_comuna FOREIGN KEY ( comuna_id_comuna )
        REFERENCES comuna ( id_comuna );

ALTER TABLE paciente
    ADD CONSTRAINT fk_paciente_sexo FOREIGN KEY ( sexo_id_sexo )
        REFERENCES sexo ( id_sexo );

ALTER TABLE pago_atencion
    ADD CONSTRAINT fk_pago_atencion_atenc_medica FOREIGN KEY ( atenc_medica_id_atencion )
        REFERENCES atenc_medica ( id_atencion );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            13
-- CREATE INDEX                             1
-- ALTER TABLE                             38
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   3
-- WARNINGS                                 0
