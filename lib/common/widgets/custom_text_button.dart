import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        print('Log in button pressed');
      },
      child: Text(
        ' Log in',
        style: AppTextStyles.smallText.copyWith(
          color: AppColors.greenlightTwo,
        ),
      ),
    );
  }
}