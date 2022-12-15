fs = require('fs')
var request = require("request-promise");


document.getElementById('add-new-deliverynote-button').addEventListener('click', () => {
    var new_deliverynote_orderdate = document.getElementById('new-deliverynote-orderdate').value
    var new_deliverynote_deliverydate = document.getElementById('new-deliverynote-deliverydate').value
    var new_deliverynote_deliverynote = document.getElementById('new-deliverynote-deliverynote').value
    var new_deliverynote_deliverystatus = document.getElementById('new-deliverynote-deliverystatus').value
    var new_deliverynote_customerid = document.getElementById('new-deliverynote-customerid').value
    var new_deliverynote_managerid = document.getElementById('new-deliverynote-managerid').value

    var options = {
        method: 'POST',
        url: 'http://127.0.0.1:5050/newdeliverynote',
        params: { deliverynote_orderdate: new_deliverynote_orderdate, deliverynote_deliverydate: new_deliverynote_deliverydate, deliverynote_deliverynote: new_deliverynote_deliverynote, deliverynote_deliverystatus: new_deliverynote_deliverystatus, deliverynote_customerid: new_deliverynote_customerid, deliverynote_managerid: new_deliverynote_managerid }
    }
    request(options)
})

function insert_row() {
    let table = document.getElementById('deliverynote-table-body')
    let first_row = table.firstElementChild
    clone = first_row.cloneNode(true)
    clone.removeAttribute('example-row')
    table.append(clone)
}