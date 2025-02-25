import 'dart:developer';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mps_app/common/models/user_model.dart';
import 'package:mps_app/services/auth_service.dart';
import 'package:mps_app/services/firebase_database.dart';

class FirebaseAuthService implements AuthService {
  final _auth = FirebaseAuth.instance;
  final _functions = FirebaseFunctions.instance;

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Log do token JWT para Hasura
        final token = await result.user!.getIdTokenResult(true);
        log('Token JWT: ${token.token}');

        return UserModel(
          name: result.user!.displayName,
          email: result.user!.email,
          id: result.user!.uid,
        );
      } else {
        throw Exception('Usuário não encontrado após o login.');
      }
    } on FirebaseAuthException catch (e) {
      log('Erro no login: ${e.message}');
      throw e.message ?? "Erro desconhecido no login.";
    } catch (e) {
      log('Erro inesperado no login: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel> signUp({
  String? name,
  required String email,
  required String password,
}) async {
  try {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Chame seu método createUser passando também o name
    await FirestoreDataSource().createUser(email, name ?? '');

    if (result.user != null) {
      // Se quiser, também pode atualizar o displayName no Firebase Auth
      // await result.user!.updateDisplayName(name);

      // Token para Hasura
      final token = await result.user!.getIdTokenResult(true);

      return UserModel(
        name: name,
        email: result.user!.email,
        id: result.user!.uid,
      );
      } else {
        throw Exception('Usuário não encontrado após o registro.');
      }
    } on FirebaseAuthException catch (e) {
      log('Erro no Firebase Auth: ${e.message}');
      throw e.message ?? "Erro desconhecido no Firebase Auth.";
    } on FirebaseFunctionsException catch (e) {
      log('Erro na Cloud Function: ${e.message}');
      throw e.message ?? "Erro desconhecido na Cloud Function.";
    } catch (e) {
      log('Erro inesperado no registro: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Erro ao fazer logout: $e');
      rethrow;
    }
  }
}