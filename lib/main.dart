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
  String _processedText = '';
  double _similarityScore = 0.0;
  bool _speechEnabled = false;
  bool _isProcessing = false;

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
    });

    try {
      // Process through single API call
      final result = await _textService.processText(text);
      
      setState(() {
        if (result['status'] == 'success') {
          _processedText = result['translated_text'] ?? 'Translation failed';
          _similarityScore = result['similarity_score'] ?? 0.0;
        } else {
          _processedText = 'Error: ${result['error'] ?? 'Unknown error'}';
          _similarityScore = 0.0;
        }
      });
    } catch (e) {
      print('Error processing text: $e');
      setState(() {
        _processedText = 'Error processing text';
        _similarityScore = 0.0;
      });
    } finally {
      setState(() {
        _isProcessing = false;
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
               // Process text when speech is final
               _processText(_text);
             }
           },
           onDevice: true,
           listenFor: Duration(seconds: 30),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RootLayout(
      child: Scaffold(
        appBar: const MinimalistNav(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeroWidget(
                onTextSubmit: (text) {
                  setState(() {
                    _text = text;
                  });
                  _processText(text);
                },
                onMicPressed: _listen,
                isListening: _isListening,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SelectableText(
                      'Original: $_text',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 20),
                    if (_isProcessing)
                      const CircularProgressIndicator()
                    else ...[
                      SelectableText(
                        'Processed: $_processedText',
                        style: const TextStyle(fontSize: 18.0, color: Colors.blue),
                      ),
                      const SizedBox(height: 10),
                      SelectableText(
                        'Similarity Score: ${(_similarityScore * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(fontSize: 16.0, color: Colors.green),
                      ),
                    ],
                  ],
                ),
              ),
              const TranslationCards(),
              const AboutSection(),
              const MotivationSection(),
              // const FiguresSection(),
              PageTransition(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}