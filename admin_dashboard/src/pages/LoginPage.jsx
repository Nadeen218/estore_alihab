import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext.jsx';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const { login, loading, error } = useAuth();
  const navigate = useNavigate();

  async function handleSubmit(e) {
    e.preventDefault();
    const success = await login(email, password);
    if (success) navigate('/', { replace: true });
  }

  return (
    <div className="min-h-screen bg-ink flex items-center justify-center px-4" dir="rtl">
      <div className="w-full max-w-sm">
        <div className="text-center mb-8">
          <img src="/EAlogo.png" alt="الإيهاب لخدمات الاتصال" className="h-16 mx-auto mb-4" />
          <h1 className="font-display text-2xl font-bold text-light">الإيهاب لخدمات الاتصال</h1>
          <p className="text-muted text-sm mt-1">تسجيل دخول الأدمن</p>
        </div>

        <form onSubmit={handleSubmit} className="bg-panel border border-border rounded-2xl p-6 space-y-4">
          {error && (
            <div className="bg-accentRed/10 border border-accentRed/30 text-accentRed text-sm rounded-lg px-4 py-2.5">
              {error}
            </div>
          )}

          <div>
            <label className="block text-sm text-muted mb-1.5">البريد الإلكتروني</label>
            <input
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full bg-panelAlt border border-border rounded-lg px-4 py-2.5 text-light text-sm outline-none focus:border-accentBlue transition-colors"
              placeholder="admin@example.com"
            />
          </div>

          <div>
            <label className="block text-sm text-muted mb-1.5">كلمة السر</label>
            <input
              type="password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full bg-panelAlt border border-border rounded-lg px-4 py-2.5 text-light text-sm outline-none focus:border-accentBlue transition-colors"
              placeholder="••••••••"
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-accentBlue hover:bg-accentBlue/90 disabled:opacity-60 text-white font-semibold text-sm rounded-lg py-2.5 transition-colors"
          >
            {loading ? 'جاري الدخول...' : 'تسجيل الدخول'}
          </button>
        </form>
      </div>
    </div>
  );
}