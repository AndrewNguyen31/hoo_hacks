import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool isOpen = false;
  
  final List<Map<String, String>> navItems = [
    {'name': 'About Us', 'href': 'about'},
    {'name': 'Motivation', 'href': 'motivation'},
    {'name': 'Contact', 'href': 'contact'},
  ];

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text('MediSpeak'),
      actions: [
        Row(
          children: navItems.map((item) => 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextButton(
                onPressed: () {
                  // Implement navigation logic here
                },
                child: Text(
                  item['name']!,
                  style: const TextStyle(
                    color: Colors.white,
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