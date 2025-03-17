import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/widgets/app_header.dart';
import 'package:mps_app/common/widgets/custom_circular_progress_indicator.dart';
import 'package:mps_app/features/home/home_controller.dart';
import 'package:mps_app/features/home/home_state.dart';
import 'package:mps_app/features/home/home_widgets/balance_card_widget.dart';
import 'package:mps_app/common/widgets/transaction_list_view.dart';
import 'package:mps_app/locator.dart';

import '../../common/constants/app_colors.dart';
import '../../common/extensions/sizes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double get textScaleFactor =>
      MediaQuery.of(context).size.width < 360 ? 0.7 : 1.0;
  double get iconSize =>
      MediaQuery.of(context).size.width < 360 ? 16.0 : 24.0;

  final controller = locator.get<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.getAllTransactions(); // Agora usa cache e não recarrega sempre
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppHeader(),
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return BalanceCard(
                totalAmount: controller.totalAmount,
                incomeAmount: controller.incomeAmount,
                outcomeAmount: controller.outcomeAmount,
              );
            },
          ),
          Positioned(
            top: 397.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transaction History',
                        style: AppTextStyles.mediumText18,
                      ),
                      TextButton(
                        onPressed: () {
                          controller.getAllTransactions(forceRefresh: true);
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.refresh, size: 18, color: Colors.blue),
                            const SizedBox(width: 5),
                            const Text(
                              'Atualizar',
                              style: AppTextStyles.inputLabelText,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      if (controller.state is HomeStateLoading) {
                        return const CustomCircularProgressIndicator(
                          color: AppColors.green,
                        );
                      }
                      if (controller.state is HomeStateError) {
                        return const Center(
                          child: Text(
                              'Não foi possível carregar os dados.'),
                        );
                      }
                      if (controller.transactions.isEmpty) {
                        return const Center(
                          child: Text(
                              'Não há dados para serem mostrados.'),
                        );
                      }
                      return TransactionListView(
                        controller: controller,
                        transactionList: controller.transactions,
                        onChange: () {},
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
