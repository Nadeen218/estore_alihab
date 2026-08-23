import React, { useEffect, useState } from 'react';
import apiClient from '../api/client.js';

const TYPE_LABELS = { fiber: 'فايبر', sim: 'SIM', maintenance: 'صيانة' };

const STATUS_LABELS = {
  pending: 'قيد الانتظار',
  in_progress: 'قيد التنفيذ',
  completed: 'مكتملة',
  rejected: 'مرفوضة',
};

const STATUS_STYLES = {
  pending: 'bg-accentGold/10 text-accentGold',
  in_progress: 'bg-accentBlue/10 text-accentBlue',
  completed: 'bg-accentGreen/10 text-accentGreen',
  rejected: 'bg-accentRed/10 text-accentRed',
};

function formatDetails(details) {
  if (!details || typeof details !== 'object') return '—';
  const entries = Object.entries(details);
  if (entries.length === 0) return '—';
  return entries.map(([key, value]) => `${key}: ${value}`).join('  •  ');
}

export default function ServiceRequestsPage() {
  const [requests, setRequests] = useState([]);
  const [loading, setLoading] = useState(true);
  const [updatingId, setUpdatingId] = useState(null);

  async function fetchRequests() {
    setLoading(true);
    try {
      const res = await apiClient.get('/services/admin/requests');
      setRequests(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    fetchRequests();
  }, []);

  async function handleStatusChange(requestId, newStatus) {
    setUpdatingId(requestId);
    try {
      await apiClient.put(`/services/admin/requests/${requestId}/status`, { status: newStatus });
      setRequests((prev) =>
        prev.map((r) => (r.id === requestId ? { ...r, status: newStatus } : r))
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
          <h1 className="font-display text-2xl font-bold text-light">طلبات الخدمة</h1>
          <p className="text-muted text-sm mt-1">{requests.length} طلب</p>
        </div>
      </div>

      <div className="bg-panel border border-border rounded-2xl overflow-hidden">
        {loading ? (
          <div className="p-10 text-center text-muted text-sm">جاري التحميل...</div>
        ) : requests.length === 0 ? (
          <div className="p-10 text-center text-muted text-sm">ما في طلبات خدمة بعد.</div>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border text-muted text-xs uppercase tracking-wide">
                <th className="text-right px-5 py-3 font-medium">النوع</th>
                <th className="text-right px-5 py-3 font-medium">التفاصيل</th>
                <th className="text-right px-5 py-3 font-medium">التاريخ</th>
                <th className="text-right px-5 py-3 font-medium">الحالة</th>
              </tr>
            </thead>
            <tbody>
              {requests.map((request) => (
                <tr key={request.id} className="border-b border-border last:border-0 hover:bg-panelAlt/40">
                  <td className="px-5 py-3">
                    <span className="text-light font-medium">
                      {TYPE_LABELS[request.type] || request.type}
                    </span>
                  </td>
                  <td className="px-5 py-3 text-muted max-w-xs truncate" title={formatDetails(request.details)}>
                    {formatDetails(request.details)}
                  </td>
                  <td className="px-5 py-3 text-muted">
                    {request.createdAt ? new Date(request.createdAt).toLocaleDateString('ar-EG') : '—'}
                  </td>
                  <td className="px-5 py-3">
                    <select
                      value={request.status}
                      disabled={updatingId === request.id}
                      onChange={(e) => handleStatusChange(request.id, e.target.value)}
                      className={`text-xs font-semibold px-2 py-1.5 rounded-full border-0 outline-none cursor-pointer disabled:opacity-50 ${
                        STATUS_STYLES[request.status] || 'bg-panelAlt text-muted'
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