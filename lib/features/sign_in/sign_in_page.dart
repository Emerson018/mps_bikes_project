import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/constants/routes.dart';
import 'package:mps_app/common/utils/validator.dart';
import 'package:mps_app/common/widgets/custom_bottom_sheet.dart';
import 'package:mps_app/common/widgets/custom_circular_progress_indicator.dart';
import 'package:mps_app/common/widgets/custom_text_button.dart';
import 'package:mps_app/common/widgets/custom_text_form_field.dart';
import 'package:mps_app/common/widgets/password_form_field.dart';
import 'package:mps_app/common/widgets/primary_button.dart';
import 'package:mps_app/features/sign_in/sign_in_controller.dart';
import 'package:mps_app/features/sign_in/sign_in_state.dart';
import 'package:mps_app/locator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _controller = locator.get<SignInController>();

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if(_controller.state is SignInStateLoading){
        showDialog(
          context: context,
          builder: (context)=> Center(
            child: CustomCircularProgressIndicator(),
          )
        );
      }
      if(_controller.state is SignInStateSuccess){
        Navigator.pop(context);
        Navigator.pushReplacementNamed(
          context,
          NamedRoute.home);
      }
      if (_controller.state is SignInStateError) {
        final error = _controller.state as SignInStateError;
        Navigator.pop(context);
        customModalBottomSheet(
          context,
          //content: error.message,
          //buttonText: "Tentar novamente.",
          //No video 20 aos 25 min ele mostra essa parte, mas n ta implementada
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text(
            'Bem vindo de volta a',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.greenlightTwo,
            ),
          ),

          Text(
            'sua conta!',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.greenlightTwo,
            ),
          ),

          Image.asset(
            'assets/images/todolist.png',
          ),

          Form(
            key: _formKey,
            child: Column(
              children: [

                CustomTextFormField(
                  controller: _emailController,
                  labelText: "your email",
                  hintText: "john@email.com",
                  validator: Validator.validateEmail,
                ),

                PasswordFormField(
                  controller: _passwordController,
                  labelText: "Sua senha",
                  hintText: "********",
                  validator: Validator.validatePassword,
                  helperText: "A senha deve conter no mínimo 8 caracteres.",
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0,
            ),

            child: PrimaryButton(
              text: 'Logar',
              onPressed: () {
                final valid = _formKey.currentState != null && _formKey.currentState!.validate();
                if(valid){
                  _controller.signIn(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                }else {
                }
              },
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Não possui uma conta?',
                style: AppTextStyles.smallText.copyWith(
                  color: AppColors.grey,
                ),
              ),
              CustomTextButtonSignUp(),
            ],
          ),
        ],
      ),
    );
  }
}