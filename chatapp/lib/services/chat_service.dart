import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ChatService {
  String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    } else {
      // For Android emulator, use 10.0.2.2
      try {
        if (Platform.isAndroid) {
          return 'http://10.0.2.2:8000';
        }
      } catch (e) {
        // Platform.isAndroid throws on web, but kIsWeb check handles it.
        // This catch is just a safety net if logic changes.
      }
      return 'http://localhost:8000';
    }
  }

  Future<String> sendMessage(String message) async {
    try {
      final url = '$_baseUrl/chat';
      print('Sending message to $url');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // 'Access-Control-Allow-Origin': '*', // Client-side headers don't fix CORS, but good to know
        },
        body: jsonEncode({'message': message}),
      );

      print('Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? 'No response from bot';
      } else {
        throw Exception('Failed to load response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in ChatService: $e');
      throw Exception('Connection error: $e');
    }
  }
}
