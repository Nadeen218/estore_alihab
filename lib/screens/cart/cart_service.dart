import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Map<String, dynamic> toJson() => {
    'productId': id,
    'title': title,
    'subtitle': subtitle,
    'price': price,
    'image': image,
    'quantity': quantity,
  };
}

class CartService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  static final ValueNotifier<List<CartItem>> cartItemsNotifier =
  ValueNotifier<List<CartItem>>([]);

  static final ValueNotifier<int> ordersCountNotifier = ValueNotifier<int>(0);

  static final ValueNotifier<List<Map<String, dynamic>>> orderHistoryNotifier =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  static List<CartItem> get items => cartItemsNotifier.value;

  static void addToCart(
      Map<String, dynamic> product, {
        int quantity = 1,
        String? selectedStorage,
        String? selectedColor,
      }) {
    double parsedPrice = 0.0;
    var rawPrice = product["price"] ?? product["productPrice"] ?? product["priceAmount"];

    if (rawPrice != null) {
      if (rawPrice is num) {
        parsedPrice = rawPrice.toDouble();
      } else {
        String cleanPrice = rawPrice.toString().replaceAll(',', '').replaceAll(RegExp(r'[^\d.]'), '');
        parsedPrice = double.tryParse(cleanPrice) ?? 0.0;
      }
    }

    final String id = (product["id"] ?? product["_id"] ?? product["title"] ?? DateTime.now().millisecondsSinceEpoch).toString();
    final String title = (product["title"] ?? product["name"] ?? "منتج").toString();
    final String image = (product["image"] ?? product["imageUrl"] ?? "").toString();

    List<String> details = [];
    if (selectedStorage != null && selectedStorage.isNotEmpty) details.add(selectedStorage);
    if (selectedColor != null && selectedColor.isNotEmpty) details.add(selectedColor);

    String subtitle = details.isNotEmpty
        ? details.join(" • ")
        : (product["subtitle"] ?? product["category"] ?? "").toString();

    List<CartItem> currentList = List.from(cartItemsNotifier.value);

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

  static Future<bool> checkoutOrderApi({String? token, Map<String, dynamic>? shippingDetails}) async {
    if (cartItemsNotifier.value.isEmpty) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'items': cartItemsNotifier.value.map((item) => item.toJson()).toList(),
          'subtotal': subtotal,
          'tax': tax,
          'total': total,
          'shippingDetails': shippingDetails ?? {},
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        checkoutOrder();
        return true;
      } else {
        checkoutOrder();
        return true;
      }
    } catch (e) {
      checkoutOrder();
      return true;
    }
  }

  static void checkoutOrder() {
    if (cartItemsNotifier.value.isEmpty) return;

    List<Map<String, dynamic>> currentHistory = List.from(orderHistoryNotifier.value);

    for (var cartItem in cartItemsNotifier.value) {
      int existingIndex = currentHistory.indexWhere((h) => h["nameAr"] == cartItem.title || h["nameEn"] == cartItem.title);

      if (existingIndex >= 0) {
        currentHistory[existingIndex]["count"] += cartItem.quantity;
      } else {
        currentHistory.add({
          "nameAr": cartItem.title,
          "nameEn": cartItem.title,
          "count": cartItem.quantity,
        });
      }
    }

    orderHistoryNotifier.value = currentHistory;
    ordersCountNotifier.value += 1;
    clearCart();
  }

  static void clearCart() {
    cartItemsNotifier.value = [];
  }

  static double get subtotal {
    return cartItemsNotifier.value.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  static double get tax => subtotal * 0.16;

  static double get total => subtotal + tax;
}