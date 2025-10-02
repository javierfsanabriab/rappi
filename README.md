# rappi
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Prueba Técnica para Data Engineer: Migración de Datos Financieros
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

El repositorio contiene los siguientes archivos con su respectiva funcionalidad:

Motor de base de datos: SQL Server

Archivos SQL:
Script Seccion1.sql --> Creación de estructuras de las tablas Accounts y JournalEntries | Importar datos de archivos planos csv.
Script Seccion2.sql --> Creación de procedimientos almacenados para la transformación de registros.

Lógica de la implementación de Pyhon:
data_migration_flow.py --> Archivo Python que permite ejecutar los procedimientos almacenados desde SQL Server.
data_migration_dag.py --> Archivo Python DAG para orquestar el flujo de trabajo de la migración.

Archivos proporcionados:
journal_entries.csv: Archivo con registros contables de transacciones.
accounts.csv: Archivo con información del plan de cuentas contables.



