const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { body, validationResult } = require('express-validator');
const { db } = require('../config/database');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

// POST /api/auth/register
// تسجيل حساب جديد

router.post(
  '/register',
  [
    // قواعد التحقق من صحة البيانات المدخلة
    body('name').trim().notEmpty().withMessage('الاسم مطلوب'),
    body('email').isEmail().withMessage('الإيميل غير صحيح'),
    body('password').isLength({ min: 6 }).withMessage('كلمة السر لازم تكون 6 أحرف على الأقل'),
  ],
  async (req, res) => {
    // نتحقق إذا في أخطاء بالبيانات المدخلة
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, email, password } = req.body;

    try {
      // 1. نتأكد إن الإيميل مو مستخدم من قبل
      const existingUser = await db
        .collection('users')
        .where('email', '==', email)
        .get();

      if (!existingUser.empty) {
        return res.status(400).json({ message: 'هاد الإيميل مستخدم من قبل' });
      }

      // 2. نشفر الباسورد قبل ما نخزنه
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(password, salt);

      // 3. نخزن المستخدم الجديد بـ Firestore
      //  role: 'customer' افتراضياً - أي تسجيل عادي من التطبيق بيصير زبون مش أدمن
      const newUserRef = await db.collection('users').add({
        name,
        email,
        password: hashedPassword, // الباسورد المشفر بس، مش الأصلي أبداً
        role: 'customer',
        createdAt: new Date().toISOString(),
      });

      // 4. نولّد JWT token عشان المستخدم يصير مسجل دخول مباشرة بعد التسجيل
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

// POST /api/auth/login
// تسجيل الدخول
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
      // 1. نلاقي المستخدم بالإيميل
      const usersSnapshot = await db
        .collection('users')
        .where('email', '==', email)
        .get();

      if (usersSnapshot.empty) {
        return res.status(400).json({ message: 'الإيميل أو كلمة السر غلط' });
      }

      const userDoc = usersSnapshot.docs[0];
      const userData = userDoc.data();

      // 2. نقارن الباسورد المدخل مع المشفر المخزن
      const isPasswordCorrect = await bcrypt.compare(password, userData.password);

      if (!isPasswordCorrect) {
        return res.status(400).json({ message: 'الإيميل أو كلمة السر غلط' });
      }

      // 3. نولّد JWT token
      const token = jwt.sign(
        { userId: userDoc.id },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN }
      );

      res.status(200).json({
        message: 'تم تسجيل الدخول بنجاح',
        token,
        //  role مضافة هون كمان حتى الداشبورد يعرف فوراً بعد تسجيل الدخول
        user: { id: userDoc.id, name: userData.name, email: userData.email, role: userData.role || 'customer' },
      });
    } catch (error) {
      console.error('Login error:', error);
      res.status(500).json({ message: 'صار خطأ بالسيرفر، حاول مرة تانية' });
    }
  }
);

// GET /api/auth/me
// جلب بيانات المستخدم الحالي (بما فيها العنوان والصلاحية) - محمي
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

module.exports = router;
