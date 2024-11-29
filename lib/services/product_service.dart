import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import '../models/product.dart';

class ProductService {
  List<Product> _products = [];

  Future<void> loadProducts() async {
    try {
      final String response =
          await rootBundle.loadString('assets/products.json');
      final List<dynamic> data = jsonDecode(response);

      _products = data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print("Error loading products: $e");
    }
  }

  List<Product> getProducts() => List.unmodifiable(_products);

  Product? getProductById(String id) {
    return _products.firstWhereOrNull((product) => product.id == id);
  }
}
