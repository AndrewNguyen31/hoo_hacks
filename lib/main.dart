import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'services/text_processing_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Original: $_text',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20),
            if (_isProcessing)
              CircularProgressIndicator()
            else ...[
              Text(
                'Processed: $_processedText',
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
              ),
              SizedBox(height: 10),
              Text(
                'Similarity Score: ${(_similarityScore * 100).toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 16.0, color: Colors.green),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        tooltip: 'Listen',
        backgroundColor: _isListening ? Colors.red : Colors.blue,
        child: Icon(
          _isListening ? Icons.mic : Icons.mic_none,
          color: Colors.white,
        ),
      ),
    );
  }
}
