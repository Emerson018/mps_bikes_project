import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mps_app/common/models/transaction_model.dart';
import 'package:mps_app/features/home/homepage.dart';
import 'package:mps_app/features/wallets/wallet_page.dart';
import 'package:mps_app/locator.dart';
import 'package:mps_app/repositories/transaction_repository.dart';
import '../../common/constants/app_colors.dart';
import '../../common/widgets/custom_bottom_app_bar.dart';
import '../profile/profile_page.dart';
import '../stats/stats_page.dart';
import '../../common/constants/routes.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});
  @override
  State<HomePageView> createState() => _HomePageViewState();
}
class _HomePageViewState extends State<HomePageView> {
  final pageController = PageController();
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      log(pageController.page.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [
          HomePage(),
          StatsPage(),
          WalletPage(),
          ProfilePage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.greenlightOne,
        onPressed: () {
    Navigator.pushNamed(context, NamedRoute.transaction);
  },/* TODO começo do hard coded */ /*async{
           final transaction = TransactionModel(
          description: 'Compra Online',
          value: 2850.50,
          date: DateTime.now().millisecondsSinceEpoch,
        );
        await locator.get<TransactionRepository>().addTransaction(transaction);
        }, /* final do hard coded */ */
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomAppBar(
        selectedItemColor: AppColors.greenlightOne,
        children: [
          CustomBottomAppBarItem(
            label: 'home',
            primaryIcon: Icons.home,
            secondaryIcon: Icons.home_outlined,
            onPressed: () => pageController.jumpToPage(
              0,
            ),
          ),
          CustomBottomAppBarItem(
            label: 'stats',
            primaryIcon: Icons.analytics,
            secondaryIcon: Icons.analytics_outlined,
            onPressed: () => pageController.jumpToPage(
              1,
            ),
          ),
          CustomBottomAppBarItem.empty(),
          CustomBottomAppBarItem(
            label: 'wallet',
            primaryIcon: Icons.account_balance_wallet,
            secondaryIcon: Icons.account_balance_wallet_outlined,
            onPressed: () => pageController.jumpToPage(
              2,
            ),
          ),
          CustomBottomAppBarItem(
            label: 'profile',
            primaryIcon: Icons.person,
            secondaryIcon: Icons.person_outline,
            onPressed: () => pageController.jumpToPage(
              3,
            ),
          ),
        ],
      ),
    );
  }
}