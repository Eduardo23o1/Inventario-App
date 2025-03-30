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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre del Inventario',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.inventory),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'El nombre es obligatorio'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Descripción',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.description),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final inventory = Inventory(
                                  id: widget.inventory?.id ?? const Uuid().v4(),
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
                              widget.inventory == null
                                  ? 'Agregar'
                                  : 'Guardar cambios',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
