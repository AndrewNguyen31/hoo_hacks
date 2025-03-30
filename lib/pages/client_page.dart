import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../services/text_processing_service.dart';
import '../components/minimalist_nav.dart';
import '../components/hero_widget.dart';
import '../components/translation_cards.dart';
import '../components/about_section.dart';
import '../components/motivation_section.dart';
import '../components/page_transition.dart';
import '../layout/root_layout.dart';
import '../models/language.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextProcessingService _textService = TextProcessingService();
  final ScrollController _scrollController = ScrollController();
  
  // Keys for sections
  final _heroKey = GlobalKey();
  final _translationsKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _motivationKey = GlobalKey();
  
  // State variables
  bool _isListening = false;
  bool _speechEnabled = false;
  bool _isProcessing = false;
  String _text = 'Press the button and start speaking';
  String _selectedLanguageCode = 'en';
  List<Map<String, dynamic>> _translations = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onStatus: (status) => print('onStatus: $status'),
      onError: (errorNotification) => print('onError: $errorNotification'),
    );
    setState(() {});
  }

  void _listen() async {
    if (!_isListening) {
      if (_speechEnabled) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
            if (result.finalResult) {
              _processText(_text);
            }
          },
          localeId: _selectedLanguageCode,
          listenFor: const Duration(seconds: 30),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      if (_text.isNotEmpty && _text != 'Press the button and start speaking') {
        _processText(_text);
      }
    }
  }

  Future<void> _processText(String text) async {
    setState(() {
      _isProcessing = true;
      _text = text;
    });

    try {
      // Make sure to send the client mode flag
      final result = await _textService.processText(
        text,
        languageCode: _selectedLanguageCode,
        isClientMode: true,
      );
      
      setState(() {
        _isProcessing = false;
        if (result['status'] == 'success') {
          if (result.containsKey('translations')) {
            _translations = List<Map<String, dynamic>>.from(result['translations']);
            print('Received translations: $_translations');
          } else {
            _translations = [];
            print('No translations found in response');
          }
        } else {
          _translations = [];
          print('Error status in response');
        }
      });
    } catch (e) {
      print('Error processing text: $e');
      setState(() {
        _isProcessing = false;
        _translations = [];
      });
    }
  }

  void scrollToSection(String id) {
    // Handle navigation back to main page
    if (id == 'doctor') {
      Navigator.pop(context);
      return;
    }
    
    final keys = {
      'home': _heroKey,
      'translations': _translationsKey,
      'about': _aboutKey,
      'motivation': _motivationKey,
    };

    if (keys.containsKey(id)) {
      final context = keys[id]!.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RootLayout(
      child: Scaffold(
        appBar: MinimalistNav(
          onSectionClick: scrollToSection,
          isClientPage: true,
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              HeroWidget(
                key: _heroKey,
                onTextSubmit: (text) {
                  setState(() {
                    _text = text;
                  });
                  _processText(text);
                },
                onMicPressed: _listen,
                isListening: _isListening,
                onLanguageChanged: (language) {
                  setState(() {
                    _selectedLanguageCode = language.code;
                  });
                  if (_text.isNotEmpty && _text != 'Press the button and start speaking') {
                    _processText(_text);
                  }
                },
                isClientMode: true,
              ),
              TranslationCards(
                key: _translationsKey,
                originalText: _text,
                translations: _translations,
                isProcessing: _isProcessing,
              ),
              AboutSection(
                key: _aboutKey,
              ),
              MotivationSection(
                key: _motivationKey,
              ),
              PageTransition(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
} 