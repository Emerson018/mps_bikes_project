import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import '../../../common/constants/app_colors.dart';
import '../../../common/extensions/sizes.dart';
class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.totalAmount,
    required this.incomeAmount,
    required this.outcomeAmount,
  });
  final double totalAmount;
  final double incomeAmount;
  final double outcomeAmount;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 24.w,
      right: 24.w,
      top: 155.h,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 32.h,
        ),
        decoration: const BoxDecoration(
          color: AppColors.greenlightTwo,
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded( // Garante que o texto não ultrapasse a tela
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: AppTextStyles.mediumText18.apply(color: AppColors.white),
          ),
          Text(
            '\$${totalAmount.toStringAsFixed(2)}',
            style: AppTextStyles.mediumText18.apply(color: AppColors.white),
            overflow: TextOverflow.ellipsis, // Evita que o texto estoure a tela
          ),
        ],
      ),
    ),
    PopupMenuButton( // Não ocupa espaço extra
      padding: EdgeInsets.zero,
      child: const Icon(Icons.more_horiz, color: AppColors.white),
      itemBuilder: (context) => [
        const PopupMenuItem(
          height: 24.0,
          child: Text("Item 1"),
        ),
      ],
    ),
  ],
),

            SizedBox(height: 36.h),
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(child: TransactionValueWidget(amount: incomeAmount)),
    Expanded(child: TransactionValueWidget(amount: outcomeAmount)),
  ],
),


          ],
        ),
      ),
    );
  }
}
class TransactionValueWidget extends StatelessWidget {
  const TransactionValueWidget({
    super.key,
    required this.amount,
  });
  final double amount;
  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width <= 360 ? 16.0 : 24.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(
              alpha: 210,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          child: Icon(
            amount.isNegative ? Icons.arrow_downward : Icons.arrow_upward,
            color: AppColors.white,
            size: iconSize,
          ),
        ),
        const SizedBox(width: 4.0),
        Flexible( // Adicionando flexibilidade
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            amount.isNegative ? 'Expense' : 'Income',
            style: AppTextStyles.mediumText18.apply(color: AppColors.white),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 100.0.w), // Limitar largura
            child: Text(
                '\$${amount.toStringAsFixed(2)}',
                style: AppTextStyles.smallText.apply(color: AppColors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      ],
    );
  }
}