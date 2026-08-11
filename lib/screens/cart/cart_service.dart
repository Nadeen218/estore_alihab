// lib/cart/cart_service.dart

import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final String subtitle;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
}

class CartService {
  static final ValueNotifier<List<CartItem>> cartItemsNotifier =
  ValueNotifier<List<CartItem>>([
    CartItem(
      id: "1",
      title: "iPhone 15 Pro Max",
      subtitle: "256GB • أسود تيتانيوم",
      price: 4500.0,
      quantity: 1,
      image: "https://img.icons8.com/plasticine/200/iphone-x.png",
    ),
    CartItem(
      id: "2",
      title: "AirPods Pro (2nd)",
      subtitle: "أبيض",
      price: 750.0,
      quantity: 1,
      image: "https://img.icons8.com/plasticine/200/headphones.png",
    ),
  ]);

  static List<CartItem> get items => cartItemsNotifier.value;

  static void addToCart(
      Map<String, dynamic> product, {
        int quantity = 1,
        String? selectedStorage,
        String? selectedColor,
      }) {
    // 1. معالجة السعر بشكل استباقي لمنع الـ null أو القيم النصية المعقدة
    double parsedPrice = 0.0;
    var rawPrice = product["price"] ?? product["productPrice"] ?? product["priceAmount"];

    if (rawPrice != null) {
      if (rawPrice is num) {
        parsedPrice = rawPrice.toDouble();
      } else {
        // تنظيف النص من الفواصل والعملات مثل "3,800 ₪" -> "3800"
        String cleanPrice = rawPrice.toString().replaceAll(',', '').replaceAll(RegExp(r'[^\d.]'), '');
        parsedPrice = double.tryParse(cleanPrice) ?? 0.0;
      }
    }

    // 2. استخراج الـ ID و العنوان و الصورة مع بدائل مريحة
    final String id = (product["id"] ?? product["_id"] ?? product["title"] ?? DateTime.now().millisecondsSinceEpoch).toString();
    final String title = (product["title"] ?? product["name"] ?? "منتج").toString();
    final String image = (product["image"] ?? product["imageUrl"] ?? "").toString();

    // 3. بناء الـ Subtitle من الخيارات المحددة
    List<String> details = [];
    if (selectedStorage != null && selectedStorage.isNotEmpty) details.add(selectedStorage);
    if (selectedColor != null && selectedColor.isNotEmpty) details.add(selectedColor);

    String subtitle = details.isNotEmpty
        ? details.join(" • ")
        : (product["subtitle"] ?? product["category"] ?? "").toString();

    List<CartItem> currentList = List.from(cartItemsNotifier.value);

    // البحث عن المنتج بالـ ID أو العنوان لضمان عدم التكرار الخاطئ
    int existingIndex = currentList.indexWhere((item) => item.id == id || item.title == title);

    if (existingIndex >= 0) {
      currentList[existingIndex].quantity += quantity;
    } else {
      currentList.add(
        CartItem(
          id: id,
          title: title,
          subtitle: subtitle,
          price: parsedPrice,
          image: image,
          quantity: quantity,
        ),
      );
    }

    // إشعار شاشة السلة بحدث التحديث
    cartItemsNotifier.value = currentList;
  }

  static void removeItem(int index) {
    List<CartItem> currentList = List.from(cartItemsNotifier.value);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      cartItemsNotifier.value = currentList;
    }
  }

  static void incrementQuantity(int index) {
    List<CartItem> currentList = List.from(cartItemsNotifier.value);
    if (index >= 0 && index < currentList.length) {
      currentList[index].quantity++;
      cartItemsNotifier.value = currentList;
    }
  }

  static void decrementQuantity(int index) {
    List<CartItem> currentList = List.from(cartItemsNotifier.value);
    if (index >= 0 && index < currentList.length) {
      if (currentList[index].quantity > 1) {
        currentList[index].quantity--;
        cartItemsNotifier.value = currentList;
      }
    }
  }

  static double get subtotal {
    return cartItemsNotifier.value.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  static double get tax => subtotal * 0.16;

  static double get total => subtotal + tax;
}