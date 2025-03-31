import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventario_app/application/bloc/product_bloc.dart';
import 'package:inventario_app/application/bloc/product_event.dart';
import 'package:inventario_app/application/bloc/product_state.dart';
import 'package:inventario_app/domain/models/product.dart';
import 'package:inventario_app/presentation/screens/product_form_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

class FakeProductEvent extends Fake implements ProductEvent {}

void main() {
  late MockProductBloc mockProductBloc;

  setUp(() {
    registerFallbackValue(FakeProductEvent());
    mockProductBloc = MockProductBloc();
  });

  tearDown(() {
    mockProductBloc.close();
  });

  Widget createTestWidget({Product? product}) {
    return MaterialApp(
      home: BlocProvider<ProductBloc>(
        create: (_) => mockProductBloc,
        child: ProductFormScreen(
          inventoryId: 'test_inventory',
          product: product,
        ),
      ),
    );
  }

  testWidgets('Renderiza correctamente el formulario para un nuevo producto', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Agregar Producto'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('Agregar'), findsOneWidget);
  });

  testWidgets('Renderiza correctamente el formulario para editar un producto', (
    WidgetTester tester,
  ) async {
    final product = Product(
      id: '1',
      name: 'Producto 1',
      price: 10.0,
      quantity: 5,
      inventoryId: 'test_inventory',
    );

    await tester.pumpWidget(createTestWidget(product: product));

    expect(find.text('Editar Producto'), findsOneWidget);
    expect(find.text('Producto 1'), findsOneWidget);
    expect(find.text('10.0'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('Guardar cambios'), findsOneWidget);
  });

  testWidgets('Muestra errores de validación si los campos están vacíos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('Agregar'));
    await tester.pump();

    expect(find.text('El nombre es obligatorio'), findsOneWidget);
    expect(find.text('El precio es obligatorio'), findsOneWidget);
    expect(find.text('La cantidad es obligatoria'), findsOneWidget);
  });

  testWidgets('Dispara AddProduct al guardar un nuevo producto', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestWidget());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nombre del Producto'),
      'Nuevo Producto',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Precio'),
      '15.5',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Cantidad'),
      '10',
    );

    await tester.tap(find.text('Agregar'));
    await tester.pump();

    verify(() => mockProductBloc.add(any(that: isA<AddProduct>()))).called(1);
  });

  testWidgets(
    'Dispara UpdateProduct al guardar cambios en un producto existente',
    (WidgetTester tester) async {
      final product = Product(
        id: '1',
        name: 'Producto 1',
        price: 10.0,
        quantity: 5,
        inventoryId: 'test_inventory',
      );

      await tester.pumpWidget(createTestWidget(product: product));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre del Producto'),
        'Producto Actualizado',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Precio'),
        '20.0',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Cantidad'),
        '8',
      );

      await tester.tap(find.text('Guardar cambios'));
      await tester.pump();

      verify(
        () => mockProductBloc.add(any(that: isA<UpdateProduct>())),
      ).called(1);
    },
  );

  testWidgets('Cierra la pantalla después de guardar el producto', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestWidget());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nombre del Producto'),
      'Nuevo Producto',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Precio'),
      '15.5',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Cantidad'),
      '10',
    );

    await tester.tap(find.text('Agregar'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductFormScreen), findsNothing);
  });
}
