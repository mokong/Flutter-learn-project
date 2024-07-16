import 'package:get_it/get_it.dart';
import 'package:scope_model_demo/scoped_model/home_model.dart';
import 'package:scope_model_demo/service/storage_service.dart';

GetIt serviceLocator = GetIt.instance;
void setupServiceLocator() {
  // Register Services
  serviceLocator.registerLazySingleton<StorageService>(() => StorageService());

  // Register models
  serviceLocator.registerFactory<HomeModel>(() => HomeModel());
}
