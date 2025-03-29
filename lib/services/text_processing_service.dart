import 'package:http/http.dart' as http;
import 'dart:convert';

class TextProcessingService {
  final String baseUrl = 'YOUR_API_BASE_URL';

  Future<Map<String, dynamic>> processText(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/process/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to process text');
      }
    } catch (e) {
      return {
        'error': e.toString(),
        'status': 'error'
      };
    }
  }
}