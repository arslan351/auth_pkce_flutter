import 'package:auth_test_project/storage_service.dart';
import 'package:flutter/material.dart';
import 'DashboardPage.dart';
import 'HomePage.dart';
import 'api_client.dart';
import 'auth_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  await ApiClient().init(authService);

  // Check for existing session
  final String? savedToken = await StorageService().getAccessToken();
  final bool isLoggedIn = savedToken != null;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn ;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Test App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoggedIn ? const DashboardPage() : HomePage(),
    );
  }
}




