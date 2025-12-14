import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/product_modal.dart';
import '../models/product.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  // Helper to open the modal in "Edit" mode
  void _showEditModal(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => ProductModal(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InventoryProvider>(context);

    return Column(
      children: [
        // --- SECTION 1: SEARCH & FILTER CONTROLS ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // 1. Search Bar
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  onChanged: (val) => provider.setSearchQuery(val),
                ),
              ),
              const SizedBox(width: 10),

              // 2. Category Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: provider.categories.contains(provider.selectedCategory)
                        ? provider.selectedCategory
                        : 'All',
                    items: provider.categories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) provider.setCategoryFilter(val);
                    },
                    icon: const Icon(Icons.filter_list, color: Colors.teal),
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- SECTION 2: PRODUCT LIST WITH SWIPE-TO-DELETE ---
        Expanded(
          child: Consumer<InventoryProvider>(
            builder: (context, provider, child) {
              final products = provider.products;

              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text(
                        "No products found",
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80, left: 8, right: 8),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  // WRAP CARD IN DISMISSIBLE FOR SWIPE DELETE
                  return Dismissible(
                    // Key is strictly required for Dismissible
                    key: Key(product.id ?? index.toString()), 
                    direction: DismissDirection.endToStart, // Swipe Right to Left
                    
                    // Background color/icon when swiping
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white, size: 30),
                    ),

                    // Confirmation Dialog before deleting
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Product'),
                          content: Text('Are you sure you want to delete "${product.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },

                    // The actual delete logic
                    onDismissed: (direction) {
                      if (product.id != null) {
                        provider.deleteProduct(product.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product.name} deleted')),
                        );
                      }
                    },

                    child: ProductCard(
                      product: product,
                      onEdit: () => _showEditModal(context, product),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}