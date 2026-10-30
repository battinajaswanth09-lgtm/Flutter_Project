const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const connUri = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/college_management';
    
    // In serverless / Render environments or local development
    const conn = await mongoose.connect(connUri, {
      serverSelectionTimeoutMS: 5000,
      autoIndex: true,
    });

    console.log(`[MongoDB] Connected successfully to host: ${conn.connection.host}`);
  } catch (error) {
    console.error(`[MongoDB] Connection error: ${error.message}`);
    // If running in development without MongoDB Atlas configured yet, warn gracefully
    if (process.env.NODE_ENV === 'production') {
      process.exit(1);
    } else {
      console.warn('[MongoDB] Running without active database connection. Set MONGODB_URI in .env to connect to MongoDB Atlas.');
    }
  }
};

module.exports = connectDB;

