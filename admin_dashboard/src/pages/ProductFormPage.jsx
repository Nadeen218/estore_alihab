import React, { useEffect, useState } from 'react';
import { useNavigate, useParams, Link } from 'react-router-dom';
import apiClient from '../api/client.js';

const emptyForm = { name: '', price: '', description: '', category: '', stock: '' };

export default function ProductFormPage() {
  const { id } = useParams();
  const isEdit = Boolean(id);
  const navigate = useNavigate();

  const [form, setForm] = useState(emptyForm);
  const [imageFile, setImageFile] = useState(null);
  const [existingImageUrl, setExistingImageUrl] = useState('');
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    if (!isEdit) return;
    apiClient.get(`/products/${id}`).then((res) => {
      const p = res.data;
      setForm({
        name: p.name || '',
        price: p.price ?? '',
        description: p.description || '',
        category: p.category || '',
        stock: p.stock ?? '',
      });
      setExistingImageUrl(p.imageUrl || '');
      setLoading(false);
    }).catch(() => {
      setError('ما قدرنا نجيب بيانات المنتج');
      setLoading(false);
    });
  }, [id, isEdit]);

  function handleChange(e) {
    setForm({ ...form, [e.target.name]: e.target.value });
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setSaving(true);
    setError('');

    const formData = new FormData();
    formData.append('name', form.name);
    formData.append('price', form.price);
    formData.append('description', form.description);
    formData.append('category', form.category);
    formData.append('stock', form.stock);
    if (imageFile) formData.append('image', imageFile);

    try {
      if (isEdit) {
        await apiClient.put(`/products/${id}`, formData, {
          headers: { 'Content-Type': 'multipart/form-data' },
        });
      } else {
        await apiClient.post('/products', formData, {
          headers: { 'Content-Type': 'multipart/form-data' },
        });
      }
      navigate('/products');
    } catch (err) {
      const errors = err.response?.data?.errors;
      if (errors?.length) {
        setError(errors.map((x) => x.msg).join(' — '));
      } else {
        setError(err.response?.data?.message || 'صار خطأ، جرب مرة تانية');
      }
    } finally {
      setSaving(false);
    }
  }

  if (loading) {
    return <div className="p-8 text-muted text-sm">جاري التحميل...</div>;
  }

  return (
    <div className="p-8 max-w-2xl">
      <div className="mb-6">
        <Link to="/products" className="text-sm text-muted hover:text-light">
          ← رجوع للمنتجات
        </Link>
        <h1 className="font-display text-2xl font-bold text-light mt-2">
          {isEdit ? 'تعديل المنتج' : 'إضافة منتج جديد'}
        </h1>
      </div>

      <form onSubmit={handleSubmit} className="bg-panel border border-border rounded-2xl p-6 space-y-5">
        {error && (
          <div className="bg-accentRed/10 border border-accentRed/30 text-accentRed text-sm rounded-lg px-4 py-2.5">
            {error}
          </div>
        )}

        <div>
          <label className="block text-sm text-muted mb-1.5">اسم المنتج</label>
          <input
            name="name"
            required
            value={form.name}
            onChange={handleChange}
            className="w-full bg-panelAlt border border-border rounded-lg px-4 py-2.5 text-light text-sm outline-none focus:border-accentBlue"
          />
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm text-muted mb-1.5">السعر (₪)</label>
            <input
              name="price"
              type="number"
              step="0.01"
              min="0"
              required
              value={form.price}
              onChange={handleChange}
              className="w-full bg-panelAlt border border-border rounded-lg px-4 py-2.5 text-light text-sm outline-none focus:border-accentBlue"
            />
          </div>
          <div>
            <label className="block text-sm text-muted mb-1.5">الكمية بالمخزون</label>
            <input
              name="stock"
              type="number"
              min="0"
              required
              value={form.stock}
              onChange={handleChange}
              className="w-full bg-panelAlt border border-border rounded-lg px-4 py-2.5 text-light text-sm outline-none focus:border-accentBlue"
            />
          </div>
        </div>

        <div>
          <label className="block text-sm text-muted mb-1.5">التصنيف</label>
          <input
            name="category"
            required
            placeholder="مثال: أجهزة، أجهزة لوحية، ساعات ذكية، إكسسوار"
            value={form.category}
            onChange={handleChange}
            className="w-full bg-panelAlt border border-border rounded-lg px-4 py-2.5 text-light text-sm outline-none focus:border-accentBlue"
          />
        </div>

        <div>
          <label className="block text-sm text-muted mb-1.5">الوصف</label>
          <textarea
            name="description"
            required
            rows={4}
            value={form.description}
            onChange={handleChange}
            className="w-full bg-panelAlt border border-border rounded-lg px-4 py-2.5 text-light text-sm outline-none focus:border-accentBlue resize-none"
          />
        </div>

        <div>
          <label className="block text-sm text-muted mb-1.5">
            صورة المنتج {isEdit && '(اتركها فاضية لو ما بدك تغيرها)'}
          </label>
          {existingImageUrl && !imageFile && (
            <img src={existingImageUrl} alt="current" className="w-20 h-20 rounded-lg object-cover mb-2 border border-border" />
          )}
          <input
            type="file"
            accept="image/*"
            onChange={(e) => setImageFile(e.target.files?.[0] || null)}
            className="w-full text-sm text-muted file:ml-3 file:py-2 file:px-4 file:rounded-lg file:border-0 file:bg-panelAlt file:text-light file:text-sm"
          />
        </div>

        <div className="flex gap-3 pt-2">
          <button
            type="submit"
            disabled={saving}
            className="bg-accentBlue hover:bg-accentBlue/90 disabled:opacity-60 text-white font-semibold text-sm rounded-lg px-6 py-2.5 transition-colors"
          >
            {saving ? 'جاري الحفظ...' : isEdit ? 'حفظ التعديلات' : 'إضافة المنتج'}
          </button>
          <Link
            to="/products"
            className="text-muted hover:text-light text-sm font-medium rounded-lg px-6 py-2.5 border border-border transition-colors"
          >
            إلغاء
          </Link>
        </div>
      </form>
    </div>
  );
}
