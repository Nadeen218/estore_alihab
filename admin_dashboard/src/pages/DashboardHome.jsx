import React, { useEffect, useState } from 'react';
import apiClient from '../api/client.js';

export default function DashboardHome() {
  const [productsCount, setProductsCount] = useState(null);
  const [ordersCount, setOrdersCount] = useState(null);
  const [usersCount, setUsersCount] = useState(null);

  useEffect(() => {
    apiClient.get('/products').then((res) => {
      setProductsCount(res.data.length);
    }).catch(() => setProductsCount(0));

    apiClient.get('/orders').then((res) => {
      setOrdersCount(res.data.length);
    }).catch(() => setOrdersCount(0));

    apiClient.get('/auth/users').then((res) => {
      setUsersCount(res.data.length);
    }).catch(() => setUsersCount(0));
  }, []);

  return (
    <div className="p-8">
      <h1 className="font-display text-2xl font-bold text-light mb-1">أهلاً بك</h1>
      <p className="text-muted text-sm mb-8">نظرة سريعة على المتجر</p>

      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="bg-panel border border-border rounded-2xl p-5">
          <p className="text-muted text-xs mb-2">عدد المنتجات</p>
          <p className="font-display text-3xl font-bold text-light">
            {productsCount === null ? '—' : productsCount}
          </p>
        </div>
        <div className="bg-panel border border-border rounded-2xl p-5">
          <p className="text-muted text-xs mb-2">عدد الطلبات</p>
          <p className="font-display text-3xl font-bold text-light">
            {ordersCount === null ? '—' : ordersCount}
          </p>
        </div>
        <div className="bg-panel border border-border rounded-2xl p-5">
          <p className="text-muted text-xs mb-2">عدد المستخدمين</p>
          <p className="font-display text-3xl font-bold text-light">
            {usersCount === null ? '—' : usersCount}
          </p>
        </div>
      </div>
    </div>
  );
}