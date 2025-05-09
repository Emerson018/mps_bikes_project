import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mps_app/features/home/homepage.dart';
import 'package:mps_app/features/wallets/wallet_page.dart';
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
  },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomAppBar(
        selectedItemColor: AppColors.greenlightOne,
        children: [
          CustomBottomAppBarItem(
            label: 'Página Inicial',
            primaryIcon: Icons.home,
            secondaryIcon: Icons.home_outlined,
            onPressed: () => pageController.jumpToPage(
              0,
            ),
          ),
          CustomBottomAppBarItem(
            label: 'Estatísticas',
            primaryIcon: Icons.analytics,
            secondaryIcon: Icons.analytics_outlined,
            onPressed: () => pageController.jumpToPage(
              1,
            ),
          ),
          CustomBottomAppBarItem.empty(),
          CustomBottomAppBarItem(
            label: 'Carteira',
            primaryIcon: Icons.account_balance_wallet,
            secondaryIcon: Icons.account_balance_wallet_outlined,
            onPressed: () => pageController.jumpToPage(
              2,
            ),
          ),
          CustomBottomAppBarItem(
            label: 'Perfil',
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