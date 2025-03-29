import 'package:flutter/material.dart';

class HeroWidget extends StatefulWidget {
  final Function(String)? onTextSubmit;
  final VoidCallback? onMicPressed;
  final bool isListening;
  
  const HeroWidget({
    super.key, 
    this.onTextSubmit,
    this.onMicPressed,
    this.isListening = false,
  });

  @override
  State<HeroWidget> createState() => _HeroWidgetState();
}

class _HeroWidgetState extends State<HeroWidget> {
  final TextEditingController _textController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3A86FF), Color(0xFF0043CE)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'MediSpeak',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Breaking the barrier and bringing clarity in care!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your text here...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 52, // Match the height of the text field
                  child: ElevatedButton(
                    onPressed: () {
                      if (_textController.text.isNotEmpty && widget.onTextSubmit != null) {
                        widget.onTextSubmit!(_textController.text);
                        _textController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A7DFF),
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.all(0),
                      minimumSize: const Size(52, 52), // Square button
                      elevation: 0,
                    ),
                    child: const Icon(Icons.arrow_forward, size: 24),
                  ),
                ),
                const SizedBox(width: 16), // Reduced spacing between buttons
                SizedBox(
                  height: 52, // Match the height
                  child: ElevatedButton(
                    onPressed: widget.onMicPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A7DFF),
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      minimumSize: const Size(200, 52),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.isListening ? Icons.mic : Icons.mic_none,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Start Speaking',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500, // Slightly reduced weight
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}