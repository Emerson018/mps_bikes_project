import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/constants/routes.dart';
import 'package:mps_app/common/utils/validator.dart';
import 'package:mps_app/common/widgets/custom_bottom_sheet.dart';
import 'package:mps_app/common/widgets/custom_circular_progress_indicator.dart';
import 'package:mps_app/common/widgets/custom_text_button.dart';
import 'package:mps_app/common/widgets/custom_text_form_field.dart';
import 'package:mps_app/common/widgets/multi_text_button.dart';
import 'package:mps_app/common/widgets/password_form_field.dart';
import 'package:mps_app/common/widgets/primary_button.dart';
import 'package:mps_app/features/sign_up/sign_up_controller.dart';
import 'package:mps_app/features/sign_up/sign_up_state.dart';
import 'package:mps_app/locator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _controller = locator.get<SignUpController>();

  @override
  void dispose(){
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if(_controller.state is SignUpLoadingState){
        showDialog(
          context: context,
          builder: (context)=> Center(
            child: CustomCircularProgressIndicator(),
          )
        );
      }
      if(_controller.state is SignUpSuccessState){
        Navigator.pop(context);
        
        Navigator.pushReplacementNamed(context,
          NamedRoute.home,
        );
      }
      if (_controller.state is SignUpErrorState) {
        final error = _controller.state as SignUpErrorState;
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
            'Comece criando a',
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
                  controller: _nameController,
                  labelText: "Nome",
                  hintText: "Johnnie Walker",

                  validator: Validator.validateName,
                ),

                CustomTextFormField(
                  controller: _emailController,
                  labelText: "Seu email",
                  hintText: "exemplo@email.com",
                  validator: Validator.validateEmail,
                ),

                PasswordFormField(
                  controller: _passwordController,
                  labelText: "Escolha sua senha",
                  hintText: "********",
                  validator: Validator.validatePassword,
                  helperText: "A senha deve conter no mínimo 8 caracteres.",
                ),

                PasswordFormField(
                  labelText: "Confirme sua senha",
                  hintText: "********",
                  validator: (value)=> Validator.validateConfirmPassword(
                    value,
                    _passwordController.text),
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
              text: 'Criar Conta',
              onPressed: () {
                final valid = _formKey.currentState != null && _formKey.currentState!.validate();
                if(valid){
                  _controller.signUp(
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                }else {
                }
              },
            ),
          ),

          MultiTextButton(
            onPressed: () => Navigator.popAndPushNamed(
              context,
              NamedRoute.signIn,
            ),
            children: [
              Text(
                'Já possui uma conta? ',
                style: AppTextStyles.smallText.copyWith(
                  color: AppColors.grey,
                ),
              ),
              Text(
                'Entrar ',
                style: AppTextStyles.smallText.copyWith(
                  color: AppColors.greenlightTwo,
                ),
              ),
              
            ],
          ),
        ],
      ),
    );
  }
}