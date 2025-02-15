import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/widgets/app_header.dart';
import 'package:mps_app/common/widgets/custom_circular_progress_indicator.dart';
import 'package:mps_app/features/home/home_controller.dart';
import 'package:mps_app/features/home/home_state.dart';
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
  double get iconSize => MediaQuery.of(context).size.width < 360 ? 16.0 : 24.0;

  final controller = locator.get<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.getAllTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppHeader(),
          Positioned(
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Balance',
                            textScaleFactor: textScaleFactor,
                            style: AppTextStyles.mediumText18
                                .apply(color: AppColors.white),
                          ),
                          Text(
                            '\$ 1,556.00',
                            textScaleFactor: textScaleFactor,
                            style: AppTextStyles.mediumText18
                                .apply(color: AppColors.white),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () => log('options'),
                        child: PopupMenuButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(
                              Icons.more_horiz,
                              color: AppColors.white,
                            ),
                            itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    height: 24.0,
                                    child: Text("Item 1"),
                                  ),
                                ]),
                      ),
                    ],
                  ),
                  SizedBox(height: 36.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.06),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_downward,
                              color: AppColors.white,
                              size: iconSize,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Income',
                                textScaleFactor: textScaleFactor,
                                style: AppTextStyles.mediumText18
                                    .apply(color: AppColors.white),
                              ),
                              Text(
                                '\$ 1,840.00',
                                textScaleFactor: textScaleFactor,
                                style: AppTextStyles.mediumText18
                                    .apply(color: AppColors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.06),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_upward,
                              color: AppColors.white,
                              size: iconSize,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expenses',
                                textScaleFactor: textScaleFactor,
                                style: AppTextStyles.mediumText18
                                    .apply(color: AppColors.white),
                              ),
                              Text(
                                '\$ 2,824.00',
                                textScaleFactor: textScaleFactor,
                                style: AppTextStyles.mediumText18
                                    .apply(color: AppColors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                    children: const [
                      Text(
                        'Transaction History',
                        style: AppTextStyles.mediumText18, //PAREI AQUI, FALTA OS DE CIMA 
                      ),
                      Text(
                        'See all',
                        style: AppTextStyles.inputLabelText,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      if(controller.state is HomeStateLoading) {
                        return const CustomCircularProgressIndicator(
                          color: AppColors.green,
                        );
                      }
                      if(controller.state is HomeStateError) { 
                        return Center(
                          child: Text(
                            'Não foi possível carregar os dados.'
                          ),
                        );
                      }
                      if(controller.transactions.isEmpty) {
                        return const Center(
                          child: Text(
                            'Não há dados para serem mostrados.'
                          ),
                        );
                      }
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: controller.transactions.length,
                        itemBuilder: (context, index) {

                          final item = controller.transactions[index];

                          final color = item.value.isNegative
                            ? AppColors.green
                            : AppColors.red;
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