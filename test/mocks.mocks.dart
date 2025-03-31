// Mocks generated by Mockito 5.4.5 from annotations
// in inventario_app/test/mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:inventario_app/data/repositories/local_storage.dart' as _i2;
import 'package:inventario_app/domain/models/inventory.dart' as _i4;
import 'package:inventario_app/domain/models/product.dart' as _i5;
import 'package:inventario_app/infrastructure/repositories/inventory_repository.dart'
    as _i6;
import 'package:inventario_app/infrastructure/repositories/product_repository.dart'
    as _i7;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeLocalStorage_0 extends _i1.SmartFake implements _i2.LocalStorage {
  _FakeLocalStorage_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [LocalStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalStorage extends _i1.Mock implements _i2.LocalStorage {
  MockLocalStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> setString(String? key, String? value) =>
      (super.noSuchMethod(
            Invocation.method(#setString, [key, value]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<String?> getString(String? key) =>
      (super.noSuchMethod(
            Invocation.method(#getString, [key]),
            returnValue: _i3.Future<String?>.value(),
          )
          as _i3.Future<String?>);

  @override
  _i3.Future<void> saveInventories(List<_i4.Inventory>? inventories) =>
      (super.noSuchMethod(
            Invocation.method(#saveInventories, [inventories]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<List<_i4.Inventory>> loadInventories() =>
      (super.noSuchMethod(
            Invocation.method(#loadInventories, []),
            returnValue: _i3.Future<List<_i4.Inventory>>.value(
              <_i4.Inventory>[],
            ),
          )
          as _i3.Future<List<_i4.Inventory>>);

  @override
  _i3.Future<void> saveProducts(List<_i5.Product>? products) =>
      (super.noSuchMethod(
            Invocation.method(#saveProducts, [products]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<List<_i5.Product>> loadProducts() =>
      (super.noSuchMethod(
            Invocation.method(#loadProducts, []),
            returnValue: _i3.Future<List<_i5.Product>>.value(<_i5.Product>[]),
          )
          as _i3.Future<List<_i5.Product>>);

  @override
  _i3.Future<List<_i5.Product>> getProductsByInventory(String? inventoryId) =>
      (super.noSuchMethod(
            Invocation.method(#getProductsByInventory, [inventoryId]),
            returnValue: _i3.Future<List<_i5.Product>>.value(<_i5.Product>[]),
          )
          as _i3.Future<List<_i5.Product>>);
}

/// A class which mocks [InventoryRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockInventoryRepository extends _i1.Mock
    implements _i6.InventoryRepository {
  MockInventoryRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.LocalStorage get localStorage =>
      (super.noSuchMethod(
            Invocation.getter(#localStorage),
            returnValue: _FakeLocalStorage_0(
              this,
              Invocation.getter(#localStorage),
            ),
          )
          as _i2.LocalStorage);

  @override
  _i3.Future<List<_i4.Inventory>> loadInventories() =>
      (super.noSuchMethod(
            Invocation.method(#loadInventories, []),
            returnValue: _i3.Future<List<_i4.Inventory>>.value(
              <_i4.Inventory>[],
            ),
          )
          as _i3.Future<List<_i4.Inventory>>);

  @override
  _i3.Future<void> saveInventories(List<_i4.Inventory>? inventories) =>
      (super.noSuchMethod(
            Invocation.method(#saveInventories, [inventories]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);
}

/// A class which mocks [ProductRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockProductRepository extends _i1.Mock implements _i7.ProductRepository {
  MockProductRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.LocalStorage get localStorage =>
      (super.noSuchMethod(
            Invocation.getter(#localStorage),
            returnValue: _FakeLocalStorage_0(
              this,
              Invocation.getter(#localStorage),
            ),
          )
          as _i2.LocalStorage);

  @override
  _i3.Future<void> addProduct(_i5.Product? product) =>
      (super.noSuchMethod(
            Invocation.method(#addProduct, [product]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<List<_i5.Product>> loadProducts() =>
      (super.noSuchMethod(
            Invocation.method(#loadProducts, []),
            returnValue: _i3.Future<List<_i5.Product>>.value(<_i5.Product>[]),
          )
          as _i3.Future<List<_i5.Product>>);

  @override
  _i3.Future<void> saveProducts(List<_i5.Product>? products) =>
      (super.noSuchMethod(
            Invocation.method(#saveProducts, [products]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);
}
