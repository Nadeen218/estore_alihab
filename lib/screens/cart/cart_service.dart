import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../api_config.dart';

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
    'name': title,
    'price': price,
    'quantity': quantity,
  };
}

class CartService {
  static String get baseUrl => ApiConfig.baseUrl;

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

  static Future<String?> checkoutOrderApi({
    required String token,
    required Map<String, dynamic> shippingDetails,
  }) async {
    if (cartItemsNotifier.value.isEmpty) return null;
    if (token.isEmpty) return null;

    final itemsPayload = cartItemsNotifier.value.map((item) => item.toJson()).toList();
    final shippingAddress =
        "${shippingDetails['city'] ?? ''} - ${shippingDetails['address'] ?? ''}";

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'items': itemsPayload,
          'shippingAddress': shippingAddress,
          'phone': shippingDetails['phone'] ?? '',
          'notes': shippingDetails['paymentMethod'] ?? '',
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final orderNumber = data['order']?['orderNumber'] as String?;
        checkoutOrder();
        return orderNumber;
      } else {
        print('Order failed: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Order error: $e');
      return null;
    }
  }

  static Future<void> fetchUserOrders(String? token) async {
    if (token == null || token.isEmpty) return;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/my-orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> fetchedOrders = data is List ? data : (data['orders'] ?? []);

        List<Map<String, dynamic>> formattedHistory = [];
        int totalCount = 0;

        for (var order in fetchedOrders) {
          var items = order['items'] ?? [];
          for (var item in items) {
            formattedHistory.add({
              "nameAr": item['name'] ?? item['title'] ?? "طلب",
              "nameEn": item['name'] ?? item['title'] ?? "Order",
              "count": item['quantity'] ?? 1,
              "date": order['createdAt'] ?? "",
              "total": order['totalAmount'] ?? order['total'] ?? 0.0,
            });
            totalCount += (item['quantity'] as num?)?.toInt() ?? 1;
          }
        }

        orderHistoryNotifier.value = formattedHistory;
        ordersCountNotifier.value = totalCount;
      }
    } catch (e) {
      // تفادي التوقف في حال فشل الاتصال المؤقت
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
          "date": DateTime.now().toString(),
          "total": total,
        });
      }
    }

    orderHistoryNotifier.value = currentHistory;
    ordersCountNotifier.value += cartItemsNotifier.value.fold(0, (sum, item) => sum + item.quantity);
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