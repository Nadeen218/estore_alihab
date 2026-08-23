const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const { db } = require('../config/database');
const authMiddleware = require('../middleware/authMiddleware');
const adminMiddleware = require('../middleware/adminMiddleware');

function generateOrderNumber() {
  const randomNumber = 10000 + Math.floor(Math.random() * 90000);
  return `ES-${randomNumber}`;
}

router.post(
  '/',
  authMiddleware,
  [
    body('items').isArray({ min: 1 }).withMessage('لازم يكون في منتج واحد على الأقل بالطلب'),
    body('items.*.productId').notEmpty().withMessage('productId مطلوب لكل منتج'),
    body('items.*.name').notEmpty().withMessage('اسم المنتج مطلوب'),
    body('items.*.price').isFloat({ min: 0 }).withMessage('سعر غير صحيح'),
    body('items.*.quantity').isInt({ min: 1 }).withMessage('الكمية لازم تكون رقم صحيح 1 أو أكتر'),
    body('shippingAddress').trim().notEmpty().withMessage('عنوان الشحن مطلوب'),
    body('phone').trim().notEmpty().withMessage('رقم الهاتف مطلوب'),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const { items, shippingAddress, phone, notes } = req.body;

      const totalAmount = items.reduce(
        (sum, item) => sum + item.price * item.quantity,
        0
      );

      const newOrder = {
        userId: req.userId,
        orderNumber: generateOrderNumber(),
        items,
        totalAmount,
        shippingAddress,
        phone,
        notes: notes || '',
        status: 'pending',
        createdAt: new Date().toISOString(),
      };

      const docRef = await db.collection('orders').add(newOrder);

      res.status(201).json({
        message: 'تم إنشاء الطلب بنجاح',
        order: { id: docRef.id, ...newOrder },
      });
    } catch (error) {
      console.error('Create order error:', error);
      res.status(500).json({ message: 'صار خطأ بإنشاء الطلب' });
    }
  }
);

router.get('/my-orders', authMiddleware, async (req, res) => {
  try {
    const snapshot = await db
      .collection('orders')
      .where('userId', '==', req.userId)
      .orderBy('createdAt', 'desc')
      .get();

    const orders = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    res.status(200).json(orders);
  } catch (error) {
    console.error('Get my orders error:', error);
    res.status(500).json({ message: 'صار خطأ بجلب الطلبات' });
  }
});

router.get('/track', async (req, res) => {
  try {
    const { orderId, phone } = req.query;

    if (!orderId || !phone) {
      return res.status(400).json({ message: 'رقم الطلب ورقم الهاتف مطلوبين' });
    }

    const snapshot = await db
      .collection('orders')
      .where('orderNumber', '==', orderId.trim())
      .get();

    if (snapshot.empty) {
      return res.status(404).json({ message: 'لم يتم العثور على الطلب' });
    }

    const doc = snapshot.docs[0];
    const orderData = doc.data();

    if (orderData.phone !== phone.trim()) {
      return res.status(404).json({ message: 'لم يتم العثور على الطلب' });
    }

    res.status(200).json({ id: doc.id, ...orderData });
  } catch (error) {
    console.error('Track order error:', error);
    res.status(500).json({ message: 'صار خطأ أثناء البحث عن الطلب' });
  }
});

// 👇 أضفنا adminMiddleware هون - بس الأدمن يقدر يشوف طلب معين بأي حالة
router.get('/:id', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const doc = await db.collection('orders').doc(req.params.id).get();

    if (!doc.exists) {
      return res.status(404).json({ message: 'الطلب غير موجود' });
    }

    res.status(200).json({ id: doc.id, ...doc.data() });
  } catch (error) {
    console.error('Get order error:', error);
    res.status(500).json({ message: 'صار خطأ بجلب الطلب' });
  }
});

// 👇 أضفنا adminMiddleware هون - بس الأدمن يقدر يشوف كل الطلبات
router.get('/', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const snapshot = await db.collection('orders').orderBy('createdAt', 'desc').get();
    const orders = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    res.status(200).json(orders);
  } catch (error) {
    console.error('Get all orders error:', error);
    res.status(500).json({ message: 'صار خطأ بجلب الطلبات' });
  }
});

// 👇 أضفنا adminMiddleware هون - بس الأدمن يقدر يغيّر حالة الطلب
router.put(
  '/:id/status',
  authMiddleware,
  adminMiddleware,
  [
    body('status')
      .isIn(['pending', 'processing', 'shipped', 'delivered', 'cancelled'])
      .withMessage('حالة غير صحيحة'),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const orderRef = db.collection('orders').doc(req.params.id);
      const doc = await orderRef.get();

      if (!doc.exists) {
        return res.status(404).json({ message: 'الطلب غير موجود' });
      }

      await orderRef.update({ status: req.body.status });

      res.status(200).json({ message: 'تم تحديث حالة الطلب بنجاح' });
    } catch (error) {
      console.error('Update order status error:', error);
      res.status(500).json({ message: 'صار خطأ بتحديث حالة الطلب' });
    }
  }
);

module.exports = router;