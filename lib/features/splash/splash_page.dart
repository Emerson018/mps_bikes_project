import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/constants/routes.dart';
import 'package:mps_app/common/widgets/custom_circular_progress_indicator.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    init();
  }

  Timer init(){
    return Timer(
      const Duration(seconds: 2),
      navigateToOnboarding,
    );
  }

  void navigateToOnboarding(){
    Navigator.pushReplacementNamed(
      context,
      NamedRoute.initial
    );
  }

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Eae man',
              style: AppTextStyles.bigText.copyWith(color: AppColors.white)
            ),
            CustomCircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}