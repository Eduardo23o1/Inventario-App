import 'dart:convert';

class Product {
  final String id;
  final String inventoryId; // Relación con el inventario
  final String name;
  final int quantity;
  final double price;

  Product({
    required this.id,
    required this.inventoryId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'inventoryId': inventoryId,
    'name': name,
    'quantity': quantity,
    'price': price,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    inventoryId: json['inventoryId'],
    name: json['name'],
    quantity: json['quantity'],
    price: json['price'].toDouble(),
  );

  static List<Product> fromJsonList(String jsonString) {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((item) => Product.fromJson(item)).toList();
  }

  static String toJsonList(List<Product> products) {
    return jsonEncode(products.map((product) => product.toJson()).toList());
  }
}
