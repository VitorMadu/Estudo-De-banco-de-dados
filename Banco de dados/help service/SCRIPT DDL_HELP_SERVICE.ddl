

DROP TABLE t_hs_ambulancia CASCADE CONSTRAINTS;

DROP TABLE t_hs_cliente CASCADE CONSTRAINTS;

DROP TABLE t_hs_hospital CASCADE CONSTRAINTS;


CREATE TABLE t_hs_ambulancia (
    cd_ambulancia         NUMBER(5) NOT NULL,
    cd_hospital           NUMBER(6) NOT NULL,
    ds_placa_ambulancia   VARCHAR2(7) NOT NULL,
    nr_renavam_ambulancia NUMBER(11) NOT NULL,
    ds_marca_ambulancia   VARCHAR2(50) NOT NULL
);

ALTER TABLE t_hs_ambulancia ADD constraint ck_hs_ambulancia_marca 
    CHECK ( DS_MARCA_AMBULANCIA IN ('FIAT','MERCEDES-BENZ','RENAULT'))
;
ALTER TABLE t_hs_ambulancia ADD CONSTRAINT pk_hs_ambulancia PRIMARY KEY ( cd_ambulancia );

ALTER TABLE t_hs_ambulancia ADD CONSTRAINT un_hs_ambulancia UNIQUE ( ds_placa_ambulancia );

CREATE TABLE t_hs_cliente (
    cd_cliente            NUMBER(5) NOT NULL,
    cd_ambulancia         NUMBER(5) NOT NULL,
    cd_hospital           NUMBER(6) NOT NULL,
    nm_cliente            VARCHAR2(30) NOT NULL,
    nm_sobrenome_cliente  VARCHAR2(50) NOT NULL,
    ds_email_cliente      VARCHAR2(100) NOT NULL,
    dt_nascimento_cliente DATE NOT NULL,
    nr_rg_cliente         NUMBER(9, 1) NOT NULL,
    nr_tele_cliente       NUMBER(13) NOT NULL,
    nr_senha_cliente      VARCHAR2(30)
);

CREATE UNIQUE INDEX t_hs_cliente__idx ON
    t_hs_cliente (
        cd_ambulancia
    ASC );

ALTER TABLE t_hs_cliente ADD CONSTRAINT pk_hs_cliente PRIMARY KEY ( cd_cliente );

CREATE TABLE t_hs_hospital (
    cd_hospital      NUMBER(6) NOT NULL,
    nm_hospital      VARCHAR2(100) NOT NULL,
    cnpj_hospital    NUMBER(14) NOT NULL,
    nr_cep_hospital  NUMBER(8) NOT NULL,
    ds_end_hospital  VARCHAR2(100) NOT NULL,
    nr_tele_hospital NUMBER(11) NOT NULL
);

ALTER TABLE t_hs_hospital ADD CONSTRAINT pk_hs_hospital PRIMARY KEY ( cd_hospital );

ALTER TABLE t_hs_ambulancia
    ADD CONSTRAINT fk_hs_ambulancia_hospital FOREIGN KEY ( cd_hospital )
        REFERENCES t_hs_hospital ( cd_hospital );

ALTER TABLE t_hs_cliente
    ADD CONSTRAINT fk_hs_cliente_ambulancia FOREIGN KEY ( cd_ambulancia )
        REFERENCES t_hs_ambulancia ( cd_ambulancia );

ALTER TABLE t_hs_cliente
    ADD CONSTRAINT fk_hs_cliente_hospital FOREIGN KEY ( cd_hospital )
        REFERENCES t_hs_hospital ( cd_hospital );


