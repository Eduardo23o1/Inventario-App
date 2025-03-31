import 'package:mockito/annotations.dart';
import 'package:inventario_app/infrastructure/repositories/inventory_repository.dart';
import 'package:inventario_app/data/repositories/local_storage.dart';

@GenerateMocks([InventoryRepository, LocalStorage])
void main() {}
