import 'package:flutter/material.dart';

class MinimalistNav extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onSectionClick;
  
  const MinimalistNav({
    super.key,
    required this.onSectionClick,
  });
  
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
    // Add scroll listener to handle navbar color change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scrollController = PrimaryScrollController.of(context);
      scrollController.addListener(() {
        setState(() {
          scrolled = scrollController.offset > 50;
        });
      });

    });
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
                onPressed: () => widget.onSectionClick(item['id']!),
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