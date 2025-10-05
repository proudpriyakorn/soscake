// lib/product_detail_screen.dart
import 'dart:math' as Math2; // ✅ must be first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_model.dart';
import 'home_screen.dart';
import 'cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // translucent appbar themed like aquarium
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(product.title),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // subtle aquarium background
          Positioned.fill(child: _AquariumBackground()),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Hero(
                  tag: 'product-${product.id}',
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.contain,
                    height: 280,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '฿ ${product.price.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.amber[200],
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.description,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add product to cart
                    Provider.of<CartProvider>(context, listen: false).addToCart(product);
                    
                    // Show order placed message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.title} added to cart!'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                    
                    // Navigate to cart tab on HomeScreen
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(initialTabIndex: 1), // Pass 1 for Cart tab
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.delivery_dining),
                  label: const Text('Order placed for same-day delivery (demo)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent[700],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Aquarium background
class _AquariumBackground extends StatefulWidget {
  @override
  State<_AquariumBackground> createState() => _AquariumBackgroundState();
}

class _AquariumBackgroundState extends State<_AquariumBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 10))
        ..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.2 + 0.4 * t, -0.6 + 0.3 * t),
              radius: 1.2,
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade700,
                Colors.blue.shade400,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: CustomPaint(
            painter: _BubblePainter(t),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}

// Bubble + starfish painter
class _BubblePainter extends CustomPainter {
  final double t;
  _BubblePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // bubbles
    for (int i = 0; i < 12; i++) {
      final progress = ((t + i / 12) % 1.0);
      final x = size.width * ((i * 37) % 100) / 100.0;
      final y = size.height * (1.0 - progress);
      paint.color = Colors.white.withOpacity(0.06 + 0.08 * (i % 4));
      canvas.drawCircle(Offset(x, y), 6.0 + (i % 3) * 2.0, paint);
    }

    // starfish
    for (int s = 0; s < 3; s++) {
      paint.color = Colors.orange.withOpacity(0.06 + 0.05 * s);
      final cx = size.width * (0.2 + 0.3 * s);
      final cy = size.height * (0.8 - 0.1 * s);
      final path = Path();
      for (int k = 0; k < 5; k++) {
        final theta = (k / 5.0) * 2 * 3.1415926;
        final r = 12.0 + 6 * (1 + (k % 2));
        final px = cx + r * Math2.cos(theta);
        final py = cy + r * Math2.sin(theta);
        if (k == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter old) => old.t != t;
}