fs = require('fs')
var request = require("request-promise");

document.getElementById('add-new-inventory-button').addEventListener('click', () => {
    var new_inventory_capacity = document.getElementById('new-inventory-capacity').value
    var new_inventory_location = document.getElementById('new-inventory-location').value
    var new_inventory_staffid = document.getElementById('new-inventory-staffid').value

    var options = {
        method: 'POST',
        url: 'http://127.0.0.1:5050/newinventory',
        params: { inventory_capacity: new_inventory_capacity, inventory_location: new_inventory_location, inventory_staffid: new_inventory_staffid}
    }
 request(options)
})

function insert_row() {
    let table = document.getElementById('inventory-table-body')
    let first_row = table.firstElementChild
    clone = first_row.cloneNode(true)
    clone.removeAttribute('example-row')
    table.append(clone)
}