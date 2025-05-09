import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/widgets/password_form_field.dart';
import 'package:mps_app/features/profile/profile_controller.dart';
import 'package:mps_app/common/utils/validator.dart'; // Onde estiver sua função checkPasswordRequirements

class ProfileChangePasswordWidget extends StatefulWidget {
  final ProfileController profileController;

  const ProfileChangePasswordWidget({
    Key? key,
    required this.profileController,
  }) : super(key: key);

  @override
  State<ProfileChangePasswordWidget> createState() =>
      _ProfileChangePasswordWidgetState();
}

class _ProfileChangePasswordWidgetState
    extends State<ProfileChangePasswordWidget> {
  final TextEditingController _passwordController = TextEditingController();

  /// Lista de requisitos que será atualizada conforme o usuário digita
  List<PasswordRequirement> _requirements = [];

  /// Indica se todos os critérios foram atendidos
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    _passwordController.dispose();
    super.dispose();
  }

  /// Sempre que o texto muda, analisamos os requisitos e atualizamos o estado
  void _onPasswordChanged() {
    final password = _passwordController.text;
    final checked = checkPasswordRequirements(password);

    setState(() {
      _requirements = checked;
      // Botão habilita se TODOS os requisitos estiverem válidos
      isButtonEnabled = checked.every((req) => req.isValid);
    });
  }

  /// Salva a nova senha chamando o método no ProfileController
  Future<void> _saveNewPassword() async {
    if (!isButtonEnabled) return;

    final newPassword = _passwordController.text.trim();
    if (newPassword.isNotEmpty) {
      try {
        await widget.profileController.updateUserPassword(newPassword);
        widget.profileController.onChangePasswordTapped(); // Fecha o widget
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar senha: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('change-password-widget'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alterar Senha',
          style: AppTextStyles.mediumText20.apply(color: AppColors.darkGrey),
        ),
        const SizedBox(height: 24),
        PasswordFormField(
          controller: _passwordController,
          labelText: 'Nova senha',
        ),
        const SizedBox(height: 16),

        // Lista de requisitos: cada item mostra se está OK (verde) ou não (vermelho)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _requirements.map((req) {
            return Row(
              children: [
                Icon(
                  req.isValid ? Icons.check_circle : Icons.cancel,
                  color: req.isValid ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    req.message,
                    style: TextStyle(
                      color: req.isValid ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenlightOne,
              ),
              onPressed: widget.profileController.onChangePasswordTapped,
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonEnabled
                    ? AppColors.greenlightTwo
                    : Colors.grey,
              ),
              onPressed: isButtonEnabled ? _saveNewPassword : null,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ],
    );
  }
}
