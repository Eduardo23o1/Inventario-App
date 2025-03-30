import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventario_app/application/bloc/inventory_bloc.dart';
import 'package:inventario_app/application/bloc/inventory_event.dart';
import 'package:inventario_app/domain/models/inventory.dart';
import 'package:uuid/uuid.dart';

class InventoryFormScreen extends StatefulWidget {
  final Inventory? inventory;

  const InventoryFormScreen({super.key, this.inventory});

  @override
  _InventoryFormScreenState createState() => _InventoryFormScreenState();
}

class _InventoryFormScreenState extends State<InventoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.inventory != null) {
      _nameController.text = widget.inventory!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.inventory == null ? 'Agregar Inventario' : 'Editar Inventario',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Inventario',
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'El nombre es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final inventory = Inventory(
                      id:
                          widget.inventory?.id ??
                          const Uuid().v4(), // Si edita, usa el mismo ID
                      name: _nameController.text,
                    );

                    if (widget.inventory == null) {
                      context.read<InventoryBloc>().add(
                        AddInventory(inventory),
                      );
                    } else {
                      context.read<InventoryBloc>().add(
                        UpdateInventory(inventory),
                      );
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(
                  widget.inventory == null ? 'Agregar' : 'Guardar cambios',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
