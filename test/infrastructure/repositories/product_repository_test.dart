import 'package:flutter_test/flutter_test.dart';
import 'package:inventario_app/data/repositories/local_storage.dart';
import 'package:inventario_app/infrastructure/repositories/product_repository.dart';
import 'package:inventario_app/domain/models/product.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'inventory_repository_test.mocks.dart';

@GenerateMocks([LocalStorage])
void main() {
  late MockLocalStorage mockLocalStorage;
  late ProductRepository repository;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    repository = ProductRepository(mockLocalStorage);
  });

  test(
    'Debe devolver una lista vacía cuando no hay productos guardados',
    () async {
      when(
        mockLocalStorage.getString('products'),
      ).thenAnswer((_) async => null);

      final result = await repository.loadProducts();

      expect(result, isEmpty);
    },
  );

  test('Debe cargar una lista de productos desde LocalStorage', () async {
    final fakeData =
        '[{"id":"1","name":"Producto X","inventoryId":"1","price":3000,"quantity":10}]';
    when(
      mockLocalStorage.getString('products'),
    ).thenAnswer((_) async => fakeData);

    final result = await repository.loadProducts();

    expect(result, isNotEmpty);
    expect(result.first.name, 'Producto X');
  });

  test('Debe guardar correctamente los productos en LocalStorage', () async {
    final products = [
      Product(
        id: '1',
        name: 'Producto X',
        inventoryId: '1',
        price: 3000,
        quantity: 10,
      ),
    ];
    when(
      mockLocalStorage.setString('products', any),
    ).thenAnswer((_) async => null);

    await repository.saveProducts(products);

    verify(mockLocalStorage.setString('products', any)).called(1);
  });
}
