import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../signin_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({Key? key}) : super(key: key);

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        // backgroundColor: Theme.of(context).cardColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).cardColor,
            ],
            center: const Alignment(0.0, 0.0),
            radius: 1.5,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _authService.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (contex) => SigninScreen()));
              },
              style: Theme.of(context).elevatedButtonTheme.style,
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
