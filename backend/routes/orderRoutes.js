const express = require('express');
const { body, validationResult } = require('express-validator');
const { db } = require('../config/database');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

// POST /api/orders
// إنشاء طلب جديد (Checkout) - محمي
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


// GET /api/orders/my-orders
// عرض طلبات المستخدم الحالي - محمي
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

// GET /api/orders/:id
// تفاصيل طلب واحد - محمي
router.get('/:id', authMiddleware, async (req, res) => {
  try {
    const doc = await db.collection('orders').doc(req.params.id).get();

    if (!doc.exists) {
      return res.status(404).json({ message: 'الطلب غير موجود' });
    }

    const orderData = doc.data();

    if (orderData.userId !== req.userId) {
      return res.status(403).json({ message: 'ما إلك صلاحية تشوف هاد الطلب' });
    }

    res.status(200).json({ id: doc.id, ...orderData });
  } catch (error) {
    console.error('Get order error:', error);
    res.status(500).json({ message: 'صار خطأ بجلب الطلب' });
  }
});


// GET /api/orders
// عرض كل الطلبات (للأدمن) - محمي
router.get('/', authMiddleware, async (req, res) => {
  try {
    const snapshot = await db.collection('orders').orderBy('createdAt', 'desc').get();
    const orders = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    res.status(200).json(orders);
  } catch (error) {
    console.error('Get all orders error:', error);
    res.status(500).json({ message: 'صار خطأ بجلب الطلبات' });
  }
});


// PUT /api/orders/:id/status
// تحديث حالة الطلب - محمي (أدمن)

router.put(
  '/:id/status',
  authMiddleware,
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