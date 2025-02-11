import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mps_app/firebase_options.dart';
import 'package:mps_app/locator.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    FirebaseFunctions.instance;
    print('Plugin cloud_functions registrado com sucesso!');
  } on MissingPluginException catch (e) {
    print('Erro: Plugin cloud_functions não registrado. Detalhes: $e');
  }
  setupDependences();
  runApp(const App());
}
//CONTA DE TESTE
// EMAIL: emersonlima.018@hotmail.com
// SENHA: MPs!bikes018
//testar otruso erros: https://chatgpt.com/c/679fd23c-e9bc-8009-8b04-33d1948521a8