import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/language.dart';

class LanguageService {
  static Future<List<Language>> loadLanguages() async {
    final String jsonString = await rootBundle.loadString('assets/metadata/languages.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    
    return jsonMap.entries
        .map((entry) => Language.fromJson(entry))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  static Language getDefaultLanguage(List<Language> languages) {
    return languages.firstWhere(
      (lang) => lang.code == 'en',
      orElse: () => languages.first,
    );
  }
}