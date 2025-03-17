import 'package:flutter/material.dart';
import 'package:mps_app/app.dart' as financy_app;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mps_app/common/widgets/multi_text_button.dart';
import 'package:mps_app/common/widgets/primary_button.dart';
import 'package:mps_app/features/onboarding/onboarding_page.dart';
import 'package:mps_app/features/sign_in/sign_in_page.dart';
import 'package:mps_app/features/sign_up/sign_up_page.dart';
import 'package:mps_app/features/splash/splash_page.dart';
import 'package:mps_app/firebase_options.dart';
import 'package:mps_app/locator.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Onboarding Test', (WidgetTester tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    setupDependences();

    await locator.allReady();

    await tester.pumpWidget(const financy_app.App());

    final splashPage = find.byType(SplashPage);
    await tester.pump();
    expect(splashPage, findsOneWidget);

    final onboardingPage = find.byType(OnboardingPage);
    await tester.pumpAndSettle();
    expect(onboardingPage, findsOneWidget);

    final getStartedButton = find.byType(PrimaryButton);
    expect(getStartedButton, findsOneWidget);
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();

    final signUpPage = find.byType(SignUpPage);
    await tester.pumpAndSettle();
    expect(signUpPage, findsOneWidget);

    final multiTextButtonFinder = find.byType(MultiTextButton);
    final scrollableFinder = find.byType(Scrollable).at(0); // Seleciona o primeiro scrollable

    await tester.scrollUntilVisible(
      multiTextButtonFinder,
      50.0,
      scrollable: scrollableFinder,
    );
    await tester.pumpAndSettle();
    expect(multiTextButtonFinder, findsOneWidget);
    await tester.tap(multiTextButtonFinder);
    await tester.pumpAndSettle();


    final signInPage = find.byType(SignInPage);
    await tester.pumpAndSettle();
    expect(signInPage, findsOneWidget);
  });
}