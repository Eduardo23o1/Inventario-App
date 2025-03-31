import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventario_app/application/bloc/product_event.dart';
import 'package:inventario_app/application/bloc/product_state.dart';
import 'package:inventario_app/infrastructure/repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  // Cargar productos para un inventario específico
  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      // Si inventoryId está vacío, carga todos los productos
      final products =
          event.inventoryId.isEmpty
              ? await _productRepository.loadProducts()
              : await _productRepository.getProductsByInventory(
                event.inventoryId,
              );

      // Emitir el estado cargado con los productos obtenidos
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Error al cargar los productos'));
    }
  }

  // Agregar un producto
  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final currentProducts = await _productRepository.loadProducts();
      currentProducts.add(event.product);
      await _productRepository.saveProducts(currentProducts);

      // Emitir el estado actualizado con la lista de productos
      emit(ProductLoaded(await _productRepository.loadProducts()));
    } catch (e) {
      emit(ProductError('Error al agregar el producto'));
    }
  }

  // Actualizar un producto
  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final currentProducts = await _productRepository.loadProducts();
      final updatedProducts =
          currentProducts
              .map(
                (product) =>
                    product.id == event.product.id ? event.product : product,
              )
              .toList();
      await _productRepository.saveProducts(updatedProducts);

      // Emitir el estado actualizado con la lista de productos
      emit(ProductLoaded(await _productRepository.loadProducts()));
    } catch (e) {
      emit(ProductError('Error al actualizar el producto'));
    }
  }

  // Eliminar un producto
  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final currentProducts = await _productRepository.loadProducts();
      final updatedProducts =
          currentProducts
              .where((product) => product.id != event.productId)
              .toList();
      await _productRepository.saveProducts(updatedProducts);

      // Emitir el estado actualizado con la lista de productos
      emit(ProductLoaded(await _productRepository.loadProducts()));
    } catch (e) {
      emit(ProductError('Error al eliminar el producto'));
    }
  }
}
