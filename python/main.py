import crud
import database

import flask
from flask import Flask, request, jsonify

app = Flask(__name__)


@app.route('/newcustomer', methods=['POST'])
def new_customer():
    name = request.form.get('customer_name')
    phone = request.form.get('customer_phone')
    location = request.form.get('customer_location')
    return str(crud.create_customer(name, phone, location))


@app.route('/readcustomer')
def read_customers():
    return str(crud.read_customers())


if __name__ == "__main__":
    crud.start()
    app.run(debug=True, port=5050)
