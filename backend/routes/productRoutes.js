const express = require('express');
const { body, validationResult } = require('express-validator');
const { db, bucket } = require('../config/database');
const authMiddleware = require('../middleware/authMiddleware');
const upload = require('../middleware/uploadMiddleware');

const router = express.Router();


//  رفع صورة لـ Firebase Storage وإرجاع الرابط

async function uploadImageToFirebase(file) {
  // اسم فريد للملف عشان ما تصير تعارضات (اسمين صور بنفس الاسم)
  const fileName = `products/${Date.now()}-${file.originalname}`;
  const fileUpload = bucket.file(fileName);

  await fileUpload.save(file.buffer, {
    metadata: { contentType: file.mimetype },
  });

  // نخلي الملف قابل للوصول العام عشان تطبيق الفلاتر يعرض الصورة مباشرة
  await fileUpload.makePublic();

  // نرجع الرابط العام للصورة
  return `https://storage.googleapis.com/${bucket.name}/${fileName}`;
}


// GET /api/products
// عرض كل المنتجات (مو محمي - أي حد يشوفهم)

router.get('/', async (req, res) => {
  try {
    const snapshot = await db.collection('products').orderBy('createdAt', 'desc').get();
    const products = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    res.status(200).json(products);
  } catch (error) {
    console.error('Get products error:', error);
    res.status(500).json({ message: 'صار خطأ بجلب المنتجات' });
  }
});


// GET /api/products/:id
// عرض منتج واحد بالتفصيل

router.get('/:id', async (req, res) => {
  try {
    const doc = await db.collection('products').doc(req.params.id).get();

    if (!doc.exists) {
      return res.status(404).json({ message: 'المنتج غير موجود' });
    }

    res.status(200).json({ id: doc.id, ...doc.data() });
  } catch (error) {
    console.error('Get product error:', error);
    res.status(500).json({ message: 'صار خطأ بجلب المنتج' });
  }
});


// POST /api/products
// إضافة منتج جديد + صورة (محمي - لازم تسجيل دخول)

router.post(
  '/',
  authMiddleware,
  upload.single('image'), // اسم الحقل يلي رح يجي فيه الملف من تطبيق الفلاتر
  [
    body('name').trim().notEmpty().withMessage('اسم المنتج مطلوب'),
    body('price').isFloat({ min: 0 }).withMessage('السعر لازم يكون رقم صحيح'),
    body('description').trim().notEmpty().withMessage('الوصف مطلوب'),
    body('category').trim().notEmpty().withMessage('التصنيف مطلوب'),
    body('stock').isInt({ min: 0 }).withMessage('الكمية لازم تكون رقم صحيح'),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const { name, price, description, category, stock } = req.body;

      let imageUrl = null;

      // إذا في صورة مرفوعة، نرفعها لـ Firebase أول
      if (req.file) {
        imageUrl = await uploadImageToFirebase(req.file);
      }

      const newProduct = {
        name,
        price: parseFloat(price),
        description,
        category,
        stock: parseInt(stock),
        imageUrl,
        createdBy: req.userId, // جاي من الـ authMiddleware
        createdAt: new Date().toISOString(),
      };

      const docRef = await db.collection('products').add(newProduct);

      res.status(201).json({
        message: 'تم إضافة المنتج بنجاح',
        product: { id: docRef.id, ...newProduct },
      });
    } catch (error) {
      console.error('Add product error:', error);
      res.status(500).json({ message: 'صار خطأ بإضافة المنتج' });
    }
  }
);


// PUT /api/products/:id
// تعديل منتج (محمي)
router.put('/:id', authMiddleware, upload.single('image'), async (req, res) => {
  try {
    const productRef = db.collection('products').doc(req.params.id);
    const doc = await productRef.get();

    if (!doc.exists) {
      return res.status(404).json({ message: 'المنتج غير موجود' });
    }

    const updates = { ...req.body };

    // لو بعت أرقام (price, stock)، نحولهم لنوعهم الصحيح
    if (updates.price) updates.price = parseFloat(updates.price);
    if (updates.stock) updates.stock = parseInt(updates.stock);

    // لو بعت صورة جديدة، نرفعها ونحدث الرابط
    if (req.file) {
      updates.imageUrl = await uploadImageToFirebase(req.file);
    }

    await productRef.update(updates);

    res.status(200).json({ message: 'تم تعديل المنتج بنجاح' });
  } catch (error) {
    console.error('Update product error:', error);
    res.status(500).json({ message: 'صار خطأ بتعديل المنتج' });
  }
});


// DELETE /api/products/:id
// حذف منتج (محمي)
router.delete('/:id', authMiddleware, async (req, res) => {
  try {
    const productRef = db.collection('products').doc(req.params.id);
    const doc = await productRef.get();

    if (!doc.exists) {
      return res.status(404).json({ message: 'المنتج غير موجود' });
    }

    await productRef.delete();

    res.status(200).json({ message: 'تم حذف المنتج بنجاح' });
  } catch (error) {
    console.error('Delete product error:', error);
    res.status(500).json({ message: 'صار خطأ بحذف المنتج' });
  }
});

module.exports = router;