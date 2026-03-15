import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Add this
import 'login_page.dart';

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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // 1. Wait for the result from LoginPage
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );

            // 2. Check if we got the Map {'code': ..., 'verifier': ...}
            if (result != null && result is Map) {
              final String code = result['code'];
              final String verifier = result['verifier'];

              print('Step 1 Success! Code: $code');

              // 3. Use Dio to exchange that code for a Token
              final dio = Dio();

              try {
                final response = await dio.post(
                  'http://192.168.73.169:8080/auth/oauth2/token',
                  data: {
                    'grant_type': 'authorization_code',
                    'client_id': 'djezzy-student-campuce-mobile',
                    'code': code,
                    'redirect_uri': 'myapp://auth/callback',
                    'code_verifier': verifier,
                  },
                  options: Options(
                    contentType: Headers.formUrlEncodedContentType,
                  ),
                );

                if (response.statusCode == 200) {
                  // Dio parses the JSON automatically
                  final accessToken = response.data['access_token'];

                  print("----------------------");
                  print('SUCCESS! Token received: $accessToken');
                  print("----------------------");
                }
              } on DioException catch (e) {
                print("----------------------");
                print('Token Exchange Error: ${e.response?.data ?? e.message}');
                print("----------------------");
              }
            }
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}