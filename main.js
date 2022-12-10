const {app, BrowserWindow} = require('electron')

function createWindow() {
    const window = new BrowserWindow({
        width:1600,
        height:900,
        resizable:true,
        webPreferences :   {
            nodeIntegration: true,
        }
    })
    window.loadFile(__dirname + '/main/html/index.html')
}

// Enable live reload for Electron too
require('electron-reload')(__dirname, {
    // Note that the path to electron may vary according to the main file
    electron: require(`${__dirname}/node_modules/electron`)
});

app.whenReady().then(createWindow)

app.on('window-all-closed', () => {
    if (process.platform!== 'linux') {
            app.quit()
    }
});

app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
            createWindow()
    }
});