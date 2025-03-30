import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class FiguresSection extends StatefulWidget {
  final bool hasTranslation;
  final bool isProcessing;
  
  const FiguresSection({
    super.key,
    this.hasTranslation = false,
    this.isProcessing = false,
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
      
      // Convert the data to our figures format - removing caption and similarity score
      List<Map<String, dynamic>> newFigures = imageData.map((data) => {
        'id': data['image_file'].split('_')[1].split('.')[0],
        'src': data['image_file'],
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const SelectableText(
            'Figures & Illustrations',
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
          else if (figures.isNotEmpty) ...[
            SizedBox(
              height: 400,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                physics: const PageScrollPhysics(),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: figures.map((figure) {
                      return Container(
                        width: 350,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            figure['src'],
                            height: 380,
                            width: 350,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  figures.remove(figure);
                                });
                              });
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ] else
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
                        'No figures yet. Try speaking or typing something!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}