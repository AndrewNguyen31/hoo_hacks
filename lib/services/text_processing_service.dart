import 'package:http/http.dart' as http;
import 'dart:convert';

enum TranslationLevel {
  easy,
  intermediate,
  advanced
}

class TextProcessingService {
  final String baseUrl = 'http://localhost:8000';

  Future<Map<String, dynamic>> processText(String text, {String languageCode = 'en'}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/process/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': text,
          'process_all_levels': true,
          'language': languageCode,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'status': 'success',
          'translations': data['translations'],
        };
      } else {
        print('API Error - Status Code: ${response.statusCode}');
        print('API Error - Response Body: ${response.body}');
        return {
          'status': 'error',
          'error': 'Failed to process text',
        };
      }
    } catch (e) {
      print('Error processing text: $e');
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }
}