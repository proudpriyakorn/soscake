// lib/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'product_detail_screen.dart';
import 'product_list_provider.dart';
import 'cart_provider.dart'; // ✅ เพิ่มบรรทัดนี้


class HomeScreen extends StatefulWidget {
  final int initialTabIndex; // Add this parameter
  
  const HomeScreen({super.key, this.initialTabIndex = 0}); // Default to 0 (Products tab)

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _index;
  static const _titles = ['Products', 'Cart', 'Profile'];

  @override
  void initState() {
    super.initState();
    _index = widget.initialTabIndex; // Initialize with the passed index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductListProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = [
      _ProductListTab(),
      _CartTab(),
      _ProfileTab(),
    ][_index];

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.cake, color: Color(0xFFFFA3E3), size: 32),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '!sos!cake',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 104, 232, 255),
                      fontFamily: 'Comic Sans MS',
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: Color(0xFF8A0057),
                          blurRadius: 0,
                          offset: Offset(2, 2),
                        ),
                        Shadow(
                          color: Color.fromARGB(255, 103, 109, 216),
                          blurRadius: 0,
                          offset: Offset(-2, -2),
                        ),
                      ],
                    ),
                  ),
                  TextSpan(
                    text: ' — ${_titles[_index]}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 152, 67, 201),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              setState(() {
                _index = 1; // Switch to Cart tab
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Full-page bh.gif background
          Positioned.fill(
            child: Image.asset(
              'assets/images/bh.gif',
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => const MainAquariumBackground(),
            ),
          ),
          // Semi-transparent overlay for better readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          SafeArea(child: body),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _index,
        height: 60,
        color: const Color.fromARGB(255, 152, 67, 201),
        backgroundColor: const Color.fromARGB(255, 105, 238, 255),
        buttonBackgroundColor: const Color.fromARGB(255, 152, 108, 255),
        animationDuration: const Duration(milliseconds: 400),
        animationCurve: Curves.easeInOut,
        onTap: (v) => setState(() => _index = v),
        items: const [
          Icon(Icons.cake, size: 30, color: Color(0xFFFFA3E3)),
          Icon(Icons.shopping_cart, size: 30, color: Color(0xFFFFA3E3)),
          Icon(Icons.person, size: 30, color: Color(0xFFFFA3E3)),
        ],
      ),
    );
  }
}

class _ProductListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductListProvider>(context);

    if (prov.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (prov.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              prov.error!,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => prov.fetchProducts(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent[700],
              ),
            ),
          ],
        ),
      );
    }

    final items = prov.items;

    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No products available',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 18),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => prov.refresh(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.78,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (ctx, i) {
            final p = items[i];
            return GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: p),
                ),
              ),
              child: Card(
                color: const Color.fromARGB(255, 213, 245, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Hero(
                        tag: 'product-${p.id}',
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14),
                          ),
                          child: Image.asset(
                            p.image,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (c, e, s) => Container(
                              color: Colors.grey.shade800,
                              child: const Icon(
                                Icons.cake,
                                size: 64,
                                color: Colors.white38,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        p.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 84, 81, 255),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '฿ ${p.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 203, 80, 129),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!p.available)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Sold Out',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CartTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    if (cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add some delicious cakes!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Cart',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                cartProvider.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cart cleared')),
                );
              },
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              label: const Text(
                'Clear',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...cartItems.map((item) => Card(
              color: Colors.white.withOpacity(0.12),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item.product.image,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey.shade800,
                          child: const Icon(Icons.cake, color: Colors.white38),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '฿ ${item.product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 203, 80, 129),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                cartProvider.updateQuantity(
                                  item.product.id,
                                  item.quantity - 1,
                                );
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                              color: Colors.white70,
                              iconSize: 24,
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cartProvider.updateQuantity(
                                  item.product.id,
                                  item.quantity + 1,
                                );
                              },
                              icon: const Icon(Icons.add_circle_outline),
                              color: Colors.white70,
                              iconSize: 24,
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () {
                            cartProvider.removeFromCart(item.product.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.product.title} removed'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete, size: 16),
                          label: const Text('Remove'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 16),
        Card(
          color: Colors.white.withOpacity(0.15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '฿ ${cartProvider.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 193, 7),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Order placed! Total: ฿${cartProvider.totalPrice.toStringAsFixed(0)}',
                ),
              ),
            );
            cartProvider.clearCart();
          },
          icon: const Icon(Icons.payment),
          label: const Text('Checkout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent[700],
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ],
    );
  }
}

class _ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile avatar with bh.gif
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white24,
            backgroundImage: const AssetImage('assets/images/bh.gif'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Guest User',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sign in to access your profile',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed('/onboarding'),
            icon: const Icon(Icons.login),
            label: const Text('Sign In'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent[700],
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings')),
              );
            },
            icon: const Icon(Icons.settings),
            label: const Text('Settings'),
            style: TextButton.styleFrom(foregroundColor: Colors.white70),
          ),
        ],
      ),
    );
  }
}

/// Minimal aquarium background used as fallback
class MainAquariumBackground extends StatefulWidget {
  const MainAquariumBackground({super.key});

  @override
  State<MainAquariumBackground> createState() => _MainAquariumBackgroundState();
}

class _MainAquariumBackgroundState extends State<MainAquariumBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 12))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.8 + 0.6 * t, -1),
              end: Alignment(0.8 - 0.6 * t, 1),
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade600,
                Colors.teal.shade700,
              ],
            ),
          ),
        );
      },
    );
  }
}