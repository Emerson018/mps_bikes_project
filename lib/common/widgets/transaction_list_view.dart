import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/features/home/home_controller.dart';

class TransactionListView extends StatelessWidget {
  const TransactionListView({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: controller.transactions.length,
      itemBuilder: (context, index) {
    
        final item = controller.transactions[index];
    
        final color = item.value.isNegative
          ? AppColors.red
          : AppColors.green;
        final value =
            "\$ ${item.value.toStringAsFixed(2)}";
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8.0),
          leading: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius:
                  BorderRadius.all(Radius.circular(8.0)),
            ),
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.monetization_on_outlined,
            ),
          ),
          title: Text(
            item.title,
            style: AppTextStyles.mediumText18,
          ),
          subtitle: Text(
            DateTime.fromMillisecondsSinceEpoch(
              item.date).toString(),                            
            style: AppTextStyles.smallText,
          ),
          trailing: Text(
            value,
            style: AppTextStyles.mediumText18.apply(color: color),
          ),
        );
      },
    );
  }
}