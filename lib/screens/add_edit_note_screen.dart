import 'package:flutter/material.dart';

class Product {
  String id;
  String name;
  int quantity;
  String category;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });
}

class AddEditNoteScreen extends StatefulWidget {
  final Product? product; // null for add, existing product for edit

  const AddEditNoteScreen({Key? key, this.product}) : super(key: key);

  @override
  _AddEditNoteScreenState createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Product> _products = []; // Local list to hold products

  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _quantityController = TextEditingController(
      text: widget.product?.quantity.toString() ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.product?.category ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final id = widget.product?.id ?? DateTime.now().toString();
      final newProduct = Product(
        id: id,
        name: _nameController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        category: _categoryController.text.trim(),
      );

      setState(() {
        if (widget.product == null) {
          _products.add(newProduct);
        } else {
          final index = _products.indexWhere(
            (product) => product.id == widget.product!.id,
          );
          if (index != -1) _products[index] = newProduct;
        }
      });

      Navigator.of(context).pop();
    }
  }

  void _deleteProduct() {
    if (widget.product != null) {
      setState(() {
        _products.removeWhere((p) => p.id == widget.product!.id);
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteProduct,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter product name'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter quantity';
                  if (int.tryParse(value) == null) return 'Enter valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter category'
                            : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(isEditing ? 'Update Product' : 'Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
