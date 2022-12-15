import crud

import flask
from flask import Flask, request, jsonify

app = Flask(__name__)


@app.route('/new_customer', methods=['POST'])
def new_customer():
    cust_id = request.form.get('customer_id')
    name = request.form.get('customer_name')
    phone = request.form.get('customer_phone')
    location = request.form.get('customer_location')
    crud.insert_customer(cust_id, name, phone, location)


@app.route('/read_tables', methods=['POST', 'GET'])
def read_customers():
    table = 'customer'
    print(table)
    return crud.read_all_db(table)


if __name__ == "__main__":
    crud.start()
    app.run(debug=True, port=5050)
