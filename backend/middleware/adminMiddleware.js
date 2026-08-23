// بيتحقق إنه المستخدم صاحب الـ token هو فعلاً "admin" مش زبون عادي

const { db } = require('../config/database');

const adminMiddleware = async (req, res, next) => {
  try {
    // req.userId جاي من authMiddleware يلي لازم يشتغل قبل هاد الميدل وير
    const userDoc = await db.collection('users').doc(req.userId).get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: 'المستخدم غير موجود' });
    }

    const userData = userDoc.data();

    if (userData.role !== 'admin') {
      return res.status(403).json({ message: 'ما عندك صلاحية تنفيذ هاد الإجراء' });
    }

    // نحفظ بيانات المستخدم عالطلب لو حبينا نستخدمها بعدين
    req.userRole = userData.role;
    next();
  } catch (error) {
    console.error('Admin check error:', error);
    res.status(500).json({ message: 'صار خطأ بالتحقق من الصلاحيات' });
  }
};

module.exports = adminMiddleware;
