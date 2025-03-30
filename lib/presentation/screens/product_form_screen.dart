import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventario_app/application/bloc/product_bloc.dart';
import 'package:inventario_app/application/bloc/product_event.dart';
import 'package:inventario_app/domain/models/product.dart';
import 'package:uuid/uuid.dart';

class ProductFormScreen extends StatefulWidget {
  final String inventoryId;
  final Product? product;

  const ProductFormScreen({super.key, required this.inventoryId, this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _quantityController.text = widget.product!.quantity.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Agregar Producto' : 'Editar Producto',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                _nameController,
                'Nombre del Producto',
                Icons.inventory,
                (value) {
                  if (value!.isEmpty) return 'El nombre es obligatorio';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(_priceController, 'Precio', Icons.attach_money, (
                value,
              ) {
                if (value!.isEmpty) return 'El precio es obligatorio';
                final price = double.tryParse(value);
                if (price == null || price < 0) return 'Precio inválido';
                return null;
              }, TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(
                _quantityController,
                'Cantidad',
                Icons.format_list_numbered,
                (value) {
                  if (value!.isEmpty) return 'La cantidad es obligatoria';
                  final quantity = int.tryParse(value);
                  if (quantity == null || quantity < 0)
                    return 'Cantidad inválida';
                  return null;
                },
                TextInputType.number,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.save),
                  label: Text(
                    widget.product == null ? 'Agregar' : 'Guardar cambios',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    String? Function(String?) validator, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? const Uuid().v4(),
        name: _nameController.text,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        inventoryId: widget.inventoryId,
      );

      if (widget.product == null) {
        context.read<ProductBloc>().add(
          AddProduct(product, _nameController.text),
        );
      } else {
        context.read<ProductBloc>().add(UpdateProduct(product));
      }

      Navigator.pop(context);
    }
  }
}
