const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { body, validationResult } = require('express-validator');
const { db } = require('../config/database');
const authMiddleware = require('../middleware/authMiddleware');
const adminMiddleware = require('../middleware/adminMiddleware');

const router = express.Router();

router.post(
  '/register',
  [
    body('name').trim().notEmpty().withMessage('الاسم مطلوب'),
    body('email').isEmail().withMessage('الإيميل غير صحيح'),
    body('password').isLength({ min: 6 }).withMessage('كلمة السر لازم تكون 6 أحرف على الأقل'),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, email, password } = req.body;

    try {
      const existingUser = await db
        .collection('users')
        .where('email', '==', email)
        .get();

      if (!existingUser.empty) {
        return res.status(400).json({ message: 'هاد الإيميل مستخدم من قبل' });
      }

      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(password, salt);

      const newUserRef = await db.collection('users').add({
        name,
        email,
        password: hashedPassword,
        role: 'customer',
        createdAt: new Date().toISOString(),
      });

      const token = jwt.sign(
        { userId: newUserRef.id },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN }
      );

      res.status(201).json({
        message: 'تم إنشاء الحساب بنجاح',
        token,
        user: { id: newUserRef.id, name, email, role: 'customer' },
      });
    } catch (error) {
      console.error('Register error:', error);
      res.status(500).json({ message: 'صار خطأ بالسيرفر، حاول مرة تانية' });
    }
  }
);

router.post(
  '/login',
  [
    body('email').isEmail().withMessage('الإيميل غير صحيح'),
    body('password').notEmpty().withMessage('كلمة السر مطلوبة'),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { email, password } = req.body;

    try {
      const usersSnapshot = await db
        .collection('users')
        .where('email', '==', email)
        .get();

      if (usersSnapshot.empty) {
        return res.status(400).json({ message: 'الإيميل أو كلمة السر غلط' });
      }

      const userDoc = usersSnapshot.docs[0];
      const userData = userDoc.data();

      const isPasswordCorrect = await bcrypt.compare(password, userData.password);

      if (!isPasswordCorrect) {
        return res.status(400).json({ message: 'الإيميل أو كلمة السر غلط' });
      }

      const token = jwt.sign(
        { userId: userDoc.id },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN }
      );

      res.status(200).json({
        message: 'تم تسجيل الدخول بنجاح',
        token,
        user: { id: userDoc.id, name: userData.name, email: userData.email, role: userData.role || 'customer' },
      });
    } catch (error) {
      console.error('Login error:', error);
      res.status(500).json({ message: 'صار خطأ بالسيرفر، حاول مرة تانية' });
    }
  }
);

router.get('/me', authMiddleware, async (req, res) => {
  try {
    const userDoc = await db.collection('users').doc(req.userId).get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: 'المستخدم غير موجود' });
    }

    const { name, email, address, phone, role } = userDoc.data();

    res.status(200).json({
      user: {
        id: userDoc.id,
        name,
        email,
        address: address || '',
        phone: phone || '',
        role: role || 'customer',
      },
    });
  } catch (error) {
    console.error('Get me error:', error);
    res.status(500).json({ message: 'صار خطأ بجلب بيانات المستخدم' });
  }
});

router.get('/users', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const snapshot = await db.collection('users').orderBy('createdAt', 'desc').get();

    const users = snapshot.docs.map((doc) => {
      const { password, ...safeData } = doc.data();
      return { id: doc.id, ...safeData };
    });

    res.status(200).json(users);
  } catch (error) {
    console.error('Get users error:', error);
    res.status(500).json({ message: 'صار خطأ بجلب المستخدمين' });
  }
});

router.put(
  '/users/:id/role',
  authMiddleware,
  adminMiddleware,
  [
    body('role').isIn(['customer', 'admin']).withMessage('role لازم يكون customer أو admin'),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    if (req.params.id === req.userId) {
      return res.status(400).json({ message: 'ما فيك تغير صلاحية حسابك انت' });
    }

    try {
      const userRef = db.collection('users').doc(req.params.id);
      const doc = await userRef.get();

      if (!doc.exists) {
        return res.status(404).json({ message: 'المستخدم غير موجود' });
      }

      await userRef.update({ role: req.body.role });

      res.status(200).json({ message: 'تم تحديث صلاحية المستخدم بنجاح' });
    } catch (error) {
      console.error('Update user role error:', error);
      res.status(500).json({ message: 'صار خطأ بتحديث الصلاحية' });
    }
  }
);

router.delete('/users/:id', authMiddleware, adminMiddleware, async (req, res) => {
  if (req.params.id === req.userId) {
    return res.status(400).json({ message: 'ما فيك تحذف حسابك انت' });
  }

  try {
    const userRef = db.collection('users').doc(req.params.id);
    const doc = await userRef.get();

    if (!doc.exists) {
      return res.status(404).json({ message: 'المستخدم غير موجود' });
    }

    await userRef.delete();

    res.status(200).json({ message: 'تم حذف المستخدم بنجاح' });
  } catch (error) {
    console.error('Delete user error:', error);
    res.status(500).json({ message: 'صار خطأ بحذف المستخدم' });
  }
});

module.exports = router;