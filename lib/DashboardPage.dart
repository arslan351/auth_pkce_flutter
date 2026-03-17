import 'package:auth_test_project/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'api_client.dart';

class DashboardPage extends StatefulWidget {
  //final Dio dio; // We pass the authenticated Dio instance

  const DashboardPage({super.key, /*required this.dio*/});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiClient _apiClient = ApiClient();

  String _data = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchProtectedData();
  }
  /*
  Future<void> _fetchProtectedData() async {
    try {
      // Because we added the interceptor in AuthService,
      // this request automatically includes the Bearer Token!

      final response = await _apiClient.dio.get('http://192.168.73.169:7080/mobile/core/api/v1/students/profile');
      setState(() {
        _data = response.data.toString();
      });
    } on DioException catch (e) {
      print('Dio Error Type: ${e.type}');
      print('Response status code: ${e.response?.statusCode}');
      print('Response headers: ${e.response?.headers}');
      print('Response data: ${e.response?.data}');
      print('Request headers: ${e.requestOptions.headers}');

      setState(() {
        _data = "API call error: ${e.message}\nStatus: ${e.response?.statusCode}";
      });
    } catch (e) {
      print('Generic Error: $e');
      setState(() {
        _data = "API call error: $e";
      });
    }
  }
  */

  Future<void> _fetchProtectedData() async {
    try {
      // Just make the call. The interceptor handles the "Bearer" header automatically!
      final response = await _apiClient.dio.get('http://192.168.73.169:7080/mobile/core/api/v1/students/profile');
      setState(() => _data = response.data.toString());
    } catch (e) {
      print("+++++++++++++++++");
      print (e);
      print("+++++++++++++++++");
      setState(() => _data = "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          //child: Text("Data from API: $_data"),
          child: Text("Data from api : $_data"),
        ),
      ),
    );
  }
}