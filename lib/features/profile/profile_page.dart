import 'package:flutter/material.dart';
import 'package:mps_app/locator.dart';
import 'package:mps_app/services/auth_service.dart';
import 'package:mps_app/services/secure_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> 
  with AutomaticKeepAliveClientMixin<ProfilePage> {
  
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            Text("Profile"),
            TextButton(
              onPressed: () async {
                await locator.get<AuthService>().signOut();
                await const Securestorage().deleteAll();
                if (mounted) {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }
              },
              child: Text("Logout")
            ),
          ],
        ),
      ),
    );
  }
  }