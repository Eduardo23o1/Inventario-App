import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventario_app/application/bloc/inventory_bloc.dart';
import 'package:inventario_app/application/bloc/inventory_event.dart';
import 'package:inventario_app/application/bloc/inventory_state.dart';
import 'package:inventario_app/domain/models/inventory.dart';
import 'package:inventario_app/presentation/screens/inventory_form_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockInventoryBloc extends MockBloc<InventoryEvent, InventoryState>
    implements InventoryBloc {}

class FakeInventoryEvent extends Fake implements InventoryEvent {}

void main() {
  late InventoryBloc mockInventoryBloc;

  setUp(() {
    registerFallbackValue(FakeInventoryEvent());
    mockInventoryBloc = MockInventoryBloc();
  });

  Widget crearWidgetDePrueba({Inventory? inventory}) {
    return BlocProvider<InventoryBloc>.value(
      value: mockInventoryBloc,
      child: MaterialApp(home: InventoryFormScreen(inventory: inventory)),
    );
  }

  testWidgets(
    'Renderiza InventoryFormScreen con campos vacíos si no se proporciona inventario',
    (WidgetTester tester) async {
      await tester.pumpWidget(crearWidgetDePrueba());

      debugPrint(tester.widgetList(find.byType(ElevatedButton)).toString());

      expect(find.text('Agregar Inventario'), findsOneWidget);
      expect(find.text('Nombre del Inventario'), findsOneWidget);
      expect(find.text('Descripción'), findsOneWidget);
      expect(find.text('Agregar'), findsOneWidget);
    },
  );

  testWidgets(
    'Renderiza InventoryFormScreen con campos llenos si se proporciona inventario',
    (WidgetTester tester) async {
      final inventory = Inventory(
        id: '1',
        name: 'Inventario de prueba',
        description: 'Descripción de prueba',
      );
      await tester.pumpWidget(crearWidgetDePrueba(inventory: inventory));

      expect(find.text('Editar Inventario'), findsOneWidget);
      expect(find.text('Inventario de prueba'), findsOneWidget);
      expect(find.text('Descripción de prueba'), findsOneWidget);
    },
  );

  testWidgets('Muestra error de validación si el campo nombre está vacío', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(crearWidgetDePrueba());

    debugPrint(
      tester.widgetList(find.byType(ElevatedButton)).toString(),
    ); // Para depuración

    await tester.tap(find.text('Agregar')); // Usa el texto del botón
    await tester.pump();

    expect(find.text('El nombre es obligatorio'), findsOneWidget);
  });

  testWidgets('Dispara el evento AddInventory al agregar un nuevo inventario', (
    WidgetTester tester,
  ) async {
    when(() => mockInventoryBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(crearWidgetDePrueba());

    await tester.enterText(
      find.byType(TextFormField).first,
      'Nuevo Inventario',
    );
    await tester.tap(find.text('Agregar'));
    await tester.pump();

    verify(
      () => mockInventoryBloc.add(any(that: isA<AddInventory>())),
    ).called(1);
  });

  testWidgets(
    'Dispara el evento UpdateInventory al editar un inventario existente',
    (WidgetTester tester) async {
      final inventory = Inventory(
        id: '1',
        name: 'Inventario de prueba',
        description: 'Descripción de prueba',
      );
      when(() => mockInventoryBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(crearWidgetDePrueba(inventory: inventory));

      await tester.enterText(
        find.byType(TextFormField).first,
        'Inventario Actualizado',
      );
      await tester.tap(find.text('Guardar cambios'));
      await tester.pump();

      verify(
        () => mockInventoryBloc.add(any(that: isA<UpdateInventory>())),
      ).called(1);
    },
  );

  testWidgets(
    'Cierra la pantalla después de enviar el formulario exitosamente',
    (WidgetTester tester) async {
      await tester.pumpWidget(crearWidgetDePrueba());

      await tester.enterText(
        find.byType(TextFormField).first,
        'Nuevo Inventario',
      );
      await tester.tap(find.text('Agregar'));
      await tester.pumpAndSettle();

      expect(find.byType(InventoryFormScreen), findsNothing);
    },
  );
}
