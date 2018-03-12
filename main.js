const path = require('path');
const url = require('url');
const { BrowserWindow, app } = require('electron');

app.on('ready', () => {
  let win = new AppWindow();
  win.on('closed', () => win = null);
  app.on('activate', () => !win && (win = new AppWindow()));
});

app.on('window-all-closed', () => process.platform !== 'darwin' && app.quit());

class AppWindow extends BrowserWindow {
  constructor() {
    super({ width: 200, height: 200 });
    this.loadURL(url.format({
      pathname: path.join(__dirname, 'app/index.html'),
      protocol: 'file:',
      slashes: true
    }));
  }
}
