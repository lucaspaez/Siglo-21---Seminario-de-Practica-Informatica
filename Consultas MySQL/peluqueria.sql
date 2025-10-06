/*
Materia: Desarrollo Web
Trabajo Práctico Nro 2

Profesor Titular Disciplinar: Pablo Alejandro Virgolini
Titular Experto: Hugo Fernando Frias
Alumno: Lucas Leonardo Paez
Legajo: VINF016138
*/

-- Script: peluqueria.sql
DROP DATABASE IF EXISTS peluqueria;
CREATE DATABASE peluqueria CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE peluqueria;

-- Tabla Cliente
CREATE TABLE Cliente (
  idCliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  telefono VARCHAR(20),
  email VARCHAR(100),
  direccion VARCHAR(150)
);

-- Tabla Empleado
CREATE TABLE Empleado (
  idEmpleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  especialidad VARCHAR(50),
  usuario VARCHAR(50) UNIQUE,
  password VARCHAR(100),
  rol ENUM('Administrador','Empleado') DEFAULT 'Empleado',
  salarioBase DECIMAL(10,2) DEFAULT 0
);

-- Tabla Proveedor
CREATE TABLE Proveedor (
  idProveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  telefono VARCHAR(20),
  direccion VARCHAR(150)
);

-- Tabla Producto
CREATE TABLE Producto (
  idProducto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  stock DECIMAL(10,2) DEFAULT 0,
  stockMinimo DECIMAL(10,2) DEFAULT 0,
  idProveedor INT NULL,
  FOREIGN KEY (idProveedor) REFERENCES Proveedor(idProveedor)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- Tabla Servicio
CREATE TABLE Servicio (
  idServicio INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  duracion INT NOT NULL, -- minutos
  precio DECIMAL(10,2) NOT NULL
);

-- Tabla Servicio_Producto (fórmula de insumos por servicio)
CREATE TABLE Servicio_Producto (
  idServicio INT NOT NULL,
  idProducto INT NOT NULL,
  cantidad DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (idServicio, idProducto),
  FOREIGN KEY (idServicio) REFERENCES Servicio(idServicio) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (idProducto) REFERENCES Producto(idProducto) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla Turno
CREATE TABLE Turno (
  idTurno INT AUTO_INCREMENT PRIMARY KEY,
  fechaHora DATETIME NOT NULL,
  estado ENUM('Pendiente','Confirmado','Realizado','Cancelado') DEFAULT 'Pendiente',
  idCliente INT NULL,
  idEmpleado INT NULL,
  total DECIMAL(10,2) DEFAULT 0,
  FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Tabla Turno_Servicio (N:M)
CREATE TABLE Turno_Servicio (
  idTurno INT NOT NULL,
  idServicio INT NOT NULL,
  PRIMARY KEY (idTurno, idServicio),
  FOREIGN KEY (idTurno) REFERENCES Turno(idTurno) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (idServicio) REFERENCES Servicio(idServicio) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla VentaProducto (cabecera)
CREATE TABLE VentaProducto (
  idVenta INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATETIME DEFAULT NOW(),
  total DECIMAL(10,2) DEFAULT 0
);

-- Tabla Venta_Detalle
CREATE TABLE Venta_Detalle (
  idVenta INT NOT NULL,
  idProducto INT NOT NULL,
  cantidad INT NOT NULL,
  precioUnitario DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (idVenta, idProducto),
  FOREIGN KEY (idVenta) REFERENCES VentaProducto(idVenta) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (idProducto) REFERENCES Producto(idProducto) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla Ingreso (turno o venta)
CREATE TABLE Ingreso (
  idIngreso INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATETIME DEFAULT NOW(),
  monto DECIMAL(10,2) NOT NULL,
  concepto VARCHAR(150),
  tipo ENUM('Turno','Venta') NOT NULL,
  idTurno INT NULL,
  idVenta INT NULL,
  FOREIGN KEY (idTurno) REFERENCES Turno(idTurno) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (idVenta) REFERENCES VentaProducto(idVenta) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Tabla Egreso (proveedor u honorario)
CREATE TABLE Egreso (
  idEgreso INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATETIME DEFAULT NOW(),
  monto DECIMAL(10,2) NOT NULL,
  concepto VARCHAR(150),
  tipo ENUM('Proveedor','Honorario') NOT NULL,
  idProveedor INT NULL,
  idEmpleado INT NULL,
  FOREIGN KEY (idProveedor) REFERENCES Proveedor(idProveedor) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado) ON DELETE SET NULL ON UPDATE CASCADE
);
