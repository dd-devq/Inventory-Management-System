fs = require('fs')

var request = require('request-promise');

function read_db() {
    var options = {
        url: 'http://127.0.0.1:5050/read_tables',
    }
    request(options)
        .then(function (repos) {
            console.log('User has %d repos', repos.length);
            console.log(repos)
            for (let i = 0; i < repos.length; i++) {
                insert_row(repos[i][0], repos[i][1], repos[i][2], repos[i][3]);
            }
        })
        .catch(function (err) {
            console.log(err)
        });
}



document.getElementById('add-new-customer-button').addEventListener('click', () => {
    var new_customer_id = document.getElementById('new-customer-id').value
    var new_customer_name = document.getElementById('new-customer-name').value
    var new_customer_phone = document.getElementById('new-customer-phone').value
    var new_customer_location = document.getElementById('new-customer-location').value

    var options = {
        method: 'POST',
        url: 'http://127.0.0.1:5050/new_customer',
        params: { customer_id: new_customer_id, customer_name: new_customer_name, customer_phone: new_customer_phone, customer_location: new_customer_location }
    }
    request(options)
})

function insert_row(id, name, phone, location) {
    let table = document.getElementById('customer-table-body')
    let first_row = table.firstElementChild

    first_row.getElementsByClassName('id').value = (id)
    first_row.getElementsByClassName('name').value = (name)
    first_row.getElementsByClassName('phone').value = (phone)
    first_row.getElementsByClassName('location').value = (location)
    clone = first_row.cloneNode(true)
    clone.remove('template-row')
    table.append(clone)

}

read_db()