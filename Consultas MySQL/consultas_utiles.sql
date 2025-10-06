/*
Materia: Desarrollo Web
Trabajo Práctico Nro 2

Profesor Titular Disciplinar: Pablo Alejandro Virgolini
Titular Experto: Hugo Fernando Frias
Alumno: Lucas Leonardo Paez
Legajo: VINF016138
*/

-- Listar todos los turnos con cliente, empleado y servicios (servicios concatenados)
SELECT
  t.idTurno,
  c.nombre AS cliente,
  e.nombre AS empleado,
  t.fechaHora,
  t.estado,
  t.total,
  GROUP_CONCAT(s.nombre SEPARATOR ', ') AS servicios
FROM Turno t
LEFT JOIN Cliente c ON t.idCliente = c.idCliente
LEFT JOIN Empleado e ON t.idEmpleado = e.idEmpleado
LEFT JOIN Turno_Servicio ts ON t.idTurno = ts.idTurno
LEFT JOIN Servicio s ON ts.idServicio = s.idServicio
GROUP BY t.idTurno, c.nombre, e.nombre, t.fechaHora, t.estado, t.total
ORDER BY t.fechaHora DESC;


-- Detalle de una venta (cabecera + detalle con productos)
SELECT vp.idVenta, vp.fecha, vp.total, vd.idProducto, p.nombre AS producto, vd.cantidad, vd.precioUnitario
FROM VentaProducto vp
JOIN Venta_Detalle vd ON vp.idVenta = vd.idVenta
JOIN Producto p ON vd.idProducto = p.idProducto
WHERE vp.idVenta = 1;

-- Productos con stock por debajo del mínimo
SELECT idProducto, nombre, stock, stockMinimo
FROM Producto
WHERE stock <= stockMinimo
ORDER BY stock ASC;

-- Ingresos agrupados por mes y tipo
SELECT DATE_FORMAT(fecha,'%Y-%m') AS mes, tipo, SUM(monto) AS total_mes
FROM Ingreso
GROUP BY mes, tipo
ORDER BY mes DESC, tipo;

-- Egresos agrupados por tipo
SELECT tipo, SUM(monto) AS total_egresos
FROM Egreso
GROUP BY tipo;

-- Balance mensual (ingresos - egresos) — para meses presentes en Ingreso/Egreso
SELECT
  m.mes,
  IFNULL(i.total_ingresos,0) AS ingresos,
  IFNULL(e.total_egresos,0) AS egresos,
  IFNULL(i.total_ingresos,0) - IFNULL(e.total_egresos,0) AS balance
FROM (
  SELECT DISTINCT DATE_FORMAT(fecha,'%Y-%m') AS mes FROM (
    SELECT fecha FROM Ingreso
    UNION
    SELECT fecha FROM Egreso
  ) AS u
) m
LEFT JOIN (
  SELECT DATE_FORMAT(fecha,'%Y-%m') AS mes, SUM(monto) AS total_ingresos
  FROM Ingreso GROUP BY mes
) i ON m.mes = i.mes
LEFT JOIN (
  SELECT DATE_FORMAT(fecha,'%Y-%m') AS mes, SUM(monto) AS total_egresos
  FROM Egreso GROUP BY mes
) e ON m.mes = e.mes
ORDER BY m.mes DESC;

-- Historial de turnos por cliente
SELECT t.idTurno, t.fechaHora, t.estado, t.total
FROM Turno t
WHERE t.idCliente = 1
ORDER BY t.fechaHora DESC;

-- Calcular total de servicios de un turno (para comprobación)
SELECT t.idTurno,
       COALESCE(SUM(s.precio),0) AS total_servicios
FROM Turno t
LEFT JOIN Turno_Servicio ts ON t.idTurno = ts.idTurno
LEFT JOIN Servicio s ON ts.idServicio = s.idServicio
WHERE t.idTurno = 1
GROUP BY t.idTurno;
