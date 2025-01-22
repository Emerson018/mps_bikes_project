import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/constants/routes.dart';

class CustomTextButtonLogIn extends StatelessWidget {
  const CustomTextButtonLogIn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, NamedRoute.signIn),
      child: Text(
        ' Log in',
        style: AppTextStyles.smallText.copyWith(
          color: AppColors.greenlightTwo,
        ),
      ),
    );
  }
}

class CustomTextButtonSignUp extends StatelessWidget {
  const CustomTextButtonSignUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, NamedRoute.signUp),
      child: Text(
        'SignUp',
        style: AppTextStyles.smallText.copyWith(
          color: AppColors.greenlightTwo,
        ),
      ),
    );
  }
}