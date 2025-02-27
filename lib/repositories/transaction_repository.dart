import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mps_app/common/models/transaction_model.dart';
import 'package:mps_app/common/models/user_model.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(TransactionModel transaction);
  Future<UserModel?> getUserData();
  Future<void> updateUserName(String newName);
  Future<void> updateUserPassword(String newPassword);
  
}

class TransactionRepositoryImpl implements TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  

  UserModel? _userData;

  @override
  UserModel? get userData => _userData;

  @override
  Future<UserModel?> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    //final snapshot = await _firestore.collection('users').doc(user.uid)

    if (snapshot.exists) {
      _userData = UserModel.fromMap(snapshot.data()!);
      return _userData;
    } else {
      throw Exception('Dados do usuário não encontrados');
    }
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .add(transaction.toMap());
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final transaction = TransactionModel.fromMap(doc.data());
      transaction.id = doc.id;
      return transaction;
    }).toList();
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    final user = _auth.currentUser;
    if (user == null) {
      log('Erro: Usuário não autenticado');
      throw Exception('Usuário não autenticado');
    }

    if (transaction.id == null) {
      log('Erro: ID da transação é nulo, não é possível atualizar');
      throw Exception('ID da transação não pode ser nulo para atualização');
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toMap());
    } catch (e) {
      log('Erro ao atualizar transação: $e');
      throw Exception('Erro ao atualizar transação: $e');
    }
  }

  @override
  Future<void> deleteTransaction(TransactionModel transaction) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    if (transaction.id == null) {
      log('Erro: ID da transação é nulo, não é possível deletar');
      throw Exception('ID da transação não pode ser nulo para exclusão');
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(transaction.id)
          .delete();
    } catch (e) {
      log('Erro ao deletar transação: $e');
      throw Exception('Erro ao deletar transação: $e');
    }
  }
  @override
  Future<void> updateUserName(String newName) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'name': newName, // Atualiza o campo 'name' no Firestore
      });

      // Atualiza localmente também
      _userData = _userData?.copyWith(name: newName);
    } catch (e) {
      log('Erro ao atualizar nome do usuário: $e');
      throw Exception('Erro ao atualizar nome: $e');
    }
  }

  @override
  Future<void> updateUserPassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    try {
      await user.updatePassword(newPassword);
      log('Senha do usuário atualizada com sucesso no FirebaseAuth.');
    } on FirebaseAuthException catch (e) {
      // Caso precise de reautenticação
      if (e.code == 'requires-recent-login') {
        log('Necessita de reautenticação: ${e.message}');
        throw Exception('Necessita de reautenticação: ${e.message}');
      }
      log('Erro ao atualizar senha: ${e.message}');
      throw Exception(e.message ?? 'Erro ao atualizar senha.');
    } catch (e) {
      log('Erro inesperado ao atualizar senha: $e');
      rethrow;
    }
  }
}
