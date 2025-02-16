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
//CONTA DE TESTE NO FIREBASE:
// EMAIL: emersonlima.018@hotmail.com
// SENHA: MPs!bikes018

//CONTAA DE TESTE FIREBASE E FIRESTORE:
//EMAIL: firestoreteste@gmail.com
//SENHA: Asdfg@2345

//algumas refatoraçoes foram feitas aos 2:00 desse video,
//mas eu não implementei: https://www.youtube.com/watch?v=aKFVTsUyevM&list=PLtlg0Apoubs_xVS8QxIX51zl0iucEcKyK&index=37

//perguntar em como nao usar o hardcoded nos valores da homepage.dart