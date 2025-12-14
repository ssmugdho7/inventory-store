import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/inventory_provider.dart';

class ProductModal extends StatefulWidget {
  final Product? product; // If null = Add Mode. If set = Edit Mode.

  const ProductModal({super.key, this.product});

  @override
  State<ProductModal> createState() => _ProductModalState();
}

class _ProductModalState extends State<ProductModal> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _quantityController;
  late TextEditingController _imageController; // <--- NEW Controller

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _categoryController = TextEditingController(text: widget.product?.category ?? '');
    _quantityController = TextEditingController(text: widget.product?.quantity.toString() ?? '');
    _imageController = TextEditingController(text: widget.product?.imageUrl ?? ''); // <--- NEW
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _imageController.dispose(); // <--- NEW
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final category = _categoryController.text.trim();
      final quantity = int.parse(_quantityController.text.trim());
      final imageUrl = _imageController.text.trim(); // <--- NEW

      final provider = Provider.of<InventoryProvider>(context, listen: false);

      if (widget.product == null) {
        // --- CREATE NEW ---
        provider.addProduct(Product(
          name: name,
          category: category,
          quantity: quantity,
          // Only save if not empty
          imageUrl: imageUrl.isNotEmpty ? imageUrl : null, 
        ));
      } else {
        // --- UPDATE EXISTING ---
        provider.updateProduct(Product(
          id: widget.product!.id,
          name: name,
          category: category,
          quantity: quantity,
          imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
        ));
      }
      Navigator.pop(context); // Close the modal
    }
  }

  void _deleteProduct() async {
    final provider = Provider.of<InventoryProvider>(context, listen: false);
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true && widget.product?.id != null) {
      provider.deleteProduct(widget.product!.id!);
      if (mounted) Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48), 
                Text(
                  widget.product == null ? 'Add New Product' : 'Edit Product',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                ),
                if (widget.product != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: _deleteProduct,
                    tooltip: "Delete Item",
                  )
                else
                  const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 20),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                prefixIcon: Icon(Icons.shopping_bag_outlined),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 12),

            // Category Field
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
                hintText: 'e.g., Electronics, Food',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (val) => val!.isEmpty ? 'Please enter a category' : null,
            ),
            const SizedBox(height: 12),

            // Quantity Field
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                prefixIcon: Icon(Icons.numbers),
              ),
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Enter quantity';
                if (int.tryParse(val) == null) return 'Must be a number';
                return null;
              },
            ),
            const SizedBox(height: 12),

            // --- NEW: Image URL Field ---
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL (Optional)',
                prefixIcon: Icon(Icons.image_outlined),
                hintText: 'Paste a link to an image',
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _saveProduct,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: Text(widget.product == null ? 'ADD TO INVENTORY' : 'SAVE CHANGES'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}