const express = require('express');
const router = express.Router();
const { db } = require('../config/database');
const authMiddleware = require('../middleware/authMiddleware');

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

module.exports = router;