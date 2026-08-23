const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const { db } = require('../config/database');
const authMiddleware = require('../middleware/authMiddleware');
const adminMiddleware = require('../middleware/adminMiddleware');

const FIBER_COVERED_AREAS = ['رام الله', 'البيرة', 'نابلس', 'الخليل', 'بيت لحم'];

router.get('/packages', async (req, res) => {
  try {
    const { type } = req.query;
    if (!type || !['fiber', 'sim'].includes(type)) {
      return res.status(400).json({ message: 'type لازم يكون fiber أو sim' });
    }

    const snapshot = await db.collection('servicePackages')
      .where('type', '==', type)
      .get();

    const packages = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(packages);
  } catch (error) {
    res.status(500).json({ message: 'خطأ بجلب الباقات', error: error.message });
  }
});

router.post('/check-coverage', (req, res) => {
  const { city } = req.body;
  if (!city || !city.trim()) {
    return res.status(400).json({ message: 'city مطلوب' });
  }

  const available = FIBER_COVERED_AREAS.some(area => area.trim() === city.trim());
  res.json({ available, city: city.trim() });
});

router.post('/check-number', async (req, res) => {
  const { number } = req.body;
  if (!number || !number.trim()) {
    return res.status(400).json({ message: 'number مطلوب' });
  }

  try {
    const snapshot = await db.collection('reservedNumbers')
      .where('number', '==', number.trim())
      .get();

    const isReserved = !snapshot.empty;

    res.json({
      available: !isReserved,
      number: number.trim(),
    });
  } catch (error) {
    res.status(500).json({ message: 'خطأ أثناء التحقق من الرقم', error: error.message });
  }
});

router.post('/reserve-number', authMiddleware, async (req, res) => {
  const { number } = req.body;
  if (!number || !number.trim()) {
    return res.status(400).json({ message: 'number مطلوب' });
  }

  try {
    const existing = await db.collection('reservedNumbers')
      .where('number', '==', number.trim())
      .get();

    if (!existing.empty) {
      return res.status(400).json({ message: 'هذا الرقم محجوز مسبقاً' });
    }

    const reservation = {
      number: number.trim(),
      userId: req.userId,
      reservedAt: new Date().toISOString(),
    };

    await db.collection('reservedNumbers').add(reservation);

    res.status(201).json({ message: 'تم حجز الرقم بنجاح', ...reservation });
  } catch (error) {
    res.status(500).json({ message: 'خطأ أثناء حجز الرقم', error: error.message });
  }
});

router.post('/request', authMiddleware, async (req, res) => {
  try {
    const { type, ...details } = req.body;
    if (!['fiber', 'sim', 'maintenance'].includes(type)) {
      return res.status(400).json({ message: 'نوع الخدمة غير صحيح' });
    }

    const newRequest = {
      userId: req.userId,
      type,
      details,
      status: 'pending',
      createdAt: new Date().toISOString(),
    };

    const docRef = await db.collection('serviceRequests').add(newRequest);
    res.status(201).json({ id: docRef.id, ...newRequest });
  } catch (error) {
    res.status(500).json({ message: 'خطأ بإرسال الطلب', error: error.message });
  }
});

router.get('/my-requests', authMiddleware, async (req, res) => {
  try {
    const snapshot = await db.collection('serviceRequests')
      .where('userId', '==', req.userId)
      .orderBy('createdAt', 'desc')
      .get();

    const requests = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(requests);
  } catch (error) {
    res.status(500).json({ message: 'خطأ بجلب الطلبات', error: error.message });
  }
});

router.get('/admin/packages', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const snapshot = await db.collection('servicePackages').get();
    const packages = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(packages);
  } catch (error) {
    res.status(500).json({ message: 'خطأ بجلب الباقات', error: error.message });
  }
});

router.post(
  '/admin/packages',
  authMiddleware,
  adminMiddleware,
  [
    body('name').trim().notEmpty().withMessage('اسم الباقة مطلوب'),
    body('type').isIn(['fiber', 'sim']).withMessage('type لازم يكون fiber أو sim'),
    body('price').isFloat({ min: 0 }).withMessage('سعر غير صحيح'),
    body('speed').trim().notEmpty().withMessage('السرعة/الداتا مطلوبة'),
    body('isPopular').optional().isBoolean().withMessage('isPopular لازم يكون true أو false'),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const { name, type, price, speed, isPopular } = req.body;
      const newPackage = {
        name,
        type,
        price: Number(price),
        speed,
        isPopular: isPopular || false,
      };

      const docRef = await db.collection('servicePackages').add(newPackage);
      res.status(201).json({ id: docRef.id, ...newPackage });
    } catch (error) {
      res.status(500).json({ message: 'خطأ بإضافة الباقة', error: error.message });
    }
  }
);

router.put(
  '/admin/packages/:id',
  authMiddleware,
  adminMiddleware,
  [
    body('name').trim().notEmpty().withMessage('اسم الباقة مطلوب'),
    body('type').isIn(['fiber', 'sim']).withMessage('type لازم يكون fiber أو sim'),
    body('price').isFloat({ min: 0 }).withMessage('سعر غير صحيح'),
    body('speed').trim().notEmpty().withMessage('السرعة/الداتا مطلوبة'),
    body('isPopular').optional().isBoolean().withMessage('isPopular لازم يكون true أو false'),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const packageRef = db.collection('servicePackages').doc(req.params.id);
      const doc = await packageRef.get();

      if (!doc.exists) {
        return res.status(404).json({ message: 'الباقة غير موجودة' });
      }

      const { name, type, price, speed, isPopular } = req.body;
      const updatedPackage = {
        name,
        type,
        price: Number(price),
        speed,
        isPopular: isPopular || false,
      };

      await packageRef.update(updatedPackage);
      res.json({ message: 'تم تحديث الباقة بنجاح', id: req.params.id, ...updatedPackage });
    } catch (error) {
      res.status(500).json({ message: 'خطأ بتحديث الباقة', error: error.message });
    }
  }
);

router.delete('/admin/packages/:id', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const packageRef = db.collection('servicePackages').doc(req.params.id);
    const doc = await packageRef.get();

    if (!doc.exists) {
      return res.status(404).json({ message: 'الباقة غير موجودة' });
    }

    await packageRef.delete();
    res.json({ message: 'تم حذف الباقة بنجاح' });
  } catch (error) {
    res.status(500).json({ message: 'خطأ بحذف الباقة', error: error.message });
  }
});

router.get('/admin/requests', authMiddleware, adminMiddleware, async (req, res) => {
  try {
    const snapshot = await db.collection('serviceRequests').orderBy('createdAt', 'desc').get();
    const requests = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(requests);
  } catch (error) {
    res.status(500).json({ message: 'خطأ بجلب طلبات الخدمة', error: error.message });
  }
});

router.put(
  '/admin/requests/:id/status',
  authMiddleware,
  adminMiddleware,
  [
    body('status')
      .isIn(['pending', 'in_progress', 'completed', 'rejected'])
      .withMessage('حالة غير صحيحة'),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const requestRef = db.collection('serviceRequests').doc(req.params.id);
      const doc = await requestRef.get();

      if (!doc.exists) {
        return res.status(404).json({ message: 'الطلب غير موجود' });
      }

      await requestRef.update({ status: req.body.status });
      res.json({ message: 'تم تحديث حالة الطلب بنجاح' });
    } catch (error) {
      res.status(500).json({ message: 'خطأ بتحديث حالة الطلب', error: error.message });
    }
  }
);

module.exports = router;