import 'dart:convert';
import 'package:inventario_app/data/repositories/local_storage.dart';
import 'package:inventario_app/domain/models/product.dart';

class ProductRepository {
  final LocalStorage localStorage;

  ProductRepository(this.localStorage);

  Future<void> addProduct(Product product) async {
    final products = await loadProducts(); // Cargar productos actuales
    products.add(product);
    await saveProducts(products); // Guardar lista actualizada
  }

  Future<List<Product>> loadProducts() async {
    final jsonString = await localStorage.getString('products');
    if (jsonString == null) return [];
    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Product.fromJson(json)).toList();
  }

  Future<void> saveProducts(List<Product> products) async {
    final jsonString = json.encode(products.map((p) => p.toJson()).toList());
    await localStorage.setString('products', jsonString);
  }
}
