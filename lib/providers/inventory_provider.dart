import 'dart:async'; // Required for StreamSubscription
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class InventoryProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  // Subscription variable to track the active stream connection
  StreamSubscription<List<Product>>? _productsSubscription;

  // Private variables to hold state
  List<Product> _allProducts = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Constructor: Start listening to database changes immediately
  InventoryProvider() {
    _init();
  }

  void _init() {
    // Listen to the stream from FirestoreService
    _productsSubscription = _service.getProductsStream().listen((productsData) {
      _allProducts = productsData;
      notifyListeners(); // Notify UI to rebuild
    });
  }

  @override
  void dispose() {
    // Stop listening to avoid memory leaks when the app is closed
    _productsSubscription?.cancel();
    super.dispose();
  }

  // --- GETTERS (Data for the UI) ---

  // 1. Get the list of products AFTER applying search and category filters
  List<Product> get products => _applyFilters();

  // 2. EXPOSE THE SELECTED CATEGORY (Needed for Dropdown UI)
  String get selectedCategory => _selectedCategory;

  // 3. Calculate total sum of quantities across all items
  int get totalStock =>
      _allProducts.fold(0, (sum, item) => sum + item.quantity);

  // 4. Count total unique items
  int get totalItems => _allProducts.length;

  // 5. Count items with low stock (less than 5)
  int get lowStockItems => _allProducts.where((p) => p.quantity < 5).length;

  // 6. Get unique categories for the dropdown menu
  List<String> get categories {
    if (_allProducts.isEmpty) return ['All'];

    final cats = _allProducts.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['All', ...cats]; // Always include 'All' option
  }

  // --- LOGIC (Filtering) ---

  List<Product> _applyFilters() {
    return _allProducts.where((product) {
      // Check if name matches search query (case-insensitive)
      final matchesSearch = product.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      // Check if category matches selection
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // --- UI ACTIONS ---

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // --- DATABASE OPERATIONS ---

  Future<void> addProduct(Product product) => _service.addProduct(product);

  Future<void> updateProduct(Product product) =>
      _service.updateProduct(product);

  Future<void> deleteProduct(String id) => _service.deleteProduct(id);

  // Helper to adjust quantity directly (+1 or -1)
  Future<void> adjustQuantity(Product product, int amount) {
    final newQty = product.quantity + amount;

    // Prevent negative stock
    if (newQty < 0) return Future.value();

    // Create updated product object
    final updatedProduct = Product(
      id: product.id,
      name: product.name,
      category: product.category,
      quantity: newQty,
    );

    return updateProduct(updatedProduct);
  }
}
