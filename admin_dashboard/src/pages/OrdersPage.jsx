import React, { useEffect, useState } from 'react';
import apiClient from '../api/client.js';

const STATUS_LABELS = {
  pending: 'قيد الانتظار',
  processing: 'قيد المعالجة',
  shipped: 'تم الشحن',
  delivered: 'تم التسليم',
  cancelled: 'ملغي',
};

const STATUS_STYLES = {
  pending: 'bg-accentGold/10 text-accentGold',
  processing: 'bg-accentBlue/10 text-accentBlue',
  shipped: 'bg-accentCyan/10 text-accentCyan',
  delivered: 'bg-accentGreen/10 text-accentGreen',
  cancelled: 'bg-accentRed/10 text-accentRed',
};

export default function OrdersPage() {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [updatingId, setUpdatingId] = useState(null);

  async function fetchOrders() {
    setLoading(true);
    try {
      const res = await apiClient.get('/orders');
      setOrders(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    fetchOrders();
  }, []);

  async function handleStatusChange(orderId, newStatus) {
    setUpdatingId(orderId);
    try {
      await apiClient.put(`/orders/${orderId}/status`, { status: newStatus });
      setOrders((prev) =>
        prev.map((o) => (o.id === orderId ? { ...o, status: newStatus } : o))
      );
    } catch (err) {
      alert(err.response?.data?.message || 'صار خطأ بتحديث حالة الطلب');
    } finally {
      setUpdatingId(null);
    }
  }

  return (
    <div className="p-8">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="font-display text-2xl font-bold text-light">الطلبات</h1>
          <p className="text-muted text-sm mt-1">{orders.length} طلب</p>
        </div>
      </div>

      <div className="bg-panel border border-border rounded-2xl overflow-hidden">
        {loading ? (
          <div className="p-10 text-center text-muted text-sm">جاري التحميل...</div>
        ) : orders.length === 0 ? (
          <div className="p-10 text-center text-muted text-sm">ما في طلبات بعد.</div>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border text-muted text-xs uppercase tracking-wide">
                <th className="text-right px-5 py-3 font-medium">رقم الطلب</th>
                <th className="text-right px-5 py-3 font-medium">الهاتف</th>
                <th className="text-right px-5 py-3 font-medium">عنوان الشحن</th>
                <th className="text-right px-5 py-3 font-medium">الإجمالي</th>
                <th className="text-right px-5 py-3 font-medium">التاريخ</th>
                <th className="text-right px-5 py-3 font-medium">الحالة</th>
              </tr>
            </thead>
            <tbody>
              {orders.map((order) => (
                <tr key={order.id} className="border-b border-border last:border-0 hover:bg-panelAlt/40">
                  <td className="px-5 py-3">
                    <span className="text-light font-medium">{order.orderNumber}</span>
                  </td>
                  <td className="px-5 py-3 text-muted">{order.phone}</td>
                  <td className="px-5 py-3 text-muted">{order.shippingAddress}</td>
                  <td className="px-5 py-3 text-light">{order.totalAmount} ₪</td>
                  <td className="px-5 py-3 text-muted">
                    {new Date(order.createdAt).toLocaleDateString('ar-EG')}
                  </td>
                  <td className="px-5 py-3">
                    <select
                      value={order.status}
                      disabled={updatingId === order.id}
                      onChange={(e) => handleStatusChange(order.id, e.target.value)}
                      className={`text-xs font-semibold px-2 py-1.5 rounded-full border-0 outline-none cursor-pointer disabled:opacity-50 ${
                        STATUS_STYLES[order.status] || 'bg-panelAlt text-muted'
                      }`}
                    >
                      {Object.entries(STATUS_LABELS).map(([value, label]) => (
                        <option key={value} value={value} className="bg-panel text-light">
                          {label}
                        </option>
                      ))}
                    </select>
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