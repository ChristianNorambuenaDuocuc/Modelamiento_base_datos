------------------------------------------------------------
-- 1. DROP TABLES 
------------------------------------------------------------
DROP TABLE digital CASCADE CONSTRAINTS;
DROP TABLE general CASCADE CONSTRAINTS;
DROP TABLE magistral CASCADE CONSTRAINTS;
DROP TABLE retenida CASCADE CONSTRAINTS;
DROP TABLE veterinaria CASCADE CONSTRAINTS;

DROP TABLE receta_medic CASCADE CONSTRAINTS;

DROP TABLE generico CASCADE CONSTRAINTS;
DROP TABLE marca CASCADE CONSTRAINTS;
DROP TABLE dosis CASCADE CONSTRAINTS;

DROP TABLE receta CASCADE CONSTRAINTS;
DROP TABLE paciente CASCADE CONSTRAINTS;
DROP TABLE pago CASCADE CONSTRAINTS;
DROP TABLE medicamento CASCADE CONSTRAINTS;

DROP TABLE medico CASCADE CONSTRAINTS;
DROP TABLE digitador CASCADE CONSTRAINTS;
DROP TABLE diagnostico CASCADE CONSTRAINTS;
DROP TABLE banco CASCADE CONSTRAINTS;

DROP TABLE comuna CASCADE CONSTRAINTS;
DROP TABLE ciudad CASCADE CONSTRAINTS;
DROP TABLE region CASCADE CONSTRAINTS;

------------------------------------------------------------
-- 2. CREATE TABLES 
------------------------------------------------------------


CREATE TABLE region (
    id_region NUMBER(7) NOT NULL,
    nombre    VARCHAR2(12) NOT NULL
);
ALTER TABLE region ADD CONSTRAINT region_pk PRIMARY KEY ( id_region );
ALTER TABLE region ADD CONSTRAINT region_nombre_un UNIQUE ( nombre );

CREATE TABLE ciudad (
    id_ciudad        NUMBER(7) NOT NULL,
    nombre           VARCHAR2(12) NOT NULL,
    region_id_region NUMBER(7) NOT NULL
);
ALTER TABLE ciudad ADD CONSTRAINT ciudad_pk PRIMARY KEY ( id_ciudad );
ALTER TABLE ciudad ADD CONSTRAINT ciudad_nombre_un UNIQUE ( nombre );
ALTER TABLE ciudad
    ADD CONSTRAINT ciudad_region_fk FOREIGN KEY ( region_id_region )
        REFERENCES region ( id_region );

CREATE TABLE comuna (
    id_comuna        NUMBER GENERATED ALWAYS AS IDENTITY
    (START WITH 1101 INCREMENT BY 1) NOT NULL,
    nombre           VARCHAR2(12) NOT NULL,
    ciudad_id_ciudad NUMBER(7) NOT NULL
);
ALTER TABLE comuna ADD CONSTRAINT comuna_pk PRIMARY KEY ( id_comuna );
ALTER TABLE comuna ADD CONSTRAINT comuna_nombre_un UNIQUE ( nombre );
ALTER TABLE comuna
    ADD CONSTRAINT comuna_ciudad_fk FOREIGN KEY ( ciudad_id_ciudad )
        REFERENCES ciudad ( id_ciudad );

CREATE TABLE banco (
    cod_banco NUMBER(2) NOT NULL,
    nombre    VARCHAR2(25) NOT NULL
);
ALTER TABLE banco ADD CONSTRAINT banco_pk PRIMARY KEY ( cod_banco );
ALTER TABLE banco ADD CONSTRAINT banco_nombre_un UNIQUE ( nombre );

CREATE TABLE diagnostico (
    cod_diagnostico NUMBER(3) NOT NULL,
    nombre          VARCHAR2(25) NOT NULL
);
ALTER TABLE diagnostico ADD CONSTRAINT diagnostico_pk PRIMARY KEY ( cod_diagnostico );
ALTER TABLE diagnostico ADD CONSTRAINT diagnostico_nombre_un UNIQUE ( nombre );

CREATE TABLE digitador (
    id_digitador NUMBER(20) NOT NULL,
    pnombre      VARCHAR2(25) NOT NULL,
    papellido    VARCHAR2(25) NOT NULL,
    rut_dig      NUMBER(8) NOT NULL,
    dv_dig       CHAR(1) NOT NULL
);
ALTER TABLE digitador
    ADD CONSTRAINT ck_dv_dig CHECK ( dv_dig IN ('0','1','2','3','4','5','6','7','8','9','K') );
ALTER TABLE digitador ADD CONSTRAINT digitador_pk PRIMARY KEY ( id_digitador );

CREATE TABLE medico (
    rut_med      NUMBER(8) NOT NULL,
    dv_med       CHAR(1) NOT NULL,
    pnombre      VARCHAR2(25) NOT NULL,
    snombre      VARCHAR2(25),
    papellido    VARCHAR2(25) NOT NULL,
    sapellido    VARCHAR2(25),
    especialidad VARCHAR2(25) NOT NULL,
    telefono     NUMBER(12) NOT NULL
);
ALTER TABLE medico
    ADD CONSTRAINT ck_dv_med CHECK ( dv_med IN ('0','1','2','3','4','5','6','7','8','9','K') );
ALTER TABLE medico ADD CONSTRAINT medico_pk PRIMARY KEY ( rut_med );
ALTER TABLE medico ADD CONSTRAINT medico_telefono_un UNIQUE ( telefono );

------------------------------------------------------------
-- ENTIDADES PRINCIPALES
------------------------------------------------------------

CREATE TABLE paciente (
    rut_pac          VARCHAR2(25) NOT NULL,
    dv_pac           CHAR(1) NOT NULL,
    pnombre          VARCHAR2(25) NOT NULL,
    snombre          VARCHAR2(25) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono         NUMBER(11) NOT NULL,
    calle            VARCHAR2(25) NOT NULL,
    numeracion       NUMBER(5) NOT NULL,
    comuna           NUMBER(5) NOT NULL,
    ciudad           NUMBER(5) NOT NULL,
    region           NUMBER(5) NOT NULL,
    comuna_id_comuna NUMBER(7) NOT NULL
);
ALTER TABLE paciente
    ADD CONSTRAINT ck_dv_pac CHECK ( dv_pac IN ('0','1','2','3','4','5','6','7','8','9','K') );
ALTER TABLE paciente ADD CONSTRAINT paciente_pk PRIMARY KEY ( rut_pac );
ALTER TABLE paciente
    ADD CONSTRAINT paciente_comuna_fk FOREIGN KEY ( comuna_id_comuna )
        REFERENCES comuna ( id_comuna );

CREATE TABLE medicamento (
    cod_medicamento  NUMBER(7) NOT NULL,
    nombre           VARCHAR2(25) NOT NULL,
    tipo_medicamento NUMBER(3) NOT NULL,
    via_administra   NUMBER(3) NOT NULL,
    stock_vta        NUMBER(38) NOT NULL,
    dosis_id_dosis   NUMBER(7) NOT NULL,
    id_medicamento   NUMBER NOT NULL,
    precio_unitario  NUMBER(10) NOT NULL
    
);
ALTER TABLE medicamento
    ADD CONSTRAINT fkarc_1_lov CHECK ( id_medicamento IN (1, 2) );
ALTER TABLE medicamento ADD CONSTRAINT medicamento_pk PRIMARY KEY ( cod_medicamento );
ALTER TABLE medicamento ADD CONSTRAINT medicamento__un UNIQUE ( id_medicamento );
ALTER TABLE medicamento ADD CONSTRAINT ck_precio_unitario CHECK (precio_unitario BETWEEN 1000 AND 2000000)

CREATE TABLE receta (
    cod_receta                  NUMBER(7) NOT NULL,
    observaciones               VARCHAR2(500),
    fecha_emision               NUMBER(5) NOT NULL,
    fecha_vencimiento           VARCHAR2(25),
    id_digitador                NUMBER(8) NOT NULL,
    id_tipo_receta              NUMBER(3) NOT NULL,
    paciente_rut_pac            VARCHAR2(25) NOT NULL,
    medico_rut_med              NUMBER(8) NOT NULL,
    diagnostico_cod_diagnostico NUMBER(3) NOT NULL,
    digitador_id_digitador      NUMBER(20) NOT NULL
);
ALTER TABLE receta
    ADD CONSTRAINT fkarc_2_lov CHECK ( id_tipo_receta IN (1,2,3,4,5) );
ALTER TABLE receta ADD CONSTRAINT receta_pk PRIMARY KEY ( cod_receta );
ALTER TABLE receta ADD CONSTRAINT receta__un UNIQUE ( id_tipo_receta );

------------------------------------------------------------
-- DEPENDIENTES / RELACIONES
------------------------------------------------------------

CREATE TABLE receta_medic (
    receta_cod_receta           NUMBER(7) NOT NULL,
    medicamento_cod_medicamento NUMBER(7) NOT NULL
);
ALTER TABLE receta_medic ADD CONSTRAINT relation_6_pk PRIMARY KEY ( receta_cod_receta, medicamento_cod_medicamento );
ALTER TABLE receta_medic
    ADD CONSTRAINT relation_6_medicamento_fk FOREIGN KEY ( medicamento_cod_medicamento )
        REFERENCES medicamento ( cod_medicamento );
ALTER TABLE receta_medic
    ADD CONSTRAINT relation_6_receta_fk FOREIGN KEY ( receta_cod_receta )
        REFERENCES receta ( cod_receta );

CREATE TABLE dosis (
    id_dosis                    NUMBER(7) NOT NULL,
    descripcio_dosis            VARCHAR2(25) NOT NULL,
    medicamento_cod_medicamento NUMBER NOT NULL
);
ALTER TABLE dosis ADD CONSTRAINT dosis_pk PRIMARY KEY ( id_dosis );

ALTER TABLE dosis ADD CONSTRAINT dosis_descripcio_dosis_un UNIQUE ( descripcio_dosis );

ALTER TABLE medicamento
    ADD CONSTRAINT medicamento_dosis_fk FOREIGN KEY ( dosis_id_dosis )
        REFERENCES dosis ( id_dosis );

CREATE TABLE pago (
    cod_boleta        NUMBER(6) NOT NULL,
    id_receta         NUMBER(7) NOT NULL,
    fecha_pago        DATE NOT NULL,
    monto_total       VARCHAR2(25) NOT NULL,
    metodo_pago       NUMBER(20) NOT NULL,
    banco_cod_banco   NUMBER(2),
    receta_cod_receta NUMBER(7) NOT NULL
);
ALTER TABLE pago ADD CONSTRAINT pago_pk PRIMARY KEY ( cod_boleta );
ALTER TABLE pago
    ADD CONSTRAINT pago_banco_fk FOREIGN KEY ( banco_cod_banco )
        REFERENCES banco ( cod_banco );
ALTER TABLE pago
    ADD CONSTRAINT pago_receta_fk FOREIGN KEY ( receta_cod_receta )
        REFERENCES receta ( cod_receta );
ALTER TABLE pago
    ADD CONSTRAINT ck_metodo_pago
    check (metodo_pago in ("EFECTIVO","TARJETA","TRANSFERENCIA" ));

------------------------------------------------------------
-- SUBTIPOS DE RECETA
------------------------------------------------------------
CREATE TABLE digital (
    cod_receta NUMBER(7) NOT NULL
);
ALTER TABLE digital ADD CONSTRAINT digital_pk PRIMARY KEY ( cod_receta );
ALTER TABLE digital
    ADD CONSTRAINT digital_receta_fk FOREIGN KEY ( cod_receta )
        REFERENCES receta ( cod_receta );

CREATE TABLE general (
    cod_receta NUMBER(7) NOT NULL
);
ALTER TABLE general ADD CONSTRAINT general_pk PRIMARY KEY ( cod_receta );
ALTER TABLE general
    ADD CONSTRAINT general_receta_fk FOREIGN KEY ( cod_receta )
        REFERENCES receta ( cod_receta );

CREATE TABLE magistral (
    cod_receta NUMBER(7) NOT NULL
);
ALTER TABLE magistral ADD CONSTRAINT magistral_pk PRIMARY KEY ( cod_receta );
ALTER TABLE magistral
    ADD CONSTRAINT magistral_receta_fk FOREIGN KEY ( cod_receta )
        REFERENCES receta ( cod_receta );

CREATE TABLE retenida (
    cod_receta NUMBER(7) NOT NULL
);
ALTER TABLE retenida ADD CONSTRAINT retenida_pk PRIMARY KEY ( cod_receta );
ALTER TABLE retenida
    ADD CONSTRAINT retenida_receta_fk FOREIGN KEY ( cod_receta )
        REFERENCES receta ( cod_receta );

CREATE TABLE veterinaria (
    cod_receta NUMBER(7) NOT NULL
);
ALTER TABLE veterinaria ADD CONSTRAINT veterinaria_pk PRIMARY KEY ( cod_receta );
ALTER TABLE veterinaria
    ADD CONSTRAINT veterinaria_receta_fk FOREIGN KEY ( cod_receta )
        REFERENCES receta ( cod_receta );

------------------------------------------------------------
-- SUBTIPOS DE MEDICAMENTO
------------------------------------------------------------
CREATE TABLE generico (
    cod_medicamento NUMBER(7) NOT NULL
);
ALTER TABLE generico ADD CONSTRAINT generico_pk PRIMARY KEY ( cod_medicamento );
ALTER TABLE generico
    ADD CONSTRAINT generico_medicamento_fk FOREIGN KEY ( cod_medicamento )
        REFERENCES medicamento ( cod_medicamento );

CREATE TABLE marca (
    cod_medicamento NUMBER(7) NOT NULL
);
ALTER TABLE marca ADD CONSTRAINT marca_pk PRIMARY KEY ( cod_medicamento );
ALTER TABLE marca
    ADD CONSTRAINT marca_medicamento_fk FOREIGN KEY ( cod_medicamento )
        REFERENCES medicamento ( cod_medicamento );



