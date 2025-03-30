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
                        'MediSpeak is an innovative healthcare application designed to break down language barriers and help patients better understand their health.',
                        style: TextStyle(
                          fontSize: 20,
                          height: 1.5,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'By combining real-time translation with easy-to-follow visual aids, MediSpeak empowers patients to make informed decisions about their care. Whether it\'s simplifying complex medical terms or tailoring explanations to cultural needs, MediSpeak ensures every patient feels heard, respected, and confident in their healthcare journey.',
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
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      '../assets/images/Logo.png',
                      width: 500,
                      height: 500,
                      fit: BoxFit.cover,
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