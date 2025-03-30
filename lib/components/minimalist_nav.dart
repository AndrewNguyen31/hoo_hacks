import 'package:flutter/material.dart';

class MinimalistNav extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onSectionClick;
  final bool isClientPage;
  
  const MinimalistNav({
    super.key,
    required this.onSectionClick,
    this.isClientPage = false,
  });
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<MinimalistNav> createState() => _MinimalistNavState();
}

class _MinimalistNavState extends State<MinimalistNav> {
  bool scrolled = false;
  late List<Map<String, String>> navItems;

  @override
  void initState() {
    super.initState();
    _setupNavItems();
    
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

  void _setupNavItems() {
    if (widget.isClientPage) {
      navItems = [
        {'name': 'Home', 'id': 'home'},
        {'name': 'Translations', 'id': 'translations'},
        {'name': 'About', 'id': 'about'},
        {'name': 'Motivation', 'id': 'motivation'},
        {'name': 'Doctor', 'id': 'doctor'}, // This will take us back to the doctor view
      ];
    } else {
      navItems = [
        {'name': 'Home', 'id': 'home'},
        {'name': 'Translations', 'id': 'translations'},
        {'name': 'Figures', 'id': 'figures'},
        {'name': 'About', 'id': 'about'},
        {'name': 'Motivation', 'id': 'motivation'},
        {'name': 'Client', 'id': 'client'}, // This will take us to the client view
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4,
      leadingWidth: 0,
      automaticallyImplyLeading: false,
      title: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) { // Switch to hamburger menu on small screens
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black87),
                  onPressed: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(0, kToolbarHeight, 0, 0),
                      items: navItems.map((item) => 
                        PopupMenuItem<String>(
                          value: item['id'],
                          child: Text(
                            item['name']!,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ).toList(),
                    ).then((value) {
                      if (value != null) {
                        widget.onSectionClick(value);
                      }
                    });
                  },
                ),
              ],
            );
          }
          
          // Original horizontal nav for larger screens
          return Container(
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
          );
        },
      ),
      centerTitle: false,
    );
  }
}