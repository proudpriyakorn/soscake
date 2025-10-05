// lib/product_list_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ProductListProvider extends ChangeNotifier {
  List<Product> _items = [];
  bool _loading = false;
  String? _error;

  List<Product> get items => _items;
  bool get loading => _loading;
  String? get error => _error;

  // ✅ Fixed: Added kIsWeb check for Flutter Web
  static String get apiUrl {
    if (kIsWeb) {
      // For Flutter Web running in browser
      return 'http://localhost:3000/products';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Android Emulator
      return 'http://10.0.2.2:3000/products';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS Simulator
      return 'http://localhost:3000/products';
    } else {
      // Physical devices - replace with your machine's IP
      return 'http://192.168.1.100:3000/products';
    }
  }

  Future<void> fetchProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Debug logs
      print('🌐 Running on: ${kIsWeb ? "Web Browser" : defaultTargetPlatform.toString()}');
      print('🌐 Fetching from: $apiUrl');
      
      final resp = await http.get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 8));

      print('📡 Response status: ${resp.statusCode}');

      if (resp.statusCode == 200) {
        final List<dynamic> raw = json.decode(resp.body);
        _items = raw.map((e) => Product.fromJson(e)).toList();
        print('✅ Loaded ${_items.length} products');
      } else {
        _error = 'Server returned ${resp.statusCode}';
        print('❌ Error: $_error');
      }
    } catch (e) {
      _error = 'Could not fetch products: $e';
      print('❌ Exception: $e');
      print('💡 Tip: Make sure json-server is running with CORS enabled');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => fetchProducts();
}