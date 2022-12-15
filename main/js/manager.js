fs = require('fs')
var request = require("request-promise");

document.getElementById('add-new-manager-button').addEventListener('click', () => {
    var new_manager_name = document.getElementById('new-manager-name').value
    var new_manager_phone = document.getElementById('new-manager-phone').value
    

    var options = {
        method: 'POST',
        url: 'http://127.0.0.1:5050/newmanager',
        params: { manager_name: new_manager_name, manager_phone: new_manager_phone }
    }
 request(options)
})

function insert_row() {
    let table = document.getElementById('manager-table-body')
    let first_row = table.firstElementChild
    clone = first_row.cloneNode(true)
    clone.removeAttribute('example-row')
    table.append(clone)
}