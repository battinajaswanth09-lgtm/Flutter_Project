const fs = require('fs');
const path = require('path');

const srcDir = path.join(__dirname, '../../frontend/build/web');
const destDir = path.join(__dirname, '../public');

if (!fs.existsSync(srcDir)) {
  console.log('[Notice] frontend/build/web does not exist yet. Run "cd frontend && flutter build web --release" first.');
  process.exit(0);
}

function copyRecursiveSync(src, dest) {
  const exists = fs.existsSync(src);
  const stats = exists && fs.statSync(src);
  const isDirectory = exists && stats.isDirectory();
  if (isDirectory) {
    if (!fs.existsSync(dest)) {
      fs.mkdirSync(dest, { recursive: true });
    }
    fs.readdirSync(src).forEach((childItemName) => {
      copyRecursiveSync(path.join(src, childItemName), path.join(dest, childItemName));
    });
  } else {
    fs.copyFileSync(src, dest);
  }
}

try {
  if (fs.existsSync(destDir)) {
    fs.rmSync(destDir, { recursive: true, force: true });
  }
  fs.mkdirSync(destDir, { recursive: true });
  copyRecursiveSync(srcDir, destDir);
  console.log('[Success] Flutter Web build copied successfully to backend/public!');
} catch (err) {
  console.error('[Error] Failed copying Flutter Web build:', err.message);
}
