// Color Correction Studio - Preload Script
// Secure bridge between Electron main process and renderer

const { contextBridge, ipcRenderer } = require('electron');

// Expose protected methods that allow the renderer process to use
// ipcRenderer without exposing the entire object
contextBridge.exposeInMainWorld('electronAPI', {
  // Get app version
  getAppVersion: () => ipcRenderer.invoke('get-app-version'),
  
  // Get app path
  getAppPath: () => ipcRenderer.invoke('get-app-path'),
  
  // Platform information
  platform: process.platform,
  isWindows: process.platform === 'win32',
  isMac: process.platform === 'darwin',
  isLinux: process.platform === 'linux'
});

console.log('✅ Preload script loaded successfully');