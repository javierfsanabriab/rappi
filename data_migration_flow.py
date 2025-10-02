""" -----------------------------------------------------------------------------
 Autor      : Javier F. Sanabria
 Fecha      : Octubre 1 de 2025
 Función    : Ejecutar consultas de la Sección 1
----------------------------------------------------------------------------- """
import pyodbc 
import pandas as pd

SERVER = 'ODBC Driver 17 for SQL Server'
SERVER_NAME = 'PCJFSB'
DATABASE_NAME = 'pruebas'

try:       
    conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=PCJFSB;'
    'DATABASE=pruebas;'
    'Trusted_Connection=yes;'
    )
    print("Conexión exitosa.")
except pyodbc.Error as ex:       
    sqlstate = ex.args[0]
    print("Error al conectar: {sqlstate}")

cursor = conn.cursor()

""" # Ejecutar primer procedimiento almacenado """
def procedure_name1():
    procedure_name1 = "PA1_TransformarRegistros"
    return cursor.execute("{{CALL {procedure_name1}}}")

""" # Ejecutar segundo procedimiento almacenado """
def procedure_name2():
    procedure_name2 = "PA2_ValidarSaldos"
    return cursor.execute("{{CALL {procedure_name2}}}")

""" # Ejecutar tercer procedimiento almacenado """
def procedure_name3():
    procedure_name3 = "PA3_ResumenCuentas"
    return cursor.execute("{{CALL {procedure_name3}}}")


""" # Ejecutar consulta para traer datos de la tabla JournalEntriesReport """
cursor.execute("SELECT * FROM JournalEntriesReport;")
rows = cursor.fetchall()
for row in rows:
    print(row)

conn.close()

"""
if row:
   print("Versión del servidor SQL: {row[0]}")

if conn:
   conn.close()
   print("Conexión cerrada.")
"""