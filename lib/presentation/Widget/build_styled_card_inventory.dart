import 'package:flutter/material.dart';

Widget buildStyledCardWithActions(
  BuildContext context,
  String name,
  int taskCount,
  Function() onTap,
  Function() onEdit,
  Function() onDelete,
) {
  return Card(
    elevation: 0,
    color: Colors.purple[50],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: const Icon(Icons.check_box_outlined, color: Colors.purple),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        'Productos: $taskCount',
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.black),
            onPressed: onDelete,
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    ),
  );
}

// Ejemplo de uso:
// buildStyledCardWithActions(
//   context,
//   'Work',
//   14,
//   () {
//     // Lógica al hacer tap en el card
//     print('Card Work tap');
//   },
//   () {
//     // Lógica para editar
//     print('Edit tap');
//   },
//   () {
//     // Lógica para eliminar
//     print('Delete tap');
//   },
// );
