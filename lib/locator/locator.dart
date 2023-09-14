import 'package:get_it/get_it.dart';
import 'package:fms/service/color_service.dart';

GetIt locator = GetIt.instance;

// https://totally-developer.tistory.com/84
initLocator() {
  locator.registerLazySingleton<ColorService>(() => ColorServiceImplementation());
}