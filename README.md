# EA Store — Full-Stack E-Commerce & Telecom Services Platform

**Company:** Al-Ihab Telecom Services

A full-stack e-commerce and telecom services platform developed entirely from scratch for EA Telecom Company during my internship.

The platform consists of three integrated components working together:

1. **Backend API** — Node.js / Express REST API with Firebase Firestore
2. **Admin Dashboard** — React web application for store management
3. **Mobile App** — Flutter application for customers with Arabic/English support and light/dark mode

---

##  📸 Screenshots

### 📱 Mobile App

<p align="center">
  <img width="200" height="450" alt="Screenshot_20260823_200132" src="https://github.com/user-attachments/assets/7b2f037c-c9c0-4e32-84f6-ea00ba6db102" />

  <img width="200" height="450" alt="Screenshot_20260823_200456" src="https://github.com/user-attachments/assets/b9f8baba-b42c-43f4-9bf2-51ab9a076913" />

  <img width="200" height="450" alt="Screenshot_20260823_200420" src="https://github.com/user-attachments/assets/d3cb041f-8cfc-4886-8445-1fd6274f187e" />


  <img width="200" height="450" alt="Screenshot_20260823_200608" src="https://github.com/user-attachments/assets/bed0cf0f-921a-4222-9071-5c08847b7434" />

</p>

### 🖥️ Admin Dashboard

<p align="center">
<img width="![Uploading Screenshot_20260823_200132.png…]()" height="912" alt="admin" src="https://github.com/user-attachments/assets/43931906-00f7-4094-b3f5-e13a355e5c36" />

</p>

---

## 🛠️ Tech Stack

| Layer           | Technology                                                             |
| --------------- | ---------------------------------------------------------------------- |
| Backend         | Node.js, Express, Firebase Firestore, JWT, bcryptjs, express-validator |
| Admin Dashboard | React, Vite, React Router, Tailwind CSS, Axios                         |
| Mobile App      | Flutter, Dart, `http` package                                          |
| Authentication  | JWT (JSON Web Tokens), role-based access (`customer` / `admin`)        |
| Database        | Firebase Firestore                                                     |

---

## ✨ Features

### Backend API

* User registration and login with hashed passwords using bcrypt
* JWT-based authentication
* Role-based access control (`customer` vs `admin`)
* Admin-only endpoints for managing users, products, orders, and services
* Product CRUD operations
* Order creation, status tracking, and order history
* Service packages and service requests management
* SIM and Fiber service requests
* Input validation and protected API routes

### Admin Dashboard

* Secure admin login with JWT-protected routes
* Dashboard overview with product, order, and user statistics
* Full product management (create, edit, list)
* Order management with status updates
* Service package management
* Service request management
* User management (view, change role, delete)
* Self-protection safeguards for administrator accounts

### Mobile App (Flutter)

* Bilingual UI (Arabic / English)
* RTL support for Arabic
* Light/Dark theme toggle
* Product browsing and categories
* Featured products
* Product details
* Shopping cart with live item count badge
* Quantity management
* Checkout
* SIM and Fiber service requests
* Order tracking
* Authentication-gated actions for guests

---

## 👩‍💻 My Role

I developed this platform **entirely from scratch** during my internship at **Al-Ihab Telecom Services**.

I was responsible for the complete development of the system, including:

* Designing and developing the Node.js / Express REST API
* Designing and implementing the backend architecture
* Implementing JWT authentication and role-based authorization
* Integrating and managing Firebase Firestore
* Developing the React + Vite Admin Dashboard
* Developing the Flutter mobile application
* Designing and implementing the application's user interfaces
* Implementing Arabic/English localization and RTL support
* Implementing light/dark mode
* Developing product browsing, categories, and product management
* Implementing shopping cart and checkout functionality
* Implementing order creation, management, and tracking
* Developing SIM and Fiber service request functionality
* Implementing user and role management
* Connecting the mobile application and admin dashboard with the backend API
* Testing, debugging, and integrating the complete system

### Full Development Scope

The entire system was designed and implemented by me across all three components:

```text
┌─────────────────────────┐
│     Flutter Mobile App  │
│        Customers        │
└────────────┬────────────┘
             │
             │ REST API
             ▼
┌─────────────────────────┐
│    Node.js + Express    │
│       Backend API       │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│    Firebase Firestore   │
│        Database         │
└─────────────────────────┘
             ▲
             │
             │ REST API
┌────────────┴────────────┐
│    React Admin Dashboard│
│       Administrators    │
└─────────────────────────┘
```

---

## 🚀 Getting Started

This project requires a Node.js backend connected to Firebase Firestore, a React admin dashboard, and a Flutter mobile app — each configured to communicate with the backend API. Environment variables, service credentials, and configuration files are intentionally not detailed here, since this was a client project built for **Al-Ihab Telecom Services**.

> Full setup instructions are available upon request for evaluation or hiring purposes.

---

## 🔑 Authentication & Roles

* New users register with the `customer` role by default.
* Only existing admins can promote another user to `admin` through the Admin Dashboard → Users page.
* Admins cannot change their own role.
* Admins cannot delete their own account.
* All admin-only API routes are protected by role-based middleware.
* Passwords are securely hashed using bcrypt.
* JWTs are used to authenticate protected requests.

---

## 📌 API Overview (Backend)

The backend exposes a RESTful API covering authentication, user management, products, orders, and telecom service requests (SIM and Fiber), with public endpoints for browsing and authenticated/admin-only endpoints for management actions.

*(Detailed endpoint documentation is available upon request.)*

---

## 🔒 Security Notes

* Environment files and service credentials are excluded from version control via `.gitignore`.
* No real secrets, API keys, Firebase credentials, or private configuration files are committed to this repository.
* Passwords are hashed with bcrypt before being stored.
* Plaintext passwords are never stored or returned by the API.
* JWT authentication is required for protected routes.
* Admin-only routes require both authentication and admin authorization.

---

## 📄 License

This project was developed entirely by me during my internship at **Al-Ihab Telecom Services** and is shared publicly on GitHub with the company's permission. The underlying system and its intellectual property belong to Al-Ihab Telecom Services; this repository is shared for portfolio and demonstration purposes only, and is not licensed for reuse, redistribution, or derivative work by third parties.
