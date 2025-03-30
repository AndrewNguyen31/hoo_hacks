import 'package:flutter/material.dart';
import 'dart:async';

class FiguresSection extends StatefulWidget {
  const FiguresSection({super.key});

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
    // Start checking for images every second
    _checkImagesTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkForImages();
    });
  }

  @override
  void dispose() {
    _checkImagesTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void checkForImages() {
    // Try to load images that start with 'image_'
    List<Map<String, dynamic>> newFigures = [];
    
    // Try loading images from 1 to 5
    for (int i = 1; i <= 7; i++) {
      String imagePath = 'assets/images/image_$i.jpg';
      // Check if image exists by trying to load it
      try {
        // Add to figures list if not already present
        if (!figures.any((f) => f['src'] == imagePath)) {
          newFigures.add({
            'id': i,
            'src': imagePath,
            'alt': 'Medical Image $i',
            'caption': 'Medical Image $i',
          });
        }
      } catch (e) {
        // Image doesn't exist, skip it
        continue;
      }
    }

    // Update state if new images were found
    if (newFigures.isNotEmpty) {
      setState(() {
        figures.addAll(newFigures);
      });
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
                          child: SelectableText(
                            figure['caption'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
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