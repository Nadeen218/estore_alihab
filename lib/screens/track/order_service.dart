import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  static const String baseUrl = 'http://localhost:5000/api/orders';

  static Future<List<Map<String, dynamic>>> getMyOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/my-orders'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('فشل في جلب الطلبات');
    }
  }
}