import sqlite3


def load_data(filename):
    with open(filename, 'r') as sql_file:
        sql = sql_file.read()
    conn = sqlite3.connect('database/inventory.db')
    database = conn.cursor()
    database.executescript(sql)
    conn.commit()
    conn.close()


load_data('sql/inventory.sql')
