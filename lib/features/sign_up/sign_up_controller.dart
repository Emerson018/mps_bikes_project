import 'package:flutter/material.dart';
import 'package:mps_app/features/sign_up/sign_up_state.dart';
import 'package:mps_app/services/auth_service.dart';
import 'package:mps_app/services/secure_storage.dart';

class SignUpController extends ChangeNotifier {
  final AuthService _service;
  final Securestorage _securestorage;

  SignUpController(this._service, this._securestorage);

  SignUpState _state = SignUpInitialState();

  SignUpState get state => _state;

  void _changeState(SignUpState newState){
    _state = newState;
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _changeState(SignUpLoadingState());

    try {
      final user = await _service.signUp(
        name: name,
        email: email,
        password: password,
      );
      if(user.id != null) {
        await _securestorage.write(
          key: "CURRENT_USER",
          value: user.toJson()
        );
        _changeState(SignUpSuccessState());
      }else {
        throw Exception();
      }   
    } catch (e) {
    _changeState(SignUpErrorState(e.toString()));
    }
    
  }
}