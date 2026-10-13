-- Creación de la base de datos (Ejecutar primero)
-- CREATE DATABASE viveros;
-- \c viveros;

----------------------------------------------------
-- 1. CREACIÓN DE TABLAS Y RESTRICCIONES
----------------------------------------------------

CREATE TABLE VIVERO (
    Id_Vivero INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Latitud NUMERIC(9,6),
    Longitud NUMERIC(9,6)
);

CREATE TABLE ZONA (
    Id_Zona INT,
    Id_Vivero INT,
    Latitud NUMERIC(9,6),
    Longitud NUMERIC(9,6),
    PRIMARY KEY (Id_Zona, Id_Vivero),
    FOREIGN KEY (Id_Vivero) REFERENCES VIVERO(Id_Vivero) ON DELETE CASCADE
);

CREATE TABLE PRODUCTO (
    Id_Producto VARCHAR(20) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Precio NUMERIC(10,2) CHECK (Precio >= 0)
);

CREATE TABLE ALOJA_STOCK (
    Id_Zona INT,
    Id_Vivero INT, -- Añadido para completar la FK compuesta a ZONA
    Id_Producto VARCHAR(20),
    Cantidad INT CHECK (Cantidad >= 0),
    PRIMARY KEY (Id_Zona, Id_Vivero, Id_Producto),
    FOREIGN KEY (Id_Zona, Id_Vivero) REFERENCES ZONA(Id_Zona, Id_Vivero) ON DELETE CASCADE,
    FOREIGN KEY (Id_Producto) REFERENCES PRODUCTO(Id_Producto) ON DELETE CASCADE
);

CREATE TABLE TAREA (
    Id_Tarea VARCHAR(50) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT
);

CREATE TABLE EMPLEADO (
    Id_Empleado VARCHAR(12) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);

CREATE TABLE HISTORICO_DESTINO (
    Id_Empleado VARCHAR(12),
    Fecha_Inicio DATE,
    Id_Tarea VARCHAR(50),
    Id_Zona INT,
    Id_Vivero INT, -- Añadido para completar la FK compuesta a ZONA
    Fecha_Fin DATE,
    Puesto VARCHAR(50),
    Productividad NUMERIC(3,1) CHECK (Productividad >= 0.0 AND Productividad <= 100.0),
    PRIMARY KEY (Id_Empleado, Fecha_Inicio, Id_Tarea),
    FOREIGN KEY (Id_Empleado) REFERENCES EMPLEADO(Id_Empleado) ON DELETE CASCADE,
    FOREIGN KEY (Id_Tarea) REFERENCES TAREA(Id_Tarea) ON DELETE CASCADE,
    FOREIGN KEY (Id_Zona, Id_Vivero) REFERENCES ZONA(Id_Zona, Id_Vivero) ON DELETE SET NULL
);

CREATE TABLE CLIENTE (
    Id_Cliente INT PRIMARY KEY,
    Fecha_Registro DATE NOT NULL,
    Volumen_Compras NUMERIC(10,2) DEFAULT 0.00 CHECK (Volumen_Compras >= 0)
);

CREATE TABLE SUSCRIPTOR (
    Id_Cliente INT PRIMARY KEY,
    Fecha_Ingreso DATE NOT NULL,
    Fecha_Salida DATE,
    Bonificaciones NUMERIC(10,2) DEFAULT 0.00 CHECK (Bonificaciones >= 0),
    FOREIGN KEY (Id_Cliente) REFERENCES CLIENTE(Id_Cliente) ON DELETE CASCADE
);

CREATE TABLE PEDIDO (
    Id_Pedido INT PRIMARY KEY,
    Id_Cliente INT,
    Id_Empleado VARCHAR(12),
    Importe_Total NUMERIC(10,2) DEFAULT 0.00, -- Derivado de la tabla CONTIENE
    FOREIGN KEY (Id_Cliente) REFERENCES CLIENTE(Id_Cliente) ON DELETE SET NULL,
    FOREIGN KEY (Id_Empleado) REFERENCES EMPLEADO(Id_Empleado) ON DELETE SET NULL
);

CREATE TABLE CONTIENE (
    Id_Pedido INT,
    Id_Producto VARCHAR(20),
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    Precio_Venta NUMERIC(10,2) NOT NULL CHECK (Precio_Venta >= 0),
    PRIMARY KEY (Id_Pedido, Id_Producto),
    FOREIGN KEY (Id_Pedido) REFERENCES PEDIDO(Id_Pedido) ON DELETE CASCADE,
    FOREIGN KEY (Id_Producto) REFERENCES PRODUCTO(Id_Producto) ON DELETE CASCADE
);

----------------------------------------------------
-- 2. INSERCIÓN DE DATOS (Mínimo 5 por tabla)
----------------------------------------------------

INSERT INTO VIVERO (Id_Vivero, Nombre, Latitud, Longitud) VALUES
(1, 'Vivero Norte', 28.4933, -16.3155),
(2, 'Vivero Sur', 28.0519, -16.5658),
(3, 'Vivero Este', 28.3245, -16.4251),
(4, 'Vivero Oeste', 28.3840, -16.7112),
(5, 'Vivero Central', 28.4022, -16.5511);

INSERT INTO ZONA (Id_Zona, Id_Vivero, Latitud, Longitud) VALUES
(1, 1, 28.4934, -16.3156),
(2, 1, 28.4935, -16.3157),
(1, 2, 28.0520, -16.5659),
(2, 2, 28.0521, -16.5660),
(1, 3, 28.3246, -16.4252);

INSERT INTO PRODUCTO (Id_Producto, Nombre, Precio) VALUES
('P001', 'Ficus', 15.50),
('P002', 'Rosal', 8.20),
('P003', 'Abono Universal 5L', 12.00),
('P004', 'Maceta Terracota', 5.50),
('P005', 'Orquídea', 22.00);

INSERT INTO ALOJA_STOCK (Id_Zona, Id_Vivero, Id_Producto, Cantidad) VALUES
(1, 1, 'P001', 50),
(2, 1, 'P002', 120),
(1, 2, 'P003', 200),
(2, 2, 'P004', 80),
(1, 3, 'P005', 30);

INSERT INTO TAREA (Id_Tarea, Nombre, Descripcion) VALUES
('T001', 'Riego', 'Regar todas las plantas de la zona asignada'),
('T002', 'Poda', 'Podar arbustos y rosales'),
('T003', 'Abonado', 'Añadir abono según especificaciones'),
('T004', 'Inventario', 'Contar stock de productos disponibles'),
('T005', 'Atención Cliente', 'Atender dudas y ventas en zona');

INSERT INTO EMPLEADO (Id_Empleado, Nombre) VALUES
('EMP001', 'Ana Sánchez'),
('EMP002', 'Luis Pérez'),
('EMP003', 'Carmen Ruiz'),
('EMP004', 'Jorge Díaz'),
('EMP005', 'Marta Gómez');

INSERT INTO HISTORICO_DESTINO (Id_Empleado, Fecha_Inicio, Id_Tarea, Id_Zona, Id_Vivero, Fecha_Fin, Puesto, Productividad) VALUES
('EMP001', '2026-01-10', 'T001', 1, 1, '2026-01-20', 'Jardinero', 85.5),
('EMP002', '2026-02-15', 'T002', 2, 1, NULL, 'Podador', 90.0),
('EMP003', '2026-03-01', 'T004', 1, 2, '2026-03-05', 'Almacenero', 95.0),
('EMP004', '2026-04-10', 'T005', NULL, NULL, NULL, 'Asesor', 88.0), -- Ejemplo donde Id_Zona es nulo
('EMP005', '2026-05-20', 'T003', 1, 3, '2026-06-20', 'Jardinero', 82.5);

INSERT INTO CLIENTE (Id_Cliente, Fecha_Registro, Volumen_Compras) VALUES
(101, '2025-11-15', 150.00),
(102, '2026-01-22', 450.50),
(103, '2026-05-10', 0.00),
(104, '2025-08-30', 890.00),
(105, '2026-09-01', 45.00);

INSERT INTO SUSCRIPTOR (Id_Cliente, Fecha_Ingreso, Fecha_Salida, Bonificaciones) VALUES
(101, '2025-11-15', NULL, 15.00),
(102, '2026-01-22', NULL, 45.00),
(104, '2025-08-30', '2026-10-01', 89.00),
(105, '2026-09-01', NULL, 4.50),
(103, '2026-05-10', '2026-06-10', 0.00);

INSERT INTO PEDIDO (Id_Pedido, Id_Cliente, Id_Empleado, Importe_Total) VALUES
(1001, 101, 'EMP004', 31.00),
(1002, 102, 'EMP004', 16.40),
(1003, 104, 'EMP005', 12.00),
(1004, NULL, 'EMP001', 22.00), -- Pedido de cliente anónimo/no registrado
(1005, 105, 'EMP004', 11.00);

INSERT INTO CONTIENE (Id_Pedido, Id_Producto, Cantidad, Precio_Venta) VALUES
(1001, 'P001', 2, 15.50),
(1002, 'P002', 2, 8.20),
(1003, 'P003', 1, 12.00),
(1004, 'P005', 1, 22.00),
(1005, 'P004', 2, 5.50);

----------------------------------------------------
-- 3. EJEMPLOS DE OPERACIONES DELETE REPRESENTATIVAS
----------------------------------------------------

-- Ejemplo A: Borrar un vivero. 
-- Al tener ON DELETE CASCADE, también borrará sus ZONAS correspondientes y el stock en ALOJA_STOCK.
DELETE FROM VIVERO WHERE Id_Vivero = 5;

-- Ejemplo B: Borrar un producto.
-- Al tener ON DELETE CASCADE, borrará las entradas correspondientes en ALOJA_STOCK y CONTIENE.
DELETE FROM PRODUCTO WHERE Id_Producto = 'P005';

-- Ejemplo C: Borrar un cliente.
-- Borrará la entrada de SUSCRIPTOR (Cascade) pero dejará los PEDIDOS asociados con Id_Cliente a NULL (Set Null).
DELETE FROM CLIENTE WHERE Id_Cliente = 104;

-- Ejemplo D: Borrar un registro histórico específico.
DELETE FROM HISTORICO_DESTINO WHERE Id_Empleado = 'EMP001' AND Fecha_Inicio = '2026-01-10' AND Id_Tarea = 'T001';

-- Ejemplo E: Borrar un empleado.
-- Por Cascade se borrará su HISTORICO_DESTINO. En PEDIDO, su Id_Empleado se volverá NULL.
DELETE FROM EMPLEADO WHERE Id_Empleado = 'EMP003';
