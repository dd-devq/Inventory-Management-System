fs = require('fs')
var request = require("request-promise");

document.getElementById('add-new-receivenote-button').addEventListener('click', () => {
    var new_receivenote_receivedate = document.getElementById('new-receivenote-receivedate').value
    var new_receivenote_receivenote = document.getElementById('new-receivenote-receivenote').value
    var new_receivenote_receivestatus = document.getElementById('new-receivenote-receivestatus').value
    var new_receivenote_orderid = document.getElementById('new-receivenote-orderid').value
    var new_receivenote_inventoryid = document.getElementById('new-receivenote-inventoryid').value

    var options = {
        method: 'POST',
        url: 'http://127.0.0.1:5050/newreceivenote',
        params: { receivenote_receivedate: new_receivenote_receivedate, receivenote_receivenote: new_receivenote_receivenote, receivenote_receivestatus: new_receivenote_receivestatus, receivenote_orderid: new_receivenote_orderid, receivenote_inventoryid: new_receivenote_inventoryid }
    }
 request(options)
})

function insert_row() {
    let table = document.getElementById('receivenote-table-body')
    let first_row = table.firstElementChild
    clone = first_row.cloneNode(true)
    clone.removeAttribute('example-row')
    table.append(clone)
}