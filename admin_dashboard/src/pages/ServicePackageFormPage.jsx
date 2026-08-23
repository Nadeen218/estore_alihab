import React, { useEffect, useState } from 'react';
import { useNavigate, useParams, Link } from 'react-router-dom';
import apiClient from '../api/client.js';

const emptyForm = { name: '', type: 'fiber', price: '', speed: '', isPopular: false };

export default function ServicePackageFormPage() {
  const { id } = useParams();
  const isEdit = Boolean(id);
  const navigate = useNavigate();

  const [form, setForm] = useState(emptyForm);
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    if (!isEdit) return;
    apiClient.get('/services/admin/packages').then((res) => {
      const pkg = res.data.find((p) => p.id === id);
      if (pkg) {
        setForm({
          name: pkg.name || '',
          type: pkg.type || 'fiber',
          price: pkg.price ?? '',
          speed: pkg.speed || '',
          isPopular: pkg.isPopular || false,
        });
      } else {
        setError('ما قدرنا نلاقي الباقة');
      }
      setLoading(false);
    }).catch(() => {
      setError('ما قدرنا نجيب بيانات الباقة');
      setLoading(false);
    });
  }, [id, isEdit]);

  function handleChange(e) {
    const { name, value, type, checked } = e.target;
    setForm({ ...form, [name]: type === 'checkbox' ? checked : value });
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setSaving(true);
    setError('');

    const payload = {
      name: form.name,
      type: form.type,
      price: form.price,
      speed: form.speed,
      isPopular: form.isPopular,
    };

    try {
      if (isEdit) {
        await apiClient.put(`/services/admin/packages/${id}`, payload);
      } else {
        await apiClient.post('/services/admin/packages', payload);
      }
      navigate('/services/packages');
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
        <Link to="/services/packages" className="text-sm text-muted hover:text-light">
          ← رجوع للباقات
        </Link>
        <h1 className="font-display text-2xl font-bold text-light mt-2">
          {isEdit ? 'تعديل الباقة' : 'إضافة باقة جديدة'}
        </h1>
      </div>

      <form onSubmit={handleSubmit} className="bg-panel border border-border rounded-2xl p-6 space-y-5">
        {error && (
          <div className="bg-accentRed/10 border border-accentRed/30 text-accentRed text-sm rounded-lg px-4 py-2.5">
            {error}
          </div>
        )}

        <div>
          <label className="block text-sm text-muted mb-1.5">اسم الباقة</label>
          <input
            name="name"
            required
            value={form.name}
            onChange={handleChange}
            className="w-full bg-panelAlt border border-border rounded-lg px-4 py-2.5 text-light text-sm outline-none focus:border-accentBlue"
          />
        </div>

        <div>
          <label className="block text-sm text-muted mb-1.5">نوع الخدمة</label>
          <select
            name="type"
            value={form.type}
            onChange={handleChange}
            className="w-full bg-panelAlt border border-border rounded-lg px-4 py-2.5 text-light text-sm outline-none focus:border-accentBlue"
          >
            <option value="fiber">فايبر</option>
            <option value="sim">SIM</option>
          </select>
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
            <label className="block text-sm text-muted mb-1.5">السرعة / الداتا</label>
            <input
              name="speed"
              required
              placeholder="مثال: 50 Mbps أو 15 GB"
              value={form.speed}
              onChange={handleChange}
              className="w-full bg-panelAlt border border-border rounded-lg px-4 py-2.5 text-light text-sm outline-none focus:border-accentBlue"
            />
          </div>
        </div>

        <div className="flex items-center gap-2.5">
          <input
            type="checkbox"
            id="isPopular"
            name="isPopular"
            checked={form.isPopular}
            onChange={handleChange}
            className="w-4 h-4 accent-accentBlue"
          />
          <label htmlFor="isPopular" className="text-sm text-light cursor-pointer">
            باقة مميزة (تظهر بشكل بارز بالتطبيق)
          </label>
        </div>

        <div className="flex gap-3 pt-2">
          <button
            type="submit"
            disabled={saving}
            className="bg-accentBlue hover:bg-accentBlue/90 disabled:opacity-60 text-white font-semibold text-sm rounded-lg px-6 py-2.5 transition-colors"
          >
            {saving ? 'جاري الحفظ...' : isEdit ? 'حفظ التعديلات' : 'إضافة الباقة'}
          </button>
          <Link
            to="/services/packages"
            className="text-muted hover:text-light text-sm font-medium rounded-lg px-6 py-2.5 border border-border transition-colors"
          >
            إلغاء
          </Link>
        </div>
      </form>
    </div>
  );
}