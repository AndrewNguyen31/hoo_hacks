import 'package:flutter/material.dart';

class FiguresSection extends StatefulWidget {
  const FiguresSection({super.key});

  @override
  State<FiguresSection> createState() => _FiguresSectionState();
}

class _FiguresSectionState extends State<FiguresSection> {
  final ScrollController _scrollController = ScrollController();
  
  // Sample images - in a real app, you would use actual images
  final List<Map<String, dynamic>> figures = [
    {
      'id': 1,
      'src': 'assets/images/image_1.jpg',
      'alt': 'Broken Collarbone Illustration',
      'caption': 'Anatomical illustration of a broken collarbone showing skeletal structure',
    },
    {
      'id': 2,
      'src': 'assets/images/image_3.png',
      'alt': 'Clavicle Fracture Anatomy',
      'caption': 'Detailed anatomical view showing nerves and blood vessels around clavicle fracture',
    },
    {
      'id': 3,
      'src': 'assets/images/image_5.jpg',
      'alt': 'X-ray of Broken Collarbone',
      'caption': 'X-ray image showing a clear fracture in the collarbone',
    },
  ];

  void _scroll(String direction) {
    final double scrollAmount = 300;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _scroll('left'),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  foregroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _scroll('right'),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  foregroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
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
                        child: figure['src'] != null 
                          ? Image.asset(
                              figure['src'],
                              height: 450,
                              width: 500,
                              fit: BoxFit.contain,
                            )
                          : Icon(
                              Icons.image,
                              size: 450,
                              color: Theme.of(context).primaryColor,
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
      ),
    );
  }
}