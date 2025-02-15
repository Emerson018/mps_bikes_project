import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/extensions/sizes.dart';
import 'package:mps_app/features/home/home_widgets/greetings_widget.dart';
import 'package:mps_app/common/widgets/notification_widget.dart';

class AppHeader extends StatefulWidget {
  final String? title;
  final bool hasOptions;

  const AppHeader({
    super.key,
    this.title,
    this.hasOptions = false,
  });
  
  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {  

  Widget get _innerHeader => widget.title != null
    ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            size: 16.0,
            color: AppColors.white,
          ),
        ),
        Text(
          widget.title!,
          style: AppTextStyles.mediumText.apply(
            color: AppColors.white,
          ),
        ),
        widget.hasOptions ? const Icon(
          Icons.more_horiz,
          color: AppColors.white,
        ) : const SizedBox(width: 16.0,),
      ],
    ) 
    : Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        GreetingsWidget(),
        NotificationWidget(),
      ],
    );

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.greenGradient,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(500, 30),
                  bottomRight: Radius.elliptical(500, 30),
                ),
              ),
              height: 287.h,
            ),
          ),
          Positioned(
              left: 24.0,
              right: 24.0,
              top: 74.h,
              child: _innerHeader
            ),
    ],);
  }
}

