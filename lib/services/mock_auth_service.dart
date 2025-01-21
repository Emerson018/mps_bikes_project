import 'package:mps_app/common/models/user_model.dart';
import 'package:mps_app/services/auth_service.dart';

class MockAuthService implements AuthService{
  @override
  Future signIn() {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signUp({
    String? name,
    required String email,
    required String password
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      if(password.startsWith('123')){
        throw Exception();
      }
      return UserModel(
      id: email.hashCode,
      name: name,
      email: email
      );
    } catch (e) {
      if(password.startsWith('123')){
        throw 'Senha insegura. Digite uma senha mais forte.';
      }
      throw 'Não foi possível criar sua conta nesse momento. Tente novamente mais tarde';
    }
  }
}