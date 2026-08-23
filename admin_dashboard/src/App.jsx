import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Layout from './components/Layout.jsx';
import ProtectedRoute from './components/ProtectedRoute.jsx';
import LoginPage from './pages/LoginPage.jsx';
import DashboardHome from './pages/DashboardHome.jsx';
import ProductsPage from './pages/ProductsPage.jsx';
import ProductFormPage from './pages/ProductFormPage.jsx';
import OrdersPage from './pages/OrdersPage.jsx';
import ServicePackagesPage from './pages/ServicePackagesPage.jsx';
import ServicePackageFormPage from './pages/ServicePackageFormPage.jsx';
import ServiceRequestsPage from './pages/ServiceRequestsPage.jsx';

export default function App() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />

      <Route
        path="/"
        element={
          <ProtectedRoute>
            <Layout />
          </ProtectedRoute>
        }
      >
        <Route index element={<DashboardHome />} />
        <Route path="products" element={<ProductsPage />} />
        <Route path="products/new" element={<ProductFormPage />} />
        <Route path="products/:id/edit" element={<ProductFormPage />} />
        <Route path="orders" element={<OrdersPage />} />
        <Route path="services/packages" element={<ServicePackagesPage />} />
        <Route path="services/packages/new" element={<ServicePackageFormPage />} />
        <Route path="services/packages/:id/edit" element={<ServicePackageFormPage />} />
        <Route path="services/requests" element={<ServiceRequestsPage />} />
      </Route>
    </Routes>
  );
}