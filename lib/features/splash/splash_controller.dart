import 'package:flutter/foundation.dart';
import 'package:mps_app/features/splash/splash_state.dart';
import 'package:mps_app/services/secure_storage.dart';

class SplashController extends ChangeNotifier{
  final Securestorage _service;

  SplashController(this._service);

  SplashState _state = SplashStateInitial();

  SplashState get state => _state;

  void _changeState(SplashState newState) {
    _state = newState;
    notifyListeners();
  }
  void isUserLogged() async{
    await Future.delayed(const Duration(seconds: 1));
    final result = await _service.readOne(key: "CURRENT_USER");
    if (result != null) {
      _changeState(SplashStateSuccess());
    } else{
      _changeState(SplashStateError());
    }
  }
}