import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';

class GreetingsWidget extends StatelessWidget {
  const GreetingsWidget({
    super.key,

  });



  @override
  Widget build(BuildContext context) {
    double _textScaleFactor =
      MediaQuery.of(context).size.width < 360 ? 0.7 : 1.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good afternoon,',
          textScaleFactor: _textScaleFactor,
          style: AppTextStyles.smallText
              .apply(color: AppColors.white),
        ),
        Text(
          'Enjelin Morgeana',
          textScaleFactor: _textScaleFactor,
          style: AppTextStyles.mediumText18
              .apply(color: AppColors.white),
        ),
      ],
    );
  }
}