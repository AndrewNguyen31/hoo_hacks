import 'package:flutter/material.dart';

class PageTransition extends StatelessWidget {
  final Widget child;

  const PageTransition({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: child,
    );
  }
}