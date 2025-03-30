import 'package:get_it/get_it.dart';
import 'package:inventario_app/data/repositories/local_storage.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<LocalStorage>(() => LocalStorage());
}
