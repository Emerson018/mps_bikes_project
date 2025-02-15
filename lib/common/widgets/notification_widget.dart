import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/extensions/sizes.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 8.w,
      ),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(4.0)),
        color: AppColors.white.withOpacity(0.06),
      ),
      child: Stack(
        alignment: const AlignmentDirectional(0.5, -0.5),
        children: [
          const Icon(
            Icons.notifications_none_outlined,
            color: AppColors.white,
          ),
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A310),
              borderRadius: BorderRadius.circular(
                4.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}