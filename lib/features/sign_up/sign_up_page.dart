import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/utils/validator.dart';
import 'package:mps_app/common/widgets/custom_text_button.dart';
import 'package:mps_app/common/widgets/custom_text_form_field.dart';
import 'package:mps_app/common/widgets/password_form_field.dart';
import 'package:mps_app/common/widgets/primary_button.dart';
import 'package:mps_app/features/sign_up/sign_up_controller.dart';
import 'package:mps_app/features/sign_up/sign_up_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _controller = SignUpController();

  @override
  void dispose(){
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
            child: CircularProgressIndicator(),
          )
        );
      }
      if(_controller.state is SignUpSuccessState){
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)=> const Scaffold(
              body: Center(
                child: Text("Nova Tela"),
              ),
            ),
          ),
        );
      }
      if(_controller.state is SignUpErrorState){
        showDialog(
          context: context,
          builder: (context) => SizedBox(
            height: 150.0,
            child: Text("Erro ao logar. Tente Novamente."),
          )
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
                  labelText: "Nome",
                  hintText: "Elon Musk",

                  validator: Validator.validateName,
                ),

                CustomTextFormField(
                  labelText: "your email",
                  hintText: "john@email.com",
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
                  _controller.doSignUp();
                }else {
                  print("erro ao logar!");
                }
              },
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Já possui uma conta?',
                style: AppTextStyles.smallText.copyWith(
                  color: AppColors.grey,
                ),
              ),
              CustomTextButton(),
            ],
          ),
        ],
      ),
    );
  }

  
}