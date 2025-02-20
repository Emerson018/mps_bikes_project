import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_text_style.dart';

import '../constants/app_colors.dart';

enum SnackBarType { success, warning, error, general }

mixin CustomSnackBar<T extends StatefulWidget> on State<T> {
  void showCustomSnackBar({
    required BuildContext context,
    required String text,
    SnackBarType type = SnackBarType.general,
  }) {
    Color setColor() {
      switch (type) {
        case SnackBarType.error:
          return AppColors.red;
        case SnackBarType.success:
          return AppColors.green;
        case SnackBarType.warning:
          return const Color(0xFFFFE100);
        case SnackBarType.general:
          return AppColors.grey;
      }
    }

    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: AppTextStyles.smallText.apply(
            color: AppColors.iceWhite,
          ),
        ),
        backgroundColor: setColor(),
        closeIconColor: AppColors.iceWhite,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}