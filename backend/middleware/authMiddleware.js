// middleware/authMiddleware.js
// هاد الملف هو "الحارس" - بيتحقق من الـ token قبل ما يسمح بالوصول لمسار محمي

const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
  // 1. نجيب الـ token من الـ header
  // العادة إنه يبعث بصيغة: Authorization: Bearer <token>
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'ما في صلاحية دخول، سجل دخولك الأول' });
  }

  // 2. نستخرج الـ token نفسه (بعد كلمة Bearer)
  const token = authHeader.split(' ')[1];

  try {
    // 3. نتحقق إن الـ token صحيح وموقّع بنفس السر (JWT_SECRET)
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // 4. نحط بيانات المستخدم (اللي كانت مخزنة بالـ token) على الطلب نفسه
    // عشان أي route بعدين يعرف "مين هاد المستخدم" بدون ما يعيد التحقق
    req.userId = decoded.userId;

    // 5. نسمح للطلب يكمل لل route المطلوب
    next();
  } catch (error) {
    // لو الـ token غلط أو منتهي الصلاحية
    return res.status(401).json({ message: 'صلاحية الدخول غير صحيحة أو منتهية' });
  }
};

module.exports = authMiddleware;