// lib/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_model.dart';
import 'product_detail_screen.dart';
import 'product_list_provider.dart'; // ✅ correct import, not main.dart

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  static const _titles = ['Products', 'Explore', 'Profile'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductListProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = [
      _ProductListTab(),
      _ExploreTab(),
      _ProfileTab(),
    ][_index];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('!sos!cake — ${_titles[_index]}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const MainAquariumBackground(),
          SafeArea(child: body),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (v) => setState(() => _index = v),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.cake), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
      return Center(child: Text(prov.error!));
    }

    final items = prov.items;
    return Padding(
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
              MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
            ),
            child: Card(
              color: Colors.white.withOpacity(0.06),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'product-${p.id}',
                      child: Image.asset(
                        p.image,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      p.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '฿ ${p.price.toStringAsFixed(0)}', // ✅ fixed
                      style: const TextStyle(color: Colors.amber),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ExploreTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        Text(
          'Ponyo Aquarium Collection',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 8,
            itemBuilder: (ctx, i) {
              final idx = (i % 10) + 1;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/$idx.png',
                    width: 200,
                    height: 140,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (c, e, s) => Container(
                      color: Colors.grey,
                      width: 200,
                      height: 140,
                      child: const Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
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
      child: TextButton.icon(
        onPressed: () => Navigator.of(context).pushNamed('/onboarding'),
        icon: const Icon(Icons.info),
        label: const Text('Profile / Settings'),
      ),
    );
  }
}

/// Minimal aquarium background used on home
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
