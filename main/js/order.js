fs = require('fs')
var request = require("request-promise");

document.getElementById('add-new-order-button').addEventListener('click', () => {
    var new_order_receivedate = document.getElementById('new-order-receivedate').value
    var new_order_receivenote = document.getElementById('new-order-receivenote').value
    var new_order_receivestatus = document.getElementById('new-order-receivestatus').value
    var new_order_manufacturerid = document.getElementById('new-order-manufacturerid').value
    var new_order_managerid = document.getElementById('new-order-managerid').value

    var options = {
        method: 'POST',
        url: 'http://127.0.0.1:5050/neworder',
        params: { order_receivedate: new_order_receivedate, order_receivenote: new_order_receivenote, order_receivestatus: new_order_receivestatus, order_manufacturerid: new_order_manufacturerid, order_managerid: new_order_managerid }
    }
 request(options)
})

function insert_row() {
    let table = document.getElementById('order-table-body')
    let first_row = table.firstElementChild
    clone = first_row.cloneNode(true)
    clone.removeAttribute('example-row')
    table.append(clone)
}