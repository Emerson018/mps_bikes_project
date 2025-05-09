import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/widgets/app_header.dart';
import 'package:mps_app/common/widgets/custom_circular_progress_indicator.dart';
import 'package:mps_app/locator.dart';
import 'wallet_controller.dart';
import 'wallet_state.dart';
import 'package:fl_chart/fl_chart.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);
  
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final controller = locator.get<WalletController>();
  
  @override
  void initState() {
    super.initState();
    controller.fetchWalletData();
  }
  
  Widget _buildTimeFrameButton(String label, TimeFrame timeFrame) {
    bool isSelected = controller.selectedTimeFrame == timeFrame;
    return TextButton(
      onPressed: () => controller.updateTimeFrame(timeFrame),
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : AppColors.green, backgroundColor: isSelected ? AppColors.green : Colors.transparent,
      ),
      child: Text(label),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppHeader(),
          
          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                if (controller.state is WalletStateLoading) {
                  return Center(
                    child: CustomCircularProgressIndicator(color: AppColors.green),
                  );
                }
                if (controller.state is WalletStateError) {
                  final errorState = controller.state as WalletStateError;
                  return Center(
                    child: Text(
                      'Erro: ${errorState.message}',
                      style: AppTextStyles.mediumText18,
                    ),
                  );
                }
                if (controller.state is WalletStateSuccess) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Filtros de intervalo de tempo
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildTimeFrameButton('1D', TimeFrame.oneDay),
                              _buildTimeFrameButton('5D', TimeFrame.fiveDays),
                              _buildTimeFrameButton('1M', TimeFrame.oneMonth),
                              _buildTimeFrameButton('6M', TimeFrame.sixMonths),
                              _buildTimeFrameButton('1Y', TimeFrame.oneYear),
                              _buildTimeFrameButton('5Y', TimeFrame.fiveYears),
                            ],
                          ),
                        ),
                        // Exibição dos dados para NVDA
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('NVDC34', style: AppTextStyles.mediumText18),
                              const SizedBox(height: 8),
                              Text(
                                'Valor Atual: R\$ ${controller.stockPrice.toStringAsFixed(2)}',
                                style: AppTextStyles.mediumText,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    controller.stockChange >= 0
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: controller.stockChange >= 0 ? Colors.green : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${controller.stockChange >= 0 ? '+' : ''}${controller.stockChange.toStringAsFixed(2)}%',
                                    style: AppTextStyles.mediumText,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 200,
                                child: LineChart(
                                  LineChartData(
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: controller.stockGraphData
                                            .asMap()
                                            .entries
                                            .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                                            .toList(),
                                        isCurved: true,
                                        barWidth: 2,
                                        color: AppColors.green,
                                        dotData: FlDotData(show: false),
                                      ),
                                    ],
                                    titlesData: FlTitlesData(show: false),
                                    borderData: FlBorderData(show: false),
                                    gridData: FlGridData(show: false),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        // Exibição dos dados para Bitcoin
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bitcoin', style: AppTextStyles.mediumText18),
                              const SizedBox(height: 8),
                              Text(
                                'Valor Atual: US\$ ${controller.bitcoinPrice.toStringAsFixed(2)}',
                                style: AppTextStyles.mediumText,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    controller.bitcoinChange >= 0
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: controller.bitcoinChange >= 0 ? Colors.green : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${controller.bitcoinChange >= 0 ? '+' : ''}${controller.bitcoinChange.toStringAsFixed(2)}%',
                                    style: AppTextStyles.mediumText,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 200,
                                child: LineChart(
                                  LineChartData(
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: controller.bitcoinGraphData
                                            .asMap()
                                            .entries
                                            .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                                            .toList(),
                                        isCurved: true,
                                        barWidth: 2,
                                        color: AppColors.green,
                                        dotData: FlDotData(show: false),
                                      ),
                                    ],
                                    titlesData: FlTitlesData(show: true),
                                    borderData: FlBorderData(show: true),
                                    gridData: FlGridData(show: false),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
