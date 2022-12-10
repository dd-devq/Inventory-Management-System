import sqlite3
import os
from sqlite3 import *


def connect():
    root = os.path.dirname(os.path.realpath(__file__))
    database = os.path.join(root, 'database/inventory.db')
    db = Path(root + 'database/inventory.db')
    try:
        conn = sqlite3.connect(database)
    except Error as err:
        print(err)


connect()
