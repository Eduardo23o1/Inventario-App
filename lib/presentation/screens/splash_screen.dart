import 'package:flutter/material.dart';
import 'package:inventario_app/presentation/screens/inventory_list_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/4149/4149723.png',
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 80, color: Colors.red);
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'INVENTARIO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Color del botón
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => InventoryListScreen()),
                );
              },
              child: const Text(
                'Gestionar',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Administra tu inventario de forma eficiente',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
