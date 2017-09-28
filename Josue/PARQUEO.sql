--CREACION DE BASE DE DATOS Y EL USUARIO

CREATE TABLESPACE PARQUEO_DAT
    DATAFILE 'C:\Users\Josue\Documents\Sistema Llobet\PARQUEO_DAT.DBF'
    SIZE 100M ONLINE;

CREATE TEMPORARY TABLESPACE PARQUEO_TEMP
    TEMPFILE 'C:\Users\Josue\Documents\Sistema Llobet\PARQUEO_TEMP.DBF'
    SIZE 3M AUTOEXTEND ON;
    
CREATE USER PARQUEO IDENTIFIED BY 010595
    DEFAULT TABLESPACE PARQUEO_DAT
    TEMPORARY TABLESPACE PARQUEO_TEMP;
    
--ACCESOS

GRANT RESOURCE TO PARQUEO;
GRANT CONNECT TO PARQUEO;
GRANT ALL PRIVILEGES TO PARQUEO;

--TABLAS

CREATE TABLE PARQUEO.PARAMETROS(
    ID_PARAMETRO        VARCHAR2(10) NOT NULL PRIMARY KEY,
    MONTO_CARRO         NUMBER,
    MONTO_MOTO          NUMBER,
    NOMBRE_PARQUEO      VARCHAR2(100),
    MENSAJE_OPCIONAL    VARCHAR2(100));
    
CREATE TABLE PARQUEO.EMPRESA(
    ID_EMPRESA      NUMBER NOT NULL PRIMARY KEY,
    NOMBRE_EMPRESA  VARCHAR2(45),
    CEDULA_JURIDICA VARCHAR2(45),
    TELEFONO        VARCHAR2(12));

CREATE TABLE PARQUEO.AUTORIZADOS(
    ID_AUTORIZADO       NUMBER NOT NULL PRIMARY KEY,
    NOMB_AUTORIZADO     VARCHAR2(45),
    APELL_AUTORIZADO    VARCHAR2(45),
    TELEFONO            VARCHAR2(12),
    TIPO_CLIENTE        NUMBER,
    ESTADO              NUMBER);
    
CREATE TABLE PARQUEO.PLACAS(
    ID_PLACA        VARCHAR2(7) NOT NULL PRIMARY KEY,
    ID_AUTORIZADO   NUMBER,
    CUOTA           NUMBER,
    MED_TRANSPORTE  NUMBER,
    ESTADO          NUMBER);
    
CREATE TABLE PARQUEO.TIPOS_CLIENTES(
    ID_CLIENTE   NUMBER NOT NULL PRIMARY KEY,
    TIPO_CLIENTE VARCHAR(10));
    
CREATE TABLE PARQUEO.TIPOS_MEDIOS_TRANSPORTE(
    ID_MEDIO    NUMBER NOT NULL PRIMARY KEY,
    TIPO_MEDIO  VARCHAR2(50),
    COBRO       NUMBER);
    
CREATE TABLE PARQUEO.LUGARES(
    ID_LUGAR            VARCHAR2(3) NOT NULL PRIMARY KEY,
    TIPO_MEDIO_LUGAR    NUMBER NOT NULL,
    ESTADO              NUMBER);
    
CREATE TABLE PARQUEO.USUARIOS(
    ID_USUARIO      NUMBER NOT NULL PRIMARY KEY,
    NOMBRE_USUARIO  VARCHAR2(45) UNIQUE,
    CLAVE           VARCHAR2(45),
    ESTADO          NUMBER DEFAULT 1);
    
CREATE TABLE PARQUEO.REPORTES(
    ID_REPORTE  NUMBER NOT NULL PRIMARY KEY,
    CAJA        NUMBER);
    
CREATE TABLE PARQUEO.MEDIOS_ACTUALES(
    ID_ACTUAL       NUMBER NOT NULL PRIMARY KEY,
    NUMERO_PLACA    VARCHAR2(7) NOT NULL,
    ENTRADA         NUMBER NOT NULL,
    FECHA_HORA_ENT  VARCHAR2(20),
    TIPO_TRANSPORTE NUMBER(3),
    TIPO_CLIENTE    VARCHAR2(10),
    LUGAR           VARCHAR2(3));
    
CREATE TABLE PARQUEO.CAJAS(
    ID_CAJA         NUMBER NOT NULL PRIMARY KEY,
    FECHA_ABRE      DATE,
    HORA_ABRE       VARCHAR2(20),
    FECHA_CIERRA    DATE,
    HORA_CIERRA     VARCHAR2(20),
    MONTO_TOTAL     NUMBER,
    MEDIOS_ACT      NUMBER,
    USUARIO         NUMBER);
    
CREATE TABLE PARQUEO.TIQUETE_ENTRADA(
    ID_ENTRADA      NUMBER NOT NULL PRIMARY KEY,
    FECHA_HORA      VARCHAR2(50),
    NUM_PLACA       VARCHAR2(10),
    LUGAR           VARCHAR2(2),
    TARIFA          NUMBER);
    
CREATE TABLE PARQUEO.TIQUETE_SALIDA(
    ID_SALIDA       NUMBER NOT NULL PRIMARY KEY,
    NUM_PLACA       VARCHAR2(10),
    FECHA_HORA_ENT  VARCHAR2(20),
    FECHA_HORA_SAL  DATE,
    TIEMPO_EFECTIVO VARCHAR2(20),
    MONTO_COBRADO   NUMBER,
    LUGAR           VARCHAR(2),
    TARIFA          NUMBER);
    
COMMIT;

--BORRAR TODAS LAS TABLAS

DROP TABLE PARQUEO.AUTORIZADOS;
DROP TABLE PARQUEO.CAJAS;
DROP TABLE PARQUEO.LUGARES;
DROP TABLE PARQUEO.MEDIOS_ACTUALES;
DROP TABLE PARQUEO.REPORTES;
DROP TABLE PARQUEO.TIPOS_CLIENTES;
DROP TABLE PARQUEO.TIPOS_MEDIOS_TRANSPORTE;
DROP TABLE PARQUEO.TIPOS_USUARIO;
DROP TABLE PARQUEO.TIQUETE_ENTRADA;
DROP TABLE PARQUEO.TIQUETE_SALIDA;
DROP TABLE PARQUEO.USUARIOS;

--MODIFICACIONES

INSERT INTO PARQUEO.TIPOS_CLIENTES (ID_CLIENTE, TIPO_CLIENTE) VALUES (1, 'GENERICO');
INSERT INTO PARQUEO.TIPOS_CLIENTES (ID_CLIENTE, TIPO_CLIENTE) VALUES (2, 'AUTORIZADO');
INSERT INTO PARQUEO.AUTORIZADOS (NOMB_AUTORIZADO, TIPO_CLIENTE, ESTADO) VALUES ('GENERICO', 1, 1);
ALTER TABLE PARQUEO.LUGARES ADD CONSTRAINT FK_TIPO_MEDIO_LUGAR FOREIGN KEY (TIPO_MEDIO_LUGAR) REFERENCES PARQUEO.TIPOS_MEDIOS_TRANSPORTE(ID_MEDIO);
ALTER TABLE PARQUEO.AUTORIZADOS ADD CONSTRAINT FK_CLIENTE_ID FOREIGN KEY (TIPO_CLIENTE) REFERENCES PARQUEO.TIPOS_CLIENTES(ID_CLIENTE);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, ESTADO) VALUES(0, 1);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, ESTADO) VALUES(1, 0);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, ESTADO) VALUES(2, 2);
INSERT INTO PARQUEO.TIPOSMEDIOSTRANSPORTE(ID_MEDIO, TIPO_MEDIO, COBRO) VALUES(0, 'Carro', 600);
UPDATE PARQUEO.LUGARES SET ESTADO = 1 WHERE ID_LUGAR = 1;
UPDATE PARQUEO.LUGARES SET ESTADO = 0 WHERE ID_LUGAR = 1;
INSERT INTO PARQUEO.PARAMETROS (ID_PARAMETRO, MONTO_CARRO, MONTO_MOTO, NOMBRE_PARQUEO, MENSAJE_OPCIONAL) VALUES ('1', 700, 350, 'La Rambla', 'Nuevo sistema de parqueo');
COMMIT;

--CONSULTAS

TRUNCATE TABLE PARQUE.TIPOSMEDIOSTRANSPORTE;
SELECT * FROM PARQUEO.TIPOS_MEDIOS_TRANSPORTE;
SELECT * FROM PARQUEO.AUTORIZADOS;
SELECT * FROM PARQUEO.TIQUETE_ENTRADA;
SELECT * FROM PARQUEO.MEDIOS_ACTUALES;
SELECT * FROM PARQUEO.AUTORIZADOS;
SELECT * FROM PARQUEO.PLACAS;
SELECT * FROM PARQUEO.LUGARES;
SELECT * FROM PARQUEO.USUARIOS;
SELECT ID_PLACA, NOMB_AUTORIZADO, APELL_AUTORIZADO FROM PARQUEO.AUTORIZADOS,
(SELECT ID_PLACA FROM PARQUEO.PLACAS WHERE ESTADO != 2
MINUS SELECT NUMERO_PLACA FROM PARQUEO.MEDIOS_ACTUALES);
TRUNCATE TABLE PARQUEO.LUGARES;
TRUNCATE TABLE PARQUEO.USUARIOS;

--TRIGGERS Y SEQUENCIAS

CREATE SEQUENCE SEQ_AUT
START WITH 1
INCREMENT BY 1;

CREATE TRIGGER TRIG_AUTORIZADOS
BEFORE INSERT ON AUTORIZADOS
FOR EACH ROW
BEGIN SELECT SEQ_AUT.NEXTVAL INTO :NEW.ID_AUTORIZADO FROM DUAL;
END;

CREATE SEQUENCE SEQ_ENTRADA
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_MED_ACT
START WITH 1
INCREMENT BY 1;

CREATE TRIGGER TRIG_MED_ACT
BEFORE INSERT ON MEDIOS_ACTUALES
FOR EACH ROW
BEGIN SELECT SEQ_MED_ACT.NEXTVAL INTO :NEW.ID_ACTUAL FROM DUAL;
END;

CREATE SEQUENCE SEQ_USUARIOS
START WITH 1
INCREMENT BY 1;

CREATE TRIGGER TRIG_USUARIOS
BEFORE INSERT ON USUARIOS
FOR EACH ROW
BEGIN SELECT SEQ_USUARIOS.NEXTVAL INTO :NEW.ID_USUARIO FROM DUAL;
END;

--PROCESOS

DECLARE PROCEDURE AGREGAR_AUTORIZADO(P_NOMB_AUTORIZADO VARCHAR2, P_APELL_AUTORIZADO VARCHAR2, P_TELEFONO VARCHAR2, P_TIPO_CLIENTE NUMBER, P_ESTADO NUMBER)
IS
BEGIN
    INSERT INTO PARQUEO.AUTORIZADO(NOMB_AUTORIZADO, APELL_AUTORIZADO, TELEFONO, TIPO_CLIENTE, ESTADO)
    VALUES (P_NOMB_AUTORIZADO, P_APELL_AUTORIZADO, P_TELEFONO, P_TIPO_CLIENTE, P_ESTADO);
END;