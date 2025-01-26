import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/routes.dart';
import 'package:mps_app/services/secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _secureStorage = const Securestorage();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Nova Tela"),
            ElevatedButton(
              onPressed: () {
                _secureStorage.deleteOne(
                  key: "CURRENT_USER"
                ).then(
                    (_) => Navigator.popAndPushNamed(
                      context,
                      NamedRoute.initial
                    ),
                );
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}