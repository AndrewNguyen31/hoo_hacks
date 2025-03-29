import 'package:flutter/material.dart';

class TranslationCards extends StatefulWidget {
  const TranslationCards({super.key});

  @override
  State<TranslationCards> createState() => _TranslationCardsState();
}

class _TranslationCardsState extends State<TranslationCards> {
  List<Map<String, dynamic>> translations = [
    {
      'text': 'Hello, how are you feeling today?',
      'translatedText': 'Hola, ¿cómo te sientes hoy?',
      'confidenceScore': 0.95
    },
    {
      'text': 'Do you have any pain?',
      'translatedText': '¿Tienes algún dolor?',
      'confidenceScore': 0.92
    },
    {
      'text': 'Please describe your symptoms.',
      'translatedText': 'Por favor, describe tus síntomas.',
      'confidenceScore': 0.88
    },
  ];
  
  int currentIndex = 0;
  bool isProcessing = false;

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % translations.length;
    });
  }

  void prevCard() {
    setState(() {
      currentIndex = (currentIndex - 1 + translations.length) % translations.length;
    });
  }

  @override
  void initState() {
    super.initState();
    // This would be connected to the actual speech recognition system
    // For now, we'll simulate it with a listener
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Text(
            'Translations',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: isProcessing
                  ? const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text('Processing speech...'),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Original Text:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          translations[currentIndex]['text'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Translated Text:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          translations[currentIndex]['translatedText'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Confidence Score: ${(translations[currentIndex]['confidenceScore'] * 100).toStringAsFixed(2)}%',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: prevCard,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  foregroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: nextCard,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  foregroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}