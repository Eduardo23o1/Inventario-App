import 'package:equatable/equatable.dart';
import 'package:inventario_app/domain/models/product.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {
  final String inventoryId;
  LoadProducts(this.inventoryId);

  @override
  List<Object> get props => [inventoryId];
}

class AddProduct extends ProductEvent {
  final Product product;
  AddProduct(this.product, String name);

  @override
  List<Object> get props => [product];
}

class UpdateProduct extends ProductEvent {
  final Product product;
  UpdateProduct(this.product);

  @override
  List<Object> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final String productId;
  DeleteProduct(this.productId);

  @override
  List<Object> get props => [productId];
}
