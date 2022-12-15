fs = require('fs')
var request = require("request-promise");

document.getElementById('add-new-electronic-button').addEventListener('click', () => {
    var new_electronic_electronictype = document.getElementById('new-electronic-electronictype').value
    var new_electronic_electronicseries = document.getElementById('new-electronic-electronicseries').value
    var new_electronic_electronicstock = document.getElementById('new-electronic-electronicstock').value
    var new_electronic_inventoryid = document.getElementById('new-electronic-inventoryid').value
    var new_electronic_manufacturername = document.getElementById('new-electronic-manufacturername').value

    var options = {
        method: 'POST',
        url: 'http://127.0.0.1:5050/newelectronic',
        params: { electronic_electronictype: new_electronic_electronictype, electronic_electronicseries: new_electronic_electronicseries, electronic_electronicstock: new_electronic_electronicstock, electronic_inventoryid: new_electronic_inventoryid, electronic_manufacturername: new_electronic_manufacturername }
    }
 request(options)
})

function insert_row() {
    let table = document.getElementById('electronic-table-body')
    let first_row = table.firstElementChild
    clone = first_row.cloneNode(true)
    clone.removeAttribute('example-row')
    table.append(clone)
}