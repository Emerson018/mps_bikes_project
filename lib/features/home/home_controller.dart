import 'package:flutter/foundation.dart';
import 'package:mps_app/common/models/transaction_model.dart';
import 'package:mps_app/features/home/home_state.dart';
import 'package:mps_app/repositories/transaction_repository.dart';

class HomeController extends ChangeNotifier {
  final TransactionRepository _transactionRepository;
  HomeController(this._transactionRepository);

  HomeState _state = HomeStateInitial();
  HomeState get state => _state;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  void _changeState(HomeState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> getAllTransactions() async {
    _changeState(HomeStateLoading());
    try {
      _transactions = await _transactionRepository.getAllTransactions();
      _changeState(HomeStateSuccess());
    } catch (e) {
      _changeState(HomeStateError());
    }
  }

  // Nova função para adicionar uma transação
  Future<void> addTransaction(TransactionModel transaction) async {
    _changeState(HomeStateLoading());
    try {
      await _transactionRepository.addTransaction(transaction);
      // Atualiza a lista local de transações se necessário
      _transactions.add(transaction);
      _changeState(HomeStateSuccess());
    } catch (e) {
      _changeState(HomeStateError());
    }
  }
}
