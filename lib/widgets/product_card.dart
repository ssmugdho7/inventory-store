import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/inventory_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InventoryProvider>(context, listen: false);

    // Visual helper for low stock
    final bool isLowStock = product.quantity < 5;
    
    // Check if we have a valid image URL
    final bool hasImage = product.imageUrl != null && product.imageUrl!.isNotEmpty;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      shape: isLowStock 
          ? RoundedRectangleBorder(
              side: const BorderSide(color: Colors.redAccent, width: 2),
              borderRadius: BorderRadius.circular(12))
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        
        // --- 1. UPDATED ICON LOGIC ---
        leading: CircleAvatar(
          backgroundColor: isLowStock ? Colors.red.shade100 : Colors.teal.shade100,
          foregroundColor: isLowStock ? Colors.red.shade900 : Colors.teal.shade900,
          radius: 25,
          // If we have an image, load it. If not, show null (which reveals the child text).
          backgroundImage: hasImage ? NetworkImage(product.imageUrl!) : null,
          
          // If NO image, show the first letter of the name
          child: hasImage 
              ? null 
              : Text(
                  product.name.isNotEmpty ? product.name[0].toUpperCase() : '?',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
        
        // 2. Product Details
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.category, style: TextStyle(color: Colors.grey[600])),
            if (isLowStock)
              const Text(
                "Low Stock!", 
                style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)
              ),
          ],
        ),

        // 3. Action Buttons
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
              onPressed: () => provider.adjustQuantity(product, -1),
              tooltip: 'Decrease Stock',
            ),
            
            Container(
              constraints: const BoxConstraints(minWidth: 35),
              alignment: Alignment.center,
              child: Text(
                '${product.quantity}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
              onPressed: () => provider.adjustQuantity(product, 1),
              tooltip: 'Increase Stock',
            ),
          ],
        ),
        
        onTap: onEdit,
        // (Note: onLongPress is removed here because we moved delete to the Modal & Swipe action, 
        // but you can keep it if you want double deletion options)
      ),
    );
  }
}