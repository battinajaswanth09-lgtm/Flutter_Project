const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const path = require('path');
const fs = require('fs');
require('dotenv').config();

const connectDB = require('./config/db');
const apiRoutes = require('./routes/index');
const fakeRoutes = require('./routes/fakeRoutes');
const errorHandler = require('./middleware/errorHandler');

// Initialize express app
const app = express();

// Determine Database Mode (Fake / In-Memory vs MongoDB Atlas)
const useFakeDb =
  process.env.USE_FAKE_DB === 'true' ||
  !process.env.MONGODB_URI ||
  process.env.MONGODB_URI.includes('127.0.0.1');

if (useFakeDb) {
  console.log('----------------------------------------------------');
  console.log('⚡ [Database] RUNNING IN ZERO-SETUP FAKE DATABASE MODE');
  console.log('⚡ All APIs, authentication & records are simulated in memory.');
  console.log('⚡ Perfect for instant free deployment without MongoDB Atlas!');
  console.log('----------------------------------------------------');
} else {
  // Connect to MongoDB Atlas
  connectDB();
}

// Security HTTP headers
app.use(
  helmet({
    contentSecurityPolicy: false, // Allows Flutter Web canvas and external fonts
  })
);

// Enable CORS
const clientUrl = process.env.CLIENT_URL || '*';
app.use(
  cors({
    origin: clientUrl === '*' ? true : clientUrl,
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  })
);

// Logging middleware
if (process.env.NODE_ENV !== 'production') {
  app.use(morgan('dev'));
} else {
  app.use(morgan('combined'));
}

// Request Body Parsers
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Rate Limiting for API routes
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 300, // Limit each IP to 300 requests per window
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    message: 'Too many requests created from this IP, please try again after 15 minutes',
  },
});
app.use('/api', limiter);

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    uptime: process.uptime(),
    status: 'UP',
    databaseMode: useFakeDb ? 'fake-in-memory-db' : 'mongodb-atlas',
    timestamp: Date.now(),
  });
});

// Mount API routes (Fake DB vs MongoDB Atlas)
if (useFakeDb) {
  app.use('/api', fakeRoutes);
} else {
  app.use('/api', apiRoutes);
}

// -------------------------------------------------------------
// All-In-One Free Deployment Support:
// Check for compiled Flutter Web assets in backend/public or frontend/build/web
// -------------------------------------------------------------
const publicDir = path.join(__dirname, '../public');
const flutterWebDir = path.join(__dirname, '../../frontend/build/web');
const staticPath = fs.existsSync(publicDir)
  ? publicDir
  : fs.existsSync(flutterWebDir)
  ? flutterWebDir
  : null;

if (staticPath) {
  // Serve Flutter Web static files
  app.use(express.static(staticPath));

  // SPA fallback for client-side Flutter routing
  app.get('*', (req, res) => {
    res.sendFile(path.join(staticPath, 'index.html'));
  });
} else {
  // If Flutter web build is not present, serve API status page
  app.get('/', (req, res) => {
    res.status(200).json({
      status: 'online',
      message: 'CampusPulse College Management System API is running smoothly',
      version: '1.0.0',
      apiDocs: '/api',
      timestamp: new Date().toISOString(),
    });
  });

  // Catch 404 for unhandled API routes
  app.use((req, res) => {
    res.status(404).json({
      success: false,
      message: `API endpoint not found: [${req.method}] ${req.originalUrl}`,
    });
  });
}

// Centralized Error Handler
app.use(errorHandler);

const PORT = process.env.PORT || 5000;

const server = app.listen(PORT, () => {
  console.log(`====================================================`);
  console.log(` College Management System Server Running on Port ${PORT}`);
  console.log(` Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(` Health check available at: http://localhost:${PORT}/health`);
  console.log(`====================================================`);
});

// Handle unhandled promise rejections
process.on('unhandledRejection', (err) => {
  console.error(`Unhandled Rejection Error: ${err.message}`);
});

module.exports = app;

