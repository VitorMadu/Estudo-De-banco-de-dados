

DROP TABLE t_br_aluno CASCADE CONSTRAINTS;

DROP TABLE t_br_automovel CASCADE CONSTRAINTS;

DROP TABLE t_br_cliente CASCADE CONSTRAINTS;

DROP TABLE t_br_empresa CASCADE CONSTRAINTS;

DROP TABLE t_br_escola CASCADE CONSTRAINTS;

DROP TABLE t_br_funcionario CASCADE CONSTRAINTS;

DROP TABLE t_br_inscricao CASCADE CONSTRAINTS;


CREATE TABLE t_br_aluno (
    cd_aluno             NUMBER(5) NOT NULL,
    cd_cliente           NUMBER(5) NOT NULL,
    cd_escola            NUMBER(3) NOT NULL,
    nm_responsavel_aluno VARCHAR2(100) NOT NULL,
    nm_escola_aluno      VARCHAR2(100) NOT NULL,
    dt_nascimento_aluno  DATE NOT NULL
);

ALTER TABLE t_br_aluno ADD CONSTRAINT pk_br_aluno PRIMARY KEY ( cd_aluno );

CREATE TABLE t_br_automovel (
    cd_automovel             NUMBER(5) NOT NULL,
    cd_empresa               NUMBER(6) NOT NULL,
    nr_renavam               NUMBER(11) NOT NULL,
    ds_placa_automovel       VARCHAR2(7) NOT NULL,
    nm_modelo_empresa        VARCHAR2(50) NOT NULL,
    nm_marca_automovel       VARCHAR2(30) NOT NULL,
    dt_ano_fabricacao        DATE NOT NULL,
    ds_cor_automovel         VARCHAR2(100) NOT NULL,
    nr_capacidade_automovel  NUMBER(2) NOT NULL,
    nm_funcionario_automovel VARCHAR2(50) NOT NULL
);

ALTER TABLE t_br_automovel ADD CONSTRAINT pk_br_automovel PRIMARY KEY ( cd_automovel,
                                                                        cd_empresa );

CREATE TABLE t_br_cliente (
    cd_cliente                NUMBER(5) NOT NULL,
    nm_login_cliente          VARCHAR2(30) NOT NULL,
    nm_cliente                VARCHAR2(100) NOT NULL,
    nr_cpf_cliente            NUMBER(11) NOT NULL,
    ds_end_cliente            VARCHAR2(100) NOT NULL,
    nr_rg_cliente             NUMBER(9, 1) NOT NULL,
    ds_grauparentesco_cliente VARCHAR2(11) NOT NULL,
    dg_genero_cliente         VARCHAR2(2) NOT NULL,
    ds_senha_cliente          VARCHAR2(30) NOT NULL
);

ALTER TABLE t_br_cliente
    ADD CONSTRAINT ck_br_cliente_dg_genero CHECK ( dg_genero_cliente IN ( 'M', 'H', 'ND' ) );

ALTER TABLE t_br_cliente ADD CONSTRAINT pk_br_cliente PRIMARY KEY ( cd_cliente );

ALTER TABLE t_br_cliente ADD CONSTRAINT pk_br_cliente_login UNIQUE ( nm_login_cliente );

CREATE TABLE t_br_empresa (
    cd_empresa                 NUMBER(6) NOT NULL,
    cnpj_empresa               NUMBER(14) NOT NULL,
    nm_empresa                 VARCHAR2(100) NOT NULL,
    nr_qt_frotas_empresa       NUMBER(3) NOT NULL,
    nr_qt_cliente_empresa      NUMBER(3) NOT NULL,
    nr_escola_atendida_empresa NUMBER(3) NOT NULL
);

ALTER TABLE t_br_empresa ADD CONSTRAINT pk_br_empresa PRIMARY KEY ( cd_empresa );

ALTER TABLE t_br_empresa ADD CONSTRAINT un_br_empresa_cnpj UNIQUE ( cnpj_empresa );

CREATE TABLE t_br_escola (
    cd_escola      NUMBER(3) NOT NULL,
    nm_escola      VARCHAR2(100) NOT NULL,
    nr_cnpj_escola NUMBER(14) NOT NULL,
    ds_end_escola  VARCHAR2(100) NOT NULL,
    nr_cep_escola  NUMBER(8) NOT NULL
);

ALTER TABLE t_br_escola ADD CONSTRAINT pk_br_escola PRIMARY KEY ( cd_escola );

CREATE TABLE t_br_funcionario (
    cd_funcionario          NUMBER(4) NOT NULL,
    cd_automovel            NUMBER(5) NOT NULL,
    cd_empresa              NUMBER(6) NOT NULL,
    nm_login_funcionario    VARCHAR2(30) NOT NULL,
    nr_telefone_funcionario NUMBER(13) NOT NULL,
    nr_rg_funcionario       NUMBER(9, 1) NOT NULL,
    ds_senha_funcionario    VARCHAR2(30) NOT NULL
);

CREATE UNIQUE INDEX t_br_funcionario__idx ON
    t_br_funcionario (
        cd_automovel
    ASC,
        cd_empresa
    ASC );

ALTER TABLE t_br_funcionario ADD CONSTRAINT pk_br_funcionario PRIMARY KEY ( cd_funcionario );

ALTER TABLE t_br_funcionario ADD CONSTRAINT un_br_funcionario_login UNIQUE ( nm_login_funcionario );

CREATE TABLE t_br_inscricao (
    cd_inscricao NUMBER(4) NOT NULL,
    cd_cliente   NUMBER(5) NOT NULL,
    cd_empresa   NUMBER(6) NOT NULL
);

CREATE UNIQUE INDEX t_br_inscricao__idx ON
    t_br_inscricao (
        cd_empresa
    ASC );

CREATE UNIQUE INDEX t_br_inscricao__idxv1 ON
    t_br_inscricao (
        cd_cliente
    ASC );

ALTER TABLE t_br_inscricao ADD CONSTRAINT pk_br_inscricao PRIMARY KEY ( cd_inscricao );

ALTER TABLE t_br_aluno
    ADD CONSTRAINT fk_br_aluno_cliente FOREIGN KEY ( cd_cliente )
        REFERENCES t_br_cliente ( cd_cliente );

ALTER TABLE t_br_aluno
    ADD CONSTRAINT fk_br_aluno_escola FOREIGN KEY ( cd_escola )
        REFERENCES t_br_escola ( cd_escola );

ALTER TABLE t_br_automovel
    ADD CONSTRAINT fk_br_automovel_empresa FOREIGN KEY ( cd_empresa )
        REFERENCES t_br_empresa ( cd_empresa );

ALTER TABLE t_br_inscricao
    ADD CONSTRAINT fk_br_inscricao_cliente FOREIGN KEY ( cd_cliente )
        REFERENCES t_br_cliente ( cd_cliente );

ALTER TABLE t_br_inscricao
    ADD CONSTRAINT fk_br_inscricao_empresa FOREIGN KEY ( cd_empresa )
        REFERENCES t_br_empresa ( cd_empresa );

ALTER TABLE t_br_funcionario
    ADD CONSTRAINT fk_funcionario_automovel FOREIGN KEY ( cd_automovel,
                                                          cd_empresa )
        REFERENCES t_br_automovel ( cd_automovel,
                                    cd_empresa );

