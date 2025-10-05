// lib/product_model.dart
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;
  final bool available;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.available,
  });

  factory Product.fromJson(Map<String, dynamic> j) {
    return Product(
      // ✅ Fixed: Handle both String and int for id
      id: j['id'] is String ? int.parse(j['id']) : (j['id'] as int),
      title: j['title'] as String,
      description: j['description'] as String,
      // ✅ Already handles both int and double
      price: (j['price'] is int) 
          ? (j['price'] as int).toDouble() 
          : (j['price'] as num).toDouble(),
      image: j['image'] as String,
      available: j['available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'image': image,
        'available': available,
      };
}