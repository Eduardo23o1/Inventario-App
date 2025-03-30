import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:inventario_app/application/bloc/inventory_bloc.dart';
import 'package:inventario_app/application/bloc/inventory_event.dart';
import 'package:inventario_app/application/bloc/product_bloc.dart';
import 'package:inventario_app/application/bloc/product_event.dart';
import 'package:inventario_app/data/repositories/local_storage.dart';
import 'package:inventario_app/infrastructure/repositories/inventory_repository.dart';
import 'package:inventario_app/infrastructure/repositories/product_repository.dart';
import 'package:inventario_app/presentation/screens/inventory_list_screen.dart';
//import 'package:inventario_app/presentation/screens/inventory_list_screen.dart';
import 'package:inventario_app/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final getIt = GetIt.instance;

  getIt.registerLazySingleton<LocalStorage>(() => LocalStorage());

  getIt.registerLazySingleton<InventoryRepository>(
    () => InventoryRepository(getIt<LocalStorage>()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(getIt<LocalStorage>()),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final getIt = GetIt.instance;

    String inventoryId = ''; // bee1a809-dbd2-4770-8d80-46ceb482692e
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  InventoryBloc(getIt<InventoryRepository>())
                    ..add(LoadInventories()),
        ),
        BlocProvider(
          create:
              (_) =>
                  ProductBloc(getIt<ProductRepository>())
                    ..add(LoadProducts(inventoryId)),
        ),
      ],
      //bee1a809-dbd2-4770-8d80-46ceb482692e
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestión de Inventarios',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const InventoryListScreen(),
      ),
    );
  }
}
