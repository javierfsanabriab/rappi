/*--------------------------------------------------------------------------------------------------------
 Autor      : Javier F. Sanabria
 Fecha      : Octubre 1 de 2025
 Función    : Archivo para creación de procedimientos almacenados y validación de reglas de negocio
--------------------------------------------------------------------------------------------------------*/

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 1.	Creación de Procedimiento Almacenado para la transformación de registros
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CREATE PROCEDURE PA1_TransformarRegistros
AS
BEGIN
 DECLARE Cursor1 CURSOR FOR
 SELECT transaction_id, transaction_date, account_number FROM JournalEntries

 /* Tabla auxiliar en memoria para almacenar valores de transformación */
 DECLARE @journals TABLE (
	transaction_id nvarchar(3) NOT NULL,
	transaction_date nvarchar(25) NOT NULL,
	account_number nvarchar(5) NOT NULL,
	debit_amount float NULL,
	credit_amount float NULL,
	is_valid_transaction bit NULL
 ) ;

/* Variables de columnas de la tabla JournalEntries */
 DECLARE @F1 NVARCHAR(3)   -- [transaction_id]
 DECLARE @F2 NVARCHAR(5)   -- [amount]
 DECLARE @F3 NVARCHAR(25)  -- [transaction_date]
 DECLARE @F4 NVARCHAR(5)   -- [account_number]
 /* Variables auxiliares */
 DECLARE @value1 FLOAT
 DECLARE @value2 FLOAT
 DECLARE @total FLOAT
 DECLARE @yearFlag BIT

 OPEN Cursor1
  FETCH NEXT FROM Cursor1 INTO @F1, @F3, @F4
   WHILE @@FETCH_STATUS = 0
    BEGIN
     DECLARE Cursor2 CURSOR FOR
     SELECT amount FROM JournalEntries
     WHERE transaction_id = @F1
     
     OPEN Cursor2    
      FETCH NEXT FROM Cursor2 INTO @F2
       
      WHILE @@FETCH_STATUS = 0
       BEGIN
        SET @value1 =  CAST(@F2 AS FLOAT)
        FETCH NEXT FROM Cursor2 INTO @F2
        SET @value2 =  CAST(@F2 AS FLOAT)
        SET @total =  @value1 + @value2
        
        IF ( SUBSTRING(@F3, 7, 4) <> '2024') 
         BEGIN
          SET @yearFlag = 1
         END
        ELSE
         BEGIN
          SET @yearFlag = 0
         END
        /* Actualizar registros de la tabla auxiliar con valores nuevos según reglas de negocio*/
        INSERT INTO @Journals 
        (transaction_id, transaction_date, account_number, debit_amount, credit_amount, is_valid_transaction)  
        VALUES (@F1, @F3, @F4, @value1, @value2, @yearFlag);
        FETCH NEXT FROM Cursor2 INTO @F2
       END

   FETCH NEXT FROM Cursor1 INTO @F1, @F3, @F4
   CLOSE Cursor2

   
   DEALLOCATE Cursor2
   FETCH NEXT FROM Cursor1 INTO @F1, @F3, @F4
  END
 
  CLOSE Cursor1
  DEALLOCATE Cursor1

  INSERT INTO JournalEntriesReport
  (transaction_id, transaction_date, account_number, debit_amount, credit_amount, is_valid_transaction)
  SELECT transaction_id, transaction_date, account_number, debit_amount, credit_amount, is_valid_transaction  
  FROM @Journals

  /* Actualizar registros de acuerdo a reglas de negocio */
  UPDATE JournalEntriesReport
  SET account_name = (SELECT account_name 
                      FROM Accounts
                      WHERE Accounts.account_number = JournalEntriesReport.account_number)

  UPDATE JournalEntriesReport
  SET is_valid_transaction = 1
  WHERE account_name IS NULL

END

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 2.	Creación de Procedimiento Almacenado para la validación de saldos
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CREATE PROCEDURE PA2_ValidarSaldos
AS
BEGIN
  SELECT TOP 10
    transaction_id,
    transaction_date,
    account_number,
    account_name,
    debit_amount,
    credit_amount,
    is_valid_transaction
  FROM
    JournalEntriesReport
  WHERE
    ABS(debit_amount) <> ABS(credit_amount)
END

GO

-- EXEC PA_ValidarSaldos;


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 3.	Creación de Procedimiento Almacenado para obtener consulta de resumen de cuentas
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CREATE PROCEDURE PA3_ResumenCuentas
AS
BEGIN
  SELECT
   account_name,
   FORMAT(SUM(debit_amount - credit_amount), '###,###,###.00', 'de-de') AS Saldo
  FROM 
   JournalEntriesReport
  WHERE 
   is_valid_transaction = 0
  GROUP BY 
   account_name
  ORDER BY 
   2 DESC
END
GO

-- EXEC PA_ResumenCuentas;