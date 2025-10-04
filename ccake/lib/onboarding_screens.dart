// lib/onboarding_screens.dart
import 'package:flutter/material.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});
  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _pc = PageController();
  int _idx = 0;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _pages => [
        {
          'title': 'Welcome to Ponyo o-clock cakes',
          'subtitle': 'Surprise saved cakes, same day delivery, fresh and cute.',
          'background': 'assets/images/1.gif',
        },
        {
          'title': 'Delivered to your door',
          'subtitle': 'Choose a cake, set the time we’ll be at your door, knock knock.',
          'background': 'assets/images/2.gif',
        },
        {
          'title': 'ENJOY CAKES',
          'subtitle': 'Enjoy happy moments with your loved ones through our service!',
          'background': 'assets/images/3.gif',
        },
      ];

  Widget _buildPage(BuildContext ctx, Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(data['background']),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.6),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(flex: 3),
              Column(
                children: [
                  Text(
                    data['title'],
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.8),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                            ),
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 4),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data['subtitle'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.8),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 3),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView with full background images
          PageView.builder(
            controller: _pc,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _idx = i),
            itemBuilder: (_, i) => _buildPage(context, _pages[i]),
          ),

          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cake_outlined,
                          color: Colors.amber,
                          size: 24,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ponyo o-clock',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Skip Button
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _idx == i ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _idx == i ? Colors.amber : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Navigation Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        _idx > 0
                            ? Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    _pc.previousPage(
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.4),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(width: 50),

                        // Next/Get Started Button
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_idx + 1 < _pages.length) {
                                  _pc.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  Navigator.of(context).pushReplacementNamed('/home');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                shadowColor: Colors.black.withOpacity(0.4),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _idx + 1 < _pages.length ? 'Next' : 'Get Started',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward_ios, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Forward Arrow Placeholder (for symmetry when no back button)
                        _idx > 0
                            ? const SizedBox(width: 50)
                            : const SizedBox(width: 50),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}