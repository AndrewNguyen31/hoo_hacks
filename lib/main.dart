import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'services/text_processing_service.dart';
import 'components/minimalist_nav.dart';
import 'components/hero_widget.dart';
import 'components/translation_cards.dart';
import 'components/about_section.dart';
import 'components/motivation_section.dart';
import 'components/figures_section.dart';
import 'components/page_transition.dart';
import 'utils/styles.dart';
import 'layout/root_layout.dart';
import 'pages/client_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediSpeak',
      theme: getAppTheme(),
      home: const MyHomePage(title: 'MediSpeak'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextProcessingService _textService = TextProcessingService();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  List<Map<String, dynamic>> _translations = [];
  bool _speechEnabled = false;
  bool _isProcessing = false;
  String _selectedLanguageCode = 'en';
  final ScrollController _scrollController = ScrollController();
  final _heroKey = GlobalKey();
  final _translationsKey = GlobalKey();
  final _figuresKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _motivationKey = GlobalKey();

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

  Future<void> _processText(String text) async {
    setState(() {
      _isProcessing = true;
      _text = text;
    });

    try {
      final result = await _textService.processText(
        text,
        languageCode: _selectedLanguageCode,
      );
      
      setState(() {
        _isProcessing = false;
        if (result['status'] == 'success') {
          _translations = List<Map<String, dynamic>>.from(result['translations']);
        } else {
          _translations = [];
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

  void _listen() async {
    if (!_isListening) {
      if (_speechEnabled) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) async {
             setState(() {
               _text = result.recognizedWords;
             });
             if (result.finalResult) {
               _processText(_text);
             }
           },
           localeId: _selectedLanguageCode,
           onDevice: true,
           listenFor: Duration(seconds: 30),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void scrollToSection(String id) {
    // Handle navigation to client page
    if (id == 'client') {
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => const ClientPage()),
      );
      return;
    }
    
    final keys = {
      'home': _heroKey,
      'translations': _translationsKey,
      'figures': _figuresKey,
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
                isClientMode: false,
              ),
              TranslationCards(
                key: _translationsKey,
                originalText: _text,
                translations: _translations,
                isProcessing: _isProcessing,
              ),
              FiguresSection(
                key: _figuresKey,
                hasTranslation: _translations.isNotEmpty,
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