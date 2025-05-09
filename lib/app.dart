import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/routes.dart';
import 'package:mps_app/common/models/transaction_model.dart';
import 'package:mps_app/features/home/homepage_view.dart';
import 'package:mps_app/features/onboarding/onboarding_page.dart';
import 'package:mps_app/features/profile/profile_page.dart';
import 'package:mps_app/features/sign_in/sign_in_page.dart';
import 'package:mps_app/features/sign_up/sign_up_page.dart';
import 'package:mps_app/features/splash/splash_page.dart';
import 'package:mps_app/features/stats/stats_page.dart';
import 'package:mps_app/features/transactions/transaction_page.dart';
import 'package:mps_app/features/wallets/wallet_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: defaultTheme,
      initialRoute: NamedRoute.splash,
      routes: {
        NamedRoute.initial: (context) => const OnboardingPage(),
        NamedRoute.splash: (context) => const SplashPage(),
        NamedRoute.signUp: (context) => const SignUpPage(),
        NamedRoute.signIn: (context) => const SignInPage(),
        NamedRoute.home: (context) => const HomePageView(),
        NamedRoute.stats: (context) => const StatsPage(),
        NamedRoute.wallet: (context) => const WalletPage(),
        NamedRoute.profile: (context) => const ProfilePage(),
        NamedRoute.transaction: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return TransactionPage(
            transaction: args != null ? args as TransactionModel : null,
          );
        }
      },
    );
  }
}