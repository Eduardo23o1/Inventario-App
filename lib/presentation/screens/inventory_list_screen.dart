import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:inventario_app/application/bloc/inventory_bloc.dart';
import 'package:inventario_app/application/bloc/inventory_event.dart';
import 'package:inventario_app/application/bloc/inventory_state.dart';
import 'package:inventario_app/application/bloc/product_bloc.dart';
import 'package:inventario_app/application/bloc/product_event.dart';
import 'package:inventario_app/data/repositories/local_storage.dart';
import 'package:inventario_app/presentation/screens/inventory_form_screen.dart';
import 'package:inventario_app/presentation/screens/product_list_screen.dart';

class InventoryListScreen extends StatelessWidget {
  const InventoryListScreen({super.key});

  void onInventorySelected(String inventoryId, BuildContext context) async {
    await GetIt.instance<LocalStorage>().setString(
      'selected_inventory_id',
      inventoryId,
    );

    // Disparar evento para recargar productos
    context.read<ProductBloc>().add(LoadProducts(inventoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventarios')),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InventoryLoaded) {
            return ListView.builder(
              itemCount: state.inventories.length,
              itemBuilder: (context, index) {
                final inventory = state.inventories[index];
                return ListTile(
                  title: Text('${inventory.name} (${inventory.id})'),
                  subtitle: Text('Descripción:'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      InventoryFormScreen(inventory: inventory),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<InventoryBloc>().add(
                            DeleteInventory(inventory.id),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    onInventorySelected(inventory.id, context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ProductListScreen(inventoryId: inventory.id),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is InventoryError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No hay inventarios disponibles'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InventoryFormScreen()),
          );
        },
      ),
    );
  }
}
