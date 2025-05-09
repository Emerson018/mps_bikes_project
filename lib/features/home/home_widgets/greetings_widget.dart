import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/features/profile/profile_controller.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';

class GreetingsWidget extends StatelessWidget {
  const GreetingsWidget({
    super.key,

  });



  @override
  Widget build(BuildContext context) {
    final profileController = locator.get<ProfileController>();
    final userName = profileController.userData.name ?? 'sem nome';

    double _textScaleFactor =
      MediaQuery.of(context).size.width < 360 ? 0.7 : 1.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seja bem vindo,',
          textScaleFactor: _textScaleFactor,
          style: AppTextStyles.smallText
              .apply(color: AppColors.white),
        ),
        Text(
          userName,
          textScaleFactor: _textScaleFactor,
          style: AppTextStyles.mediumText18
              .apply(color: AppColors.white),
        ),
      ],
    );
  }
}