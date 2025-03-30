import 'package:flutter/material.dart';

AppBar buildStyledAppBar(String texto) {
  return AppBar(
    title: Text(
      texto,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: Colors.white,
      ),
    ),
    centerTitle: true,
    elevation: 1,
    backgroundColor: Colors.purple,
    actions: [
      /*IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Lógica para agregar un nuevo inventario
        },
      ),
      IconButton(
        icon: const Icon(Icons.search, color: Colors.white),
        onPressed: () {
          // Lógica para buscar inventarios
        },
      ),*/
    ],
  );
}
