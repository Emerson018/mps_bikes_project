import 'package:flutter/foundation.dart';
import 'package:mps_app/common/models/user_model.dart';
import 'profile_state.dart';

class ProfileController extends ChangeNotifier {
  /// Serviço para lidar com os dados do usuário (no seu caso,
  /// é o TransactionRepository, conforme o locator)
  final dynamic _userDataService;
  void onChangeNameTapped() => toggleChangeName();
  void onChangePasswordTapped() => toggleChangePassword();
  


  ProfileController({required userDataService})
      : _userDataService = userDataService;

  ProfileState _state = ProfileStateInitial();
  ProfileState get state => _state;

  UserModel get userData => _userDataService.userData;

  bool _reauthRequired = false;
  bool get reauthRequired => _reauthRequired;

  bool _showUpdatedNameMessage = false;
  bool get showNameUpdateMessage =>
      _showUpdatedNameMessage && state is ProfileStateSuccess;

  bool _showUpdatedPasswordMessage = false;
  bool get showPasswordUpdateMessage =>
      _showUpdatedPasswordMessage && state is ProfileStateSuccess;

  bool _showChangeName = false;
  bool get showChangeName => _showChangeName;

  bool _showChangePassword = false;
  bool get showChangePassword => _showChangePassword;

  bool _enabledButton = false;
  bool get enabledButton => _enabledButton;

  bool get canSave => enabledButton && state is! ProfileStateLoading;

  bool isButtonEnabled = false;

  void _changeState(ProfileState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Alterna a exibição do widget de alteração de nome.
  void toggleChangeName() {
    _showChangeName = !_showChangeName;
    _changeState(ProfileStateInitial());
  }

  /// Alterna a exibição do widget de alteração de senha.
  void toggleChangePassword() {
    _showChangePassword = !_showChangePassword;
    _changeState(ProfileStateInitial());
  }

  /// Atualiza o estado do botão (habilitado/desabilitado).
  void toggleButtonTap(bool enabled) {
    isButtonEnabled = enabled;
    notifyListeners();
  }

  /// Busca os dados do usuário.
  Future<void> getUserData() async {
    _changeState(ProfileStateLoading());
    try {
      final data = await _userDataService.getUserData();
      _changeState(ProfileStateSuccess(user: data));
    } catch (e) {
      _changeState(ProfileStateError(message: e.toString()));
    }
  }

  /// Atualiza o nome do usuário.
  Future<void> updateUserName(String newUserName) async {
    _changeState(ProfileStateLoading());
    try {
      await _userDataService.updateUserName(newUserName);
      _showUpdatedNameMessage = true;
      _showUpdatedPasswordMessage = false;
      // Esconde o widget de alteração de nome
      _showChangeName = false;
      // Desabilita o botão de salvar
      _enabledButton = false;
      _changeState(ProfileStateSuccess());
    } catch (e) {
      _changeState(ProfileStateError(message: e.toString()));
    }
  }

  /// Atualiza a senha do usuário.
  Future<void> updateUserPassword(String newPassword) async {
  _changeState(ProfileStateLoading());
  try {
    // Chame o método que você adicionou no TransactionRepositoryImpl
    await _userDataService.updateUserPassword(newPassword);

    _showUpdatedPasswordMessage = true;
    _showUpdatedNameMessage = false;
    // Fecha o widget de troca de senha
    _showChangePassword = false;
    // Desabilita o botão
    _enabledButton = false;
    _changeState(ProfileStateSuccess());
  } catch (e) {
    _reauthRequired = true;
    _changeState(ProfileStateError(message: e.toString()));
  }
}

  /// Exclui a conta do usuário.
  Future<void> deleteAccount() async {
    _changeState(ProfileStateLoading());
    try {
      await _userDataService.deleteAccount();
      _changeState(ProfileStateSuccess());
    } catch (e) {
      _changeState(ProfileStateError(message: e.toString()));
    }
  }
}
