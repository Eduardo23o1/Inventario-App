import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventario_app/application/bloc/product_bloc.dart';
import 'package:inventario_app/application/bloc/product_event.dart';
import 'package:inventario_app/application/bloc/product_state.dart';
import 'package:inventario_app/presentation/Widget/appbar.dart';
import 'package:inventario_app/presentation/Widget/build_styled_card_product.dart';
import 'package:inventario_app/presentation/screens/product_form_screen.dart';

class ProductListScreen extends StatelessWidget {
  final String inventoryId;

  const ProductListScreen({super.key, required this.inventoryId});

  void _confirmDelete(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
            '¿Estás seguro de que deseas eliminar este producto?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<ProductBloc>().add(DeleteProduct(productId));
                Navigator.of(context).pop();
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildStyledAppBar("Productos"),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final products =
                state.products
                    .where((product) => product.inventoryId == inventoryId)
                    .toList();

            if (products.isEmpty) {
              return const Center(
                child: Text(
                  'No hay productos disponibles',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final product = products[index];
                return buildStyledCardWithActionsProduct(
                  context,
                  product.name,
                  product.price,
                  product.quantity,
                  () {},
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ProductFormScreen(
                              inventoryId: inventoryId,
                              product: product,
                            ),
                      ),
                    );
                  },
                  () {
                    _confirmDelete(context, product.id);
                  },
                );
              },
            );
          } else if (state is ProductError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(
            child: Text(
              'No hay productos disponibles',
              style: TextStyle(fontSize: 16),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductFormScreen(inventoryId: inventoryId),
            ),
          );
        },
      ),
    );
  }
}
