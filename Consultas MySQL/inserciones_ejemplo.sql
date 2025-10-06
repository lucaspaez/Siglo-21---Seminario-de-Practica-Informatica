USE peluqueria;

-- Clientes
INSERT INTO Cliente (nombre, telefono, email, direccion)
VALUES ('María Pérez','11223344','maria@gmail.com','Av. Mitre 123');

-- Empleados
INSERT INTO Empleado (nombre, especialidad, usuario, password, rol, salarioBase)
VALUES ('Laura Gómez','Colorista','lgomez','pass1','Empleado',30000.00),
       ('Carlos Díaz','Administrador','cdiaz','admin123','Administrador',0.00);

-- Proveedores
INSERT INTO Proveedor (nombre, telefono, direccion)
VALUES ('Distribuidora Sur','11221122','Calle 8 445');

-- Productos
INSERT INTO Producto (nombre, precio, stock, stockMinimo, idProveedor)
VALUES ('Shampoo',1500.00,30,5,1),
       ('Acondicionador',1800.00,20,5,1);

-- Servicios
INSERT INTO Servicio (nombre, duracion, precio)
VALUES ('Corte de Cabello',30,2500.00),
       ('Coloración',60,4000.00);

-- Fórmula insumos: Coloración usa 1 Shampoo y 1 Acondicionador
INSERT INTO Servicio_Producto (idServicio,idProducto,cantidad)
VALUES (2,1,1.0),(2,2,1.0);

-- Turno (realizado ejemplo)
INSERT INTO Turno (fechaHora, estado, idCliente, idEmpleado, total)
VALUES ('2025-10-04 10:00:00','Realizado',1,1,2500.00);

INSERT INTO Turno_Servicio (idTurno, idServicio) VALUES (1,1);

-- Ingreso por turno
INSERT INTO Ingreso (fecha, monto, concepto, tipo, idTurno)
VALUES (NOW(),2500.00,'Ingreso por turno realizado','Turno',1);

-- Venta de productos
INSERT INTO VentaProducto (fecha, total) VALUES (NOW(),3300.00);
INSERT INTO Venta_Detalle (idVenta,idProducto,cantidad,precioUnitario)
VALUES (1,1,1,1500.00),(1,2,1,1800.00);

-- Ingreso por venta
INSERT INTO Ingreso (fecha,monto,concepto,tipo,idVenta)
VALUES (NOW(),3300.00,'Venta directa de productos','Venta',1);

-- Egresos: pago a proveedor y pago a empleado (honorarios)
INSERT INTO Egreso (fecha,monto,concepto,tipo,idProveedor)
VALUES (NOW(),5000.00,'Pago a proveedor X','Proveedor',1);

INSERT INTO Egreso (fecha,monto,concepto,tipo,idEmpleado)
VALUES (NOW(),15000.00,'Pago honorarios - Septiembre','Honorario',2);
-- Nota: el INSERT anterior usa idEmpleado=2 (Carlos Díaz) — ajusta si cambias IDs.
