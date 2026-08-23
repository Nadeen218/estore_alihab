import React, { useEffect, useState } from 'react';
import apiClient from '../api/client.js';
import { useAuth } from '../context/AuthContext.jsx';

const ROLE_LABELS = { admin: 'أدمن', customer: 'زبون' };

export default function UsersPage() {
  const { user: currentUser } = useAuth();
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [updatingId, setUpdatingId] = useState(null);
  const [deletingId, setDeletingId] = useState(null);

  async function fetchUsers() {
    setLoading(true);
    try {
      const res = await apiClient.get('/auth/users');
      setUsers(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    fetchUsers();
  }, []);

  async function handleRoleChange(userId, newRole) {
    setUpdatingId(userId);
    try {
      await apiClient.put(`/auth/users/${userId}/role`, { role: newRole });
      setUsers((prev) =>
        prev.map((u) => (u.id === userId ? { ...u, role: newRole } : u))
      );
    } catch (err) {
      alert(err.response?.data?.message || 'صار خطأ بتحديث الصلاحية');
    } finally {
      setUpdatingId(null);
    }
  }

  async function handleDelete(userId) {
    if (!window.confirm('متأكد بدك تحذف هاد المستخدم؟ هاد الإجراء ما فيه رجعة.')) return;
    setDeletingId(userId);
    try {
      await apiClient.delete(`/auth/users/${userId}`);
      setUsers((prev) => prev.filter((u) => u.id !== userId));
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
          <h1 className="font-display text-2xl font-bold text-light">المستخدمين</h1>
          <p className="text-muted text-sm mt-1">{users.length} مستخدم</p>
        </div>
      </div>

      <div className="bg-panel border border-border rounded-2xl overflow-hidden">
        {loading ? (
          <div className="p-10 text-center text-muted text-sm">جاري التحميل...</div>
        ) : users.length === 0 ? (
          <div className="p-10 text-center text-muted text-sm">ما في مستخدمين بعد.</div>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border text-muted text-xs uppercase tracking-wide">
                <th className="text-right px-5 py-3 font-medium">الاسم</th>
                <th className="text-right px-5 py-3 font-medium">الإيميل</th>
                <th className="text-right px-5 py-3 font-medium">الهاتف</th>
                <th className="text-right px-5 py-3 font-medium">تاريخ التسجيل</th>
                <th className="text-right px-5 py-3 font-medium">الصلاحية</th>
                <th className="text-right px-5 py-3 font-medium"></th>
              </tr>
            </thead>
            <tbody>
              {users.map((u) => {
                const isSelf = u.id === currentUser?.id;
                return (
                  <tr key={u.id} className="border-b border-border last:border-0 hover:bg-panelAlt/40">
                    <td className="px-5 py-3">
                      <span className="text-light font-medium">{u.name}</span>
                      {isSelf && (
                        <span className="text-muted text-xs mr-2">(أنت)</span>
                      )}
                    </td>
                    <td className="px-5 py-3 text-muted">{u.email}</td>
                    <td className="px-5 py-3 text-muted">{u.phone || '—'}</td>
                    <td className="px-5 py-3 text-muted">
                      {u.createdAt ? new Date(u.createdAt).toLocaleDateString('ar-EG') : '—'}
                    </td>
                    <td className="px-5 py-3">
                      {isSelf ? (
                        <span
                          className={`text-xs font-semibold px-2 py-1 rounded-full ${
                            u.role === 'admin'
                              ? 'bg-accentGreen/10 text-accentGreen'
                              : 'bg-panelAlt text-muted'
                          }`}
                        >
                          {ROLE_LABELS[u.role] || u.role}
                        </span>
                      ) : (
                        <select
                          value={u.role}
                          disabled={updatingId === u.id}
                          onChange={(e) => handleRoleChange(u.id, e.target.value)}
                          className={`text-xs font-semibold px-2 py-1.5 rounded-full border-0 outline-none cursor-pointer disabled:opacity-50 ${
                            u.role === 'admin'
                              ? 'bg-accentGreen/10 text-accentGreen'
                              : 'bg-panelAlt text-muted'
                          }`}
                        >
                          <option value="customer" className="bg-panel text-light">زبون</option>
                          <option value="admin" className="bg-panel text-light">أدمن</option>
                        </select>
                      )}
                    </td>
                    <td className="px-5 py-3">
                      <div className="flex items-center gap-2 justify-end">
                        {!isSelf && (
                          <button
                            onClick={() => handleDelete(u.id)}
                            disabled={deletingId === u.id}
                            className="text-xs font-medium text-accentRed hover:underline disabled:opacity-50"
                          >
                            {deletingId === u.id ? 'جاري الحذف...' : 'حذف'}
                          </button>
                        )}
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}