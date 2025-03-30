import 'package:flutter/material.dart';

class TranslationCards extends StatefulWidget {
  final String? originalText;
  final List<Map<String, dynamic>> translations;
  final bool isProcessing;
  
  const TranslationCards({
    super.key,
    this.originalText,
    required this.translations,
    this.isProcessing = false,
  });

  @override
  State<TranslationCards> createState() => _TranslationCardsState();
}

class _TranslationCardsState extends State<TranslationCards> {
  List<Map<String, dynamic>> translationHistory = [];
  int? hoveredCardIndex;
  int? expandedCardIndex;

  String getLevelTitle(String level) {
    switch (level) {
      case 'easy':
        return 'Simple Language';
      case 'intermediate':
        return 'Moderate Detail';
      case 'advanced':
        return 'Technical Detail';
      default:
        return 'Translation';
    }
  }

  Color getScoreColor(double score) {
    if (score >= 0.7) {
      return Colors.green;
    } else if (score >= 0.5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  void didUpdateWidget(TranslationCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Add new translations to history when we receive them
    if (widget.translations.isNotEmpty && 
        (translationHistory.isEmpty || 
         translationHistory.last['originalText'] != widget.originalText)) {
      setState(() {
        translationHistory.add({
          'originalText': widget.originalText!,
          'translations': widget.translations,
        });
      });
    }
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
              fontSize: 40,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          if (widget.isProcessing)
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Processing text...'),
                ],
              ),
            )
          else if (widget.translations.isEmpty)
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: const Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'No translations yet. Try speaking or typing something!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            Column(
              children: [
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
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
                        SelectableText(
                          widget.originalText ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    // Calculate card width based on screen size
                    // On smaller screens (phones), show one card at ~90% width
                    // On larger screens (tablets/desktop), show multiple cards
                    final cardWidth = screenWidth < 600 
                        ? screenWidth * 0.9 
                        : screenWidth * 0.3;
                    // Calculate height based on available height or minimum of 300
                    final cardHeight = constraints.maxHeight * 0.6;
                    
                    return SizedBox(
                      height: cardHeight.clamp(300.0, 500.0), // Min 300, max 500
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: widget.translations.asMap().entries.map((entry) {
                            final index = entry.key;
                            final translation = entry.value;
                            
                            return MouseRegion(
                              onEnter: (_) => setState(() => hoveredCardIndex = index),
                              onExit: (_) => setState(() => hoveredCardIndex = null),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    expandedCardIndex = expandedCardIndex == index ? null : index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  width: expandedCardIndex == index 
                                      ? (cardWidth.clamp(300.0, 400.0) * 1.15) 
                                      : cardWidth.clamp(300.0, 400.0),
                                  // Enhanced transform for both hover and expanded states
                                  transform: expandedCardIndex == index 
                                      ? (Matrix4.identity()
                                        ..translate(0.0, -10.0, 0.0)
                                        ..scale(1.05))
                                      : hoveredCardIndex == index
                                        ? (Matrix4.identity()
                                          ..translate(0.0, -5.0, 0.0))
                                        : Matrix4.identity(),
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Card(
                                    elevation: expandedCardIndex == index 
                                        ? 12 
                                        : hoveredCardIndex == index 
                                            ? 8 
                                            : 4,
                                    shadowColor: (expandedCardIndex == index || hoveredCardIndex == index)
                                        ? const Color(0xFFFF006E).withOpacity(0.5) 
                                        : Colors.black.withOpacity(0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: hoveredCardIndex == index ? const Color(0xFFFF006E) : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getLevelTitle(translation['level']),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: SelectableText(
                                                translation['translated_text'],
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: getScoreColor(translation['similarity_score']).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              'Similarity: ${(translation['similarity_score'] * 100).toStringAsFixed(1)}%',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: getScoreColor(translation['similarity_score']),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}