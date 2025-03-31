import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventario_app/application/bloc/product_bloc.dart';
import 'package:inventario_app/application/bloc/product_event.dart';
import 'package:inventario_app/application/bloc/product_state.dart';
import 'package:inventario_app/domain/models/product.dart';
import 'package:inventario_app/presentation/screens/product_list_screen.dart';

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

void main() {
  late MockProductBloc mockProductBloc;

  setUp(() {
    mockProductBloc = MockProductBloc();
  });

  tearDown(() {
    mockProductBloc.close();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<ProductBloc>(
        create: (_) => mockProductBloc,
        child: const ProductListScreen(inventoryId: 'test_inventory'),
      ),
    );
  }

  testWidgets(
    'Muestra el indicador de carga cuando el estado es ProductLoading',
    (WidgetTester tester) async {
      whenListen(
        mockProductBloc,
        Stream.fromIterable([ProductLoading()]),
        initialState: ProductLoading(),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('Muestra productos cuando el estado es ProductLoaded', (
    WidgetTester tester,
  ) async {
    final products = [
      Product(
        id: '1',
        name: 'Producto 1',
        price: 10.0,
        quantity: 5,
        inventoryId: 'test_inventory',
      ),
      Product(
        id: '2',
        name: 'Producto 2',
        price: 20.0,
        quantity: 3,
        inventoryId: 'test_inventory',
      ),
    ];

    whenListen(
      mockProductBloc,
      Stream.fromIterable([ProductLoaded(products)]),
      initialState: ProductLoaded(products),
    );

    await tester.pumpWidget(createTestWidget());

    expect(find.text('Producto 1'), findsOneWidget);
    expect(find.text('Producto 2'), findsOneWidget);
  });

  testWidgets('Muestra mensaje cuando no hay productos disponibles', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockProductBloc,
      Stream.fromIterable([ProductLoaded([])]),
      initialState: ProductLoaded([]),
    );

    await tester.pumpWidget(createTestWidget());

    expect(find.text('No hay productos disponibles'), findsOneWidget);
  });

  testWidgets('Muestra mensaje de error cuando el estado es ProductError', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockProductBloc,
      Stream.fromIterable([ProductError('Error al cargar productos')]),
      initialState: ProductError('Error al cargar productos'),
    );

    await tester.pumpWidget(createTestWidget());

    expect(find.text('Error al cargar productos'), findsOneWidget);
  });

  testWidgets(
    'Navega al formulario de productos al presionar el botón flotante',
    (WidgetTester tester) async {
      whenListen(
        mockProductBloc,
        Stream.fromIterable([ProductLoaded([])]),
        initialState: ProductLoaded([]),
      );

      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(ProductListScreen), findsNothing);
    },
  );
}
