import 'package:dio/dio.dart';

class ApiRepository {
  static final ApiRepository _instance = ApiRepository._internal();

  factory ApiRepository() {
    return _instance;
  }

  ApiRepository._internal() {
    configureDio();
  }

  final Dio dio = Dio();

  static const String _iP = '172.17.12.83';
  static const String _baseUrl = 'http://$_iP:8000/api';
  static const String _patientLogin = '/users/patient/login';
  static const String _doctorLogin = '/doctor/login/';
  static const String _patientRegister = '/users/patient/register';
  static const String _doctorRegister = '/doctor/register/';
  static const String _checkNavigation = '/classify/v1/check-navigation/';
  static const String _texttoText = '/classify/v1/text-voice-generator/';

  void configureDio() {
    dio.options.baseUrl = _baseUrl;
  }

  Future<Map<String, dynamic>> patientLogin(
      Map<String, dynamic> patientData) async {
    try {
      final response = await dio.post(_patientLogin, data: patientData);
      return response.data;
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> doctorLogin(
      String email, String password) async {
    try {
      final response = await dio.post(_doctorLogin, data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> patientRegister(
      Map<String, dynamic> patientData) async {
    try {
      final response = await dio.post(_patientRegister, data: patientData);
      return response.data;
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> doctorRegister(
      Map<String, dynamic> doctorData) async {
    try {
      final response = await dio.post(_doctorRegister, data: doctorData);
      return response.data;
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> checkNavigation(
      Map<String, dynamic> navigationData) async {
    try {
      final response = await dio.post(_checkNavigation, data: navigationData);
      return response.data;
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> textToText(String text) async {
    try {
      final response = await dio.post(_texttoText, data: {'text': text});
      return response.data;
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Map<String, dynamic> _handleDioError(DioException e) {
    if (e.response != null) {
      print('Dio error!');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('HEADERS: ${e.response?.headers}');
      return {
        'error': true,
        'message':
            'Error ${e.response?.statusCode}: ${e.response?.statusMessage}',
        'data': e.response?.data
      };
    } else {
      print('Error sending request!');
      print(e.message);
      return {
        'error': true,
        'message': e.message ?? 'An unknown error occurred',
      };
    }
  }
}
