import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:inventario_app/application/bloc/inventory_bloc.dart';
import 'package:inventario_app/application/bloc/inventory_event.dart';
import 'package:inventario_app/application/bloc/inventory_state.dart';
import 'package:inventario_app/domain/models/inventory.dart';
import 'package:inventario_app/infrastructure/repositories/inventory_repository.dart';
import 'package:inventario_app/data/repositories/local_storage.dart';
import '../../di/injection.dart';
import 'package:mockito/mockito.dart';
import '../../mocks.mocks.dart';

void main() {
  late MockInventoryRepository mockRepository;
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    // Reiniciar GetIt antes de registrar dependencias para evitar conflictos
    locator.reset();

    // Crear mocks
    mockRepository = MockInventoryRepository();
    mockLocalStorage = MockLocalStorage();

    // Registrar mocks en GetIt
    locator.registerSingleton<LocalStorage>(mockLocalStorage);
    locator.registerSingleton<InventoryRepository>(mockRepository);
  });

  blocTest<InventoryBloc, InventoryState>(
    'Debe emitir [InventoryLoaded] con el inventario agregado cuando se agrega un inventario',
    build: () {
      when(mockLocalStorage.saveInventories(any)).thenAnswer((_) async {});
      return InventoryBloc(locator.get<InventoryRepository>());
    },
    seed: () => InventoryLoaded([]),
    act:
        (bloc) => bloc.add(
          AddInventory(
            Inventory(id: '1', name: 'Item 1', description: 'Description 1'),
          ),
        ),
    expect:
        () => [
          isA<InventoryLoaded>().having(
            (state) => state.inventories.length,
            'length',
            1,
          ),
        ],
  );

  blocTest<InventoryBloc, InventoryState>(
    'Debe emitir [InventoryLoaded] con el inventario actualizado cuando se actualiza un inventario',
    build: () {
      when(mockLocalStorage.saveInventories(any)).thenAnswer((_) async {});
      return InventoryBloc(locator.get<InventoryRepository>());
    },
    seed:
        () => InventoryLoaded([
          Inventory(id: '1', name: 'Item 1', description: 'Description 1'),
        ]),
    act:
        (bloc) => bloc.add(
          UpdateInventory(
            Inventory(
              id: '1',
              name: 'Updated Item',
              description: 'Description 1',
            ),
          ),
        ),
    expect:
        () => [
          isA<InventoryLoaded>().having(
            (state) => state.inventories.first.name,
            'updated name',
            'Updated Item',
          ),
        ],
  );

  blocTest<InventoryBloc, InventoryState>(
    'Debe emitir [InventoryLoaded] con el inventario eliminado cuando se elimina un inventario',
    build: () {
      when(mockLocalStorage.saveInventories(any)).thenAnswer((_) async {});
      return InventoryBloc(locator.get<InventoryRepository>());
    },
    seed:
        () => InventoryLoaded([
          Inventory(id: '1', name: 'Item 1', description: 'Description 1'),
        ]),
    act: (bloc) => bloc.add(DeleteInventory('1')),
    expect:
        () => [
          isA<InventoryLoaded>().having(
            (state) => state.inventories.isEmpty,
            'is empty',
            true,
          ),
        ],
  );

  blocTest<InventoryBloc, InventoryState>(
    'Debe emitir [InventoryLoading, InventoryLoaded] cuando se cargan los inventarios correctamente',
    build: () {
      when(mockLocalStorage.loadInventories()).thenAnswer(
        (_) async => [
          Inventory(id: '1', name: 'Item 1', description: 'Description 1'),
        ],
      );
      return InventoryBloc(locator.get<InventoryRepository>());
    },
    act: (bloc) => bloc.add(LoadInventories()),
    expect:
        () => [
          isA<InventoryLoading>(),
          isA<InventoryLoaded>().having(
            (state) => state.inventories.length,
            'length',
            1,
          ),
        ],
  );

  blocTest<InventoryBloc, InventoryState>(
    'Debe emitir [InventoryLoading, InventoryError] cuando ocurre un error al cargar los inventarios',
    build: () {
      when(mockLocalStorage.loadInventories()).thenThrow(Exception('Error'));
      return InventoryBloc(locator.get<InventoryRepository>());
    },
    act: (bloc) => bloc.add(LoadInventories()),
    expect:
        () => [
          isA<InventoryLoading>(),
          isA<InventoryError>().having(
            (state) => state.message,
            'message',
            'Error al cargar los inventarios',
          ),
        ],
  );
}
