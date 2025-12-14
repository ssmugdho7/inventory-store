class Product {
  final String? id;
  final String name;
  final String category;
  final int quantity;
  final String? imageUrl; // <--- NEW: Optional Image URL

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.quantity,
    this.imageUrl, // <--- NEW
  });

  // 1. TO MAP: Save to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'quantity': quantity,
      'imageUrl': imageUrl, // <--- NEW
    };
  }

  // 2. FROM MAP: Read from Firestore
  factory Product.fromMap(Map<String, dynamic> map, String documentId) {
    return Product(
      id: documentId,
      name: map['name'] ?? '',
      category: map['category'] ?? 'General',
      quantity: (map['quantity'] ?? 0).toInt(),
      imageUrl: map['imageUrl'], // <--- NEW: Fetch from map
    );
  }
}
