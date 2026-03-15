import 'package:auth_test_project/pkce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String codeVerifier;
  late String authUrl;
  final String redirectUri = 'myapp://auth/callback';

  @override
  void initState() {
    super.initState();
    // 1. Générer les codes PKCE
    codeVerifier = generateCodeVerifier();
    String codeChallenge = generateCodeChallenge(codeVerifier);

    // 2. Construire l'URL avec le Challenge
    authUrl = 'http://192.168.73.169:8080/auth/oauth2/authorize'
        '?response_type=code'
        '&client_id=djezzy-student-campuce-mobile'
        '&redirect_uri=${Uri.encodeComponent(redirectUri)}'
        '&scope=openid'
        '&code_challenge=$codeChallenge'
        '&code_challenge_method=S256';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(authUrl)),
        onLoadStart: (controller, url) async {
          if (url != null && url.toString().startsWith(redirectUri)) {
            final code = url.queryParameters['code'];
            if (code != null) {
              // 3. Retourner le code ET le verifier (indispensable pour l'étape suivante)
              Navigator.of(context).pop({'code': code, 'verifier': codeVerifier});
            }
          }
        },
        // ADD THIS PART TO PREVENT THE 404:
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var uri = navigationAction.request.url;

          if (uri != null && uri.toString().startsWith(redirectUri)) {
            // Tell the WebView: "Stop! Don't actually try to load this fake URL"
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }
}