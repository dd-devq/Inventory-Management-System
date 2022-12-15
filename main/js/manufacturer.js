fs = require('fs')
var request = require("request-promise");

document.getElementById('add-new-manufacturer-button').addEventListener('click', () => {
    var new_manufacturer_name = document.getElementById('new-manufacturer-name').value

    var options = {
        method: 'POST',
        url: 'http://127.0.0.1:5050/newmanufacturer',
        params: { manufacturer_name: new_manufacturer_name }
    }
 request(options)
})

function insert_row() {
    let table = document.getElementById('manufacturer-table-body')
    let first_row = table.firstElementChild
    clone = first_row.cloneNode(true)
    clone.removeAttribute('example-row')
    table.append(clone)
}