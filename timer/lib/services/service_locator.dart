import 'package:get_it/get_it.dart';
import 'package:timer/pages/timer_page/timer_page_logic.dart';
import 'package:timer/services/storage_service/shared_preferences_storage.dart';
import 'package:timer/services/storage_service/storage_service.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<TimerPageManager>(() => TimerPageManager());

  getIt.registerLazySingleton<StorageService>(() => SharedPreferencesStorage());
}
