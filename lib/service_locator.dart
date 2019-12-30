
import 'package:get_it/get_it.dart';
import 'model/app_state_model.dart';

GetIt locator = GetIt();

void setupLocator() {
  // Register services

  locator.registerFactory<NewAppStateModel>(() => NewAppStateModel());
  // Register models
}