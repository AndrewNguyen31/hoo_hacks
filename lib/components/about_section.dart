import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'About MediSpeak',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 80),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column - Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'MediSpeak is an innovative healthcare application designed to bridge language barriers and enhance patient understanding in medical settings.',
                        style: TextStyle(
                          fontSize: 20,
                          height: 1.5,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'By leveraging advanced AI-powered natural language processing (NLP) and culturally adaptive content, MediSpeak sets itself apart as a comprehensive communication tool for healthcare providers and patients.',
                        style: TextStyle(
                          fontSize: 20,
                          height: 1.5,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 80),
                // Right column - Image placeholder
                Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}