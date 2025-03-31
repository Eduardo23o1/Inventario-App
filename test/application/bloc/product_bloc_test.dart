import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inventario_app/domain/models/product.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:inventario_app/application/bloc/product_bloc.dart';
import 'package:inventario_app/application/bloc/product_event.dart';
import 'package:inventario_app/application/bloc/product_state.dart';
import 'package:inventario_app/data/repositories/local_storage.dart';
import 'package:inventario_app/infrastructure/repositories/product_repository.dart';

import '../../mocks.mocks.dart';

@GenerateMocks([LocalStorage, ProductRepository])
void main() {
  late MockLocalStorage mockLocalStorage;
  late MockProductRepository mockProductRepository;
  late ProductBloc productBloc;

  final sl = GetIt.instance; // Instancia de GetIt

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    mockProductRepository = MockProductRepository();
    if (!sl.isRegistered<LocalStorage>()) {
      sl.registerLazySingleton<LocalStorage>(() => mockLocalStorage);
    }
    if (!sl.isRegistered<ProductRepository>()) {
      sl.registerLazySingleton<ProductRepository>(() => mockProductRepository);
    }
    productBloc = ProductBloc(sl<ProductRepository>());
  });

  tearDown(() {
    productBloc.close();
  });

  test('initial state is ProductInitial', () {
    expect(productBloc.state, ProductInitial());
  });

  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoading, ProductLoaded] when LoadProducts is added and succeeds',
    build: () {
      when(mockLocalStorage.loadProducts()).thenAnswer(
        (_) async => [
          Product(
            id: '1',
            name: 'Test Product',
            inventoryId: '1',
            quantity: 10,
            price: 100,
          ),
        ],
      );
      return productBloc;
    },
    act: (bloc) => bloc.add(LoadProducts('')),
    expect:
        () => [
          ProductLoading(),
          ProductLoaded([
            Product(
              id: '1',
              name: 'Test Product',
              inventoryId: '1',
              quantity: 10,
              price: 100,
            ),
          ]),
        ],
    verify: (_) {
      verify(mockLocalStorage.loadProducts()).called(1);
    },
  );

  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoading, ProductError] when LoadProducts fails',
    build: () {
      when(mockLocalStorage.loadProducts()).thenThrow(Exception('Error'));
      return productBloc;
    },
    act: (bloc) => bloc.add(LoadProducts('')),
    expect:
        () => [
          ProductLoading(),
          isA<ProductError>(), // Verifica solo que el estado es ProductError
        ],
    verify: (_) {
      verify(mockLocalStorage.loadProducts()).called(1);
    },
  );

  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoaded([])] when DeleteProduct is added',
    build: () {
      final List<Product> mockProductList = [
        Product(
          id: '1',
          name: 'Test Product',
          inventoryId: '1',
          quantity: 10,
          price: 100,
        ),
      ];

      when(
        mockLocalStorage.loadProducts(),
      ).thenAnswer((_) async => List.from(mockProductList));
      when(mockLocalStorage.saveProducts(any)).thenAnswer((invocation) async {
        mockProductList.clear();
        mockProductList.addAll(
          invocation.positionalArguments.first as List<Product>,
        );
      });

      return productBloc;
    },
    act: (bloc) => bloc.add(DeleteProduct('1')),
    expect: () => [ProductLoaded([])],
    verify: (_) {
      verify(mockLocalStorage.loadProducts()).called(greaterThanOrEqualTo(1));
      verify(mockLocalStorage.saveProducts(any)).called(1);
    },
  );
}
