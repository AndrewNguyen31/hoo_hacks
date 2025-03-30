import 'package:flutter/material.dart';

class ImageReveal extends StatefulWidget {
  final String src;
  final String alt;
  final Widget child;
  
  const ImageReveal ({
    super.key,
    required this.src,
    required this.alt,
    required this.child,
  });

  @override
  State<ImageReveal> createState() => _ImageRevealState();
}

class _ImageRevealState extends State<ImageReveal> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: isHovered 
            ? (Matrix4.identity()..scale(1.05))
            : Matrix4.identity(),
        child: Stack(
          children: [
            Image.asset(
              widget.src,
              semanticLabel: widget.alt,
            ),
            Positioned.fill(
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}