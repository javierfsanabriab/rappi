/*---------------------------------------------------------------------------------------------------------
 Autor      : Javier F. Sanabria
 Fecha      : Septiembre 30 de 2025
 Función    : Archivo para creación de tablas y carga de datos
---------------------------------------------------------------------------------------------------------*/

----------------------------------------------------------------------------------------------------------
-- Crear estructuras de tablas Accounts & JournalEntries
----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------
-- 1. CREAR TABLAS
----------------------------------------------------------------------------------------------------------
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 1a. Accounts
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CREATE TABLE Accounts (
    account_number NVARCHAR(3) NOT NULL,
	account_name NVARCHAR(25) NOT NULL
)
GO

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 1b. JournalEntries
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CREATE TABLE JournalEntries (
    transaction_id NVARCHAR(3) NOT NULL,
	transaction_date NVARCHAR(25) NOT NULL,
	account_number NVARCHAR(5) NOT NULL,
	amount NVARCHAR(5) NOT NULL
)
GO

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 1c. JournalEntriesReport
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CREATE TABLE JournalEntriesReport (
    transaction_id NVARCHAR(3) NOT NULL,
	transaction_date NVARCHAR(25) NOT NULL,
	account_number NVARCHAR(5) NOT NULL,
	account_name NVARCHAR(25),
	debit_amount FLOAT,
	credit_amount FLOAT,
	is_valid_transaction BIT
)
GO


----------------------------------------------------------------------------------------------------------
-- Sección 1: Análisis y Transformación de Datos (SQL)
----------------------------------------------------------------------------------------------------------

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 1a. Importar datos del archivo accounts.csv a la Tabla Accounts
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
BULK INSERT Accounts
FROM 'C:\Prueba Técnica\accounts.csv'
WITH
(
 FORMAT = 'CSV',
 FIRSTROW = 2
)
GO

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 1b. Importar datos del archivo journal_entries.csv a la Tabla JournalEntries
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
BULK INSERT JournalEntries
FROM 'C:\Prueba Técnica\journal_entries.csv'
WITH
(
 FORMAT='CSV',
 FIRSTROW=2
)
GO

--drop table Accounts
--DROP TABLE JournalEntriesReport
--TRUNCATE TABLE JournalEntriesReport
--select * from JournalEntries
--EXEC sp_rename 'Account', 'Accounts';

