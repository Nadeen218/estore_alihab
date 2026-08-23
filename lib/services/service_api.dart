import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_config.dart';
import 'auth_service.dart';

class ServicesApi {
  static String get baseUrl => '${ApiConfig.baseUrl}/services';

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

  static Future<Map<String, dynamic>> checkNumber(String number) async {
    final response = await http.post(
      Uri.parse('$baseUrl/check-number'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'number': number}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return {'available': false};
  }

  static Future<bool> reserveNumber(String number) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    final response = await http.post(
      Uri.parse('$baseUrl/reserve-number'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'number': number}),
    );
    return response.statusCode == 201;
  }

  static Future<bool> submitServiceRequest(Map<String, dynamic> requestData) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

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

  static Future<bool> submitMaintenance(Map<String, dynamic> details) async {
    return submitServiceRequest({
      'type': 'maintenance',
      ...details,
    });
  }
}