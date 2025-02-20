import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/features/home/home_controller.dart';
import 'package:mps_app/features/transactions/transaction_controller.dart';
import 'package:mps_app/locator.dart';

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
        // Cor do valor (positivo/negativo)
        final color = item.value.isNegative ? AppColors.red : AppColors.green;
        final value = "R\$ ${item.value.toStringAsFixed(2)}";

        return Dismissible(
          key: ValueKey(item.id ?? index),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) async {
            await controller.deleteTransaction(item);
          },
          child: ListTile(
            onTap: () async {
              final result = await Navigator.pushNamed(
                context,
                '/transaction',
                arguments: item,
              );
              if (result != null) {
                locator.get<HomeController>().getAllTransactions();
              }
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            leading: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.monetization_on_outlined),
            ),
            title: Text(
              item.description,
              style: AppTextStyles.mediumText18,
            ),
            subtitle: Text(
              DateTime.fromMillisecondsSinceEpoch(item.date).toString(),
              style: AppTextStyles.smallText,
            ),
            trailing: Text(
              value,
              style: AppTextStyles.mediumText18.apply(color: color),
            ),
          ),
        );
      },
    );
  }
}