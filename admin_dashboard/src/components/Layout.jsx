import React from 'react';
import { NavLink, Outlet } from 'react-router-dom';
import { useAuth } from '../context/AuthContext.jsx';

const navItems = [
  { to: '/', label: 'الرئيسية', end: true },
  { to: '/products', label: 'المنتجات' },
  { to: '/orders', label: 'الطلبات' },
  { to: '/services/packages', label: 'باقات الخدمة' },
  { to: '/services/requests', label: 'طلبات الخدمة' },
  { to: '/users', label: 'المستخدمين' },
];

function SignalBars() {
  return (
    <span className="signal-bars">
      <span></span>
      <span></span>
      <span></span>
    </span>
  );
}

export default function Layout() {
  const { user, logout } = useAuth();

  return (
    <div className="min-h-screen bg-ink flex" dir="rtl">
      <aside className="w-64 shrink-0 bg-panel border-l border-border flex flex-col">
        <div className="px-6 py-6 border-b border-border">
          <h1 className="font-display text-lg font-bold text-light">الإيهاب</h1>
          <p className="text-xs text-muted mt-1 tracking-wide">لوحة تحكم الأدمن</p>
        </div>

        <nav className="flex-1 px-3 py-6 space-y-1">
          {navItems.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.end}
              className={({ isActive }) =>
                `nav-item flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium transition-colors ${
                  isActive
                    ? 'active bg-panelAlt text-light'
                    : 'text-muted hover:text-light hover:bg-panelAlt/60'
                }`
              }
            >
              <SignalBars />
              {item.label}
            </NavLink>
          ))}
        </nav>

        <div className="px-4 py-5 border-t border-border">
          <p className="text-xs text-muted px-2 mb-2 truncate">{user?.email}</p>
          <button
            onClick={logout}
            className="w-full text-right text-sm font-medium text-accentRed hover:bg-panelAlt/60 rounded-lg px-4 py-2 transition-colors"
          >
            تسجيل الخروج
          </button>
        </div>
      </aside>

      <main className="flex-1 overflow-y-auto">
        <Outlet />
      </main>
    </div>
  );
}