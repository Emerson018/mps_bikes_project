import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/extensions/sizes.dart';
import 'package:mps_app/common/widgets/app_header.dart';
import 'package:mps_app/common/widgets/custom_circular_progress_indicator.dart';
import 'package:mps_app/common/widgets/transaction_list_view.dart';
import 'package:mps_app/features/home/home_controller.dart';
import 'package:mps_app/locator.dart';

import 'stats_controller.dart';
import 'stats_state.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage>
    with SingleTickerProviderStateMixin {
  final _statsController = locator.get<StatsController>();
  late final TabController _periodTabController;

  @override
  void initState() {
    super.initState();
    _statsController.getTrasactionsByPeriod();
    _periodTabController = TabController(
      initialIndex: _statsController.selectedPeriod.index,
      length: _statsController.periods.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _periodTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppHeader(),
          Positioned(
            top: 150.h,
            left: 8.w,
            right: 8.w,
            bottom: 0,
            child: Column(
              children: [
                StatefulBuilder(
                  builder: (context, setState) {
                    return TabBar(
                      controller: _periodTabController,
                      onTap: (index) => setState(() {
                        _statsController.getTrasactionsByPeriod(
                            period: StatsPeriod.values[index]);
                      }),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: AppColors.green,
                      ),
                      splashBorderRadius: BorderRadius.circular(8.0),
                      tabs: _statsController.periods
                          .map(
                            (e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                e.name,
                                textAlign: TextAlign.center,
                                style: _statsController.selectedPeriod.name ==
                                        e.name
                                    ? AppTextStyles.smallText13.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                      )
                                    : AppTextStyles.smallText13.copyWith(
                                        color: AppColors.green,
                                      ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 32.0),
                Flexible(
                  child: AnimatedBuilder(
                    animation: _statsController,
                    builder: (context, child) {
                      if (_statsController.state is StatsStateLoading) {
                        return const Center(
                          child: CustomCircularProgressIndicator(
                            color: AppColors.green,
                          ),
                        );
                      }

                      if (_statsController.state is StatsStateSuccess) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 24.0,
                          ),
                          child: LineChart(
                            LineChartData(
                              lineTouchData: LineTouchData(
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipBorder: const BorderSide(
                                    color: AppColors.greenlightOne,
                                  ),
                                  //tooltipBgColor: AppColors.antiFlashWhite,
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((e) {
                                      return LineTooltipItem(
                                        '\$${e.y.toStringAsFixed(2)}',
                                        AppTextStyles.smallText.copyWith(
                                          color: AppColors.greenlightOne,
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                              gridData: const FlGridData(show: false),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    interval: _statsController.interval,
                                    getTitlesWidget: (value, meta) {
                                      String text;

                                      switch (_statsController.selectedPeriod) {
                                        case StatsPeriod.day:
                                          text = '${value.toInt()}h';

                                        case StatsPeriod.week:
                                          text =
                                              _statsController.dayName(value);

                                        case StatsPeriod.month:
                                          text = 'W${(value + 1).toInt()}';

                                        case StatsPeriod.year:
                                          text =
                                              _statsController.monthName(value);
                                      }

                                      return Text(text);
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              minX: _statsController.minX,
                              maxX: _statsController.maxX,
                              minY: _statsController.minY,
                              maxY: _statsController.maxY,
                              lineBarsData: [
                                LineChartBarData(
                                  preventCurveOverShooting: true,
                                  spots: _statsController.valueSpots,
                                  isCurved: true,
                                  barWidth: 2,
                                  color: AppColors.green,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.green.withOpacity(0.20),
                                        AppColors.greenlightOne.withOpacity(0),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Top transações',
                        style: AppTextStyles.mediumText18,
                      ),
                      GestureDetector(
                        onTap: _statsController.sortTransactions,
                        child: const Icon(
                          Icons.sort,
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: AnimatedBuilder(
                      animation: _statsController,
                      builder: (context, child) {
                        if (_statsController.state is StatsStateLoading) {
                          return const Center(
                            child: CustomCircularProgressIndicator(
                              color: AppColors.green,
                            ),
                          );
                        }
                        return TransactionListView(
  controller: locator.get<HomeController>(),
  transactionList: _statsController.transactions,
  onChange: () {
    _statsController.getTrasactionsByPeriod();
  },
);
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}