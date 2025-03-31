import 'package:mockito/annotations.dart';
import 'package:inventario_app/data/repositories/local_storage.dart';
import 'package:inventario_app/infrastructure/repositories/inventory_repository.dart';
import 'package:inventario_app/infrastructure/repositories/product_repository.dart';

@GenerateMocks([LocalStorage, InventoryRepository, ProductRepository])
void main() {}
