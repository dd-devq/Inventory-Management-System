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

document.getElementById('index-left-container-menu-item-dispatch').addEventListener('click', () => {
    fs.readFile('main/html/dispatch.html', (err, data) => {
        document.getElementById('index-right-container').innerHTML = data
        if (err) {
            return console.log(err)
        }
        var importScript = document.createElement('script')
        importScript.src = '../js/dispatch.js'
        document.head.appendChild(importScript)
    })
})

document.getElementById('index-left-container-menu-item-return').addEventListener('click', () => {
    fs.readFile('main/html/return.html', (err, data) => {
        document.getElementById('index-right-container').innerHTML = data
        if (err) {
            return console.log(err)
        }
        var importScript = document.createElement('script')
        importScript.src = '../js/return.js'
        document.head.appendChild(importScript)
    })
})

document.getElementById('index-left-container-menu-item-shipment').addEventListener('click', () => {
    fs.readFile('main/html/shipment.html', (err, data) => {
        document.getElementById('index-right-container').innerHTML = data
        if (err) {
            return console.log(err)
        }
        var importScript = document.createElement('script')
        importScript.src = '../js/shipment.js'
        document.head.appendChild(importScript)
    })
})


