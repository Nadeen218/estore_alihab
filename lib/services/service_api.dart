import 'dart:convert';
import 'package:http/http.dart' as http;

class ServicesApi {
  static const String baseUrl = 'http://10.0.2.2:5000/api/services';

  static Future<List<dynamic>> getPackages(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/packages?type=$type'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return [];
  }

  static Future<bool> checkFiberCoverage(String city) async {
    final response = await http.post(
      Uri.parse('$baseUrl/check-coverage'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'city': city}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['available'];
    }
    return false;
  }

  static Future<bool> submitServiceRequest(String token, Map<String, dynamic> requestData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(requestData),
    );
    return response.statusCode == 201;
  }

  static Future<bool> submitMaintenance(Map<String, dynamic> requestData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/maintenance'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}