import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = 'http://localhost:5000/api/products';

  static Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('فشل في جلب المنتجات من السيرفر');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم');
    }
  }

  static Future<Map<String, dynamic>> getProductById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('المنتج غير موجود');
      }
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم');
    }
  }
}