import 'package:get_it/get_it.dart';
import 'package:fms/service/http_service.dart';

import '../service/http_chat.dart';

GetIt locator = GetIt.instance;

// https://totally-developer.tistory.com/84
initLocator() {
  locator.registerLazySingleton<HttpService>(() => HttpServiceImplementation());
  locator.registerLazySingleton<HttpChat>(() => HttpChatImplementation());
}