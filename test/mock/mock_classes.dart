import 'package:mocktail/mocktail.dart';
import 'package:mps_app/services/auth_service.dart';
import 'package:mps_app/services/secure_storage.dart';

class MockFirebaseAuthService extends Mock implements AuthService{}

class MockSecureStorage extends Mock implements Securestorage{}