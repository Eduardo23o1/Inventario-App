import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventario_app/application/bloc/product_event.dart';
import 'package:inventario_app/application/bloc/product_state.dart';
import 'package:inventario_app/data/repositories/local_storage.dart';
import 'package:inventario_app/di/injection.dart';
import 'package:inventario_app/infrastructure/repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final LocalStorage _localStorage = locator<LocalStorage>();

  ProductBloc(ProductRepository productRepository) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products =
          event.inventoryId.isEmpty
              ? await _localStorage
                  .loadProducts() // Cargar todos los productos
              : await _localStorage.getProductsByInventory(event.inventoryId);

      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Error al cargar los productos'));
    }
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    final currentProducts = await _localStorage.loadProducts();
    currentProducts.add(event.product);
    await _localStorage.saveProducts(currentProducts);

    // Emitir el estado actualizado con todos los productos
    emit(ProductLoaded(await _localStorage.loadProducts()));
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    final currentProducts = await _localStorage.loadProducts();
    final updatedProducts =
        currentProducts
            .map(
              (product) =>
                  product.id == event.product.id ? event.product : product,
            )
            .toList();
    await _localStorage.saveProducts(updatedProducts);

    emit(ProductLoaded(await _localStorage.loadProducts()));
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    final currentProducts = await _localStorage.loadProducts();
    final updatedProducts =
        currentProducts
            .where((product) => product.id != event.productId)
            .toList();
    await _localStorage.saveProducts(updatedProducts);

    emit(ProductLoaded(await _localStorage.loadProducts()));
  }
}
