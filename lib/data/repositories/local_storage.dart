import 'package:inventario_app/domain/models/inventory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventario_app/domain/models/product.dart';

class LocalStorage {
  static const String _productsKey = 'products';

  static const String _inventoriesKey = 'inventories';

  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Obtener instancia de SharedPreferences
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  // Guardar lista de inventarios
  Future<void> saveInventories(List<Inventory> inventories) async {
    final prefs = await _prefs;
    await prefs.setString(_inventoriesKey, Inventory.encode(inventories));
  }

  // Cargar lista de inventarios
  Future<List<Inventory>> loadInventories() async {
    final prefs = await _prefs;
    final data = prefs.getString(_inventoriesKey);
    return data != null ? Inventory.decode(data) : [];
  }

  // Guardar lista de productos
  Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_productsKey, Product.toJsonList(products));
  }

  // Cargar lista de productos
  Future<List<Product>> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_productsKey);
    return data != null ? Product.fromJsonList(data) : [];
  }

  // Filtra los productos por un inventoryId específico
  Future<List<Product>> getProductsByInventory(String inventoryId) async {
    final allProducts = await loadProducts();
    return allProducts
        .where((product) => product.inventoryId == inventoryId)
        .toList();
  }
}
