import 'package:flutter/material.dart';

class MotivationSection extends StatelessWidget {
  const MotivationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'title': 'Translation\n',
        'description': 'MediSpeak breaks down language barriers with real-time translation, ensuring clear communication between patients and healthcare providers. It fosters understanding and trust in medical settings, regardless of the language spoken.',
      },
      {
        'title': 'Plain-Language\nSimplification',
        'description': 'Medical jargon can be overwhelming, but MediSpeak simplifies complex terms into easy-to-understand language. Patients gain clarity about their health, while doctors save time rephrasing explanations.',
      },
      {
        'title': 'Improved Efficiency and Costs',
        'description': 'MediSpeak reduces reliance on costly interpreters and streamlines communication workflows for hospitals. Doctors save energy and time, improving efficiency while enhancing patient care quality.',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      child: Column(
        children: [
          const Text(
            'Our Motivation',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 240),
                child: Text(
                  'We believe that everyone deserves equal access to healthcare information, regardless of language barriers or health literacy levels.',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    height: 1.5,
                    color: const Color(0xFF4A4A4A),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 80),
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;
              final cardWidth = isSmallScreen ? constraints.maxWidth - 40 : 380.0;
              
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  child: Row(
                    children: features.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 32),
                        child: Container(
                          width: cardWidth,
                          height: isSmallScreen ? 400 : 350,
                          padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, 2),
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                spreadRadius: -5,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                feature['title']!,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 20 : 23,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF007FFF),
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Expanded(
                                child: Text(
                                  feature['description']!,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 16 : 18,
                                    height: 1.5,
                                    color: const Color(0xFF666666),
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}