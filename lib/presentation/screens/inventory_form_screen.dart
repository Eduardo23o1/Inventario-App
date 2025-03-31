import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventario_app/application/bloc/inventory_bloc.dart';
import 'package:inventario_app/application/bloc/inventory_event.dart';
import 'package:inventario_app/domain/models/inventory.dart';
import 'package:inventario_app/presentation/Widget/appbar.dart';
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
      _descriptionController.text = widget.inventory!.description;
    }
  }

  //,
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildStyledAppBar(
        widget.inventory == null ? 'Agregar Inventario' : 'Editar Inventario',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.inventory),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'El nombre es obligatorio'
                                      : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Descripción',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.description),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newInventory = Inventory(
                        id: widget.inventory?.id ?? const Uuid().v4(),
                        name: _nameController.text,
                        description: _descriptionController.text,
                      );

                      if (widget.inventory == null) {
                        context.read<InventoryBloc>().add(
                          AddInventory(newInventory),
                        );
                      } else {
                        context.read<InventoryBloc>().add(
                          UpdateInventory(newInventory),
                        );
                      }

                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: Text(
                    widget.inventory == null ? 'Agregar' : 'Guardar cambios',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
