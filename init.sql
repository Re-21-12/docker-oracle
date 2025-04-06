-- Crear el usuario BANCARIO en Oracle
CREATE USER BANCARIO IDENTIFIED BY "Alfredo+123";

-- Asignar permisos (Oracle usa estos roles por defecto)
GRANT CONNECT, RESOURCE, DBA TO BANCARIO;

-- Cambiar el esquema actual
ALTER SESSION SET CURRENT_SCHEMA = BANCARIO;
CREATE TABLE bitacora 
(
    num_transaccion     NUMBER (12),
    nom_tabla           VARCHAR2 (50 BYTE),
    nom_campo           VARCHAR2 (50 BYTE),
    nuevo_valor         VARCHAR2 (3000 BYTE),
    valor_anterior      VARCHAR2 (3000 BYTE),
    usuario_transaccion VARCHAR2 (20 BYTE),
    fecha_transaccion   DATE,
    tipo_transaccion    CHAR (1 BYTE),
    llave_primaria      INTEGER
);

CREATE TABLE bitacora_pago 
(
    num_transaccion     INTEGER,
    codigo_prestamo     INTEGER,
    monto_pago          NUMBER (12,2),
    fecha_pago          DATE,
    saldo_anterior      NUMBER (12,2),
    saldo_nuevo         NUMBER (12,2),
    meses_pendiente     INTEGER,
    tipo_transaccion    CHAR (1 BYTE),
    usuario_transaccion VARCHAR2 (20 BYTE),
    fecha_transaccion   DATE
);


CREATE TABLE inicio_sesion
(
    secuencia     NUMBER,      
    numero_tarjeta  NUMBER,      
    codigo_caja     NUMBER,      
    codigo_cliente  NUMBER,      
    codigo_titular  NUMBER,      
    fecha_hora      TIMESTAMP    
);


CREATE TABLE caja_ahorro 
(
    codigo_caja    INTEGER NOT NULL,
    descripcion    VARCHAR2 (50 BYTE) NOT NULL,
    codigo_cliente INTEGER NOT NULL,
    saldo_caja     NUMBER (12,2)
);
ALTER TABLE caja_ahorro ADD CONSTRAINT caja_ahorro_PK PRIMARY KEY (codigo_caja);

CREATE TABLE cajero 
(
    codigo_cajero INTEGER NOT NULL,
    ubicacion     VARCHAR2 (100 BYTE) NOT NULL,
    saldo         NUMBER (12,2) NOT NULL
);
ALTER TABLE cajero ADD CONSTRAINT cajero_PK PRIMARY KEY (codigo_cajero);

CREATE TABLE cliente 
(
    codigo_cliente   INTEGER NOT NULL,
    primer_nombre    VARCHAR2 (50 BYTE) NOT NULL,
    segundo_nombre   VARCHAR2 (50 BYTE) NOT NULL,
    tercer_nombre    VARCHAR2 (50 BYTE),
    primer_apellido  VARCHAR2 (50 BYTE) NOT NULL,
    segundo_apellido VARCHAR2 (50 BYTE) NOT NULL,
    edad             INTEGER NOT NULL,
    direccion        VARCHAR2 (100 BYTE) NOT NULL
);
ALTER TABLE cliente ADD CONSTRAINT cliente_PK PRIMARY KEY (codigo_cliente);

CREATE TABLE movimiento 
(
    codigo_movimiento INTEGER NOT NULL,
    tipo_operacion    VARCHAR2 (50 BYTE) NOT NULL,
    fecha             DATE NOT NULL,
    codigo_titular    INTEGER NOT NULL,
    codigo_cajero     INTEGER NOT NULL,
    cuenta_debitar    INTEGER,
    cuenta_acreditar  INTEGER,
    monto             NUMBER (12,2) NOT NULL
);
ALTER TABLE movimiento ADD CONSTRAINT movimiento_PK PRIMARY KEY (codigo_movimiento);

CREATE TABLE operacion 
(
    codigo_operacion INTEGER NOT NULL,
    nombre_operacion VARCHAR2 (50 BYTE) NOT NULL,
    codigo_cajero    INTEGER NOT NULL
);
ALTER TABLE operacion ADD CONSTRAINT operacion_PK PRIMARY KEY (codigo_operacion);

CREATE TABLE pago 
(
    numero_pago     INTEGER NOT NULL,
    fecha_pago      DATE NOT NULL,
    monto_pago      NUMBER (12,2) NOT NULL,
    codigo_prestamo INTEGER NOT NULL
);
ALTER TABLE pago ADD CONSTRAINT pago_PK PRIMARY KEY (numero_pago);

CREATE TABLE prestamo 
(
    codigo_prestamo   INTEGER NOT NULL,
    monto_inicial     NUMBER (12,2) NOT NULL,
    monto_pagado      NUMBER (12,2) NOT NULL,
    saldo_pendiente   NUMBER (12,2) NOT NULL,
    fecha_otorgado    DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    estado_prestamo   VARCHAR2 (20 BYTE) NOT NULL,
    monto_total       NUMBER (12,2) NOT NULL,
    interes          NUMBER (6,2) NOT NULL,
    meses_pendiente   INTEGER NOT NULL,
    codigo_cliente    INTEGER NOT NULL
);
ALTER TABLE prestamo ADD CONSTRAINT prestamo_PK PRIMARY KEY (codigo_prestamo);

CREATE TABLE titular 
(
    codigo_titular   INTEGER NOT NULL,
    primer_nombre    VARCHAR2 (50 BYTE) NOT NULL,
    segundo_nombre   VARCHAR2 (50 BYTE) NOT NULL,
    tercer_nombre    VARCHAR2 (50 BYTE),
    primer_apellido  VARCHAR2 (50 BYTE) NOT NULL,
    segundo_apellido VARCHAR2 (50 BYTE) NOT NULL,
    direccion        VARCHAR2 (100 BYTE) NOT NULL,
    edad             INTEGER NOT NULL
);
ALTER TABLE titular ADD CONSTRAINT titular_PK PRIMARY KEY (codigo_titular);

CREATE TABLE tarjeta 
(
    numero_tarjeta    INTEGER NOT NULL,
    marca             VARCHAR2 (50 BYTE) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    pin               INTEGER NOT NULL,
    codigo_caja       INTEGER NOT NULL,
    codigo_titular    INTEGER UNIQUE NOT NULL
);
ALTER TABLE tarjeta ADD CONSTRAINT tarjeta_PK PRIMARY KEY (numero_tarjeta);

ALTER TABLE tarjeta ADD CONSTRAINT tarjeta_caja_ahorro_FK FOREIGN KEY (codigo_caja) 
REFERENCES caja_ahorro (codigo_caja);

ALTER TABLE tarjeta ADD CONSTRAINT tarjeta_titular_FK FOREIGN KEY (codigo_titular) 
REFERENCES titular (codigo_titular);

ALTER TABLE caja_ahorro ADD CONSTRAINT caja_ahorro_cliente_FK FOREIGN KEY (codigo_cliente) 
REFERENCES cliente (codigo_cliente);

ALTER TABLE movimiento ADD CONSTRAINT movimiento_cajero_FK FOREIGN KEY (codigo_cajero) 
REFERENCES cajero (codigo_cajero);

ALTER TABLE movimiento ADD CONSTRAINT movimiento_titular_FK FOREIGN KEY (codigo_titular) 
REFERENCES titular (codigo_titular);

ALTER TABLE operacion ADD CONSTRAINT operacion_cajero_FK FOREIGN KEY (codigo_cajero) 
REFERENCES cajero (codigo_cajero);

ALTER TABLE pago ADD CONSTRAINT pago_prestamo_FK FOREIGN KEY (codigo_prestamo) 
REFERENCES prestamo (codigo_prestamo);

ALTER TABLE prestamo ADD CONSTRAINT prestamo_cliente_FK FOREIGN KEY (codigo_cliente) 
REFERENCES cliente (codigo_cliente);





INSERT INTO cliente (codigo_cliente, primer_nombre, segundo_nombre, tercer_nombre, primer_apellido, segundo_apellido, edad, direccion)
VALUES (2, 'Cristiano', 'Leonel', 'Neymar', 'Castañeda', 'Chan', 1, 'Boca Del Monte');

INSERT INTO cliente (codigo_cliente, primer_nombre, segundo_nombre, tercer_nombre, primer_apellido, segundo_apellido, edad, direccion)
VALUES (3, 'Carlos', 'Estiven', 'Victor', 'Garcia', 'Juan', 25, 'villa canales');
select * from cliente;


INSERT INTO prestamo (codigo_prestamo, monto_inicial, monto_pagado, saldo_pendiente, fecha_otorgado, fecha_vencimiento, estado_prestamo, monto_total, interes, meses_pendiente, codigo_cliente)
VALUES (1, 20000.00, 0.00, 20000.00, TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'), 'ACTIVO', 22000.00, 0.10, 12, 2);
SELECT * FROM PRESTAMO;

INSERT INTO TITULAR (CODIGO_TITULAR, PRIMER_NOMBRE, SEGUNDO_NOMBRE, TERCER_NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, DIRECCION, EDAD) 
VALUES (1, 'LUIS', 'PEDRO', 'JUAN', 'PEREZ', 'GOMEZ', 'GUATEMALA', 25);
SELECT * FROM TITULAR;

INSERT INTO caja_ahorro (codigo_caja, descripcion, codigo_cliente, saldo_caja)
VALUES (1, 'Cuenta Ahorro Principal', 2, 15000.00);

INSERT INTO caja_ahorro (codigo_caja, descripcion, codigo_cliente, saldo_caja)
VALUES (2, 'Cuenta Ahorro POBRE', 3, 10.00);

SELECT * FROM CAJA_AHORRO;

--insert en cajero

INSERT INTO cajero (codigo_cajero, ubicacion, saldo)
VALUES (101, 'Sucursal Principal', 10000.00);

select * from cajero;


--SECUENCIA PARA LOS PAGOS
CREATE SEQUENCE bitacora_pago_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
SELECT * FROM BITACORA_PAGO;

--TRIGGER PARA PAGOS-ACTUALIZA EL SALDO DEL PRESTAMO EN INSERTA EN BITACORA
CREATE OR REPLACE TRIGGER actualizar_saldo_pago
AFTER INSERT ON pago
FOR EACH ROW
DECLARE
    v_saldo_anterior     NUMBER(12,2);
    v_saldo_nuevo        NUMBER(12,2);
    v_meses_pendientes   INTEGER;
    v_codigo_cliente     INTEGER;
BEGIN
    -- Obtener el saldo pendiente y los meses pendientes del préstamo
    SELECT saldo_pendiente, meses_pendiente, codigo_cliente
    INTO v_saldo_anterior, v_meses_pendientes, v_codigo_cliente
    FROM prestamo
    WHERE codigo_prestamo = :NEW.codigo_prestamo;

    -- Calcular el nuevo saldo pendiente
    v_saldo_nuevo := v_saldo_anterior - :NEW.monto_pago;

    -- Restar 1 mes a los meses pendientes si el saldo es mayor que 0
    IF v_saldo_nuevo > 0 THEN
        v_meses_pendientes := v_meses_pendientes - 1;
    ELSE
        v_meses_pendientes := 0;
    END IF;

    -- Actualizar el saldo pendiente y los meses pendientes en la tabla prestamo
    UPDATE prestamo
    SET saldo_pendiente = v_saldo_nuevo,
        meses_pendiente = v_meses_pendientes
    WHERE codigo_prestamo = :NEW.codigo_prestamo;

    -- Insertar el registro de pago en la bitacora
    INSERT INTO bitacora_pago
    (num_transaccion, 
     codigo_prestamo, 
     monto_pago, 
     fecha_pago, 
     saldo_anterior, 
     saldo_nuevo, 
     meses_pendiente, 
     tipo_transaccion, 
     usuario_transaccion, 
     fecha_transaccion)
    VALUES 
    (bitacora_pago_seq.NEXTVAL,  -- Usar la secuencia para generar el ID
     :NEW.codigo_prestamo, 
     :NEW.monto_pago, 
     :NEW.fecha_pago, 
     v_saldo_anterior, 
     v_saldo_nuevo, 
     v_meses_pendientes, 
     'P',  -- Tipo de transacción 'P' para pago
     USER,  -- O el nombre del usuario si corresponde
     SYSDATE);   -- Fecha actual de la transacción
END;
/


--COMPROOBAR PAGO 
INSERT INTO pago (numero_pago,codigo_prestamo, monto_pago, fecha_pago)
VALUES (1,1, 1000.00, TO_DATE('2025-03-25', 'YYYY-MM-DD'));
select * from prestamo;
select * from bitacora_pago;

--TRIGGER FUNCIONA CORRECTAMENTE








--STORES PROCEDURES PARA TRANSFERENCIAS ENTRE CUENTAS
CREATE OR REPLACE PROCEDURE realizar_transferencia(
    p_codigo_titular IN INTEGER,  -- Titular que realiza la transferencia
    p_codigo_origen  IN INTEGER,
    p_codigo_destino IN INTEGER,
    p_monto         IN NUMBER,
    p_codigo_cajero IN INTEGER
)
IS
    v_saldo_origen NUMBER(12, 2);
    v_saldo_destino NUMBER(12, 2);
    v_codigo_movimiento INTEGER;
BEGIN
    -- Verificar que las cuentas existen
    SELECT saldo_caja INTO v_saldo_origen
    FROM caja_ahorro
    WHERE codigo_caja = p_codigo_origen;
    
    SELECT saldo_caja INTO v_saldo_destino
    FROM caja_ahorro
    WHERE codigo_caja = p_codigo_destino;

    -- Verificar saldo suficiente en la cuenta origen
    IF v_saldo_origen < p_monto THEN
        RAISE_APPLICATION_ERROR(-20001, 'Saldo insuficiente en la cuenta de origen.');
    END IF;

    -- Realizar la transferencia: debitar origen y acreditar destino
    UPDATE caja_ahorro
    SET saldo_caja = saldo_caja - p_monto
    WHERE codigo_caja = p_codigo_origen;

    UPDATE caja_ahorro
    SET saldo_caja = saldo_caja + p_monto
    WHERE codigo_caja = p_codigo_destino;

    -- Generar un código de movimiento
    SELECT COALESCE(MAX(codigo_movimiento), 0) + 1 INTO v_codigo_movimiento FROM movimiento;

    -- Registrar el movimiento con el titular
    INSERT INTO movimiento (
        codigo_movimiento,
        tipo_operacion,
        fecha,
        cuenta_debitar,
        cuenta_acreditar,
        codigo_cajero,
        monto,
        codigo_titular  -- Ahora sí se inserta correctamente
    )
    VALUES (
        v_codigo_movimiento,
        'Transferencia',
        SYSDATE,
        p_codigo_origen,
        p_codigo_destino,
        p_codigo_cajero,
        p_monto,
        p_codigo_titular  -- Aquí se usa el parámetro ingresado
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transferencia realizada exitosamente.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Una de las cuentas no existe.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END realizar_transferencia;
/

--CUENTA ORIGEN, CUENTA DESTINO Y CODIGO CAJERO
EXECUTE realizar_transferencia(1, 1, 2, 500.00, 101);

select * from titular;
SELECT * FROM CAJERO;

SELECT * FROM CAJA_AHORRO;

select * from movimiento;


--STORED PROCEDURE PARA EXTRAER DINERO
CREATE OR REPLACE PROCEDURE realizar_extraccion(
    p_codigo_titular IN INTEGER,  -- Titular de la cuenta que realiza la extracción
    p_codigo_caja    IN INTEGER,  -- Cuenta de la caja de ahorro de donde se extrae
    p_monto          IN NUMBER,   -- Monto a extraer
    p_codigo_cajero  IN INTEGER   -- Código del cajero que realiza la operación
)
IS
    v_saldo_caja      NUMBER(12,2);
    v_saldo_cajero    NUMBER(12,2);
    v_codigo_movimiento INTEGER;
BEGIN
    -- Verificar que la caja de ahorro existe y obtener el saldo actual
    SELECT saldo_caja INTO v_saldo_caja
    FROM caja_ahorro
    WHERE codigo_caja = p_codigo_caja;
    
    -- Verificar que el cajero existe y obtener su saldo actual
    SELECT saldo INTO v_saldo_cajero
    FROM cajero
    WHERE codigo_cajero = p_codigo_cajero;
    
    -- Verificar si la caja de ahorro tiene saldo suficiente
    IF v_saldo_caja < p_monto THEN
        RAISE_APPLICATION_ERROR(-20001, 'Saldo insuficiente en la caja de ahorro.');
    END IF;
    
    -- Verificar si el cajero tiene saldo suficiente para la extracción
    IF v_saldo_cajero < p_monto THEN
        RAISE_APPLICATION_ERROR(-20002, 'Saldo insuficiente en la caja del cajero.');
    END IF;
    
    -- Actualizar el saldo de la caja de ahorro (restar el monto extraído)
    UPDATE caja_ahorro
    SET saldo_caja = saldo_caja - p_monto
    WHERE codigo_caja = p_codigo_caja;
    
    -- Actualizar el saldo del cajero (restar el monto extraído)
    UPDATE cajero
    SET saldo = saldo - p_monto
    WHERE codigo_cajero = p_codigo_cajero;

    -- Generar un nuevo código de movimiento
    SELECT COALESCE(MAX(codigo_movimiento), 0) + 1 
      INTO v_codigo_movimiento 
      FROM movimiento;
      
    -- Registrar el movimiento de extracción en la tabla movimiento
    INSERT INTO movimiento (
        codigo_movimiento,
        tipo_operacion,
        fecha,
        cuenta_debitar,
        cuenta_acreditar,
        codigo_cajero,
        monto,
        codigo_titular
    )
    VALUES (
        v_codigo_movimiento,
        'Extracción',
        SYSDATE,
        p_codigo_caja,  -- Se debita la cuenta de ahorro
        NULL,           -- No se acredita ninguna cuenta en una extracción
        p_codigo_cajero,
        p_monto,
        p_codigo_titular -- Se registra el titular que hizo la operación
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Extracción realizada exitosamente.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'La caja de ahorro o el cajero no existen.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END realizar_extraccion;
/


select * from titular;
SELECT * FROM CAJERO;

SELECT * FROM CAJA_AHORRO;

select * from movimiento;
EXEC realizar_extraccion(1, 1, 4500, 101);


--AMBOS STORED PROCEDURED FUNCIONAN 






CREATE SEQUENCE  "SEQUENCE"  MINVALUE 1 MAXVALUE 99999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;


--TRIGGER PARA LA TABLA CAJERO
CREATE OR REPLACE TRIGGER MOV_CAJERO
BEFORE DELETE OR INSERT OR UPDATE
ON CAJERO
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
    V_FECHA DATE := SYSDATE;
    SECUENCIA NUMBER(12);
BEGIN
    SECUENCIA := SEQUENCE.NEXTVAL;
    
    -- INSERT
    IF INSERTING THEN
        INSERT INTO BITACORA VALUES (SECUENCIA, 'CAJERO', 'CODIGO_CAJERO', :NEW.CODIGO_CAJERO, NULL, USER, V_FECHA, 'I', :NEW.CODIGO_CAJERO);
    END IF;

    -- UPDATE
    IF UPDATING THEN
        IF :NEW.CODIGO_CAJERO != :OLD.CODIGO_CAJERO THEN
            INSERT INTO BITACORA VALUES (SECUENCIA, 'CAJERO', 'CODIGO_CAJERO', :NEW.CODIGO_CAJERO, :OLD.CODIGO_CAJERO, USER, V_FECHA, 'U', :NEW.CODIGO_CAJERO);
        END IF;
        IF :NEW.UBICACION != :OLD.UBICACION THEN
            INSERT INTO BITACORA VALUES (SECUENCIA, 'CAJERO', 'UBICACION', :NEW.UBICACION, :OLD.UBICACION, USER, V_FECHA, 'U', :NEW.CODIGO_CAJERO);
        END IF;
        IF :NEW.SALDO != :OLD.SALDO THEN
            INSERT INTO BITACORA VALUES (SECUENCIA, 'CAJERO', 'SALDO', :NEW.SALDO, :OLD.SALDO, USER, V_FECHA, 'U', :NEW.CODIGO_CAJERO);
        END IF;
    END IF;

    -- DELETE
    IF DELETING THEN
        INSERT INTO BITACORA VALUES (SECUENCIA, 'CAJERO', 'CODIGO_CAJERO', NULL, :OLD.CODIGO_CAJERO, USER, V_FECHA, 'D', :OLD.CODIGO_CAJERO);
    END IF;
END;
/

SELECT * FROM CAJERO;
SELECT * FROM BITACORA;

INSERT INTO CAJERO(CODIGO_CAJERO, UBICACION, SALDO) VALUES (102, 'AMATITLAN', 12500.00);
UPDATE CAJERO SET SALDO = 35000.00 WHERE CODIGO_CAJERO = 102;


--TRIGGER PARA CAJA_AHORRO
CREATE OR REPLACE TRIGGER MOV_CAJA_AHORRO
BEFORE DELETE OR INSERT OR UPDATE
ON CAJA_AHORRO
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
    SECUENCIA NUMBER(12);
    V_FECHA DATE := SYSDATE;
BEGIN
  IF INSERTING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    INSERT INTO BITACORA VALUES (SECUENCIA, 'CAJA_AHORRO', 'CODIGO_CAJA', :NEW.CODIGO_CAJA, NULL, USER, V_FECHA, 'I', :NEW.CODIGO_CAJA);
  END IF;

  IF UPDATING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    IF :NEW.CODIGO_CAJA != :OLD.CODIGO_CAJA THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'CAJA_AHORRO', 'CODIGO_CAJA', :NEW.CODIGO_CAJA, :OLD.CODIGO_CAJA, USER, V_FECHA, 'U', :NEW.CODIGO_CAJA);
    END IF;
    IF :NEW.DESCRIPCION != :OLD.DESCRIPCION THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'CAJA_AHORRO', 'DESCRIPCION', :NEW.DESCRIPCION, :OLD.DESCRIPCION, USER, V_FECHA, 'U', :NEW.CODIGO_CAJA);
    END IF;
    IF :NEW.CODIGO_CLIENTE != :OLD.CODIGO_CLIENTE THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'CAJA_AHORRO', 'CODIGO_CLIENTE', :NEW.CODIGO_CLIENTE, :OLD.CODIGO_CLIENTE, USER, V_FECHA, 'U', :NEW.CODIGO_CAJA);
    END IF;
    IF :NEW.SALDO_CAJA != :OLD.SALDO_CAJA THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'CAJA_AHORRO', 'SALDO_CAJA', :NEW.SALDO_CAJA, :OLD.SALDO_CAJA, USER, V_FECHA, 'U', :NEW.CODIGO_CAJA);
    END IF;
  END IF;

  IF DELETING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    INSERT INTO BITACORA VALUES (SECUENCIA, 'CAJA_AHORRO', 'CODIGO_CAJA', NULL, :OLD.CODIGO_CAJA, USER, V_FECHA, 'D', :OLD.CODIGO_CAJA);
  END IF;
END;
/

SELECT * FROM BITACORA;
SELECT * FROM CAJA_AHORRO;
INSERT INTO caja_ahorro (codigo_caja, descripcion, codigo_cliente, saldo_caja)
VALUES (3, 'Cuenta Ahorro LIBRE', 2, 15000.00);

DELETE FROM CAJA_AHORRO WHERE CODIGO_CAJA = 3;


--TRIGER PARA CLIENTE
CREATE OR REPLACE TRIGGER MOV_CLIENTE
BEFORE DELETE OR INSERT OR UPDATE
ON CLIENTE
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
    SECUENCIA NUMBER(12);
    V_FECHA DATE := SYSDATE;
BEGIN
  IF INSERTING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    INSERT INTO BITACORA VALUES (SECUENCIA, 'CLIENTE', 'CODIGO_CLIENTE', :NEW.CODIGO_CLIENTE, NULL, USER, V_FECHA, 'I', :NEW.CODIGO_CLIENTE);
  END IF;

  IF UPDATING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    IF :NEW.PRIMER_NOMBRE != :OLD.PRIMER_NOMBRE THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'CLIENTE', 'PRIMER_NOMBRE', :NEW.PRIMER_NOMBRE, :OLD.PRIMER_NOMBRE, USER, V_FECHA, 'U', :NEW.CODIGO_CLIENTE);
    END IF;
    IF :NEW.SEGUNDO_NOMBRE != :OLD.SEGUNDO_NOMBRE THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'CLIENTE', 'SEGUNDO_NOMBRE', :NEW.SEGUNDO_NOMBRE, :OLD.SEGUNDO_NOMBRE, USER, V_FECHA, 'U', :NEW.CODIGO_CLIENTE);
    END IF;
    IF :NEW.TERCER_NOMBRE != :OLD.TERCER_NOMBRE THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'CLIENTE', 'TERCER_NOMBRE', :NEW.TERCER_NOMBRE, :OLD.TERCER_NOMBRE, USER, V_FECHA, 'U', :NEW.CODIGO_CLIENTE);
    END IF;
    IF :NEW.PRIMER_APELLIDO != :OLD.PRIMER_APELLIDO THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'CLIENTE', 'PRIMER_APELLIDO', :NEW.PRIMER_APELLIDO, :OLD.PRIMER_APELLIDO, USER, V_FECHA, 'U', :NEW.CODIGO_CLIENTE);
    END IF;
    IF :NEW.SEGUNDO_APELLIDO != :OLD.SEGUNDO_APELLIDO THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'CLIENTE', 'SEGUNDO_APELLIDO', :NEW.SEGUNDO_APELLIDO, :OLD.SEGUNDO_APELLIDO, USER, V_FECHA, 'U', :NEW.CODIGO_CLIENTE);
    END IF;
    IF :NEW.EDAD != :OLD.EDAD THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'CLIENTE', 'EDAD', :NEW.EDAD, :OLD.EDAD, USER, V_FECHA, 'U', :NEW.CODIGO_CLIENTE);
    END IF;
    IF :NEW.DIRECCION != :OLD.DIRECCION THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'CLIENTE', 'DIRECCION', :NEW.DIRECCION, :OLD.DIRECCION, USER, V_FECHA, 'U', :NEW.CODIGO_CLIENTE);
    END IF;
  END IF;

  IF DELETING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    INSERT INTO BITACORA VALUES (SECUENCIA, 'CLIENTE', 'CODIGO_CLIENTE', NULL, :OLD.CODIGO_CLIENTE, USER, V_FECHA, 'D', :OLD.CODIGO_CLIENTE);
  END IF;
END;
/

SELECT * FROM BITACORA;
select * from cliente;
INSERT INTO cliente (codigo_cliente, primer_nombre, segundo_nombre, tercer_nombre, primer_apellido, segundo_apellido, edad, direccion)
VALUES (1, 'Cristiano', 'MODRIC', 'Neymar', 'Castañeda', 'Chan', 85, 'Boca Del Monte');

UPDATE CLIENTE SET PRIMER_NOMBRE = 'ANTONIO' WHERE CODIGO_CLIENTE = 3;


--TRIGER PARA MOVIMIENTO
CREATE OR REPLACE TRIGGER MOV_MOVIMIENTO
BEFORE DELETE OR INSERT OR UPDATE
ON MOVIMIENTO
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
    SECUENCIA NUMBER(12);
    V_FECHA DATE := SYSDATE;
BEGIN
  IF INSERTING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    INSERT INTO BITACORA VALUES (SECUENCIA, 'MOVIMIENTO', 'CODIGO_MOVIMIENTO', :NEW.CODIGO_MOVIMIENTO, NULL, USER, V_FECHA, 'I', :NEW.CODIGO_MOVIMIENTO);
  END IF;

  IF UPDATING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    IF :NEW.TIPO_OPERACION != :OLD.TIPO_OPERACION THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'MOVIMIENTO', 'TIPO_OPERACION', :NEW.TIPO_OPERACION, :OLD.TIPO_OPERACION, USER, V_FECHA, 'U', :NEW.CODIGO_MOVIMIENTO);
    END IF;
    IF :NEW.FECHA != :OLD.FECHA THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'MOVIMIENTO', 'FECHA', :NEW.FECHA, :OLD.FECHA, USER, V_FECHA, 'U', :NEW.CODIGO_MOVIMIENTO);
    END IF;
    IF :NEW.CODIGO_TITULAR != :OLD.CODIGO_TITULAR THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'MOVIMIENTO', 'CODIGO_TITULAR', :NEW.CODIGO_TITULAR, :OLD.CODIGO_TITULAR, USER, V_FECHA, 'U', :NEW.CODIGO_MOVIMIENTO);
    END IF;
    IF :NEW.CODIGO_CAJERO != :OLD.CODIGO_CAJERO THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'MOVIMIENTO', 'CODIGO_CAJERO', :NEW.CODIGO_CAJERO, :OLD.CODIGO_CAJERO, USER, V_FECHA, 'U', :NEW.CODIGO_MOVIMIENTO);
    END IF;
    IF :NEW.CUENTA_DEBITAR != :OLD.CUENTA_DEBITAR THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'MOVIMIENTO', 'CUENTA_DEBITAR', :NEW.CUENTA_DEBITAR, :OLD.CUENTA_DEBITAR, USER, V_FECHA, 'U', :NEW.CODIGO_MOVIMIENTO);
    END IF;
    IF :NEW.CUENTA_ACREDITAR != :OLD.CUENTA_ACREDITAR THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'MOVIMIENTO', 'CUENTA_ACREDITAR', :NEW.CUENTA_ACREDITAR, :OLD.CUENTA_ACREDITAR, USER, V_FECHA, 'U', :NEW.CODIGO_MOVIMIENTO);
    END IF;
    IF :NEW.MONTO != :OLD.MONTO THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'MOVIMIENTO', 'MONTO', :NEW.MONTO, :OLD.MONTO, USER, V_FECHA, 'U', :NEW.CODIGO_MOVIMIENTO);
    END IF;
  END IF;

  IF DELETING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    INSERT INTO BITACORA VALUES (SECUENCIA, 'MOVIMIENTO', 'CODIGO_MOVIMIENTO', NULL, :OLD.CODIGO_MOVIMIENTO, USER, V_FECHA, 'D', :OLD.CODIGO_MOVIMIENTO);
  END IF;
END;
/






--TRIGGER PARA OPERACION 
CREATE OR REPLACE TRIGGER MOV_OPERACION
BEFORE DELETE OR INSERT OR UPDATE
ON OPERACION
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
    SECUENCIA NUMBER(12);
    V_FECHA DATE := SYSDATE;
BEGIN
  IF INSERTING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    INSERT INTO BITACORA VALUES (SECUENCIA, 'OPERACION', 'CODIGO_OPERACION', :NEW.CODIGO_OPERACION, NULL, USER, V_FECHA, 'I', :NEW.CODIGO_OPERACION);
  END IF;

  IF UPDATING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    IF :NEW.NOMBRE_OPERACION != :OLD.NOMBRE_OPERACION THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'OPERACION', 'NOMBRE_OPERACION', :NEW.NOMBRE_OPERACION, :OLD.NOMBRE_OPERACION, USER, V_FECHA, 'U', :NEW.CODIGO_OPERACION);
    END IF;
    IF :NEW.CODIGO_CAJERO != :OLD.CODIGO_CAJERO THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'OPERACION', 'CODIGO_CAJERO', :NEW.CODIGO_CAJERO, :OLD.CODIGO_CAJERO, USER, V_FECHA, 'U', :NEW.CODIGO_OPERACION);
    END IF;
  END IF;

  IF DELETING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    INSERT INTO BITACORA VALUES (SECUENCIA, 'OPERACION', 'CODIGO_OPERACION', NULL, :OLD.CODIGO_OPERACION, USER, V_FECHA, 'D', :OLD.CODIGO_OPERACION);
  END IF;
END;
/

SELECT * FROM BITACORA;
SELECT * FROM OPERACION;
INSERT INTO OPERACION (CODIGO_OPERACION, NOMBRE_OPERACION, CODIGO_CAJERO) VALUES(1, 'TRANSFERENCIA', 101);
INSERT INTO OPERACION (CODIGO_OPERACION, NOMBRE_OPERACION, CODIGO_CAJERO) VALUES(2, 'EXTRACCION', 101);



--TRIGER PARA LA TABLA prestamo
CREATE OR REPLACE TRIGGER MOV_PRESTAMO
BEFORE DELETE OR INSERT OR UPDATE
ON PRESTAMO
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
    SECUENCIA NUMBER(12);
    V_FECHA DATE := SYSDATE;
BEGIN
  -- Inserción
  IF INSERTING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    INSERT INTO BITACORA VALUES (SECUENCIA, 'PRESTAMO', 'CODIGO_PRESTAMO', :NEW.CODIGO_PRESTAMO, NULL, USER, V_FECHA, 'I', :NEW.CODIGO_PRESTAMO);
  END IF;

  -- Actualización
  IF UPDATING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    
    IF :NEW.MONTO_INICIAL != :OLD.MONTO_INICIAL THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'PRESTAMO', 'MONTO_INICIAL', :NEW.MONTO_INICIAL, :OLD.MONTO_INICIAL, USER, V_FECHA, 'U', :NEW.CODIGO_PRESTAMO);
    END IF;
    
    IF :NEW.MONTO_PAGADO != :OLD.MONTO_PAGADO THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'PRESTAMO', 'MONTO_PAGADO', :NEW.MONTO_PAGADO, :OLD.MONTO_PAGADO, USER, V_FECHA, 'U', :NEW.CODIGO_PRESTAMO);
    END IF;
    
    IF :NEW.SALDO_PENDIENTE != :OLD.SALDO_PENDIENTE THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'PRESTAMO', 'SALDO_PENDIENTE', :NEW.SALDO_PENDIENTE, :OLD.SALDO_PENDIENTE, USER, V_FECHA, 'U', :NEW.CODIGO_PRESTAMO);
    END IF;
    
    IF :NEW.FECHA_OTORGADO != :OLD.FECHA_OTORGADO THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'PRESTAMO', 'FECHA_OTORGADO', :NEW.FECHA_OTORGADO, :OLD.FECHA_OTORGADO, USER, V_FECHA, 'U', :NEW.CODIGO_PRESTAMO);
    END IF;

    IF :NEW.FECHA_VENCIMIENTO != :OLD.FECHA_VENCIMIENTO THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'PRESTAMO', 'FECHA_VENCIMIENTO', :NEW.FECHA_VENCIMIENTO, :OLD.FECHA_VENCIMIENTO, USER, V_FECHA, 'U', :NEW.CODIGO_PRESTAMO);
    END IF;
    
    IF :NEW.ESTADO_PRESTAMO != :OLD.ESTADO_PRESTAMO THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'PRESTAMO', 'ESTADO_PRESTAMO', :NEW.ESTADO_PRESTAMO, :OLD.ESTADO_PRESTAMO, USER, V_FECHA, 'U', :NEW.CODIGO_PRESTAMO);
    END IF;

    IF :NEW.MONTO_TOTAL != :OLD.MONTO_TOTAL THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'PRESTAMO', 'MONTO_TOTAL', :NEW.MONTO_TOTAL, :OLD.MONTO_TOTAL, USER, V_FECHA, 'U', :NEW.CODIGO_PRESTAMO);
    END IF;

    IF :NEW.INTERES != :OLD.INTERES THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'PRESTAMO', 'INTERES', :NEW.INTERES, :OLD.INTERES, USER, V_FECHA, 'U', :NEW.CODIGO_PRESTAMO);
    END IF;

    IF :NEW.MESES_PENDIENTE != :OLD.MESES_PENDIENTE THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'PRESTAMO', 'MESES_PENDIENTE', :NEW.MESES_PENDIENTE, :OLD.MESES_PENDIENTE, USER, V_FECHA, 'U', :NEW.CODIGO_PRESTAMO);
    END IF;

    IF :NEW.CODIGO_CLIENTE != :OLD.CODIGO_CLIENTE THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'PRESTAMO', 'CODIGO_CLIENTE', :NEW.CODIGO_CLIENTE, :OLD.CODIGO_CLIENTE, USER, V_FECHA, 'U', :NEW.CODIGO_PRESTAMO);
    END IF;
  END IF;

  -- Eliminación
  IF DELETING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    INSERT INTO BITACORA VALUES (SECUENCIA, 'PRESTAMO', 'CODIGO_PRESTAMO', NULL, :OLD.CODIGO_PRESTAMO, USER, V_FECHA, 'D', :OLD.CODIGO_PRESTAMO);
  END IF;
END;
/

SELECT * FROM PRESTAMO;
SELECT * FROM BITACORA;

INSERT INTO prestamo (codigo_prestamo, monto_inicial, monto_pagado, saldo_pendiente, fecha_otorgado, fecha_vencimiento, estado_prestamo, monto_total, interes, meses_pendiente, codigo_cliente)
VALUES (2, 20000.00, 0.00, 20000.00, TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'), 'ACTIVO', 22000.00, 0.10, 12, 1);


--TRIGER PARA TITULAR
CREATE OR REPLACE TRIGGER MOV_TITULAR
BEFORE DELETE OR INSERT OR UPDATE
ON TITULAR
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
    SECUENCIA NUMBER(12);
    V_FECHA DATE := SYSDATE;
BEGIN
  -- Inserción
  IF INSERTING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    INSERT INTO BITACORA VALUES (SECUENCIA, 'TITULAR', 'CODIGO_TITULAR', :NEW.CODIGO_TITULAR, NULL, USER, V_FECHA, 'I', :NEW.CODIGO_TITULAR);
  END IF;

  -- Actualización
  IF UPDATING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    
    IF :NEW.PRIMER_NOMBRE != :OLD.PRIMER_NOMBRE THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'TITULAR', 'PRIMER_NOMBRE', :NEW.PRIMER_NOMBRE, :OLD.PRIMER_NOMBRE, USER, V_FECHA, 'U', :NEW.CODIGO_TITULAR);
    END IF;
    
    IF :NEW.SEGUNDO_NOMBRE != :OLD.SEGUNDO_NOMBRE THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'TITULAR', 'SEGUNDO_NOMBRE', :NEW.SEGUNDO_NOMBRE, :OLD.SEGUNDO_NOMBRE, USER, V_FECHA, 'U', :NEW.CODIGO_TITULAR);
    END IF;
    
    IF :NEW.TERCER_NOMBRE != :OLD.TERCER_NOMBRE THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'TITULAR', 'TERCER_NOMBRE', :NEW.TERCER_NOMBRE, :OLD.TERCER_NOMBRE, USER, V_FECHA, 'U', :NEW.CODIGO_TITULAR);
    END IF;
    
    IF :NEW.PRIMER_APELLIDO != :OLD.PRIMER_APELLIDO THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'TITULAR', 'PRIMER_APELLIDO', :NEW.PRIMER_APELLIDO, :OLD.PRIMER_APELLIDO, USER, V_FECHA, 'U', :NEW.CODIGO_TITULAR);
    END IF;

    IF :NEW.SEGUNDO_APELLIDO != :OLD.SEGUNDO_APELLIDO THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'TITULAR', 'SEGUNDO_APELLIDO', :NEW.SEGUNDO_APELLIDO, :OLD.SEGUNDO_APELLIDO, USER, V_FECHA, 'U', :NEW.CODIGO_TITULAR);
    END IF;
    
    IF :NEW.DIRECCION != :OLD.DIRECCION THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'TITULAR', 'DIRECCION', :NEW.DIRECCION, :OLD.DIRECCION, USER, V_FECHA, 'U', :NEW.CODIGO_TITULAR);
    END IF;

    IF :NEW.EDAD != :OLD.EDAD THEN 
      INSERT INTO BITACORA VALUES (SECUENCIA, 'TITULAR', 'EDAD', :NEW.EDAD, :OLD.EDAD, USER, V_FECHA, 'U', :NEW.CODIGO_TITULAR);
    END IF;
  END IF;

  -- Eliminación
  IF DELETING THEN
    SECUENCIA := SEQUENCE.NEXTVAL;
    INSERT INTO BITACORA VALUES (SECUENCIA, 'TITULAR', 'CODIGO_TITULAR', NULL, :OLD.CODIGO_TITULAR, USER, V_FECHA, 'D', :OLD.CODIGO_TITULAR);
  END IF;
END;
/

INSERT INTO TITULAR (CODIGO_TITULAR, PRIMER_NOMBRE, SEGUNDO_NOMBRE, TERCER_NOMBRE, PRIMER_APELLIDO, SEGUNDO_APELLIDO, DIRECCION, EDAD) 
VALUES (2, 'JONATHAN', 'JOEL', NULL,  'CHAN', 'CUELLAR', 'GUATEMALA', 22);

UPDATE TITULAR SET SEGUNDO_NOMBRE = 'GEOBANY' WHERE CODIGO_TITULAR = 2;

SELECT * FROM TITULAR;
SELECT * FROM BITACORA;

DELETE FROM TITULAR WHERE CODIGO_TITULAR = 2;

COMMIT;


--TRIGER PARA TABLA TARJETA
CREATE OR REPLACE TRIGGER MOV_TARJETA
BEFORE DELETE OR INSERT OR UPDATE
ON TARJETA
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
    V_FECHA DATE := SYSDATE;
    SECUENCIA NUMBER(12);
BEGIN
    SECUENCIA := SEQUENCE.NEXTVAL;
    
    -- INSERT: Se registra la inserción de una nueva tarjeta
    IF INSERTING THEN
        INSERT INTO BITACORA 
        VALUES (SECUENCIA, 'TARJETA', 'NUMERO_TARJETA', :NEW.NUMERO_TARJETA, NULL, USER, V_FECHA, 'I', :NEW.NUMERO_TARJETA);
    END IF;

    -- UPDATE: Se registran los cambios en cada uno de los campos relevantes
    IF UPDATING THEN
        IF :NEW.NUMERO_TARJETA != :OLD.NUMERO_TARJETA THEN
            INSERT INTO BITACORA 
            VALUES (SECUENCIA, 'TARJETA', 'NUMERO_TARJETA', :NEW.NUMERO_TARJETA, :OLD.NUMERO_TARJETA, USER, V_FECHA, 'U', :NEW.NUMERO_TARJETA);
        END IF;
        IF :NEW.MARCA != :OLD.MARCA THEN
            INSERT INTO BITACORA 
            VALUES (SECUENCIA, 'TARJETA', 'MARCA', :NEW.MARCA, :OLD.MARCA, USER, V_FECHA, 'U', :NEW.NUMERO_TARJETA);
        END IF;
        IF :NEW.FECHA_VENCIMIENTO != :OLD.FECHA_VENCIMIENTO THEN
            INSERT INTO BITACORA 
            VALUES (SECUENCIA, 'TARJETA', 'FECHA_VENCIMIENTO', TO_CHAR(:NEW.FECHA_VENCIMIENTO, 'YYYY-MM-DD'), TO_CHAR(:OLD.FECHA_VENCIMIENTO, 'YYYY-MM-DD'), USER, V_FECHA, 'U', :NEW.NUMERO_TARJETA);
        END IF;
        IF :NEW.PIN != :OLD.PIN THEN
            INSERT INTO BITACORA 
            VALUES (SECUENCIA, 'TARJETA', 'PIN', :NEW.PIN, :OLD.PIN, USER, V_FECHA, 'U', :NEW.NUMERO_TARJETA);
        END IF;
        IF :NEW.CODIGO_CAJA != :OLD.CODIGO_CAJA THEN
            INSERT INTO BITACORA 
            VALUES (SECUENCIA, 'TARJETA', 'CODIGO_CAJA', :NEW.CODIGO_CAJA, :OLD.CODIGO_CAJA, USER, V_FECHA, 'U', :NEW.NUMERO_TARJETA);
        END IF;
    END IF;

    -- DELETE: Se registra la eliminación de una tarjeta
    IF DELETING THEN
        INSERT INTO BITACORA 
        VALUES (SECUENCIA, 'TARJETA', 'NUMERO_TARJETA', NULL, :OLD.NUMERO_TARJETA, USER, V_FECHA, 'D', :OLD.NUMERO_TARJETA);
    END IF;
END;
/

INSERT INTO TARJETA (NUMERO_TARJETA, MARCA, FECHA_VENCIMIENTO, PIN, CODIGO_CAJA)
VALUES (123456789, 'VISA', TO_DATE('2026-12-31', 'YYYY-MM-DD'), 1234, 1);



SELECT * FROM BITACORA;
SELECT * FROM TARJETA;
SELECT * FROM CAJA_AHORRO;
SELECT * FROM TITULAR;


INSERT INTO tarjeta (numero_tarjeta, marca, fecha_vencimiento, pin, codigo_caja, codigo_titular)
VALUES (123456789, 'VISA', TO_DATE('2028-12-31', 'YYYY-MM-DD'), 1234, 1, 1);



--secuencia para inicio de session

CREATE SEQUENCE inicio_sesion_secuencia START WITH 1 INCREMENT BY 1;


CREATE OR REPLACE PROCEDURE registrar_inicio_sesion (
    p_numero_tarjeta IN NUMBER,
    p_pin            IN NUMBER
)
AS
    v_codigo_caja    NUMBER;
    v_codigo_titular NUMBER;
    v_codigo_cliente NUMBER;
    v_fecha_hora     TIMESTAMP;
BEGIN
    -- Validamos y obtenemos los datos de la tarjeta
    SELECT codigo_caja, codigo_titular
      INTO v_codigo_caja, v_codigo_titular
      FROM tarjeta
     WHERE numero_tarjeta = p_numero_tarjeta
       AND pin = p_pin;
    
    -- Obtenemos el código del cliente a partir de la caja de ahorro
    SELECT codigo_cliente
      INTO v_codigo_cliente
      FROM caja_ahorro
     WHERE codigo_caja = v_codigo_caja;
    
    -- Obtenemos la fecha y hora actual
    v_fecha_hora := SYSTIMESTAMP;
    
    -- Insertamos en la tabla de auditoría usando la secuencia
    INSERT INTO inicio_sesion (
        secuencia,
        numero_tarjeta,
        codigo_caja,
        codigo_cliente,
        codigo_titular,
        fecha_hora
    )
    VALUES (
        inicio_sesion_secuencia.NEXTVAL,
        p_numero_tarjeta,
        v_codigo_caja,
        v_codigo_cliente,
        v_codigo_titular,
        v_fecha_hora
    );
    
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'Número de tarjeta o PIN incorrecto.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

SELECT * FROM INICIO_SESION;
select * from caja_ahorro;

BEGIN
    registrar_inicio_sesion(123456789, 1234);
END;

execute registrar_inicio_sesion(123456789, 1234);




--privilegios sobre usuario atm para que pueda ejecutar los procedimientos DE REALIZAR_TRANSFERENCIA Y REALIZAR_EXTRACCION
CREATE USER C##ATM IDENTIFIED BY atm123;

GRANT CREATE SESSION TO C##ATM;
GRANT EXECUTE ON realizar_transferencia TO C##ATM;
GRANT EXECUTE ON realizar_extraccion TO C##ATM;









--OTRA FORMA PERO NO ME DEJA :((((((((((


-- Conectado como SYSTEM con password 6321

-- 1. Crear el usuario ATM
CREATE USER atm IDENTIFIED BY atm123;

-- 2. Otorgar privilegios básicos de conexión
GRANT CREATE SESSION TO atm;

-- 3. Otorgar permisos específicos para ejecutar los procedimientos
GRANT EXECUTE ON realizar_transferencia TO atm;
GRANT EXECUTE ON realizar_extraccion TO atm;

-- 4. Otorgar permisos de lectura en las tablas necesarias
GRANT SELECT ON caja_ahorro TO atm;
GRANT SELECT ON cajero TO atm;
GRANT SELECT ON titular TO atm;
GRANT SELECT ON movimiento TO atm;

-- 5. Si es necesario, otorgar permisos de inserción en la tabla movimiento
GRANT INSERT ON movimiento TO atm;

-- 6. Si los procedimientos actualizan tablas, otorgar permisos de actualización
GRANT UPDATE ON caja_ahorro TO atm;
GRANT UPDATE ON cajero TO atm;

