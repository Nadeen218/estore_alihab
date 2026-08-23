import React, { useEffect, useState } from 'react';
import apiClient from '../api/client.js';

export default function DashboardHome() {
  const [productsCount, setProductsCount] = useState(null);

  useEffect(() => {
    apiClient.get('/products').then((res) => {
      setProductsCount(res.data.length);
    }).catch(() => setProductsCount(0));
  }, []);

  return (
    <div className="p-8">
      <h1 className="font-display text-2xl font-bold text-light mb-1">أهلاً بيك 👋</h1>
      <p className="text-muted text-sm mb-8">نظرة سريعة على المتجر</p>

      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="bg-panel border border-border rounded-2xl p-5">
          <p className="text-muted text-xs mb-2">عدد المنتجات</p>
          <p className="font-display text-3xl font-bold text-light">
            {productsCount === null ? '—' : productsCount}
          </p>
        </div>
        <div className="bg-panel border border-border rounded-2xl p-5 opacity-50">
          <p className="text-muted text-xs mb-2">الطلبات (قريباً)</p>
          <p className="font-display text-3xl font-bold text-light">—</p>
        </div>
        <div className="bg-panel border border-border rounded-2xl p-5 opacity-50">
          <p className="text-muted text-xs mb-2">المستخدمين (قريباً)</p>
          <p className="font-display text-3xl font-bold text-light">—</p>
        </div>
      </div>
    </div>
  );
}
