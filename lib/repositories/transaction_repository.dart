import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mps_app/common/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> updateTransaction(TransactionModel transaction);
}

class TransactionRepositoryImpl implements TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    log('Atualizando transação ID: ${transaction.id} com dados: ${transaction.toMap()}');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .doc(transaction.id) // Atualiza o documento com o ID correto
        .update(transaction.toMap());

    log('Transação atualizada com sucesso');
  } catch (e) {
    log('Erro ao atualizar transação: $e');
    throw Exception('Erro ao atualizar transação: $e');
  }
}

}
