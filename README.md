# 🛍️ Flutter E-Commerce App

## 📦 Project Overview

This Flutter-based e-commerce mobile application provides a seamless and interactive shopping experience. It allows users to browse products, view detailed descriptions, manage their cart, checkout, and maintain user profiles. The app uses a modern UI design with a teal color theme, soft shadows, and rounded input fields to ensure a clean and engaging experience.

---

## 🚀 Features

- 🛒 **Product Listing & Details**: Users can view products with detailed descriptions, pricing, and images.
- 🧺 **Shopping Cart**: Add/remove items, view total price, apply promo codes, and checkout with confirmation.
- 🔐 **User Authentication**: Signup and login functionality with validation for Gmail-only addresses and strong password enforcement.
- 👤 **Profile Management**: View/edit profile name, view email, access order history, and wishlist.
- 🧾 **Order History**: Displays user-specific order history after checkout.
- 💖 **Wishlist View**: Displays placeholder favorite products (can be extended to real user data).
- ✨ **Modern UI/UX**: All screens follow a consistent design pattern with gradient backgrounds, rounded widgets, and soft UI shadows.
- 🛠 **State Management**: Uses the `Provider` package to manage user and cart state across the app.

---

## 🧰 Tools & Technologies Used

| Technology         | Description                                       |
|--------------------|---------------------------------------------------|
| **Flutter**        | Core mobile framework for cross-platform apps     |
| **Dart**           | Programming language for Flutter development      |
| **Provider**       | Lightweight and scalable state management         |
| **Material Design**| UI components like buttons, cards, and dialogs    |
| **SharedPreferences** *(optional)* | For storing simple persistent user data    |
| **Firebase** *(optional)*          | Can be integrated for authentication & DB |

---

## 🗂 Code Structure

The project follows a simplified **MVVM (Model-View-ViewModel)** architecture to maintain modularity and clean separation of concerns.

### ✅ Design Pattern: MVVM

| Layer        | Role                                                                  |
|--------------|-----------------------------------------------------------------------|
| **Model**    | Contains data models like `Product`, `User`, etc.                     |
| **View**     | Contains UI screens like `HomeScreen`, `LoginScreen`, etc.           |
| **ViewModel**| Contains business logic and state (via `Provider`s like Cart/User)    |

---

## 📁 Folder Structure

```text
lib/
├── main.dart
├── models/
│   └── product.dart
├── providers/
│   ├── cart_provider.dart
│   └── user_provider.dart
├── screens/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   ├── cart_screen.dart
│   ├── profile_screen.dart
│   └── product_detail_screen.dart
├── widgets/
│   └── (Reusable UI components if needed)
└── utils/
    └── validators.dart (email/password validation)





    
 https://drive.google.com/file/d/1F9A-jVu8uvSRWgzIz97re3K3C81ijYLR/view?usp=drivesdk

 https://drive.google.com/file/d/1F2QjZbfWX2r28Jop2-oZXqHgdCrFCErW/view?usp=drivesdk