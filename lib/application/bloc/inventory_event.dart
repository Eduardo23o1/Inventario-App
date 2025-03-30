import 'package:equatable/equatable.dart';
import 'package:inventario_app/domain/models/inventory.dart';

abstract class InventoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadInventories extends InventoryEvent {}

class AddInventory extends InventoryEvent {
  final Inventory inventory;
  AddInventory(this.inventory);

  @override
  List<Object> get props => [inventory];
}

class UpdateInventory extends InventoryEvent {
  final Inventory inventory;
  UpdateInventory(this.inventory);

  @override
  List<Object> get props => [inventory];
}

class DeleteInventory extends InventoryEvent {
  final String inventoryId;
  DeleteInventory(this.inventoryId);

  @override
  List<Object> get props => [inventoryId];
}
