// Color Correction Studio - Electron Main Process
// Version: 3.0.0
// Cross-platform desktop application

const { app, BrowserWindow, ipcMain, dialog } = require('electron');
const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');
const os = require('os');

// Keep global references to prevent garbage collection
let mainWindow = null;
let backendProcess = null;
let frontendProcess = null;

const isDev = process.env.NODE_ENV === 'development' || !app.isPackaged;
const isWindows = process.platform === 'win32';
const isMac = process.platform === 'darwin';
const isLinux = process.platform === 'linux';

// Configuration
const BACKEND_PORT = 5000;
const FRONTEND_PORT = 5173;
const APP_NAME = 'Color Correction Studio';

// Get resource paths
function getResourcePath(relativePath) {
  if (isDev) {
    return path.join(__dirname, relativePath);
  }
  // In production, resources are in app.asar or extraResources
  return path.join(process.resourcesPath, relativePath);
}

// Get Python executable path
function getPythonPath() {
  if (isDev) {
    return isWindows ? 'python' : 'python3';
  }
  // In production, use bundled Python executable
  const execName = isWindows ? 'server_enhanced.exe' : 'server_enhanced';
  return path.join(getResourcePath('backend'), execName);
}

// Start Backend Server
function startBackend() {
  return new Promise((resolve, reject) => {
    console.log('🔧 Starting Backend Server...');
    
    const pythonPath = getPythonPath();
    const backendDir = getResourcePath('backend');
    
    console.log(`   Python: ${pythonPath}`);
    console.log(`   Backend Dir: ${backendDir}`);
    
    if (isDev) {
      // Development mode: Run Python script directly
      backendProcess = spawn(pythonPath, ['server_enhanced.py'], {
        cwd: backendDir,
        shell: true,
        stdio: 'inherit'
      });
    } else {
      // Production mode: Run compiled executable
      backendProcess = spawn(pythonPath, [], {
        cwd: backendDir,
        shell: false,
        stdio: 'inherit'
      });
    }
    
    backendProcess.on('error', (err) => {
      console.error('❌ Backend error:', err);
      reject(err);
    });
    
    backendProcess.on('exit', (code) => {
      console.log(`⚠️  Backend exited with code ${code}`);
    });
    
    // Wait for backend to be ready
    setTimeout(() => {
      console.log('✅ Backend should be ready');
      resolve();
    }, 3000);
  });
}

// Start Frontend (only in dev mode, in production we use built files)
function startFrontend() {
  return new Promise((resolve, reject) => {
    if (!isDev) {
      // In production, we serve static files
      resolve();
      return;
    }
    
    console.log('🌐 Starting Frontend Dev Server...');
    
    frontendProcess = spawn('npm', ['run', 'dev'], {
      cwd: __dirname,
      shell: true,
      stdio: 'inherit'
    });
    
    frontendProcess.on('error', (err) => {
      console.error('❌ Frontend error:', err);
      reject(err);
    });
    
    // Wait for frontend to be ready
    setTimeout(() => {
      console.log('✅ Frontend should be ready');
      resolve();
    }, 5000);
  });
}

// Create the main application window
async function createWindow() {
  console.log('\n============================================================');
  console.log(`  🎨 ${APP_NAME} - Initializing...`);
  console.log('============================================================\n');
  
  // Start backend first
  try {
    await startBackend();
  } catch (err) {
    dialog.showErrorBox(
      'Backend Startup Failed',
      `Failed to start the backend server:\n\n${err.message}\n\nPlease ensure Python dependencies are installed.`
    );
    app.quit();
    return;
  }
  
  // Start frontend in dev mode
  if (isDev) {
    try {
      await startFrontend();
    } catch (err) {
      console.error('Frontend startup failed:', err);
    }
  }
  
  // Create the browser window
  mainWindow = new BrowserWindow({
    width: 1400,
    height: 900,
    minWidth: 1200,
    minHeight: 700,
    title: APP_NAME,
    icon: path.join(__dirname, 'icon.png'), // Add your icon here
    backgroundColor: '#1e1b4b',
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js'),
      webSecurity: true
    },
    show: false // Don't show until ready
  });
  
  // Show window when ready to prevent flash
  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
    console.log('\n✅ Application window opened\n');
  });
  
  // Load the app
  if (isDev) {
    // Development: Load from Vite dev server
    mainWindow.loadURL(`http://localhost:${FRONTEND_PORT}`);
    // Open DevTools in development
    mainWindow.webContents.openDevTools();
  } else {
    // Production: Load built files
    mainWindow.loadFile(path.join(__dirname, 'dist', 'index.html'));
  }
  
  // Handle window close
  mainWindow.on('closed', () => {
    mainWindow = null;
  });
  
  // Handle window close button
  mainWindow.on('close', async (event) => {
    if (backendProcess || frontendProcess) {
      event.preventDefault();
      
      const choice = dialog.showMessageBoxSync(mainWindow, {
        type: 'question',
        buttons: ['Yes', 'No'],
        title: 'Confirm Exit',
        message: 'Are you sure you want to exit Color Correction Studio?',
        detail: 'All unsaved work will be lost.'
      });
      
      if (choice === 0) {
        await cleanup();
        mainWindow.destroy();
        app.quit();
      }
    }
  });
}

// Cleanup processes
async function cleanup() {
  console.log('\n🛑 Cleaning up processes...');
  
  const killProcess = (proc, name) => {
    return new Promise((resolve) => {
      if (!proc || !proc.pid) {
        resolve();
        return;
      }
      
      console.log(`   Stopping ${name} (PID: ${proc.pid})...`);
      
      if (isWindows) {
        // Windows: Use taskkill with /T flag to kill entire process tree
        const killCmd = spawn('taskkill', ['/pid', proc.pid.toString(), '/T', '/F'], {
          shell: true,
          stdio: 'ignore'
        });
        
        killCmd.on('exit', (code) => {
          console.log(`   ✓ ${name} stopped (exit code: ${code})`);
          resolve();
        });
        
        killCmd.on('error', (err) => {
          console.error(`   Error stopping ${name}:`, err.message);
          resolve();
        });
        
        // Timeout after 2 seconds
        setTimeout(() => {
          try {
            proc.kill('SIGKILL');
          } catch (e) {
            // Process already dead
          }
          resolve();
        }, 2000);
      } else {
        // Unix-like: Kill process group
        try {
          process.kill(-proc.pid, 'SIGTERM');
          setTimeout(() => {
            console.log(`   ✓ ${name} stopped`);
            resolve();
          }, 500);
        } catch (err) {
          console.error(`   Error stopping ${name}:`, err.message);
          try {
            proc.kill('SIGKILL');
          } catch (e) {
            // Process already dead
          }
          resolve();
        }
      }
    });
  };
  
  // Kill processes in parallel
  const promises = [];
  
  if (backendProcess) {
    promises.push(killProcess(backendProcess, 'backend'));
  }
  
  if (frontendProcess) {
    promises.push(killProcess(frontendProcess, 'frontend'));
  }
  
  await Promise.all(promises);
  
  backendProcess = null;
  frontendProcess = null;
  
  console.log('✅ Cleanup complete\n');
  
  // Additional wait for processes to fully terminate
  await new Promise(resolve => setTimeout(resolve, 300));
}

// App lifecycle events
app.whenReady().then(createWindow);

app.on('window-all-closed', async () => {
  // On macOS, keep app running even when all windows closed
  if (!isMac) {
    await cleanup();
    app.quit();
  }
});

app.on('activate', () => {
  // On macOS, recreate window when dock icon is clicked
  if (mainWindow === null) {
    createWindow();
  }
});

app.on('before-quit', async (event) => {
  if (backendProcess || frontendProcess) {
    event.preventDefault();
    await cleanup();
    app.exit(0);
  }
});

// Handle uncaught exceptions
process.on('uncaughtException', (error) => {
  console.error('❌ Uncaught exception:', error);
  dialog.showErrorBox('Application Error', `An unexpected error occurred:\n\n${error.message}`);
});

// IPC Handlers for communication with renderer process
ipcMain.handle('get-app-version', () => {
  return app.getVersion();
});

ipcMain.handle('get-app-path', () => {
  return app.getAppPath();
});

console.log(`\n📦 Application Mode: ${isDev ? 'Development' : 'Production'}`);
console.log(`🖥️  Platform: ${process.platform} (${os.arch()})`);
console.log(`📁 App Path: ${app.getAppPath()}\n`);