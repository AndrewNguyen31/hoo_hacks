import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class FiguresSection extends StatefulWidget {
  final bool hasTranslation;
  
  const FiguresSection({
    super.key,
    this.hasTranslation = false,
  });

  @override
  State<FiguresSection> createState() => _FiguresSectionState();
}

class _FiguresSectionState extends State<FiguresSection> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> figures = [];
  Timer? _checkImagesTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(FiguresSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Start or stop checking for images based on hasTranslation
    if (widget.hasTranslation && !oldWidget.hasTranslation) {
      _startCheckingImages();
    } else if (!widget.hasTranslation && oldWidget.hasTranslation) {
      _stopCheckingImages();
    }
  }

  void _startCheckingImages() {
    // Start checking for images every second
    _checkImagesTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkForImages();
    });
  }

  void _stopCheckingImages() {
    _checkImagesTimer?.cancel();
  }

  @override
  void dispose() {
    _stopCheckingImages();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> checkForImages() async {
    try {
      // Load the metadata file
      final String jsonString = await rootBundle.loadString('assets/metadata/google_images_data.json');
      final List<dynamic> imageData = json.decode(jsonString);
      
      // Convert the data to our figures format
      List<Map<String, dynamic>> newFigures = imageData.map((data) => {
        'id': data['image_file'].split('_')[1].split('.')[0],
        'src': data['image_file'],
        'alt': data['image_description'],
        'caption': data['ai_description'] ?? data['image_description'],
        'similarity_score': data['similarity_score'],
      }).toList();

      // Update state if we have new figures
      if (newFigures.isNotEmpty) {
        setState(() {
          figures = newFigures;
        });
      }
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  void _scroll(String direction) {
    final double scrollAmount = 560;
    if (direction == 'left') {
      _scrollController.animateTo(
        _scrollController.offset - scrollAmount,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.animateTo(
        _scrollController.offset + scrollAmount,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const SelectableText(
            'Figures & Illustrations',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          if (figures.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _scroll('left'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _scroll('right'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 600,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: figures.length,
                itemBuilder: (context, index) {
                  final figure = figures[index];
                  return Container(
                    width: 500,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.asset(
                            figure['src'],
                            height: 450,
                            width: 500,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // Remove this figure if image fails to load
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  figures.remove(figure);
                                });
                              });
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(24),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                figure['caption'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: getScoreColor(figure['similarity_score']).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Relevance: ${(figure['similarity_score'] * 100).toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: getScoreColor(figure['similarity_score']),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}