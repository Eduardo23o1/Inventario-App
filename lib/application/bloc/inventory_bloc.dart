import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventario_app/application/bloc/inventory_event.dart';
import 'package:inventario_app/application/bloc/inventory_state.dart';
import 'package:inventario_app/data/repositories/local_storage.dart';
import 'package:inventario_app/domain/models/inventory.dart';
import 'package:inventario_app/di/injection.dart';
import 'package:inventario_app/infrastructure/repositories/inventory_repository.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final LocalStorage _localStorage = locator<LocalStorage>();

  InventoryBloc(InventoryRepository inventoryRepository)
    : super(InventoryInitial()) {
    on<LoadInventories>(_onLoadInventories);
    on<AddInventory>(_onAddInventory);
    on<UpdateInventory>(_onUpdateInventory);
    on<DeleteInventory>(_onDeleteInventory);
  }

  Future<void> _onLoadInventories(
    LoadInventories event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final inventories = await _localStorage.loadInventories();
      emit(InventoryLoaded(inventories));
    } catch (e) {
      emit(InventoryError('Error al cargar los inventarios'));
    }
  }

  Future<void> _onAddInventory(
    AddInventory event,
    Emitter<InventoryState> emit,
  ) async {
    if (state is InventoryLoaded) {
      final inventories = List<Inventory>.from(
        (state as InventoryLoaded).inventories,
      )..add(event.inventory);
      await _localStorage.saveInventories(inventories);
      emit(InventoryLoaded(inventories));
    }
  }

  Future<void> _onUpdateInventory(
    UpdateInventory event,
    Emitter<InventoryState> emit,
  ) async {
    if (state is InventoryLoaded) {
      final inventories =
          (state as InventoryLoaded).inventories
              .map(
                (inventory) =>
                    inventory.id == event.inventory.id
                        ? event.inventory
                        : inventory,
              )
              .toList();
      await _localStorage.saveInventories(inventories);
      emit(InventoryLoaded(inventories));
    }
  }

  Future<void> _onDeleteInventory(
    DeleteInventory event,
    Emitter<InventoryState> emit,
  ) async {
    if (state is InventoryLoaded) {
      final inventories =
          (state as InventoryLoaded).inventories
              .where((inventory) => inventory.id != event.inventoryId)
              .toList();
      await _localStorage.saveInventories(inventories);
      emit(InventoryLoaded(inventories));
    }
  }
}
