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
      backgroundColor: Colors.white,
      elevation: 4,
      leadingWidth: 0,
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: navItems.map((item) => 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TextButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 8.0)),
                  minimumSize: WidgetStateProperty.all(Size.zero),
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return const Color(0xFFFF006E);
                    }
                    return Colors.black87;
                  }),
                ),
                onPressed: () => widget.onSectionClick(item['id']!),
                child: Text(
                  item['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ).toList(),
        ),
      ),
      centerTitle: false,
    );
  }
}