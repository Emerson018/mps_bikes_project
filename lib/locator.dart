import 'package:get_it/get_it.dart';
import 'package:mps_app/features/home/home_controller.dart';
import 'package:mps_app/features/sign_in/sign_in_controller.dart';
import 'package:mps_app/features/sign_up/sign_up_controller.dart';
import 'package:mps_app/features/splash/splash_controller.dart';
import 'package:mps_app/features/wallets/wallet_controller.dart';
import 'package:mps_app/repositories/transaction_repository.dart';
import 'package:mps_app/services/auth_service.dart';
import 'package:mps_app/services/firebase_auth_service.dart';
import 'package:mps_app/services/secure_storage.dart';
import 'features/transactions/transaction_controller.dart';

final locator = GetIt.instance;

void setupDependences() {
  locator.registerLazySingleton<AuthService>(
    () => FirebaseAuthService());

  locator.registerFactory<SplashController>(
    () => SplashController(const Securestorage()));

  locator.registerFactory<SignInController>(
    () => SignInController(locator.get<AuthService>()));

  locator.registerFactory<SignUpController>(
    ()=> SignUpController(locator.get<AuthService>(), 
    const Securestorage()));

  locator.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl());

  locator.registerLazySingleton<HomeController>(
    () => HomeController(locator.get<TransactionRepository>()));

//o git hub excluiu essa parte, nao sei porque
    locator.registerFactory<TransactionController>(
    () => TransactionController(
      repository: locator.get<TransactionRepository>(),
      storage: const Securestorage(),
    ),
  );
  
  locator.registerLazySingleton(
    () => WalletController(transactionRepository: locator.get<TransactionRepository>()),
  );
}