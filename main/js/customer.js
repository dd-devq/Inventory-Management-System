fs = require('fs')
const axios = require("axios");

document.getElementById('add-new-customer-button').addEventListener('click', () => {
    var new_customer_name = document.getElementById('new-customer-name').value
    var new_customer_phone = document.getElementById('new-customer-phone').value
    var new_customer_location = document.getElementById('new-customer-location').value

    // var options = {
    //     method: 'POST',
    //     url: 'http://127.0.0.1:5050/newcustomer',
    //     params: { customer_name: new_customer_name, customer_phone: new_customer_phone, customer_location: new_customer_location }
    // }

    axios.post("http://127.0.0.1:5050/newcustomer", {
        customer_name: new_customer_name, customer_phone: new_customer_phone, customer_location: new_customer_location
    }).then((response) => {
        console.log("Server response: ", response.data);
    }).catch((error) => {
        console.error(error);
    });

})

function insert_row() {
    let table = document.getElementById('customer-table-body')
    let first_row = table.firstElementChild
    clone = first_row.cloneNode(true)
    clone.removeAttribute('example-row')
    table.append(clone)
}