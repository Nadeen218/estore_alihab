import React, { createContext, useContext, useState } from 'react';
import apiClient from '../api/client.js';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(() => {
    const stored = localStorage.getItem('admin_user');
    return stored ? JSON.parse(stored) : null;
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  async function login(email, password) {
    setLoading(true);
    setError('');
    try {
      const res = await apiClient.post('/auth/login', { email, password });
      const { token, user: loggedInUser } = res.data;

      // 👈 نتحقق إنه المستخدم أدمن قبل ما نسمحله يدخل الداشبورد
      if (loggedInUser.role !== 'admin') {
        setError('هاد الحساب مش عنده صلاحية أدمن');
        setLoading(false);
        return false;
      }

      localStorage.setItem('admin_token', token);
      localStorage.setItem('admin_user', JSON.stringify(loggedInUser));
      setUser(loggedInUser);
      setLoading(false);
      return true;
    } catch (err) {
      setError(err.response?.data?.message || 'صار خطأ، جرب مرة تانية');
      setLoading(false);
      return false;
    }
  }

  function logout() {
    localStorage.removeItem('admin_token');
    localStorage.removeItem('admin_user');
    setUser(null);
  }

  return (
    <AuthContext.Provider value={{ user, login, logout, loading, error }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}
