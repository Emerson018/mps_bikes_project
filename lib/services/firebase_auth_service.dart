import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mps_app/common/models/user_model.dart';
import 'package:mps_app/services/auth_service.dart';
import 'package:mps_app/services/firebase_database.dart';

class FirebaseAuthService implements AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

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

    /// Atualiza o nome do usuário tanto no displayName do FirebaseAuth
  /// quanto no documento Firestore do usuário (campo "name").
  Future<void> updateUserName(String newName) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Nenhum usuário logado.');
    }

    try {
      // 1) Atualiza o displayName no Firebase Auth
      await user.updateDisplayName(newName);

      // 2) Atualiza no Firestore (coleção "users", doc = user.uid)
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'name': newName});

      log('Nome do usuário atualizado para $newName no FirebaseAuth e Firestore.');
    } on FirebaseAuthException catch (e) {
      log('Erro ao atualizar nome: ${e.message}');
      throw e.message ?? "Erro ao atualizar nome no Firebase Auth.";
    } catch (e) {
      log('Erro inesperado ao atualizar nome: $e');
      rethrow;
    }
  }

  /// Atualiza a senha do usuário no FirebaseAuth.
  /// Se a sessão estiver “antiga”, pode precisar de reautenticação.
  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Nenhum usuário logado.');
    }

    try {
      await user.updatePassword(newPassword);
      log('Senha do usuário atualizada com sucesso no FirebaseAuth.');
    } on FirebaseAuthException catch (e) {
      // Caso precise de reautenticação, você pode capturar aqui:
      if (e.code == 'requires-recent-login') {
        // Por exemplo, você pode notificar o controller
        // para que exiba um fluxo de reautenticação
        // e, depois, tente novamente updatePassword(newPassword).
      }
      log('Erro ao atualizar senha: ${e.message}');
      throw e.message ?? "Erro ao atualizar senha no Firebase Auth.";
    } catch (e) {
      log('Erro inesperado ao atualizar senha: $e');
      rethrow;
    }
  }
}