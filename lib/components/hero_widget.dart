import 'package:flutter/material.dart';
import '../models/language.dart';
import '../services/language_service.dart';

class HeroWidget extends StatefulWidget {
  final Function(String)? onTextSubmit;
  final VoidCallback? onMicPressed;
  final bool isListening;
  final Function(Language)? onLanguageChanged;
  
  const HeroWidget({
    super.key, 
    this.onTextSubmit,
    this.onMicPressed,
    this.isListening = false,
    this.onLanguageChanged,
  });

  @override
  State<HeroWidget> createState() => _HeroWidgetState();
}

class _HeroWidgetState extends State<HeroWidget> {
  final TextEditingController _textController = TextEditingController();
  List<Language> _languages = [];
  Language? _selectedLanguage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    try {
      final languages = await LanguageService.loadLanguages();
      setState(() {
        _languages = languages;
        _selectedLanguage = LanguageService.getDefaultLanguage(languages);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading languages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3A86FF), Color(0xFF0043CE)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'MediSpeak',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Breaking the barrier and bringing clarity in care!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your text here...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_textController.text.isNotEmpty && widget.onTextSubmit != null) {
                        widget.onTextSubmit!(_textController.text);
                        _textController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A7DFF),
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.all(0),
                      minimumSize: const Size(52, 52),
                      elevation: 0,
                    ),
                    child: const Icon(Icons.arrow_forward, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: widget.onMicPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A7DFF),
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      minimumSize: const Size(200, 52),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.isListening ? Icons.mic : Icons.mic_none,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Start Speaking',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const SizedBox(
                height: 52,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            else
              Container(
                height: 52,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    popupMenuTheme: PopupMenuThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: DropdownButton<Language>(
                    value: _selectedLanguage,
                    isExpanded: true,
                    icon: const Icon(Icons.language),
                    menuMaxHeight: 250,
                    dropdownColor: Colors.white,
                    underline: Container(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    items: _languages.map((Language language) {
                      return DropdownMenuItem<Language>(
                        value: language,
                        child: Text(
                          language.name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (Language? newValue) {
                      setState(() {
                        _selectedLanguage = newValue;
                      });
                      if (newValue != null && widget.onLanguageChanged != null) {
                        widget.onLanguageChanged!(newValue);
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}