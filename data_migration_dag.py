""" -----------------------------------------------------------------------------
 Autor      : Javier F. Sanabria
 Fecha      : Octubre 2 de 2025
 Función    : Sección 2: Orquestación y Lógica de Transformación (Airflow)
----------------------------------------------------------------------------- """
from datetime import timedelta

from airflow import DAG
from airflow.operators.python_operator import PythonOperator    
from airflow.utils.dates import days_ago

import logging
import data_migration_flow

default_args = {
    'owner' : 'airflow',
    'depends_on_past' : False,
    'start_date' : airflow.utils.dates.days_ago(1),
    'email' : ['nicolas.morales@rappi.com'],
    'email_on_failure' : False,
    'email_on_retry' : False,
    'retries' : 1,
    'retry_delay' : timedelta(minutes=5)
}

def transform_records():
    logging.info("Ejecutar función para transformar los datos...")
    data_migration_flow.procedure_name1()
    logging.info("Paso 1 ejecutado.")
                 
def validate_balances():
    logging.info("Ejecutar función para validar los saldos...")
    data_migration_flow.procedure_name2()
    data_migration_flow.procedure_name3()
    logging.info("Paso 2 Ejecutado.")

def generate_report():
    logging.info("Generar reporte...")
    logging.info("Paso 3 ejecutado.")

with DAG (
    'Rappi Migracion Datos',
    default_args=default_args,
    schedule_interval=timedelta(days=1),
    start_date=days_ago(1),
    tags=['data_migration'],
) as dag:
    task1 = PythonOperator (task_id='transform_records', python_callable=transform_records)
    task2 = PythonOperator( task_id='validate_balances', python_callable=validate_balances)
    task3 = PythonOperator( task_id='generate_report', python_callable=generate_report)

    task1 >> task2 >> task3
