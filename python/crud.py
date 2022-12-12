import os
import sqlite3
import json
from sqlite3 import *
conn = None

counter = 0
relative_db_path = 'database/inventory.db'


def execute_sql_script(filename):
    with open(filename, 'r') as sql_file:
        sql = sql_file.read()
    cursor.executescript(sql)
    conn.commit()


def connect():
    root = os.path.dirname(os.path.realpath(__file__))
    database = os.path.join(root, relative_db_path)
    try:
        conn = sqlite3.connect(database, check_same_thread=False)
        return conn
    except Error as err:
        print(err)


def create_customer(name, phone, location):
    query = f"INSERT INTO customer (cust_name, cust_phone, cust_location) VALUES ('{name}','{phone}','{location}')"
    cursor.execute(query)
    conn.commit()
    return cursor.lastrowid


def read_customers():
    query = f"SELECT * FROM customer"
    cursor.execute(query)
    json_cust = json.dumps(cursor.fetchall())
    return json_cust


def start():
    global conn, cursor
    conn = connect()
    cursor = conn.cursor()
    execute_sql_script('sql/inventory.sql')
