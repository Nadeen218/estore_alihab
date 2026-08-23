import axios from 'axios';

// رابط الباك اند - جاي من ملف .env (شوف .env.example)
const baseURL = import.meta.env.VITE_API_URL || 'http://localhost:5000/api';

const apiClient = axios.create({ baseURL });

// نضيف الـ token تلقائياً لكل طلب لو المستخدم مسجل دخول
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('admin_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// لو رجع 401 (توكن منتهي/غلط)، نطلع المستخدم لصفحة تسجيل الدخول
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('admin_token');
      localStorage.removeItem('admin_user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default apiClient;
