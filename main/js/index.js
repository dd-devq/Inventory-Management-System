fs = require('fs')

fs.readFile('main/html/dashboard.html', (err, data) => {
    document.getElementById('index-right-container').innerHTML = data
    if (err) {
        return console.log(err)
    }
    var importScript = document.createElement('script')
    importScript.src = '../js/dashboard.js'
    document.head.appendChild(importScript)
})

document.getElementById('index-left-container-menu-item-dashboard').addEventListener('click', () => {
    fs.readFile('main/html/dashboard.html', (err, data) => {
        document.getElementById('index-right-container').innerHTML = data
        if (err) {
            return console.log(err)
        }
        var importScript = document.createElement('script')
        importScript.src = '../js/dashboard.js'
        document.head.appendChild(importScript)
    })
})


document.getElementById('index-left-container-menu-item-customer').addEventListener('click', load_customer)

function load_customer() {
    fs.readFile('main/html/customer.html', (err, data) => {
        document.getElementById('index-right-container').innerHTML = data
        console.log(data)
        if (err) {
            return console.log(err)
        }
        var importScript = document.createElement('script')
        importScript.src = '../js/customer.js'
        document.head.appendChild(importScript)
    })
}

document.getElementById('index-left-container-menu-item-manager').addEventListener('click', load_manager)

function load_manager() {
    fs.readFile('main/html/manager.html', (err, data) => {
        document.getElementById('index-right-container').innerHTML = data
        if (err) {
            return console.log(err)
        }
        var importScript = document.createElement('script')
        importScript.src = '../js/manager.js'
        document.head.appendChild(importScript)
    })
}

document.getElementById('index-left-container-menu-item-manufacturer').addEventListener('click', load_manufacturer)

function load_manufacturer() {
    fs.readFile('main/html/manufacturer.html', (err, data) => {
        document.getElementById('index-right-container').innerHTML = data
        if (err) {
            return console.log(err)
        }
        var importScript = document.createElement('script')
        importScript.src = '../js/manufacturer.js'
        document.head.appendChild(importScript)
    })
}

document.getElementById('index-left-container-menu-item-staff').addEventListener('click', load_staff)

function load_staff() {
    fs.readFile('main/html/staff.html', (err, data) => {
        document.getElementById('index-right-container').innerHTML = data
        if (err) {
            return console.log(err)
        }
        var importScript = document.createElement('script')
        importScript.src = '../js/staff.js'
        document.head.appendChild(importScript)
    })
}

document.getElementById('index-left-container-menu-item-deliverynote').addEventListener('click', load_deliverynote)

function load_deliverynote() {
    fs.readFile('main/html/deliverynote.html', (err, data) => {
        document.getElementById('index-right-container').innerHTML = data
        if (err) {
            return console.log(err)
        }
        var importScript = document.createElement('script')
        importScript.src = '../js/deliverynote.js'
        document.head.appendChild(importScript)
    })
}

document.getElementById('index-left-container-menu-item-inventory').addEventListener('click', load_inventory)

function load_inventory() {
    fs.readFile('main/html/inventory.html', (err, data) => {
        document.getElementById('index-right-container').innerHTML = data
        if (err) {
            return console.log(err)
        }
        var importScript = document.createElement('script')
        importScript.src = '../js/inventory.js'
        document.head.appendChild(importScript)
    })
}

document.getElementById('index-left-container-menu-item-receivenote').addEventListener('click', load_receivenote)

function load_receivenote() {
    fs.readFile('main/html/receivenote.html', (err, data) => {
        document.getElementById('index-right-container').innerHTML = data
        if (err) {
            return console.log(err)
        }
        var importScript = document.createElement('script')
        importScript.src = '../js/receivenote.js'
        document.head.appendChild(importScript)
    })
}

document.getElementById('index-left-container-menu-item-order').addEventListener('click', load_order)

function load_order() {
    fs.readFile('main/html/order.html', (err, data) => {
        document.getElementById('index-right-container').innerHTML = data
        if (err) {
            return console.log(err)
        }
        var importScript = document.createElement('script')
        importScript.src = '../js/order.js'
        document.head.appendChild(importScript)
    })
}

document.getElementById('index-left-container-menu-item-electronic').addEventListener('click', load_electronic)

function load_electronic() {
    fs.readFile('main/html/electronic.html', (err, data) => {
        document.getElementById('index-right-container').innerHTML = data
        if (err) {
            return console.log(err)
        }
        var importScript = document.createElement('script')
        importScript.src = '../js/electronic.js'
        document.head.appendChild(importScript)
    })
}

