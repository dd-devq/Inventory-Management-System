fs = require('fs')
var request = require("request-promise");

document.getElementById('add-new-staff-button').addEventListener('click', () => {
    var new_staff_name = document.getElementById('new-staff-name').value
    var new_staff_phone = document.getElementById('new-staff-phone').value
    var new_manager_id = document.getElementById('new-manager-id').value
    var new_inventory_id = document.getElementById('new-inventory-id').value

    var options = {
        method: 'POST',
        url: 'http://127.0.0.1:5050/newstaff',
        params: { staff_name: new_staff_name, staff_phone: new_staff_phone, manager_id: new_manager_id, inventory_id: new_inventory_id }
    }
 request(options)
})

function insert_row() {
    let table = document.getElementById('staff-table-body')
    let first_row = table.firstElementChild
    clone = first_row.cloneNode(true)
    clone.removeAttribute('example-row')
    table.append(clone)
}