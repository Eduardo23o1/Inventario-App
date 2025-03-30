import 'dart:convert';
import 'package:inventario_app/data/repositories/local_storage.dart';
import 'package:inventario_app/domain/models/inventory.dart';

class InventoryRepository {
  final LocalStorage localStorage;

  InventoryRepository(this.localStorage) {
    print("InventoryRepository inicializado correctamente.");
  }

  Future<List<Inventory>> loadInventories() async {
    final jsonString = await localStorage.getString('inventories');
    if (jsonString == null) return [];
    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Inventory.fromJson(json)).toList();
  }

  Future<void> saveInventories(List<Inventory> inventories) async {
    final jsonString = json.encode(inventories.map((i) => i.toJson()).toList());
    await localStorage.setString('inventories', jsonString);
  }
}
