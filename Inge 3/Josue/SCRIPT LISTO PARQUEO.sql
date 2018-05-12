--CREACION DE BASE DE DATOS Y EL USUARIO

CREATE TABLESPACE PARQUEO_DAT
    DATAFILE 'C:\Parqueo\PARQUEO_DAT.DBF'
    SIZE 100M ONLINE;

CREATE TEMPORARY TABLESPACE PARQUEO_TEMP
    TEMPFILE 'C:\Parqueo\PARQUEO_TEMP.DBF'
    SIZE 25M AUTOEXTEND ON;
    
--CREACION DE USUARIO Y CONTRASE�A PARA LA BASE DE DATOS
    
CREATE USER PARQUEO IDENTIFIED BY PARQUEO_LLOBET
    DEFAULT TABLESPACE PARQUEO_DAT
    TEMPORARY TABLESPACE PARQUEO_TEMP;
    
--ACCESOS

GRANT RESOURCE TO PARQUEO;
GRANT CONNECT TO PARQUEO;
GRANT ALL PRIVILEGES TO PARQUEO;

CREATE TABLE PARQUEO.PARAMETROS(
    ID_PARAMETRO        VARCHAR2(10) NOT NULL PRIMARY KEY,
    MENSAJE_OPCIONAL    VARCHAR2(100),
    MENSAJE_HORARIO     VARCHAR(100),
    USUARIO_ON          NUMBER,
    NUM_ENTRADA         NUMBER,
    NUM_PLACA           VARCHAR2(7),
    TIEMPO_GRACIA       NUMBER(2),
    CAJA_ACTUAL         NUMBER,
    IMPUESTO            FLOAT);
    
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
    
    /*
    1-ADMINISTRADOR
    2-AUDITOR
    3-OPERADOR
    */
CREATE TABLE PARQUEO.USUARIOS(
    ID_USUARIO      NUMBER NOT NULL PRIMARY KEY,
    NOMBRE_USUARIO  VARCHAR2(45) UNIQUE,
    CLAVE           VARCHAR2(45),
    TIPO_USUARIO    NUMBER,
    ESTADO          NUMBER DEFAULT 1);
    
CREATE TABLE PARQUEO.REPORTES(
    ID_REPORTE  NUMBER NOT NULL PRIMARY KEY,
    CAJA        NUMBER);
    
CREATE TABLE PARQUEO.MEDIOS_ACTUALES(
    ID_ACTUAL       NUMBER NOT NULL PRIMARY KEY,
    NUMERO_PLACA    VARCHAR2(7) NOT NULL,
    ENTRADA         NUMBER NOT NULL,
    FECHA_HORA_ENT  VARCHAR2(30),
    TIPO_TRANSPORTE NUMBER,
    TIPO_CLIENTE    NUMBER,
    LUGAR           VARCHAR2(3));
        
CREATE TABLE PARQUEO.CAJAS(
    ID_CAJA         NUMBER NOT NULL PRIMARY KEY,
    FECHA_HORA_ABRE VARCHAR2(30),
    FECHA_HORA_CIER VARCHAR2(30),
    MONTO_TOTAL     NUMBER,
    USUARIO         NUMBER);
        
CREATE TABLE PARQUEO.TIQUETE_ENTRADA(
    ID_ENTRADA      NUMBER NOT NULL PRIMARY KEY,
    FECHA_HORA      VARCHAR2(30),
    NUM_PLACA       VARCHAR2(7),
    LUGAR           VARCHAR2(3),
    TARIFA          NUMBER);
        
CREATE TABLE PARQUEO.TIQUETE_SALIDA(
    ID_SALIDA       NUMBER NOT NULL PRIMARY KEY,
    ID_ENTRADA      NUMBER,
	ID_USUARIO		NUMBER,
    ID_CAJA         NUMBER,
    NUM_PLACA       VARCHAR2(7),
    FECHA_HORA_ENT  VARCHAR2(30),
    FECHA_HORA_SAL  VARCHAR2(30),
    TIEMPO_EFECTIVO VARCHAR2(50),
    DIAS            NUMBER,
    HORAS           NUMBER,
    MINUTOS         NUMBER,
    MONTO_COBRADO   NUMBER,
    LUGAR           VARCHAR(3),
    TARIFA          NUMBER);
    
--LAVES FORANEAS
        
ALTER TABLE PARQUEO.PLACAS ADD CONSTRAINT FK_ID_AUTORIZADO FOREIGN KEY (ID_AUTORIZADO) REFERENCES PARQUEO.AUTORIZADOS(ID_AUTORIZADO);

ALTER TABLE PARQUEO.AUTORIZADOS ADD CONSTRAINT FK_TIPO_CLIENTE FOREIGN KEY (TIPO_CLIENTE) REFERENCES PARQUEO.TIPOS_CLIENTES(ID_CLIENTE);
    
ALTER TABLE PARQUEO.LUGARES ADD CONSTRAINT FK_MED_TRANSPORTE FOREIGN KEY (TIPO_MEDIO_LUGAR) REFERENCES PARQUEO.TIPOS_MEDIOS_TRANSPORTE(ID_MEDIO);

ALTER TABLE PARQUEO.MEDIOS_ACTUALES ADD CONSTRAINT FK_ID_ENTRADA FOREIGN KEY (ENTRADA) REFERENCES PARQUEO.TIQUETE_ENTRADA(ID_ENTRADA);
ALTER TABLE PARQUEO.MEDIOS_ACTUALES ADD CONSTRAINT FK_TIPO_TRANSPORTE FOREIGN KEY (TIPO_TRANSPORTE) REFERENCES PARQUEO.TIPOS_MEDIOS_TRANSPORTE(ID_MEDIO);
ALTER TABLE PARQUEO.MEDIOS_ACTUALES ADD CONSTRAINT FK_TIPO_CLIENT FOREIGN KEY (TIPO_CLIENTE) REFERENCES PARQUEO.TIPOS_CLIENTES(ID_CLIENTE);
ALTER TABLE PARQUEO.MEDIOS_ACTUALES ADD CONSTRAINT FK_LUGAR FOREIGN KEY (LUGAR) REFERENCES PARQUEO.LUGARES(ID_LUGAR);

ALTER TABLE PARQUEO.CAJAS ADD CONSTRAINT FK_USUARIO FOREIGN KEY (USUARIO) REFERENCES PARQUEO.USUARIOS(ID_USUARIO);

ALTER TABLE PARQUEO.TIQUETE_ENTRADA ADD CONSTRAINT FK_CAMPO_LUGAR FOREIGN KEY (LUGAR) REFERENCES PARQUEO.LUGARES(ID_LUGAR);

ALTER TABLE PARQUEO.TIQUETE_SALIDA ADD CONSTRAINT FK_ENTRADA FOREIGN KEY (ID_ENTRADA) REFERENCES PARQUEO.TIQUETE_ENTRADA(ID_ENTRADA);
ALTER TABLE PARQUEO.TIQUETE_SALIDA ADD CONSTRAINT FK_CAMP_LUGAR FOREIGN KEY (LUGAR) REFERENCES PARQUEO.LUGARES(ID_LUGAR);
ALTER TABLE PARQUEO.TIQUETE_SALIDA ADD CONSTRAINT FK_ID_USUARIO FOREIGN KEY (ID_USUARIO) REFERENCES PARQUEO.USUARIOS(ID_USUARIO);

--TRIGGERS Y SEQUENCIAS

CREATE SEQUENCE PARQUEO.SEQ_AUT
START WITH 1
INCREMENT BY 1;

CREATE TRIGGER PARQUEO.TRIG_AUTORIZADOS
BEFORE INSERT ON PARQUEO.AUTORIZADOS
FOR EACH ROW
BEGIN SELECT PARQUEO.SEQ_AUT.NEXTVAL INTO :NEW.ID_AUTORIZADO FROM DUAL;
END;

CREATE SEQUENCE PARQUEO.SEQ_ENTRADA
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE PARQUEO.SEQ_SALIDA
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE PARQUEO.SEQ_MED_ACT
START WITH 1
INCREMENT BY 1;

CREATE TRIGGER PARQUEO.TRIG_MED_ACT
BEFORE INSERT ON PARQUEO.MEDIOS_ACTUALES
FOR EACH ROW
BEGIN SELECT PARQUEO.SEQ_MED_ACT.NEXTVAL INTO :NEW.ID_ACTUAL FROM DUAL;
END;

CREATE SEQUENCE PARQUEO.SEQ_USUARIOS
START WITH 1
INCREMENT BY 1;

CREATE TRIGGER PARQUEO.TRIG_USUARIOS
BEFORE INSERT ON PARQUEO.USUARIOS
FOR EACH ROW
BEGIN SELECT PARQUEO.SEQ_USUARIOS.NEXTVAL INTO :NEW.ID_USUARIO FROM DUAL;
END;

CREATE SEQUENCE PARQUEO.SEQ_TIPOS_MEDIOS_TRANSPORTE
START WITH 1
INCREMENT BY 1;

CREATE TRIGGER PARQUEO.TRIG_TIPOS_MEDIOS_TRANSPORTE
BEFORE INSERT ON PARQUEO.TIPOS_MEDIOS_TRANSPORTE
FOR EACH ROW
BEGIN SELECT PARQUEO.SEQ_TIPOS_MEDIOS_TRANSPORTE.NEXTVAL INTO :NEW.ID_MEDIO FROM DUAL;
END;

CREATE SEQUENCE PARQUEO.SEQ_CAJAS
START WITH 1
INCREMENT BY 1;

--INSERCIONES NECESARIAS

INSERT INTO PARQUEO.PARAMETROS (ID_PARAMETRO, MENSAJE_OPCIONAL, MENSAJE_HORARIO, IMPUESTO) VALUES ('1', 'Nuevo sistema de parqueo', 'L-V 8 AM-7PM S-D 8AM-5PM', 0);

INSERT INTO PARQUEO.EMPRESA(ID_EMPRESA, NOMBRE_EMPRESA, CEDULA_JURIDICA, TELEFONO) VALUES (1, '', '', '');

INSERT INTO PARQUEO.TIPOS_CLIENTES (ID_CLIENTE, TIPO_CLIENTE) VALUES (1, 'COMUN');
INSERT INTO PARQUEO.TIPOS_CLIENTES (ID_CLIENTE, TIPO_CLIENTE) VALUES (2, 'AUTORIZADO');

INSERT INTO PARQUEO.TIPOS_MEDIOS_TRANSPORTE (ID_MEDIO, TIPO_MEDIO, COBRO) VALUES (1, 'CARRO', 900);
INSERT INTO PARQUEO.TIPOS_MEDIOS_TRANSPORTE (ID_MEDIO, TIPO_MEDIO, COBRO) VALUES (2, 'MOTO', 800);

--INSERCIONES DE LOS AUTORIZADOS
--MANTENER EL AUTORIZADO COM�N

INSERT INTO PARQUEO.AUTORIZADOS (NOMB_AUTORIZADO, TIPO_CLIENTE, ESTADO)
VALUES ('COMUN', 1, 1);
INSERT INTO PARQUEO.AUTORIZADOS (NOMB_AUTORIZADO, APELL_AUTORIZADO, TELEFONO, TIPO_CLIENTE, ESTADO) 
VALUES ('JOSUE', 'CASTRO', '122345', 2, 1);
INSERT INTO PARQUEO.AUTORIZADOS (NOMB_AUTORIZADO, APELL_AUTORIZADO, TELEFONO, TIPO_CLIENTE, ESTADO) 
VALUES ('ANDRES', 'BARRANTES', '122345', 2, 1);
INSERT INTO PARQUEO.AUTORIZADOS (NOMB_AUTORIZADO, APELL_AUTORIZADO, TELEFONO, TIPO_CLIENTE, ESTADO) 
VALUES ('JOSE', 'BARRANTES', '122345', 2, 1);
INSERT INTO PARQUEO.AUTORIZADOS (NOMB_AUTORIZADO, APELL_AUTORIZADO, TELEFONO, TIPO_CLIENTE, ESTADO) 
VALUES ('GREIVIN', 'BARRANTES', '122345', 2, 1);
INSERT INTO PARQUEO.AUTORIZADOS (NOMB_AUTORIZADO, APELL_AUTORIZADO, TELEFONO, TIPO_CLIENTE, ESTADO) 
VALUES ('ALEX', 'BALTODANO', '122345', 2, 1);

--INSERCIONES DE PLACAS AUTORIZADAS
--SE TUVO QUE AGREGAR AUTORIZADOS PARA PODER AGREGAR PLACAS AUTORIZADAS

INSERT INTO PARQUEO.PLACAS (ID_PLACA, ID_AUTORIZADO, CUOTA, MED_TRANSPORTE, ESTADO) VALUES ('TY1234', 2, 800, 2, 1);
INSERT INTO PARQUEO.PLACAS (ID_PLACA, ID_AUTORIZADO, CUOTA, MED_TRANSPORTE, ESTADO) VALUES ('TY1456', 3, 900, 1, 1);
INSERT INTO PARQUEO.PLACAS (ID_PLACA, ID_AUTORIZADO, CUOTA, MED_TRANSPORTE, ESTADO) VALUES ('RK1906', 4, 900, 1, 1);
INSERT INTO PARQUEO.PLACAS (ID_PLACA, ID_AUTORIZADO, CUOTA, MED_TRANSPORTE, ESTADO) VALUES ('YU0976', 5, 900, 1, 1);
INSERT INTO PARQUEO.PLACAS (ID_PLACA, ID_AUTORIZADO, CUOTA, MED_TRANSPORTE, ESTADO) VALUES ('OL7672', 6, 900, 1, 1);

--INSERCIONES DE LOS LUGARES

INSERT INTO PARQUEO.LUGARES(ID_LUGAR, TIPO_MEDIO_LUGAR, ESTADO) VALUES('M1', 2, 1);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, TIPO_MEDIO_LUGAR, ESTADO) VALUES('M2', 2, 1);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, TIPO_MEDIO_LUGAR, ESTADO) VALUES('C1', 1, 1);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, TIPO_MEDIO_LUGAR, ESTADO) VALUES('C2', 1, 1);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, TIPO_MEDIO_LUGAR, ESTADO) VALUES('C3', 1, 1);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, TIPO_MEDIO_LUGAR, ESTADO) VALUES('C4', 1, 1);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, TIPO_MEDIO_LUGAR, ESTADO) VALUES('C5', 1, 1);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, TIPO_MEDIO_LUGAR, ESTADO) VALUES('C6', 1, 1);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, TIPO_MEDIO_LUGAR, ESTADO) VALUES('C7', 1, 1);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, TIPO_MEDIO_LUGAR, ESTADO) VALUES('C8', 1, 1);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, TIPO_MEDIO_LUGAR, ESTADO) VALUES('C9', 1, 1);
INSERT INTO PARQUEO.LUGARES(ID_LUGAR, TIPO_MEDIO_LUGAR, ESTADO) VALUES('C10', 1, 1);

--PROCESOS ALMACENADOS NECESARIOS

--LOGEO DEL USUARIO QUE INICIA SESION

CREATE OR REPLACE PROCEDURE PARQUEO.LOGEAR (USUARIO_ID NUMBER, CAJA_ACT NUMBER) IS
BEGIN
    UPDATE PARQUEO.PARAMETROS SET USUARIO_ON = USUARIO_ID;
    UPDATE PARQUEO.PARAMETROS SET CAJA_ACTUAL = CAJA_ACT;
    COMMIT;
END;

CREATE OR REPLACE PROCEDURE PARQUEO.ACTUALIZAR_AUTORIZADOS (P_ID_AUTORIZADO NUMBER, P_NOMB_AUTORIZADO VARCHAR2, P_APELL_AUTORIZADO VARCHAR2, P_TELEFONO VARCHAR2, P_TIPO_CLIENTE NUMBER, P_ESTADO NUMBER) IS
BEGIN
    UPDATE PARQUEO.AUTORIZADOS SET NOMB_AUTORIZADO = P_NOMB_AUTORIZADO, APELL_AUTORIZADO = P_APELL_AUTORIZADO, 
    TELEFONO = P_TELEFONO, TIPO_CLIENTE = P_TIPO_CLIENTE, ESTADO = P_ESTADO WHERE ID_AUTORIZADO = P_ID_AUTORIZADO;
    COMMIT;
END;

CREATE OR REPLACE PROCEDURE PARQUEO.ACTUALIZAR_USUARIOS (P_ID_USUARIO NUMBER, P_NOMBRE_USUARIO VARCHAR2, P_CLAVE VARCHAR2, P_TIPO_USUARIO NUMBER, P_ESTADO NUMBER) IS
BEGIN    
    UPDATE PARQUEO.USUARIOS SET NOMBRE_USUARIO = P_NOMBRE_USUARIO, CLAVE = P_CLAVE, 
    TIPO_USUARIO = P_TIPO_USUARIO, ESTADO = P_ESTADO WHERE ID_USUARIO = P_ID_USUARIO;
    COMMIT;
END;

CREATE OR REPLACE PROCEDURE PARQUEO.ACTUALIZAR_LUGARES (P_ID_LUGAR VARCHAR2, P_TIPO_MEDIO_LUGAR NUMBER, P_ESTADO NUMBER, P_ID_LUGAR_REF VARCHAR2) IS
BEGIN    
    UPDATE PARQUEO.LUGARES SET ID_LUGAR = P_ID_LUGAR, TIPO_MEDIO_LUGAR = P_TIPO_MEDIO_LUGAR, 
    ESTADO = P_ESTADO WHERE ID_LUGAR = P_ID_LUGAR_REF;
    COMMIT;
END;

CREATE OR REPLACE PROCEDURE PARQUEO.ACTUALIZAR_TIPOS_VEHICULOS (P_ID_MEDIO NUMBER, P_TIPO_MEDIO VARCHAR2, P_COBRO NUMBER) IS
BEGIN    
    UPDATE PARQUEO.TIPOS_MEDIOS_TRANSPORTE SET TIPO_MEDIO = P_TIPO_MEDIO, 
    COBRO = P_COBRO WHERE ID_MEDIO = P_ID_MEDIO;
    COMMIT;
END;

CREATE OR REPLACE PROCEDURE ACTUALIZAR_PLACAS (P_ID_PLACA VARCHAR2, P_ID_AUTORIZADO NUMBER, P_CUOTA NUMBER, P_MED_TRANSPORTE NUMBER, P_ESTADO NUMBER) IS
BEGIN    
    UPDATE PARQUEO.PLACAS SET ID_AUTORIZADO = P_ID_AUTORIZADO, CUOTA = P_CUOTA, MED_TRANSPORTE = P_MED_TRANSPORTE, ESTADO = P_ESTADO
    WHERE ID_PLACA = P_ID_PLACA;
    COMMIT;
END;

COMMIT;