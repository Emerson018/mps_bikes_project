import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mps_app/common/models/transaction_model.dart';


abstract class TransactionRepository {
  Future<void> addTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getAllTransactions();
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
        .collection('transactions') // Subcoleção de transações
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

    return snapshot.docs
        .map((doc) => TransactionModel.fromMap(doc.data()))
        .toList();
  }
}

