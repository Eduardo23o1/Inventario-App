import 'dart:convert';

class Inventory {
  final String id;
  final String name;
  final String description;

  Inventory({required this.id, required this.name, required this.description});

  // Convierte un inventario a formato JSON.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };

  // Convierte un JSON a un objeto Inventory
  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  // Convierte una lista de inventarios en un String JSON
  static String encode(List<Inventory> inventories) =>
      json.encode(inventories.map((e) => e.toJson()).toList());

  // Convierte un String JSON en una lista de inventarios.
  static List<Inventory> decode(String inventories) =>
      (json.decode(inventories) as List<dynamic>)
          .map((e) => Inventory.fromJson(e))
          .toList();
}
