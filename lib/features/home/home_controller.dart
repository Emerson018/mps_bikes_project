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

  // Variáveis do balanço
  double _totalAmount = 0.0;
  double _incomeAmount = 0.0;
  double _outcomeAmount = 0.0;

  double get totalAmount => _totalAmount;
  double get incomeAmount => _incomeAmount;
  double get outcomeAmount => _outcomeAmount;

  bool _isCached = false; // Adiciona cache

  void _changeState(HomeState newState) {
    _state = newState;
    notifyListeners();
  }

  void _calculateBalance() {
    _totalAmount = 0.0;
    _incomeAmount = 0.0;
    _outcomeAmount = 0.0;

    for (final t in _transactions) {
      _totalAmount += t.value;
      if (t.value >= 0) {
        _incomeAmount += t.value;
      } else {
        _outcomeAmount += t.value;
      }
    }
  }

  Future<void> getAllTransactions({bool forceRefresh = false}) async {
    if (_isCached && !forceRefresh) {
      return; // Se já tem cache e não for atualização manual, não faz nada
    }

    _changeState(HomeStateLoading());
    try {
      _transactions = await _transactionRepository.getAllTransactions();
      _calculateBalance();
      _isCached = true; // Marca que os dados estão no cache
      _changeState(HomeStateSuccess());
    } catch (e) {
      _changeState(HomeStateError());
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    _changeState(HomeStateLoading());
    try {
      await _transactionRepository.addTransaction(transaction);
      _transactions.add(transaction);
      _calculateBalance();
      _isCached = true; // Mantém o cache atualizado
      _changeState(HomeStateSuccess());
    } catch (e) {
      _changeState(HomeStateError());
    }
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    _changeState(HomeStateLoading());
    try {
      await _transactionRepository.deleteTransaction(transaction);
      _transactions.removeWhere((t) => t.id == transaction.id);
      _calculateBalance();
      _isCached = true; // Mantém o cache atualizado
      _changeState(HomeStateSuccess());
    } catch (e) {
      _changeState(HomeStateError());
    }
  }
}
