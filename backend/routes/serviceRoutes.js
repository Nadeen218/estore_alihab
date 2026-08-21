const express = require('express');
const router = express.Router();
const { db } = require('../config/database');
const authMiddleware = require('../middleware/authMiddleware');

// قائمة بسيطة بالمناطق المغطاة لخدمة Fiber
const FIBER_COVERED_AREAS = ['رام الله', 'البيرة', 'نابلس', 'الخليل', 'بيت لحم'];

// ==================== GET /api/services/packages?type=fiber|sim ====================
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

// ==================== POST /api/services/check-coverage ====================
// body: { city: "رام الله" }  -- خاص بـ Fiber فقط
router.post('/check-coverage', (req, res) => {
  const { city } = req.body;
  if (!city || !city.trim()) {
    return res.status(400).json({ message: 'city مطلوب' });
  }

  const available = FIBER_COVERED_AREAS.some(area => area.trim() === city.trim());
  res.json({ available, city: city.trim() });
});

// ==================== POST /api/services/request (محمي) ====================
// body: { type: "fiber"|"sim"|"maintenance", ...تفاصيل حسب النوع }
router.post('/request', authMiddleware, async (req, res) => {
  try {
    const { type, ...details } = req.body;
    if (!['fiber', 'sim', 'maintenance'].includes(type)) {
      return res.status(400).json({ message: 'نوع الخدمة غير صحيح' });
    }

    const newRequest = {
      userId: req.userId,     // جاي من authMiddleware
      type,
      details,                // مرن حسب النوع (منطقة+باقة / رقم+باقة / جهاز+عطل+وصف)
      status: 'pending',      // pending -> in_progress -> completed
      createdAt: new Date().toISOString(),
    };

    const docRef = await db.collection('serviceRequests').add(newRequest);
    res.status(201).json({ id: docRef.id, ...newRequest });
  } catch (error) {
    res.status(500).json({ message: 'خطأ بإرسال الطلب', error: error.message });
  }
});

// ==================== GET /api/services/my-requests (محمي) ====================
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