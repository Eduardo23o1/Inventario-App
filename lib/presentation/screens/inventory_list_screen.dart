import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:inventario_app/application/bloc/inventory_bloc.dart';
import 'package:inventario_app/application/bloc/inventory_event.dart';
import 'package:inventario_app/application/bloc/inventory_state.dart';
import 'package:inventario_app/application/bloc/product_bloc.dart';
import 'package:inventario_app/application/bloc/product_event.dart';
import 'package:inventario_app/data/repositories/local_storage.dart';
import 'package:inventario_app/presentation/Widget/appbar.dart';
import 'package:inventario_app/presentation/Widget/build_styled_card_inventory.dart';
import 'package:inventario_app/presentation/screens/inventory_form_screen.dart';
import 'package:inventario_app/presentation/screens/product_list_screen.dart';

class InventoryListScreen extends StatelessWidget {
  const InventoryListScreen({super.key});

  void onInventorySelected(String inventoryId, BuildContext context) async {
    await GetIt.instance<LocalStorage>().setString(
      'selected_inventory_id',
      inventoryId,
    );
    // ignore: use_build_context_synchronously
    context.read<ProductBloc>().add(LoadProducts(inventoryId));
  }

  void _confirmDelete(BuildContext context, String inventoryId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
            '¿Estás seguro de que deseas eliminar este inventario?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<InventoryBloc>().add(DeleteInventory(inventoryId));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Inventario eliminado')),
                );
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
      appBar: buildStyledAppBar("Inventarios"),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InventoryLoaded) {
            if (state.inventories.isEmpty) {
              return const Center(
                child: Text(
                  'No hay inventarios disponibles',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.inventories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final inventory = state.inventories[index];
                return buildStyledCardWithActions(
                  context,
                  inventory.name,
                  inventory.description,
                  () {
                    onInventorySelected(inventory.id, context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ProductListScreen(inventoryId: inventory.id),
                      ),
                    );
                  },
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => InventoryFormScreen(inventory: inventory),
                      ),
                    );
                  },
                  () {
                    _confirmDelete(context, inventory.id);
                  },
                );
              },
            );
          } else if (state is InventoryError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(
            child: Text(
              'No hay inventarios disponibles',
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
            MaterialPageRoute(builder: (_) => const InventoryFormScreen()),
          );
        },
      ),
    );
  }
}
