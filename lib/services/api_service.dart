import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'storage_service.dart';

class ApiService {
  // Lavellh Backend API
  static const String baseURL = 'https://lavellh-backend.onrender.com';

  /// Get default headers with authentication token
  static Future<Map<String, String>> _getDefaultHeaders({
    Map<String, String>? additionalHeaders,
  }) async {
    final token = await StorageService.getToken();

    if (token != null) {
      debugPrint("   Token length: ${token.length}");
      debugPrint(
        "   Token preview: ${token.substring(0, token.length > 20 ? 20 : token.length)}...",
      );
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    if (token != null) {
      debugPrint(
        "   Authorization: Bearer ${token.substring(0, token.length > 30 ? 30 : token.length)}...",
      );
    }

    return headers;
  }

  static Future<http.Response> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('$baseURL$endpoint');

    final defaultHeaders = requireAuth
        ? await _getDefaultHeaders(additionalHeaders: headers)
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (headers != null) ...headers,
          };

    try {
      final requestBody = jsonEncode(body);

      debugPrint("🌐 POST Request to: $url");
      debugPrint("📦 Request Body: $requestBody");

      final response = await http.post(
        url,
        headers: defaultHeaders,
        body: requestBody,
      );

      debugPrint("✅ Response Status: ${response.statusCode}");
      debugPrint("📥 Response Body: ${response.body}");

      return response;
    } catch (e) {
      debugPrint("❌ Network Error: $e");
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> get({
    required String endpoint,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('$baseURL$endpoint');

    final defaultHeaders = requireAuth
        ? await _getDefaultHeaders(additionalHeaders: headers)
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (headers != null) ...headers,
          };

    try {
      debugPrint("🌐 GET Request to: $url");

      final response = await http.get(url, headers: defaultHeaders);

      debugPrint("✅ Response Status: ${response.statusCode}");

      return response;
    } catch (e) {
      debugPrint("❌ Network Error: $e");
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('$baseURL$endpoint');

    final defaultHeaders = requireAuth
        ? await _getDefaultHeaders(additionalHeaders: headers)
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (headers != null) ...headers,
          };

    try {
      final requestBody = jsonEncode(body);

      debugPrint("🌐 PUT Request to: $url");

      final response = await http.put(
        url,
        headers: defaultHeaders,
        body: requestBody,
      );

      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> patch({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('$baseURL$endpoint');

    final defaultHeaders = requireAuth
        ? await _getDefaultHeaders(additionalHeaders: headers)
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (headers != null) ...headers,
          };

    try {
      final requestBody = jsonEncode(body);

      final response = await http.patch(
        url,
        headers: defaultHeaders,
        body: requestBody,
      );

      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> delete({
    required String endpoint,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('$baseURL$endpoint');

    final defaultHeaders = requireAuth
        ? await _getDefaultHeaders(additionalHeaders: headers)
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (headers != null) ...headers,
          };

    try {
      final response = await http.delete(url, headers: defaultHeaders);

      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.StreamedResponse> postMultipart({
    required String endpoint,
    required Map<String, String> fields,
    required Map<String, dynamic>
    files, // Map<String, File> or Map<String, List<File>>
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('$baseURL$endpoint');

    final request = http.MultipartRequest('POST', url);

    // Headers
    final token = await StorageService.getToken();
    if (requireAuth && token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers['Accept'] = 'application/json';

    // Fields
    request.fields.addAll(fields);

    // Files
    for (var entry in files.entries) {
      if (entry.value is String) {
        String path = entry.value;
        if (path.isNotEmpty) {
          MediaType? contentType;
          if (path.toLowerCase().endsWith('.png')) {
            contentType = MediaType('image', 'png');
          } else if (path.toLowerCase().endsWith('.jpg') ||
              path.toLowerCase().endsWith('.jpeg')) {
            contentType = MediaType('image', 'jpeg');
          } else if (path.toLowerCase().endsWith('.webp')) {
            contentType = MediaType('image', 'webp');
          }

          var file = await http.MultipartFile.fromPath(
            entry.key,
            path,
            contentType: contentType,
          );
          request.files.add(file);
        }
      } else if (entry.value is List<String>) {
        for (var path in entry.value) {
          if (path.isNotEmpty) {
            MediaType? contentType;
            if (path.toLowerCase().endsWith('.png')) {
              contentType = MediaType('image', 'png');
            } else if (path.toLowerCase().endsWith('.jpg') ||
                path.toLowerCase().endsWith('.jpeg')) {
              contentType = MediaType('image', 'jpeg');
            } else if (path.toLowerCase().endsWith('.webp')) {
              contentType = MediaType('image', 'webp');
            }

            var file = await http.MultipartFile.fromPath(
              entry.key,
              path,
              contentType: contentType,
            );
            request.files.add(file);
          }
        }
      }
    }

    try {
      debugPrint("🌐 POST Multipart Request to: $url");
      debugPrint("📦 Fields: $fields");
      debugPrint("📂 Files keys: ${files.keys}");

      final streamedResponse = await request.send();
      return streamedResponse;
    } catch (e) {
      debugPrint("❌ Network Error: $e");
      throw Exception('Network error: $e');
    }
  }
}
