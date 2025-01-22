import 'package:get_it/get_it.dart';
import 'package:mps_app/features/sign_in/sign_in_controller.dart';
import 'package:mps_app/features/sign_up/sign_up_controller.dart';
import 'package:mps_app/services/auth_service.dart';
import 'package:mps_app/services/mock_auth_service.dart';

final locator = GetIt.instance;

void setupDependences() {
  locator.registerLazySingleton<AuthService>(() => MockAuthService());

  locator.registerFactory<SignInController>(
    () => SignInController(locator.get<AuthService>()));

  locator.registerFactory<SignUpController>(
    () => SignUpController(locator.get<AuthService>()));
}