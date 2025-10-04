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

  // ✅ Dynamic API URL based on platform
  static String get apiUrl {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/products'; // Android Emulator
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'http://localhost:3000/products'; // iOS Simulator
    } else {
      // For physical devices, replace with your machine's IP
      // Find your IP: Windows (ipconfig), Mac/Linux (ifconfig)
      return 'http://192.168.1.100:3000/products'; // ⚠️ CHANGE THIS TO YOUR IP
    }
  }

  Future<void> fetchProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      print('🌐 Fetching from: $apiUrl'); // Debug log
      
      final resp = await http.get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 8));

      print('📡 Response status: ${resp.statusCode}'); // Debug log

      if (resp.statusCode == 200) {
        final List<dynamic> raw = json.decode(resp.body);
        _items = raw.map((e) => Product.fromJson(e)).toList();
        print('✅ Loaded ${_items.length} products'); // Debug log
      } else {
        _error = 'Server returned ${resp.statusCode}';
        print('❌ Error: $_error'); // Debug log
      }
    } catch (e) {
      _error = 'Could not fetch products: $e';
      print('❌ Exception: $e'); // Debug log
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ✅ Optional: Add a refresh method
  Future<void> refresh() => fetchProducts();
}