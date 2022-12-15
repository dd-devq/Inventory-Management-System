import crud

import flask
from flask import Flask, request, jsonify

app = Flask(__name__)


@app.route('/newcustomer', methods=['POST'])
def new_customer():
    cust_id = request.form.get('customer_id')
    name = request.form.get('customer_name')
    phone = request.form.get('customer_phone')
    location = request.form.get('customer_location')
    crud.insert_customer(cust_id, name, phone, location)


@app.route('/readcustomer')
def read_customers():
    return crud.read_all_db('customer')


if __name__ == "__main__":
    crud.start()
    app.run(debug=True, port=5050)
