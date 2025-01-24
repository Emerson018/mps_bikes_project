import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/constants/routes.dart';
import 'package:mps_app/common/widgets/custom_circular_progress_indicator.dart';
import 'package:mps_app/features/splash/splash_controller.dart';
import 'package:mps_app/features/splash/splash_state.dart';
import 'package:mps_app/locator.dart';
import 'package:mps_app/services/secure_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _splashController = locator.get<SplashController>();

  @override
  void initState() {
    super.initState();
    _splashController.isUserLogged();
    _splashController.addListener(() {
      if(_splashController.state is SplashStateSuccess){

      } else{
        
      }
    });
  }

  @override
  void dispose() {
    _splashController.dispose();
    super.dispose();
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