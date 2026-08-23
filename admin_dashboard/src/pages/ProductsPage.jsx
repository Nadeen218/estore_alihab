import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import apiClient from '../api/client.js';

export default function ProductsPage() {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [deletingId, setDeletingId] = useState(null);

  async function fetchProducts() {
    setLoading(true);
    try {
      const res = await apiClient.get('/products');
      setProducts(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    fetchProducts();
  }, []);

  async function handleDelete(id) {
    if (!window.confirm('متأكد بدك تحذف هاد المنتج؟')) return;
    setDeletingId(id);
    try {
      await apiClient.delete(`/products/${id}`);
      setProducts((prev) => prev.filter((p) => p.id !== id));
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
          <h1 className="font-display text-2xl font-bold text-light">المنتجات</h1>
          <p className="text-muted text-sm mt-1">{products.length} منتج</p>
        </div>
        <Link
          to="/products/new"
          className="bg-accentBlue hover:bg-accentBlue/90 text-white text-sm font-semibold rounded-lg px-5 py-2.5 transition-colors"
        >
          + إضافة منتج
        </Link>
      </div>

      <div className="bg-panel border border-border rounded-2xl overflow-hidden">
        {loading ? (
          <div className="p-10 text-center text-muted text-sm">جاري التحميل...</div>
        ) : products.length === 0 ? (
          <div className="p-10 text-center text-muted text-sm">ما في منتجات بعد. ضيف أول منتج.</div>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border text-muted text-xs uppercase tracking-wide">
                <th className="text-right px-5 py-3 font-medium">المنتج</th>
                <th className="text-right px-5 py-3 font-medium">التصنيف</th>
                <th className="text-right px-5 py-3 font-medium">السعر</th>
                <th className="text-right px-5 py-3 font-medium">المخزون</th>
                <th className="text-right px-5 py-3 font-medium"></th>
              </tr>
            </thead>
            <tbody>
              {products.map((product) => (
                <tr key={product.id} className="border-b border-border last:border-0 hover:bg-panelAlt/40">
                  <td className="px-5 py-3">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-lg bg-panelAlt overflow-hidden shrink-0 flex items-center justify-center">
                        {product.imageUrl ? (
                          <img src={product.imageUrl} alt={product.name} className="w-full h-full object-cover" />
                        ) : (
                          <span className="text-muted text-xs">—</span>
                        )}
                      </div>
                      <span className="text-light font-medium">{product.name}</span>
                    </div>
                  </td>
                  <td className="px-5 py-3 text-muted">{product.category}</td>
                  <td className="px-5 py-3 text-light">{product.price} ₪</td>
                  <td className="px-5 py-3">
                    <span
                      className={`text-xs font-semibold px-2 py-1 rounded-full ${
                        product.stock > 0
                          ? 'bg-accentGreen/10 text-accentGreen'
                          : 'bg-accentRed/10 text-accentRed'
                      }`}
                    >
                      {product.stock > 0 ? `${product.stock} متوفر` : 'نفدت الكمية'}
                    </span>
                  </td>
                  <td className="px-5 py-3">
                    <div className="flex items-center gap-2 justify-end">
                      <Link
                        to={`/products/${product.id}/edit`}
                        className="text-xs font-medium text-accentBlue hover:underline"
                      >
                        تعديل
                      </Link>
                      <button
                        onClick={() => handleDelete(product.id)}
                        disabled={deletingId === product.id}
                        className="text-xs font-medium text-accentRed hover:underline disabled:opacity-50"
                      >
                        {deletingId === product.id ? 'جاري الحذف...' : 'حذف'}
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
