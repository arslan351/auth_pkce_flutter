import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'DashboardPage.dart';
import 'auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Test App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          // Inside your HomePage ElevatedButton onPressed:

          /*onPressed: () async {
            // 1. Perform login
            try {
              await _authService.login();
            } on PlatformException catch (e) {
              print("ErrorCode: ${e.code}");
              print("ErrorMessage: ${e.message}");
              print("ErrorDetails: ${e.details}"); // This often contains the server's error message
            } catch (e) {
              print("General Error: $e");
            }

            // 2. Navigate to Dashboard, passing the authenticated Dio client
            if (_authService.dio.interceptors.isNotEmpty) {
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DashboardPage(dio: _authService.dio)
                  ),
                );
              }
            }
          },*/

          onPressed: () async {
            final token = await _authService.login();

            if (token != null && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DashboardPage(dio: _authService.dio),
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


