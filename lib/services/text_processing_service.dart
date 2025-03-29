import 'package:http/http.dart' as http;
import 'dart:convert';

class TextProcessingService {
  final String baseUrl = 'YOUR_API_BASE_URL';

  Future<String> simplifyText(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/simplify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['simplified_text'];
      } else {
        throw Exception('Failed to simplify text');
      }
    } catch (e) {
      print('Error simplifying text: $e');
      return text; // Return original text on error
    }
  }

  Future<String> translateText(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/translate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['translated_text'];
      } else {
        throw Exception('Failed to translate text');
      }
    } catch (e) {
      print('Error translating text: $e');
      return text;
    }
  }

  Future<double> getSimilarityScore(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/similarity'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['similarity_score'];
      } else {
        throw Exception('Failed to get similarity score');
      }
    } catch (e) {
      print('Error getting similarity score: $e');
      return 0.0;
    }
  }
}