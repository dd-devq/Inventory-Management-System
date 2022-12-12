import crud
import database

import flask
from flask import Flask, request, jsonify

app = Flask(__name__)


@app.route('/new_customer')
def new_customer():
    return str(crud.create_customer('Vinh', '123-534-879-234', 'Vietnam'))


@app.route('/read_customer')
def read_customers():
    return str(crud.read_customers())


if __name__ == "__main__":
    crud.start()
    app.run(debug=True, port=5050)
