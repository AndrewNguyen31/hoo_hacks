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
      'icon': Icons.medical_services,
      'alt': 'Medical translation in action',
      'caption': 'Real-time translation during patient consultation',
    },
    // {
    //   'id': 2,
    //   'src': 'assets/images/hero_background.jpg',
    //   'alt': 'MediSpeak mobile app',
    //   'caption': 'MediSpeak mobile application interface',
    // },
    // {
    //   'id': 3,
    //   'src': 'assets/images/hero_background.jpg',
    //   'alt': 'Language barrier statistics',
    //   'caption': 'Impact of language barriers in healthcare',
    // },
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
          const Text(
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
            height: 400,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: figures.length,
              itemBuilder: (context, index) {
                final figure = figures[index];
                return Container(
                  width: 300,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Image.asset(
                        figure['src'],
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        figure['caption'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
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