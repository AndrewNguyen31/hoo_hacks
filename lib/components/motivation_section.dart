import 'package:flutter/material.dart';

class MotivationSection extends StatelessWidget {
  const MotivationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'title': 'Translation',
        'description': 'Leverage medical glossary to make translation more robust, sensitive, and efficient',
      },
      {
        'title': 'Plain-Language\nSimplification',
        'description': 'Automatic rephrasing of complex medical jargon into easy-to-understand explanations',
      },
      {
        'title': 'Confidence Score',
        'description': 'Implement confidence score to see if the MVP model works well',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      child: Column(
        children: [
          const Text(
            'Our Motivation',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 240),
            child: Text(
              'We believe that everyone deserves equal access to healthcare information, regardless of language barriers or health literacy levels.',
              style: TextStyle(
                fontSize: 20,
                height: 1.5,
                color: Color(0xFF4A4A4A),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 80),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 32,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                children: features.map((feature) {
                  return Container(
                    width: 380,
                    height: 250,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          feature['title']!,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: Text(
                            feature['description']!,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}