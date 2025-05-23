import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/constants/routes.dart';
import 'package:mps_app/common/widgets/custom_text_button.dart';
import 'package:mps_app/common/widgets/primary_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.iceWhite,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 60.0),
            Expanded(
              flex: 2,
              child: Image.asset('assets/images/man.png'),
            ),
            Text(
              'Registre-se já',
              style: AppTextStyles.mediumText.copyWith(
                color: AppColors.greenlightTwo,
              ),
            ),
            Text(
              'E tenha acesso a todas as funcionalidades do app',
              style: AppTextStyles.mediumText.copyWith(
                color: AppColors.greenlightTwo,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0,
              ),
              child: PrimaryButton(
                text: 'Cadastrar-se',
                onPressed: () {
                    Navigator.popAndPushNamed(
                    context,
                    NamedRoute.signUp,
                  );
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
                CustomTextButtonLogIn(),
              ],
            ),
            const SizedBox(height: 14.0),
          ],
        ),
      ),
    );
  }
}