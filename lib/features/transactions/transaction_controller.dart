import 'dart:developer';

import 'package:flutter/foundation.dart';
import '../../common/models/transaction_model.dart';
import '../../common/models/user_model.dart';
import '../../repositories/transaction_repository.dart';
import '../../services/secure_storage.dart';
import 'transaction_state.dart';

class TransactionController extends ChangeNotifier {
  final TransactionRepository repository;
  final Securestorage storage;

  TransactionController({
    required this.repository,
    required this.storage,
  });

  TransactionState _state = TransactionStateInitial();
  TransactionState get state => _state;

  void _changeState(TransactionState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    _changeState(TransactionStateLoading());
    try {
      final data = await storage.readOne(key: 'CURRENT_USER');
      final user = UserModel.fromJson(data ?? '');
      
      // Aguarda a execução do método. Se não lançar exceção, é sucesso.
      await repository.addTransaction(transaction);
      
      _changeState(TransactionStateSuccess());
    } catch (e) {
      _changeState(TransactionStateError(e.toString()));
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
  log('Chamando updateTransaction no controller para ID: ${transaction.id}');

    _changeState(TransactionStateLoading());
    try {
      await repository.updateTransaction(transaction);
      log('Transação atualizada com sucesso no controller');
      _changeState(TransactionStateSuccess());
    } catch (e) {
      log('Erro no controller ao atualizar transação: $e');
      _changeState(TransactionStateError(e.toString()));
    }
  }

}

