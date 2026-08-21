// server.js
const express = require('express');
const cors = require('cors');
require('dotenv').config();

require('./config/database');

const authRoutes = require('./routes/authRoutes');
const authMiddleware = require('./middleware/authMiddleware');
const productRoutes = require('./routes/productRoutes');
const orderRoutes = require('./routes/orderRoutes');
const serviceRoutes = require('./routes/serviceRoutes');

const app = express();

// ===== Middlewares =====
app.use(cors());
app.use(express.json());

// ===== Routes =====
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    message: 'السيرفر شغال تمام ',
    timestamp: new Date().toISOString()
  });
});

app.use('/api/auth', authRoutes);
app.use('/api/products', productRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/services', serviceRoutes);

// مسار تجريبي محمي - بس لتجربة الـ middleware
app.get('/api/protected-test', authMiddleware, (req, res) => {
  res.json({
    message: 'وصلت للمسار المحمي بنجاح!',
    userId: req.userId
  });
});

// ===== تشغيل السيرفر =====
const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(` السيرفر شغال على http://localhost:${PORT}`);
});