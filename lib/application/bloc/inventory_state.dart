import 'package:equatable/equatable.dart';
import 'package:inventario_app/domain/models/inventory.dart';

abstract class InventoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<Inventory> inventories;
  InventoryLoaded(this.inventories);

  @override
  List<Object> get props => [inventories];
}

class InventoryError extends InventoryState {
  final String message;
  InventoryError(this.message);

  @override
  List<Object> get props => [message];
}
