// middleware/uploadMiddleware.js
// إعداد Multer لاستقبال الصور المرفوعة (بالذاكرة مؤقتاً قبل رفعها لـ Firebase)

const multer = require('multer');

// نخزن الملف بالذاكرة (RAM) مؤقتاً، مش على القرص
// لأننا رح نرفعه مباشرة لـ Firebase Storage بعدين
const storage = multer.memoryStorage();

const fileFilter = (req, file, cb) => {
  const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error('لازم تكون الصورة بصيغة JPG, PNG أو WEBP فقط'), false);
  }
};

const upload = multer({
  storage,
  fileFilter,
  limits: { fileSize: 5 * 1024 * 1024 },
});

module.exports = upload;