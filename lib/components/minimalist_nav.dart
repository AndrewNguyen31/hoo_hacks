import 'package:flutter/material.dart';

class MinimalistNav extends StatefulWidget implements PreferredSizeWidget {
  const MinimalistNav({super.key});
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<MinimalistNav> createState() => _MinimalistNavState();
}

class _MinimalistNavState extends State<MinimalistNav> {
  bool scrolled = false;
  final List<Map<String, String>> navItems = [
    {'name': 'Home', 'id': 'home'},
    {'name': 'Translations', 'id': 'translations'},
    {'name': 'Figures', 'id': 'figures'},
    {'name': 'About', 'id': 'about'},
    {'name': 'Motivation', 'id': 'motivation'},
  ];

  @override
  void initState() {
    super.initState();
    // In Flutter, we would use a ScrollController to detect scrolling
    // For this example, we'll just set scrolled to false initially
  }

  void scrollToSection(String id) {
    // In Flutter, we would use a ScrollController to scroll to a specific section
    // This would be implemented differently based on your app's structure
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: scrolled ? Colors.white : Colors.transparent,
      elevation: scrolled ? 4 : 0,
      title: Text(
        'MediSpeak',
        style: TextStyle(
          color: scrolled ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Row(
          children: navItems.map((item) => 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextButton(
                onPressed: () => scrollToSection(item['id']!),
                child: Text(
                  item['name']!,
                  style: TextStyle(
                    color: scrolled ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ).toList(),
        ),
      ],
    );
  }
}