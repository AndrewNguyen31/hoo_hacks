import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class AnimatedCircle extends StatefulWidget {
  final double radius;
  final Duration duration;
  final Color color;

  const AnimatedCircle({
    required this.radius,
    required this.duration,
    required this.color,
    super.key,
  });

  @override
  State<AnimatedCircle> createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<AnimatedCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: Container(
            width: widget.radius * 2,
            height: widget.radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.color,
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}

class FloatingSphere extends StatefulWidget {
  final double size;
  final Duration duration;
  final Color color;
  final double orbitRadius;
  final double phase;

  const FloatingSphere({
    required this.size,
    required this.duration,
    required this.color,
    required this.orbitRadius,
    required this.phase,
    super.key,
  });

  @override
  State<FloatingSphere> createState() => _FloatingSphereState();
}

class _FloatingSphereState extends State<FloatingSphere> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value * 2 * math.pi + widget.phase;
        return Transform.translate(
          offset: Offset(
            math.cos(value) * widget.orbitRadius,
            math.sin(value) * widget.orbitRadius * 0.9, // Slightly elliptical
          ),
          child: Center(
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.color,
                    widget.color.withOpacity(widget.color.opacity * 0.5),
                    widget.color.withOpacity(0.0),
                  ],
                  stops: const [0.2, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
import '../models/language.dart';
import '../services/language_service.dart';

class HeroWidget extends StatefulWidget {
  final Function(String)? onTextSubmit;
  final VoidCallback? onMicPressed;
  final bool isListening;
  final Function(Language)? onLanguageChanged;
  
  const HeroWidget({
    super.key, 
    this.onTextSubmit,
    this.onMicPressed,
    this.isListening = false,
    this.onLanguageChanged,
  });

  @override
  State<HeroWidget> createState() => _HeroWidgetState();
}

class _HeroWidgetState extends State<HeroWidget> {
  final TextEditingController _textController = TextEditingController();
  
  List<Widget> _createSpheres() {
    final spheres = <Widget>[];
    final random = math.Random();
    
    // Create more varied orbit rings with some randomness
    for (int i = 0; i < 20; i++) {  // Create 20 individual spheres
      // Random orbit radius between 200 and 600
      double orbitRadius = random.nextDouble() * 400 + 200;
      // Random starting position
      double phase = random.nextDouble() * 2 * math.pi;
      
      spheres.add(
        Center(
          child: FloatingSphere(
            size: random.nextDouble() * 80 + 60, // Smaller size: 60-140
            duration: Duration(seconds: random.nextInt(10) + 15), // Random duration: 15-25s
            color: Colors.white.withOpacity(random.nextDouble() * 0.15 + 0.1), // Lower opacity: 0.1-0.25
            orbitRadius: orbitRadius,
            phase: phase,
          ),
        ),
      );
    }
    return spheres;
  }
  List<Language> _languages = [];
  Language? _selectedLanguage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    try {
      final languages = await LanguageService.loadLanguages();
      setState(() {
        _languages = languages;
        _selectedLanguage = LanguageService.getDefaultLanguage(languages);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading languages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-1.5, -1.5),
          end: const Alignment(1.5, 1.5),
          colors: [
            const Color(0xFF4169E1),    // Royal Blue
            const Color(0xFF1E90FF),    // Dodger Blue
            const Color(0xFF4169E1),    // Royal Blue
            const Color(0xFF7B68EE),    // Medium Slate Blue
            const Color(0xFF8A2BE2),    // Blue Violet
          ],
          stops: const [
            0.0,
            0.3,
            0.5,
            0.7,
            1.0
          ],
          transform: GradientRotation(math.pi / 6), // 30 degrees rotation
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Add a subtle radial gradient overlay for more depth
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.2, -0.2),
                radius: 1.2,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),
          
          Stack(
            fit: StackFit.expand,
            children: _createSpheres(),
          ),
          
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'MediSpeak',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(3, 3),
                      ),
                      Shadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TypewriterText(
                  phrases: const [
                    'Breaking the barrier',
                    'Bringing clarity in care!',
                  ],
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'Roboto',
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
                      height: 52,
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
                          minimumSize: const Size(52, 52),
                          elevation: 0,
                        ),
                        child: const Icon(Icons.arrow_forward, size: 24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: 52,
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
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_isLoading)
              const SizedBox(
                height: 52,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            else
              Container(
                height: 52,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    popupMenuTheme: PopupMenuThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: DropdownButton<Language>(
                    value: _selectedLanguage,
                    isExpanded: true,
                    icon: const Icon(Icons.language),
                    menuMaxHeight: 250,
                    dropdownColor: Colors.white,
                    underline: Container(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    items: _languages.map((Language language) {
                      return DropdownMenuItem<Language>(
                        value: language,
                        child: Text(
                          language.name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (Language? newValue) {
                      setState(() {
                        _selectedLanguage = newValue;
                      });
                      if (newValue != null && widget.onLanguageChanged != null) {
                        widget.onLanguageChanged!(newValue);
                      }
                    },
                  ),
                ),
              ),
          ],
            ),
          ),
        ],
      ),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final List<String> phrases;
  final TextStyle style;

  const TypewriterText({
    super.key,
    required this.phrases,
    required this.style,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayText = '';
  int _currentIndex = 0;
  int _currentPhraseIndex = 0;
  bool _showCursor = true;
  bool _isTyping = true;
  Timer? _timer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _startCursorBlink();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  void _resetAndSwitchPhrase() {
    setState(() {
      _displayText = '';
      _currentIndex = 0;
      _isTyping = true;
      _currentPhraseIndex = (_currentPhraseIndex + 1) % widget.phrases.length;
    });
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;

      String currentPhrase = widget.phrases[_currentPhraseIndex];
      
      setState(() {
        if (_isTyping) {
          if (_currentIndex < currentPhrase.length) {
            _displayText = currentPhrase.substring(0, _currentIndex + 1);
            _currentIndex++;
          } else {
            // Pause at the end of typing
            timer.cancel();
            Future.delayed(const Duration(milliseconds: 2000), () {
              if (mounted) {
                setState(() => _isTyping = false);
                _startAnimation();
              }
            });
          }
        } else {
          if (_currentIndex > 0) {
            _displayText = currentPhrase.substring(0, _currentIndex - 1);
            _currentIndex--;
          } else {
            // Switch to next phrase
            timer.cancel();
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (mounted) {
                _resetAndSwitchPhrase();
                _startAnimation();
              }
            });
          }
        }
      });
    });
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_displayText${_showCursor ? "|" : ""}',
      style: widget.style.copyWith(
        fontWeight: FontWeight.w900,
        color: Colors.yellow,
        letterSpacing: 0.5,
        height: 1.2,
      ),
    );
  }
}