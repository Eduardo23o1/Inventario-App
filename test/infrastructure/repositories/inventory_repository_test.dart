import 'package:flutter_test/flutter_test.dart';
import 'package:inventario_app/data/repositories/local_storage.dart';
import 'package:inventario_app/infrastructure/repositories/inventory_repository.dart';
import 'package:inventario_app/domain/models/inventory.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'inventory_repository_test.mocks.dart';

// 🔹 Genera el mock de LocalStorage
@GenerateMocks(<Type>[LocalStorage])
void main() {
  late MockLocalStorage mockLocalStorage;
  late InventoryRepository repository;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    repository = InventoryRepository(mockLocalStorage);
  });

  test('Debe devolver una lista vacía cuando no hay datos guardados', () async {
    when(
      mockLocalStorage.getString('inventories'),
    ).thenAnswer((_) async => null);

    final result = await repository.loadInventories();

    expect(result, isEmpty);
    verify(mockLocalStorage.getString('inventories')).called(1);
  });

  test('Debe cargar una lista de inventarios desde LocalStorage', () async {
    final fakeData =
        '[{"id":"1","name":"Inventario A","description":"Descripción A"}]';
    when(
      mockLocalStorage.getString('inventories'),
    ).thenAnswer((_) async => fakeData);

    final result = await repository.loadInventories();

    expect(result, isNotEmpty);
    expect(result.first.name, 'Inventario A');
  });

  test('Debe guardar correctamente los inventarios en LocalStorage', () async {
    final inventories = [
      Inventory(id: '1', name: 'Inventario A', description: 'Descripción A'),
    ];
    when(
      mockLocalStorage.setString('inventories', any),
    ).thenAnswer((_) async => null);

    await repository.saveInventories(inventories);

    verify(mockLocalStorage.setString('inventories', any)).called(1);
  });
}
