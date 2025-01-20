import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
            AppColors.greenlightOne,
            AppColors.greenlightTwo,
            ]
          )
        ),
        child: Text(
          'Eae man',
          style: AppTextStyles.bigText.copyWith(color: AppColors.white)
        ),
      ),
    );
  }
}