import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import apiClient from '../api/client.js';

const TYPE_LABELS = { fiber: 'فايبر', sim: 'SIM' };

export default function ServicePackagesPage() {
  const [packages, setPackages] = useState([]);
  const [loading, setLoading] = useState(true);
  const [deletingId, setDeletingId] = useState(null);

  async function fetchPackages() {
    setLoading(true);
    try {
      const res = await apiClient.get('/services/admin/packages');
      setPackages(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    fetchPackages();
  }, []);

  async function handleDelete(id) {
    if (!window.confirm('متأكد بدك تحذف هاي الباقة؟')) return;
    setDeletingId(id);
    try {
      await apiClient.delete(`/services/admin/packages/${id}`);
      setPackages((prev) => prev.filter((p) => p.id !== id));
    } catch (err) {
      alert(err.response?.data?.message || 'صار خطأ بالحذف');
    } finally {
      setDeletingId(null);
    }
  }

  return (
    <div className="p-8">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="font-display text-2xl font-bold text-light">باقات الخدمة</h1>
          <p className="text-muted text-sm mt-1">{packages.length} باقة</p>
        </div>
        <Link
          to="/services/packages/new"
          className="bg-accentBlue hover:bg-accentBlue/90 text-white text-sm font-semibold rounded-lg px-5 py-2.5 transition-colors"
        >
          + إضافة باقة
        </Link>
      </div>

      <div className="bg-panel border border-border rounded-2xl overflow-hidden">
        {loading ? (
          <div className="p-10 text-center text-muted text-sm">جاري التحميل...</div>
        ) : packages.length === 0 ? (
          <div className="p-10 text-center text-muted text-sm">ما في باقات بعد. ضيف أول باقة.</div>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border text-muted text-xs uppercase tracking-wide">
                <th className="text-right px-5 py-3 font-medium">الباقة</th>
                <th className="text-right px-5 py-3 font-medium">النوع</th>
                <th className="text-right px-5 py-3 font-medium">السرعة / الداتا</th>
                <th className="text-right px-5 py-3 font-medium">السعر</th>
                <th className="text-right px-5 py-3 font-medium">مميزة</th>
                <th className="text-right px-5 py-3 font-medium"></th>
              </tr>
            </thead>
            <tbody>
              {packages.map((pkg) => (
                <tr key={pkg.id} className="border-b border-border last:border-0 hover:bg-panelAlt/40">
                  <td className="px-5 py-3 text-light font-medium">{pkg.name}</td>
                  <td className="px-5 py-3">
                    <span
                      className={`text-xs font-semibold px-2 py-1 rounded-full ${
                        pkg.type === 'fiber'
                          ? 'bg-accentCyan/10 text-accentCyan'
                          : 'bg-accentGold/10 text-accentGold'
                      }`}
                    >
                      {TYPE_LABELS[pkg.type] || pkg.type}
                    </span>
                  </td>
                  <td className="px-5 py-3 text-muted">{pkg.speed}</td>
                  <td className="px-5 py-3 text-light">{pkg.price} ₪</td>
                  <td className="px-5 py-3">
                    {pkg.isPopular ? (
                      <span className="text-xs font-semibold px-2 py-1 rounded-full bg-accentGreen/10 text-accentGreen">
                        مميزة
                      </span>
                    ) : (
                      <span className="text-muted text-xs">—</span>
                    )}
                  </td>
                  <td className="px-5 py-3">
                    <div className="flex items-center gap-2 justify-end">
                      <Link
                        to={`/services/packages/${pkg.id}/edit`}
                        className="text-xs font-medium text-accentBlue hover:underline"
                      >
                        تعديل
                      </Link>
                      <button
                        onClick={() => handleDelete(pkg.id)}
                        disabled={deletingId === pkg.id}
                        className="text-xs font-medium text-accentRed hover:underline disabled:opacity-50"
                      >
                        {deletingId === pkg.id ? 'جاري الحذف...' : 'حذف'}
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}