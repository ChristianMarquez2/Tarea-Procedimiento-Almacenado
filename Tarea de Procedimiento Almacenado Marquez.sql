--1. Creación de la Tabla de Cliente en PostgreSQL
CREATE TABLE cliente (
    ClienteID SERIAL PRIMARY KEY,  
    Nombre VARCHAR(100),
    Estatura DECIMAL(5,2),
    FechaNacimiento DATE,
    Sueldo DECIMAL(10,2)
);
--2. Ejercicio 1: Procedimiento para seleccionar datos de la tabla cliente
CREATE OR REPLACE FUNCTION seleccionarClientes()
RETURNS TABLE(ClienteID INT, Nombre VARCHAR, Estatura DECIMAL, FechaNacimiento DATE, Sueldo DECIMAL) AS
$$
BEGIN
    RETURN QUERY 
    SELECT c.ClienteID, c.Nombre, c.Estatura, c.FechaNacimiento, c.Sueldo
    FROM cliente c;  -- Alias "c" para la tabla cliente
END;
$$ LANGUAGE plpgsql;


--3. Ejercicio 2: Ejecutar el procedimiento
SELECT * FROM seleccionarClientes();

--4. Procedimiento de Inserción (INSERT)
CREATE OR REPLACE FUNCTION insertarCliente(
    p_nombre VARCHAR(100),
    p_estatura DECIMAL(5,2),
    p_fechaNacimiento DATE,
    p_sueldo DECIMAL(10,2)
)
RETURNS VOID AS
$$
BEGIN
    INSERT INTO cliente (Nombre, Estatura, FechaNacimiento, Sueldo)
    VALUES (p_nombre, p_estatura, p_fechaNacimiento, p_sueldo);
END;
$$ LANGUAGE plpgsql;

SELECT insertarCliente('Juan Pérez', 1.75, '1985-08-10', 30000.00);

--5. Procedimiento de Actualización (UPDATE)
CREATE OR REPLACE FUNCTION actualizarEdadCliente(
    p_clienteID INT,
    p_nuevaEdad INT
)
RETURNS VOID AS
$$
BEGIN
    UPDATE cliente
    SET Edad = p_nuevaEdad
    WHERE ClienteID = p_clienteID;
END;
$$ LANGUAGE plpgsql;

--6. Procedimiento de Eliminación (DELETE)
CREATE OR REPLACE FUNCTION eliminarCliente(
    p_clienteID INT
)
RETURNS VOID AS
$$
BEGIN
    DELETE FROM cliente WHERE ClienteID = p_clienteID;
END;
$$ LANGUAGE plpgsql;
SELECT eliminarCliente(5);  -- Suponiendo que 5 es el ID del cliente a eliminar

--7. Uso de Condicionales (IF) en Procedimientos Almacenados
CREATE OR REPLACE FUNCTION verificarEdadCliente(
    p_clienteID INT
)
RETURNS VOID AS
$$
DECLARE
    clienteEdad INT;
BEGIN
    SELECT EXTRACT(YEAR FROM age(FechaNacimiento)) INTO clienteEdad
    FROM cliente WHERE ClienteID = p_clienteID;
    
    IF clienteEdad >= 22 THEN
        RAISE NOTICE 'El cliente es mayor de 22 años';
    ELSE
        RAISE NOTICE 'El cliente es menor de 22 años';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT verificarEdadCliente(3);  

--8. Creación de la Tabla de Órdenes (con relación con el Cliente)
CREATE TABLE ordenes (
    OrdenID SERIAL PRIMARY KEY,
    ClienteID INT,
    FechaOrden DATE,
    Monto DECIMAL(10,2),
    FOREIGN KEY (ClienteID) REFERENCES cliente(ClienteID)
);

--9. Procedimientos para la Tabla de Órdenes
--Insertar Orden
CREATE OR REPLACE FUNCTION insertarOrden(
    p_clienteID INT,
    p_fechaOrden DATE,
    p_monto DECIMAL(10,2)
)
RETURNS VOID AS
$$
BEGIN
    INSERT INTO ordenes (ClienteID, FechaOrden, Monto)
    VALUES (p_clienteID, p_fechaOrden, p_monto);
END;
$$ LANGUAGE plpgsql;
--Ejecutar el procedimiento de inserción de orden:
SELECT insertarOrden(1, '2025-01-06', 150.00);

--Actualizar Orden
CREATE OR REPLACE FUNCTION actualizarOrden(
    p_ordenID INT,
    p_nuevoMonto DECIMAL(10,2)
)
RETURNS VOID AS
$$
BEGIN
    UPDATE ordenes
    SET Monto = p_nuevoMonto
    WHERE OrdenID = p_ordenID;
END;
$$ LANGUAGE plpgsql;

--Eliminar Orden
CREATE OR REPLACE FUNCTION eliminarOrden(
    p_ordenID INT
)
RETURNS VOID AS
$$
BEGIN
    DELETE FROM ordenes WHERE OrdenID = p_ordenID;
END;
$$ LANGUAGE plpgsql;

--Ejecutar el procedimiento de eliminación de orden:
SELECT eliminarOrden(1);  

--CHRISTIAN MÁRQUEZ
