import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DashboardPage.dart';
import 'auth_service.dart';

class HomePage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          // Inside your HomePage ElevatedButton onPressed:
          onPressed: () async {
            final token = await _authService.login();

            if (token != null && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DashboardPage(/*dio: _authService.dio*/),
                ),
              );
            } else {
              // Show a snackbar or alert that login failed
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login failed or cancelled')),
              );
            }
          },


          child: const Text('Login'),
        ),
      ),
    );
  }
}