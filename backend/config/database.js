// config/database.js
// هاد الملف مسؤول عن الاتصال بـ Firebase (Admin SDK)
// وبيصدّر: db (Firestore) و bucket (Firebase Storage) عشان باقي الملفات تستخدمهم

const admin = require('firebase-admin');
const path = require('path');
require('dotenv').config();

// تحميل مفتاح الحساب الخدمي (Service Account)
const serviceAccount = require(path.join(__dirname, '..', 'serviceAccountKey.json'));

// تهيئة Firebase Admin (مرة وحدة بس)
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  });
}

// Firestore - قاعدة البيانات
const db = admin.firestore();

// Storage Bucket - لتخزين صور المنتجات
const bucket = admin.storage().bucket();

// نصدّر الاتصالات عشان أي ملف بالمشروع يقدر يستخدمها
module.exports = { admin, db, bucket };