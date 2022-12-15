import os
import sqlite3
import json
from sqlite3 import *
conn = None
default_inventory = 'INV0'

counter = 0
relative_db_path = 'database/inventory.db'

# NOTE: Utils


def connect():
    root = os.path.dirname(os.path.realpath(__file__))
    database = os.path.join(root, relative_db_path)
    try:
        conn = sqlite3.connect(database, check_same_thread=False)
        return conn
    except Error as err:
        print(err)


def execute_sql_script(filename):
    with open(filename, 'r') as sql_file:
        sql = sql_file.read()
    cursor.executescript(sql)
    conn.commit()


def execute_create_query(query):
    try:
        cursor.execute(query)
    except sqlite3.IntegrityError as err:
        print(err)
        return False
    conn.commit()
    print('Success')
    return True


def execute_update_query(query):
    try:
        cursor.execute(query)
    except sqlite3.Error as err:
        print(err)
        return False
    conn.commit()
    print('Success')
    return True


def execute_read_query(query):
    try:
        cursor.execute(query)
        return cursor.fetchall()
    except sqlite3.IntegrityError as err:
        print(err)
        return None
    return None


def generate_el_id(mfr_name, el_series, el_type):
    el_id = mfr_name[0:3] + '-' + el_type + '-' + el_series
    return el_id


# NOTE: Insert Section


def insert_electronics(el_type, el_series, el_stock, inv_id, mfr_name):
    el_id = generate_el_id(mfr_name, el_series, el_type)
    query = f"INSERT INTO electronics VALUES ('{el_id}', '{el_type}', '{el_series}', '{el_stock}', '{inv_id}', '{mfr_name}')"
    execute_create_query(query)


def insert_customer(cust_id, cust_name, cust_phone, cust_location):
    query = f"INSERT INTO customer VALUES ('{cust_id}','{cust_name}', '{cust_phone}', '{cust_location}');"
    execute_create_query(query)


def insert_staff(stf_id, stf_name, stf_phone, mgr_id, inv_id):
    query = f"INSERT INTO staff VALUES ('{stf_id}','{stf_name}', '{stf_phone}', '{mgr_id}', '{inv_id}');"
    execute_create_query(query)


def insert_inventory(inv_id, inv_capacity, inv_location, stf_id=None):
    if stf_id == None:
        query = f"INSERT INTO inventory (inv_id, inv_capacity, inv_location) VALUES ('{inv_id}', '{inv_capacity}', '{inv_location}');"
    else:
        query = f"INSERT INTO inventory VALUES ('{inv_id}', '{inv_capacity}', '{inv_location}', '{stf_id}');"
    execute_create_query(query)


def insert_manager(mgr_id, mgr_name, mgr_phone):
    query = f"INSERT INTO manager VALUES ('{mgr_id}','{mgr_name}', '{mgr_phone}');"
    execute_create_query(query)


def insert_manufacturer(key, name):
    query = f"INSERT INTO manufacturer VALUES ('{key}','{name}');"
    execute_create_query(query)


def insert_order(ord_id, ord_date, ord_note, ord_status, mfr_name, mgr_id, order):
    if len(order) == 0:
        print('Invalid Order!')
        return
    else:
        query = f"INSERT INTO order_note VALUES ('{ord_id}','{ord_date}', '{ord_note}', '{ord_status}', '{mfr_name}', '{mgr_id}');"
        execute_create_query(query)
        for i in range(len(order)):
            el_series = order[i][2]
            el_type = order[i][1]
            quantity = order[i][3]
            el_id = generate_el_id(mfr_name, el_series, el_type)
            query = f"INSERT INTO temp_ord (ord_id, el_id, quantity) VALUES ('{ord_id}', '{el_id}', '{quantity}');"
            execute_create_query(query)
            if read_db('electronics', 'el_id', el_id) == 0:
                insert_electronics(el_type, el_series, 0,
                                   default_inventory, mfr_name)


def insert_receive_note(rcv_id, rcv_date, rcv_note, rcv_status, ord_id, inv_id, rcv_electronics):
    if len(rcv_electronics) == 0:
        print('Invalid Note')
        return
    else:
        query = f"INSERT INTO receive_note VALUES ('{rcv_id}', '{rcv_date}', '{rcv_note}', '{rcv_status}', '{ord_id}', '{inv_id}');"
        execute_create_query(query)
        for i in range(len(rcv_electronics)):
            mfr_name = rcv_electronics[i][0]
            el_series = rcv_electronics[i][2]
            el_type = rcv_electronics[i][1]
            quantity = rcv_electronics[i][3]
            el_id = generate_el_id(mfr_name, el_series, el_type)
            query = f"INSERT INTO temp_rcv (rcv_id, ord_id, el_id, quantity) VALUES ('{rcv_id}', '{ord_id}','{el_id}', '{quantity}');"
            execute_create_query(query)


# NOTE: Update Section

def update_db(table, columns_mod, values, column_con, condition):
    if len(columns_mod) != len(values):
        print("Invalid Update")
        return False
    query = f"UPDATE {table} SET "
    condition = f"WHERE {column_con} = '{condition}';"
    if len(columns_mod) != 1:
        index = 0
        for i in range(len(columns_mod) - 1):
            temp_update = f"{columns_mod[i]} = '{values[i]}', "
            query += temp_update
            index = i
        temp_update = f"{columns_mod[index + 1]} = '{values[index + 1]}' "
        query += temp_update
    else:
        temp_update = f"{columns_mod[0]} = '{values[0]}' "
        query += temp_update
    query += condition
    print(query)
    execute_update_query(query)


# NOTE: Delete Section

# NOTE: Read Section


def read_db(table, column, condition):
    query = f"SELECT * FROM {table} WHERE {column} = '{condition}'"
    obj = execute_read_query(query)
    return len(obj)

# NOTE: Data Section


def make_manufacture():
    insert_manufacturer('ASU', 'ASUS')
    insert_manufacturer('MSI', 'MSI')
    insert_manufacturer('NVI', 'NVIDIA')
    insert_manufacturer('GIG', 'GIGABYTE')
    insert_manufacturer('AMD', 'AMD')
    insert_manufacturer('INT', 'INTEL')


def make_manager():
    insert_manager('MGR1', 'Danh', '123-123-123-123')
    insert_manager('MGR2', 'Phuong', '231-165-397-756')
    insert_manager('MGR3', 'An', '943-763-643-435')
    insert_manager('MGR4', 'Bach', '534-654-232-654')
    insert_manager('MGR5', 'Hoang', '121-435-453-345')


def make_customer():
    insert_customer('CUST1', 'Guest 1', '229-167-123-423', 'Vietnam')
    insert_customer('CUST2', 'Guest 2', '239-165-327-456', 'Vietnam')
    insert_customer('CUST3', 'Guest 3', '249-763-623-465', 'Vietnam')
    insert_customer('CUST4', 'Guest 4', '239-668-222-434', 'Vietnam')
    insert_customer('CUST5', 'Guest 5', '219-465-323-425', 'Vietnam')


def make_staff():
    insert_staff('STF1', 'NPC1', '123-127-183-123', 'MGR1', 'INV2')
    insert_staff('STF2', 'NPC2', '231-125-347-756', 'MGR2', 'INV3')
    insert_staff('STF3', 'NPC3', '943-743-663-465', 'MGR3', 'INV1')
    insert_staff('STF4', 'NPC4', '534-678-272-634', 'MGR4', 'INV5')
    insert_staff('STF5', 'NPC5', '111-425-323-325', 'MGR5', 'INV4')


def make_inventory():
    insert_inventory(
        'INV1', 0, 'Ly Thuong Kiet, District 10, Ho Chi Minh City')
    insert_inventory(
        'INV2', 0, 'Thanh Thai, District 10, Ho Chi Minh City')
    insert_inventory(
        'INV3', 0, 'Cach Mang Thang Tam, District 10, Ho Chi Minh City')
    insert_inventory(
        'INV4', 0, 'Dien Bien Phu, District 10, Ho Chi Minh City')
    insert_inventory(
        'INV5', 0, 'Ly Thai To, District 10, Ho Chi Minh City')


def make_order():
    order_1 = [['ASUS', 'LAPTOP', 'ZephyrG14', 175],
               ['ASUS', 'MOTHERBOARD', 'Z690', 107], ['ASUS', 'MONITOR', 'PROART', 184]]

    order_2 = [['AMD', 'CPU', 'ZEN', 104], ['AMD', 'GPU', '6070', 127]]

    order_3 = [['MSI', 'LAPTOP', 'KATANA', 187],
               ['MSI', 'MOTHERBOARD', 'Z590', 136]]

    order_4 = [['GIGABYTE', 'LAPTOP', 'AERO', 161],
               ['GIGABYTE', 'GPU', '3070', 198]]

    order_5 = [['INTEL', 'CPU', '12', 185], ['INTEL', 'GPU', 'ARC', 200]]

    order_6 = [['NVIDIA', 'GPU', '3070', 109], [
        'NVIDIA', 'GPU', '3090', 133], ['NVIDIA', 'GPU', '4090', 133]]

    order_7 = [['GIGABYTE', 'MOTHERBOARD', 'B590', 113],
               ['GIGABYTE', 'MONITOR', 'AORUS', 136]]

    insert_order('ORD1', '2022-01-04', 'Handle with care!',
                 'Processing', 'ASUS', 'MGR1', order_1)
    insert_order('ORD2', '2022-02-21', 'Handle with care!',
                 'Processing', 'AMD', 'MGR2', order_2)
    insert_order('ORD3', '2022-03-19', 'Handle with care!',
                 'Processing', 'MSI', 'MGR3', order_3)
    insert_order('ORD4', '2022-06-16', 'ASAP',
                 'Processing', 'GIGABYTE', 'MGR3', order_4)
    insert_order('ORD5', '2022-09-08', 'None',
                 'Processing', 'INTEL', 'MGR4', order_5)
    insert_order('ORD6', '2022-10-27', 'Handle with care!',
                 'Processing', 'NVIDIA', 'MGR5', order_6)
    insert_order('ORD7', '2022-12-23', 'None',
                 'Processing', 'GIGABYTE', 'MGR2', order_7)


def make_receive_note():
    rcv_electronics_1_p1 = [['ASUS', 'LAPTOP', 'ZephyrG14', 75],
                            ['ASUS', 'MOTHERBOARD', 'Z690', 70], ['ASUS', 'MONITOR', 'PROART', 100]]

    rcv_electronics_1_p2 = [['ASUS', 'LAPTOP', 'ZephyrG14', 100],
                            ['ASUS', 'MOTHERBOARD', 'Z690', 37], ['ASUS', 'MONITOR', 'PROART', 84]]

    rcv_electronics_2 = [['AMD', 'CPU', 'ZEN', 104],
                         ['AMD', 'GPU', '6070', 127]]

    rcv_electronics_3_p1 = [['MSI', 'MOTHERBOARD', 'Z590', 136]]

    rcv_electronics_3_p2 = [['MSI', 'LAPTOP', 'KATANA', 187]]

    rcv_electronics_4 = [['GIGABYTE', 'LAPTOP', 'AERO', 161],
                         ['GIGABYTE', 'GPU', '3070', 198]]

    rcv_electronics_5 = [['INTEL', 'CPU', '12', 185],
                         ['INTEL', 'GPU', 'ARC', 200]]

    rcv_electronics_6_p1 = [['NVIDIA', 'GPU', '3070', 109],
                            ['NVIDIA', 'GPU', '3090', 133]]

    rcv_electronics_6_p2 = [['NVIDIA', 'GPU', '4090', 133]]

    rcv_electronics_7_p1 = [['GIGABYTE', 'MOTHERBOARD', 'B590', 73],
                            ['GIGABYTE', 'MONITOR', 'AORUS', 100]]

    rcv_electronics_7_p2 = [['GIGABYTE', 'MOTHERBOARD', 'B590', 40],
                            ['GIGABYTE', 'MONITOR', 'AORUS', 36]]

    insert_receive_note('RCV1', '2022/01/10', 'None', 'Finished',
                        'ORD1', 'INV1', rcv_electronics_1_p1)
    insert_receive_note('RCV2', '2022/01/20', 'None', 'Finished',
                        'ORD1', 'INV1', rcv_electronics_1_p2)

    insert_receive_note('RCV3', '2022/03/05', 'None', 'Finished',
                        'ORD2', 'INV3', rcv_electronics_2)

    insert_receive_note('RCV4', '2022/03/25', 'None', 'Finished',
                        'ORD3', 'INV5', rcv_electronics_3_p1)
    insert_receive_note('RCV5', '2022/4/01', 'None', 'Finished',
                        'ORD3', 'INV5', rcv_electronics_3_p2)

    insert_receive_note('RCV6', '2022/06/29', 'None', 'Finished',
                        'ORD4', 'INV2', rcv_electronics_4)

    insert_receive_note('RCV8', '2022/09/27', 'None', 'Finished',
                        'ORD5', 'INV1', rcv_electronics_5)

    insert_receive_note('RCV9', '2022/01/10', 'None', 'Finished',
                        'ORD6', 'INV4', rcv_electronics_6_p1)
    insert_receive_note('RCV10', '2022/01/20', 'None', 'Finished',
                        'ORD6', 'INV4', rcv_electronics_6_p2)

    insert_receive_note('RCV11', '2022/01/10', 'None', 'Finished',
                        'ORD7', 'INV5', rcv_electronics_7_p1)
    insert_receive_note('RCV12', '2022/01/20', 'None', 'Finished',
                        'ORD7', 'INV5', rcv_electronics_7_p2)


def start():
    global conn, cursor
    conn = connect()
    cursor = conn.cursor()
    execute_sql_script('sql/inventory.sql')


if __name__ == '__main__':
    start()
    make_manufacture()
    make_manager()
    make_customer()
    make_inventory()
    make_staff()
    make_order()
    make_receive_note()


def insert_delivery_note(del_id, order_date, delivery_date, note, status, cust_id, mgr_id, del_electronics):
    query = f"INSERT INTO delivery VALUES ('{del_id}', '{order_date}', '{delivery_date}', '{note}', '{status}', '{cust_id}', '{mgr_id}');"
    execute_create_query(query)
