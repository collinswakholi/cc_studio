// Color Correction Studio - Cross-platform Startup Script
// This Node.js script works on Windows, Linux, and macOS

import { spawn } from 'child_process';
import { platform } from 'os';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const isWindows = platform() === 'win32';
const isMac = platform() === 'darwin';

console.log('\n============================================================');
console.log('  🎨 Color Correction Studio - Starting...');
console.log('============================================================\n');

// Start Backend Server
console.log('🔧 Starting Backend Server (Python Flask)...');
const backendDir = join(__dirname, 'backend');
const backendProcess = spawn(
  isWindows ? 'python' : 'python3',
  ['server_enhanced.py'],
  {
    cwd: backendDir,
    shell: true,
    stdio: 'inherit',
    detached: !isWindows
  }
);

// Handle backend process errors
backendProcess.on('error', (err) => {
  console.error('❌ Failed to start backend:', err.message);
  process.exit(1);
});

// Wait for backend to initialize
setTimeout(() => {
  // Start Frontend Server
  console.log('🌐 Starting Frontend Server (Vite + React)...');
  const frontendProcess = spawn(
    isWindows ? 'npm.cmd' : 'npm',
    ['run', 'dev'],
    {
      cwd: __dirname,
      shell: true,
      stdio: 'inherit',
      detached: !isWindows
    }
  );

  // Handle frontend process errors
  frontendProcess.on('error', (err) => {
    console.error('❌ Failed to start frontend:', err.message);
    backendProcess.kill();
    process.exit(1);
  });

  // Wait for frontend to start, then open browser
  setTimeout(() => {
    console.log('\n============================================================');
    console.log('  ✅ Both servers are running!');
    console.log('============================================================\n');
    console.log('  🌐 Frontend: http://localhost:5173');
    console.log('  🔧 Backend:  http://localhost:5000\n');
    console.log('  ⚠️  Press Ctrl+C to stop both servers\n');

    // Open browser
    if (isWindows) {
      spawn('cmd', ['/c', 'start', 'http://localhost:5173'], { shell: true });
    } else if (isMac) {
      spawn('open', ['http://localhost:5173']);
    } else {
      spawn('xdg-open', ['http://localhost:5173']);
    }
  }, 3000);

  // Enhanced cleanup with proper process termination
  const cleanup = async (signal) => {
    console.log(`\n🛑 Received ${signal || 'exit signal'} - Stopping servers...`);
    
    // Prevent multiple cleanup calls
    if (cleanup.called) {
      return;
    }
    cleanup.called = true;
    
    const killProcess = (proc, name) => {
      return new Promise((resolve) => {
        if (!proc || !proc.pid) {
          resolve();
          return;
        }
        
        console.log(`🔪 Terminating ${name} process (PID: ${proc.pid})...`);
        
        if (isWindows) {
          // Windows: Use taskkill with /T flag to kill entire process tree
          const killCmd = spawn('taskkill', ['/pid', proc.pid.toString(), '/T', '/F'], { 
            shell: true,
            stdio: 'ignore'
          });
          
          killCmd.on('exit', () => {
            console.log(`✓ ${name} terminated`);
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
            console.log(`✓ ${name} terminated`);
          } catch (e) {
            try {
              proc.kill('SIGKILL');
            } catch (e2) {
              // Process already dead
            }
          }
          
          // Give it a moment to die gracefully
          setTimeout(resolve, 500);
        }
      });
    };
    
    try {
      // Kill processes in parallel
      await Promise.all([
        killProcess(backendProcess, 'Backend'),
        killProcess(frontendProcess, 'Frontend')
      ]);
      
      console.log('✅ All servers stopped successfully.');
    } catch (err) {
      console.error('⚠️  Error during cleanup:', err.message);
    }
    
    // Final wait before exiting
    setTimeout(() => {
      process.exit(0);
    }, 300);
  };

  // Register cleanup handlers
  process.on('SIGINT', () => cleanup('SIGINT'));
  process.on('SIGTERM', () => cleanup('SIGTERM'));
  process.on('beforeExit', () => cleanup('beforeExit'));
  
  // Handle uncaught exceptions to ensure cleanup
  process.on('uncaughtException', (err) => {
    console.error('❌ Uncaught exception:', err);
    cleanup('uncaughtException');
  });

}, 3000);
