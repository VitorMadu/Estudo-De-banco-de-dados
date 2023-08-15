DROP TABLE FRUTO;
DROP TABLE RIG_LINHA;
DROP TABLE SOCKET;
DROP TABLE PESSOA_FISICA;
DROP TABLE PESSOA_JURIDICA;
DROP TABLE LOG_ERROR;

CREATE TABLE fruto (
    id_fruto           NUMBER(19) NOT NULL,
    id_pessoa_juridica NUMBER(19) NOT NULL,
    id_linha           NUMBER(19) NOT NULL,
    id_socket          NUMBER(19) NOT NULL,
    nm_fenotipo        VARCHAR2(255) NOT NULL,
    nm_fruto           VARCHAR2(255) NOT NULL,
    qt_carboitrato     FLOAT(53) NOT NULL,
    qt_monoinsaturada  FLOAT(53) NOT NULL,
    qt_poliisaturada   FLOAT(53) NOT NULL,
    qt_saturada        FLOAT(53) NOT NULL,
    qt_kcal            FLOAT(53) NOT NULL,
    qt_porcao          FLOAT(53) NOT NULL,
    qt_proteina        FLOAT(53) NOT NULL,
    tp_fruto           VARCHAR2(255) NOT NULL
);

ALTER TABLE fruto ADD CONSTRAINT fruto_pk PRIMARY KEY ( id_fruto );

CREATE TABLE pessoa_fisica (
    id_pessoa_fisica    NUMBER(19) NOT NULL,
    nr_cpf              VARCHAR2(255) NOT NULL,
    dt_contratacao      DATE NOT NULL,
    dt_nascimento       DATE NOT NULL,
    ds_email            VARCHAR2(255) NOT NULL,
    ds_endereco         VARCHAR2(255) NOT NULL,
    ds_estado_civil     VARCHAR2(255) NOT NULL,
    nr_filhos           NUMBER(10) NOT NULL,
    nm_pessoa           VARCHAR2(255),
    ds_renda            FLOAT(53) NOT NULL,
    ds_renda_per_capita FLOAT(53) NOT NULL,
    sexo                VARCHAR2(255) NOT NULL,
    nr_telefone         VARCHAR2(11) NOT NULL
);

ALTER TABLE pessoa_fisica ADD CONSTRAINT pk_pessoa_fisica PRIMARY KEY ( id_pessoa_fisica );

ALTER TABLE pessoa_fisica ADD CONSTRAINT un_pessoa_fisica UNIQUE ( nr_cpf );

CREATE TABLE pessoa_juridica (
    id_pessoa_juridica NUMBER(19) NOT NULL,
    nr_cnpj            VARCHAR2(20) NOT NULL,
    dt_contratacao     DATE NOT NULL,
    ds_email           VARCHAR2(255) NOT NULL,
    ds_endereco        VARCHAR2(255) NOT NULL,
    nm_empresa         VARCHAR2(255) NOT NULL,
    nr_telefone        VARCHAR2(11) NOT NULL
);

ALTER TABLE pessoa_juridica ADD CONSTRAINT pk_pessoa_juridica PRIMARY KEY ( id_pessoa_juridica );

ALTER TABLE pessoa_juridica ADD CONSTRAINT un_pessoa_juridica UNIQUE ( nr_cnpj );

CREATE TABLE rig_linha (
    id_linha           NUMBER(19) NOT NULL,
    id_pessoa_juridica NUMBER(19) NOT NULL,
    id_socket          NUMBER(19) NOT NULL,
    qt_fluxo_agua      FLOAT(53) NOT NULL,
    qt_ligado          FLOAT(53) NOT NULL,
    qt_ec              FLOAT(53) NOT NULL,
    qt_ph              FLOAT(53) NOT NULL,
    qt_ppm             FLOAT(53) NOT NULL,
    qt_fosforo         FLOAT(53) NOT NULL,
    qt_magnesio        FLOAT(53) NOT NULL,
    qt_nitrogenio      FLOAT(53) NOT NULL,
    qt_potassio        FLOAT(53) NOT NULL,
    qt_zinco           FLOAT(53) NOT NULL,
    nr_plantas_rig     FLOAT(53) NOT NULL
);

ALTER TABLE rig_linha
    ADD CONSTRAINT pk_rig_linha PRIMARY KEY ( id_linha,
                                              id_socket,
                                              id_pessoa_juridica );

CREATE TABLE socket (
    id_socket          NUMBER(19) NOT NULL,
    id_pessoa_juridica NUMBER(19) NOT NULL,
    id_pessoa_fisica   NUMBER(19) NOT NULL,
    skt_dt_colheita    DATE NOT NULL,
    skt_dt_plantio     DATE NOT NULL,
    skt_temperatura    FLOAT(53) NOT NULL,
    skt_peso           FLOAT(53) NOT NULL,
    umidade_ar         FLOAT(53) NOT NULL
);

ALTER TABLE socket ADD CONSTRAINT pk_socket PRIMARY KEY ( id_pessoa_juridica );

ALTER TABLE fruto
    ADD CONSTRAINT fk_fruto_rig_linha FOREIGN KEY ( id_linha,
                                                    id_socket,
                                                    id_pessoa_juridica )
        REFERENCES rig_linha ( id_linha,
                               id_socket,
                               id_pessoa_juridica );

ALTER TABLE rig_linha
    ADD CONSTRAINT fk_rig_linha_socket FOREIGN KEY ( id_pessoa_juridica )
        REFERENCES socket ( id_pessoa_juridica );

ALTER TABLE socket
    ADD CONSTRAINT fk_socket_pessoa_fisica FOREIGN KEY ( id_pessoa_fisica )
        REFERENCES pessoa_fisica ( id_pessoa_fisica );

ALTER TABLE socket
    ADD CONSTRAINT fk_socket_pessoa_juridica FOREIGN KEY ( id_pessoa_juridica )
        REFERENCES pessoa_juridica ( id_pessoa_juridica );

CREATE TABLE LOG_ERROR (
    usuario VARCHAR2(50),
    data_ocorrencia DATE,
    codigo_erro NUMBER,
    msg_erro VARCHAR2(255)
);

-----------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_carga_inicial AS 
  ex_unique_constraint EXCEPTION;
  PRAGMA EXCEPTION_INIT(ex_unique_constraint, -00001);
  ex_value_too_large EXCEPTION;
  PRAGMA EXCEPTION_INIT(ex_value_too_large, -12899);
  
  v_code NUMBER;
  v_errm VARCHAR2(64);
BEGIN

 
    INSERT INTO pessoa_juridica (id_pessoa_juridica, nr_cnpj, dt_contratacao, ds_email, ds_endereco, nm_empresa, nr_telefone)
    VALUES (1, '12345678900001', TO_DATE('2021-01-01', 'YYYY-MM-DD'), 'Apple@gmail.com', 'Av. bandeirantes, 123', 'Apple', '5556667777');
    INSERT INTO pessoa_juridica (id_pessoa_juridica, nr_cnpj, dt_contratacao, ds_email, ds_endereco, nm_empresa, nr_telefone)
    VALUES (2, '98765432000100', TO_DATE('2019-05-15', 'YYYY-MM-DD'), 'BurgerKing@hotmail.com', 'Av.Castelo Branco, 012', 'Burguer King', '5556667778');
    INSERT INTO pessoa_juridica (id_pessoa_juridica, nr_cnpj, dt_contratacao, ds_email, ds_endereco, nm_empresa, nr_telefone)
    VALUES (3, '11111111100002', TO_DATE('2022-03-15', 'YYYY-MM-DD'), 'Dasa@hotmail.com', 'Av. João Dias, 789', 'Dasa', '5556667779');
    INSERT INTO pessoa_juridica (id_pessoa_juridica, nr_cnpj, dt_contratacao, ds_email, ds_endereco, nm_empresa, nr_telefone)  
    VALUES (4, '22222222200003', TO_DATE('2020-10-20', 'YYYY-MM-DD'), 'Extra@gmail.com', 'Rua Epaminondas Melo, 012', 'Extra', '5556667780');
    INSERT INTO pessoa_juridica (id_pessoa_juridica, nr_cnpj, dt_contratacao, ds_email, ds_endereco, nm_empresa, nr_telefone)
    VALUES (5, '33333333300004', TO_DATE('2023-01-05', 'YYYY-MM-DD'), 'Carrefour.com', 'Rua Antonio Domingues de Carvalho, 345', 'Carrefour', '5556667781');

  
    INSERT INTO pessoa_fisica (id_pessoa_fisica, nr_cpf, dt_contratacao, dt_nascimento, ds_email, ds_endereco, ds_estado_civil, nr_filhos, nm_pessoa, ds_renda, ds_renda_per_capita, sexo, nr_telefone)
    VALUES (1, '12345678901', TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('1980-05-10', 'YYYY-MM-DD'), 'MargotdosSantos.com', 'Av imirim, 456', 'Solteiro', 0, 'Margot', 5000.00, 5000.00, 'M', '9998887777');
    INSERT INTO pessoa_fisica (id_pessoa_fisica, nr_cpf, dt_contratacao, dt_nascimento, ds_email, ds_endereco, ds_estado_civil, nr_filhos, nm_pessoa, ds_renda, ds_renda_per_capita, sexo, nr_telefone)
    VALUES (2, '98765432109', TO_DATE('2020-02-15', 'YYYY-MM-DD'), TO_DATE('1995-09-20', 'YYYY-MM-DD'), 'MaleniadaSilva@gmail.com', 'Rua São Domingos, 789', 'Casado', 2, 'Malenia Da Silva', 7000.00, 3500.00, 'F', '9998887778');
    INSERT INTO pessoa_fisica (id_pessoa_fisica, nr_cpf, dt_contratacao, dt_nascimento, ds_email, ds_endereco, ds_estado_civil, nr_filhos, nm_pessoa, ds_renda, ds_renda_per_capita, sexo, nr_telefone)
    VALUES (3, '11122233344', TO_DATE('2022-04-10', 'YYYY-MM-DD'), TO_DATE('1990-08-25', 'YYYY-MM-DD'), 'MariaCarla@hotmail.com', 'Rua Ramal Dos Meneses, 123', 'Casado', 1, 'Maria Carla', 6000.00, 6000.00, 'F', '9998887779');
    INSERT INTO pessoa_fisica (id_pessoa_fisica, nr_cpf, dt_contratacao, dt_nascimento, ds_email, ds_endereco, ds_estado_civil, nr_filhos, nm_pessoa, ds_renda, ds_renda_per_capita, sexo, nr_telefone)
    VALUES (4, '44455566677', TO_DATE('2021-02-20', 'YYYY-MM-DD'), TO_DATE('1985-11-12', 'YYYY-MM-DD'), 'EduardoAdolfo@hotmail.com', 'Avenida Paulista, 456', 'Solteiro', 0, 'Eduardo Adolfo', 4500.00, 4500.00, 'M', '9998887780');
    INSERT INTO pessoa_fisica (id_pessoa_fisica, nr_cpf, dt_contratacao, dt_nascimento, ds_email, ds_endereco, ds_estado_civil, nr_filhos, nm_pessoa, ds_renda, ds_renda_per_capita, sexo, nr_telefone)
    VALUES (5, '77788899900', TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('1992-06-05', 'YYYY-MM-DD'), 'RobertoSoares@gmail.com', 'Rua Augusta, 789', 'Solteiro', 0, 'Roberto Soares', 5500.00, 5500.00, 'M', '9998887781');

    INSERT INTO socket (id_socket, id_pessoa_juridica, id_pessoa_fisica, skt_dt_colheita, skt_dt_plantio, skt_temperatura, skt_peso, umidade_ar)
    VALUES (1, 1, 1, TO_DATE('2023-05-01', 'YYYY-MM-DD'), TO_DATE('2023-04-01', 'YYYY-MM-DD'), 28.5, 1.2, 65);
    INSERT INTO socket (id_socket, id_pessoa_juridica, id_pessoa_fisica, skt_dt_colheita, skt_dt_plantio, skt_temperatura, skt_peso, umidade_ar)
    VALUES (2, 2, 2, TO_DATE('2023-06-01', 'YYYY-MM-DD'), TO_DATE('2023-05-01', 'YYYY-MM-DD'), 26.8, 1.5, 60);
    INSERT INTO socket (id_socket, id_pessoa_juridica, id_pessoa_fisica, skt_dt_colheita, skt_dt_plantio, skt_temperatura, skt_peso, umidade_ar)
    VALUES (3, 3, 3, TO_DATE('2023-05-01', 'YYYY-MM-DD'), TO_DATE('2023-01-01', 'YYYY-MM-DD'), 28.5, 1.2, 60);
    INSERT INTO socket (id_socket, id_pessoa_juridica, id_pessoa_fisica, skt_dt_colheita, skt_dt_plantio, skt_temperatura, skt_peso, umidade_ar)
    VALUES (4, 4, 4, TO_DATE('2023-05-15', 'YYYY-MM-DD'), TO_DATE('2023-02-01', 'YYYY-MM-DD'), 27.8, 1.5, 62);
    INSERT INTO socket (id_socket, id_pessoa_juridica, id_pessoa_fisica, skt_dt_colheita, skt_dt_plantio, skt_temperatura, skt_peso, umidade_ar)
    VALUES (5, 5, 5, TO_DATE('2023-06-01', 'YYYY-MM-DD'), TO_DATE('2023-03-01', 'YYYY-MM-DD'), 29.0, 1.0, 58);

    INSERT INTO rig_linha (id_linha, id_pessoa_juridica, id_socket, qt_fluxo_agua, qt_ligado, qt_ec, qt_ph, qt_ppm, qt_fosforo, qt_magnesio, qt_nitrogenio, qt_potassio, qt_zinco, nr_plantas_rig)
    VALUES (1, 1, 1, 15.2, 5.7, 0.8, 6.5, 300, 2.5, 1.3, 1.6, 0.9, 0.5, 100);
    INSERT INTO rig_linha (id_linha, id_pessoa_juridica, id_socket, qt_fluxo_agua, qt_ligado, qt_ec, qt_ph, qt_ppm, qt_fosforo, qt_magnesio, qt_nitrogenio, qt_potassio, qt_zinco, nr_plantas_rig)
    VALUES (2, 2, 2, 12.8, 4.3, 0.6, 6.8, 250, 2.2, 1.1, 1.4, 0.8, 0.4, 80);
    INSERT INTO rig_linha (id_linha, id_pessoa_juridica, id_socket, qt_fluxo_agua, qt_ligado, qt_ec, qt_ph, qt_ppm, qt_fosforo, qt_magnesio, qt_nitrogenio, qt_potassio, qt_zinco, nr_plantas_rig)
    VALUES (3, 3, 3, 10.3, 3.9, 0.5, 6.2, 200, 2.0, 1.0, 1.2, 0.7, 0.3, 70);
    INSERT INTO rig_linha (id_linha, id_pessoa_juridica, id_socket, qt_fluxo_agua, qt_ligado, qt_ec, qt_ph, qt_ppm, qt_fosforo, qt_magnesio, qt_nitrogenio, qt_potassio, qt_zinco, nr_plantas_rig)
    VALUES (4, 4, 4, 14.7, 5.1, 0.7, 6.7, 280, 2.3, 1.2, 1.5, 0.8, 0.4, 90);
    INSERT INTO rig_linha (id_linha, id_pessoa_juridica, id_socket, qt_fluxo_agua, qt_ligado, qt_ec, qt_ph, qt_ppm, qt_fosforo, qt_magnesio, qt_nitrogenio, qt_potassio, qt_zinco, nr_plantas_rig)
    VALUES (5, 5, 5, 11.9, 4.7, 0.6, 6.4, 230, 2.1, 1.1, 1.3, 0.6, 0.2, 80);


    INSERT INTO fruto (id_fruto, id_pessoa_juridica, id_linha, id_socket, nm_fenotipo, nm_fruto, qt_carboitrato, qt_monoinsaturada, qt_poliisaturada, qt_saturada, qt_kcal, qt_porcao, qt_proteina, tp_fruto)
    VALUES (1, 1, 1, 1, 'Recessivo', 'Maça', 10.5, 2.3, 1.8, 0.9, 150.0, 100.0, 5.0, 'Tipo A');
    INSERT INTO fruto (id_fruto, id_pessoa_juridica, id_linha, id_socket, nm_fenotipo, nm_fruto, qt_carboitrato, qt_monoinsaturada, qt_poliisaturada, qt_saturada, qt_kcal, qt_porcao, qt_proteina, tp_fruto)
    VALUES (2, 2, 2, 2, 'Dominante', 'Pera', 12.3, 2.1, 1.5, 0.8, 140.0, 90.0, 4.5, 'Tipo B');
    INSERT INTO fruto (id_fruto, id_pessoa_juridica, id_linha, id_socket, nm_fenotipo, nm_fruto, qt_carboitrato, qt_monoinsaturada, qt_poliisaturada, qt_saturada, qt_kcal, qt_porcao, qt_proteina, tp_fruto)
    VALUES (3, 3, 3, 3, 'Recessivo', 'Tomate', 9.7, 1.9, 1.2, 0.7, 120.0, 80.0, 4.0, 'Tipo C');
    INSERT INTO fruto (id_fruto, id_pessoa_juridica, id_linha, id_socket, nm_fenotipo, nm_fruto, qt_carboitrato, qt_monoinsaturada, qt_poliisaturada, qt_saturada, qt_kcal, qt_porcao, qt_proteina, tp_fruto)
    VALUES (4, 4, 4, 4, 'Dominante', 'Abacaxi', 11.5, 1.8, 1.3, 0.8, 135.0, 90.0, 4.5, 'Tipo D');
    INSERT INTO fruto (id_fruto, id_pessoa_juridica, id_linha, id_socket, nm_fenotipo, nm_fruto, qt_carboitrato, qt_monoinsaturada, qt_poliisaturada, qt_saturada, qt_kcal, qt_porcao, qt_proteina, tp_fruto)
    VALUES (5, 5, 5, 5, 'Recessivo', 'Limão', 10.2, 1.7, 1.1, 0.6, 110.0, 70.0, 4.2, 'Tipo B');

  COMMIT;
EXCEPTION
  WHEN ex_unique_constraint THEN
    v_code := SQLCODE;
    v_errm := SUBSTR(SQLERRM, 1, 64);
    INSERT INTO log_error (usuario, data_ocorrencia, codigo_erro, msg_erro) 
    VALUES (USER, SYSDATE, v_code, 'ex_unique_constraint: constraint unique violada');
  
  WHEN ex_value_too_large THEN
    v_code := SQLCODE;
    v_errm := SUBSTR(SQLERRM, 1, 64);
    INSERT INTO log_error (usuario, data_ocorrencia, codigo_erro, msg_erro) 
    VALUES (USER, SYSDATE, v_code, 'ex_value_too_large: valor excede o tamanho da coluna');
  
  WHEN OTHERS THEN
    v_code := SQLCODE;
    v_errm := SUBSTR(SQLERRM, 1, 64);
    INSERT INTO log_error (usuario, data_ocorrencia, codigo_erro, msg_erro) 
    VALUES (USER, SYSDATE, v_code, v_errm);
END pr_carga_inicial;
------------------------------------------------------------------------------------------
EXEC pr_carga_inicial;
------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE pr_busc_pessoa_fisica (p_id_pessoa_fisica IN pessoa_fisica.id_pessoa_fisica%TYPE) AS
  cursor c_pessoa_fisica is
    SELECT *
    FROM pessoa_fisica
    WHERE id_pessoa_fisica = p_id_pessoa_fisica;

  v_pessoa_fisica c_pessoa_fisica%ROWTYPE;
BEGIN
  open c_pessoa_fisica;

  loop
    fetch c_pessoa_fisica into v_pessoa_fisica;
    exit when c_pessoa_fisica%NOTFOUND;

    dbms_output.put_line('ID Pessoa Fisica: ' || v_pessoa_fisica.id_pessoa_fisica);
    dbms_output.put_line('Nome: ' || v_pessoa_fisica.nm_pessoa);
    dbms_output.put_line('Cpf: ' || v_pessoa_fisica.nr_cpf);
    
  end loop;

  close c_pessoa_fisica;
END pr_busc_pessoa_fisica;
/
EXEC pr_busc_pessoa_fisica(1);
EXEC pr_busc_pessoa_fisica(2);
EXEC pr_busc_pessoa_fisica(3);
EXEC pr_busc_pessoa_fisica(4);
EXEC pr_busc_pessoa_fisica(5);

-----------------------------------
CREATE OR REPLACE PROCEDURE pr_busc_pessoa_juridica (p_id_pessoa_juridica IN pessoa_juridica.id_pessoa_juridica%TYPE) AS
  cursor c_pessoa_juridica is
    SELECT *
    FROM pessoa_juridica
    WHERE id_pessoa_juridica = p_id_pessoa_juridica;

  v_pessoa_juridica c_pessoa_juridica%ROWTYPE;
BEGIN
  open c_pessoa_juridica;

  loop
    fetch c_pessoa_juridica into v_pessoa_juridica;
    exit when c_pessoa_juridica%NOTFOUND;

    dbms_output.put_line('ID Resposta: ' || v_pessoa_juridica.id_pessoa_juridica);
    dbms_output.put_line('Cnjp: ' || v_pessoa_juridica.nr_cnpj);
    dbms_output.put_line('Contratação: ' || v_pessoa_juridica.dt_contratacao);
  end loop;

  close c_pessoa_juridica;
END pr_busc_pessoa_juridica;
/

EXEC pr_busc_pessoa_juridica(1);
EXEC pr_busc_pessoa_juridica(2);
EXEC pr_busc_pessoa_juridica(3);
EXEC pr_busc_pessoa_juridica(4);
EXEC pr_busc_pessoa_juridica(5);

