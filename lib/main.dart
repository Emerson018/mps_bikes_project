import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mps_app/firebase_options.dart';
import 'package:mps_app/locator.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  setupDependences();
  runApp(const App());
}
//CONTA DE TESTE
// EMAIL: emersonlima.018@hotmail.com
// SENHA: MPs!bikes018