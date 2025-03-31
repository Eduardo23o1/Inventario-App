import 'dart:convert';

class Inventory {
  final String id;
  final String name;
  final String description;

  Inventory({required this.id, required this.name, required this.description});

  // Convertir a JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };

  // Crear desde JSON
  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  // Convertir lista a JSON
  static String encode(List<Inventory> inventories) =>
      json.encode(inventories.map((e) => e.toJson()).toList());

  // Decodificar lista desde JSON
  static List<Inventory> decode(String inventories) =>
      (json.decode(inventories) as List<dynamic>)
          .map((e) => Inventory.fromJson(e))
          .toList();
}
