import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventario_app/application/bloc/product_event.dart';
import 'package:inventario_app/presentation/screens/inventory_form_screen.dart';
import 'package:inventario_app/application/bloc/inventory_bloc.dart';
import 'package:inventario_app/application/bloc/inventory_event.dart';
import 'package:inventario_app/application/bloc/inventory_state.dart';
import 'package:inventario_app/application/bloc/product_bloc.dart';
import 'package:inventario_app/application/bloc/product_state.dart';
import 'package:inventario_app/presentation/screens/inventory_list_screen.dart';
import 'package:inventario_app/domain/models/inventory.dart';

class MockInventoryBloc extends MockBloc<InventoryEvent, InventoryState>
    implements InventoryBloc {}

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

void main() {
  late MockInventoryBloc mockInventoryBloc;
  late MockProductBloc mockProductBloc;

  setUp(() {
    mockInventoryBloc = MockInventoryBloc();
    mockProductBloc = MockProductBloc();

    whenListen(
      mockInventoryBloc,
      Stream.fromIterable([InventoryLoading()]),
      initialState: InventoryLoading(),
    );

    whenListen(
      mockProductBloc,
      Stream.fromIterable([ProductLoaded([])]),
      initialState: ProductLoaded([]),
    );
  });

  tearDown(() {
    mockInventoryBloc.close();
    mockProductBloc.close();
  });

  Widget createTestWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InventoryBloc>(create: (_) => mockInventoryBloc),
        BlocProvider<ProductBloc>(create: (_) => mockProductBloc),
      ],
      child: const MaterialApp(home: InventoryListScreen()),
    );
  }

  testWidgets(
    'Muestra un indicador de carga cuando el estado es InventoryLoading',
    (WidgetTester tester) async {
      whenListen(
        mockInventoryBloc,
        Stream.fromIterable([InventoryLoading()]),
        initialState: InventoryLoading(),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('Muestra un mensaje cuando no hay inventarios disponibles', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockInventoryBloc,
      Stream.fromIterable([InventoryLoaded([])]),
      initialState: InventoryLoaded([]),
    );

    await tester.pumpWidget(createTestWidget());

    expect(find.text('No hay inventarios disponibles'), findsOneWidget);
  });

  testWidgets(
    'Muestra una lista de inventarios cuando el estado es InventoryLoaded con datos',
    (WidgetTester tester) async {
      final inventories = [
        Inventory(id: '1', name: 'Inventario 1', description: 'Descripción 1'),
        Inventory(id: '2', name: 'Inventario 2', description: 'Descripción 2'),
      ];

      whenListen(
        mockInventoryBloc,
        Stream.fromIterable([InventoryLoaded(inventories)]),
        initialState: InventoryLoaded(inventories),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Inventario 1'), findsOneWidget);
      expect(find.text('Inventario 2'), findsOneWidget);
    },
  );

  testWidgets('Navega a InventoryFormScreen al presionar el botón flotante', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockInventoryBloc,
      Stream.fromIterable([InventoryLoaded([])]),
      initialState: InventoryLoaded([]),
    );

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(InventoryFormScreen), findsOneWidget);
  });
}
