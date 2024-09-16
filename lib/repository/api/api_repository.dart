import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/models/hospital.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';

class ApiRepository {
  static final ApiRepository _instance = ApiRepository._internal();

  factory ApiRepository() {
    return _instance;
  }

  ApiRepository._internal() {
    configureDio();
  }

  final Dio dio = Dio();

  static const String _baseUrl =
      'https://ror-django-backend-7pxm.onrender.com/api/';
  static const String _patientLogin = 'users/patient/login';
  static const String _doctorLogin = 'doctor/login';
  static const String _patientRegister = 'users/patient/register';
  static const String _doctorRegister = 'doctor/register';
  static const String _checkNavigation = 'classify/v1/check-navigation/';
  static const String _getDoctors = 'users/get-doctors';
  static const String _updateProfile = 'users/update-profile/?id=';
  static const String _chatBot = 'classify/v1/medical-chatbot/?id=';
  static const String _textToVoice = 'classify/v1/text-voice-generator/';
  static const String _predict =
      'https://invisible-fredrika-koyeb-cibiyanna-organization-af4ed798.koyeb.app/predict';
  static const String _getNearbyHospitals = 'users/nearby-hospital/?id=';

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
      Map<String, dynamic> doctorData) async {
    try {
      final response = await dio.post(_doctorLogin, data: doctorData);
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

  Future<List<Doctor>> getDoctors() async {
    try {
      final response = await dio.get(_getDoctors);
      final List<Doctor> doctors = [];
      for (final doctor in response.data) {
        doctors.add(Doctor.fromJson(doctor));
      }
      log('Doctors: $doctors');
      return doctors;
    } on DioException catch (e) {
      _handleDioError(e);
      throw Exception('Failed to load doctors');
    }
  }

  Future<List<Hospital>> getNearbyHospitals() async {
    try {
      final SharedPreferencesHelper prefs = SharedPreferencesHelper();
      final phoneNumber = await prefs.getString('phoneNumber');
      final response = await dio
          .get('$_getNearbyHospitals${phoneNumber!}&user_role=patient');
      final List<Hospital> hospitals = [];
      for (final hospital in response.data["hospitals"]) {
        hospitals.add(Hospital.fromJson(hospital));
      }
      log('Hospitals: $hospitals');
      return hospitals;
    } on DioException catch (e) {
      _handleDioError(e);
      throw Exception('Failed to load doctors');
    }
  }

  Future<Map<String, dynamic>> getDoctorBasedOnSpecialization(
      String specialization) async {
    try {
      final response =
          await dio.post('$_getDoctors?specialization=$specialization');
      return response.data;
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> profileData) async {
    try {
      final SharedPreferencesHelper prefs = SharedPreferencesHelper();
      final phoneNumber = await prefs.getString('phoneNumber');
      final response = await dio.patch(
          "$_updateProfile$phoneNumber&user_role=patient",
          data: profileData);
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

  Future<Map<String, dynamic>> chatbot(Map<String, dynamic> chatBotData) async {
    try {
      final SharedPreferencesHelper prefs = SharedPreferencesHelper();
      final phoneNumber = await prefs.getString('phoneNumber');
      final response =
          await dio.post(_chatBot + phoneNumber!, data: chatBotData);
      return response.data;
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> textToVoice(
      Map<String, dynamic> textToVoiceData) async {
    try {
      final response = await dio.post(_textToVoice, data: textToVoiceData);
      return response.data;
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> predict(FormData predictData) async {
    try {
      final response = await dio.post(_predict, data: predictData);
      return response.data;
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Map<String, dynamic> _handleDioError(DioException e) {
    if (e.response != null) {
      log('Dio error!');
      log('STATUS: ${e.response?.statusCode}');
      log('DATA: ${e.response?.data}');
      log('HEADERS: ${e.response?.headers}');
      return {
        'error': true,
        'message':
            'Error ${e.response?.statusCode}: ${e.response?.statusMessage}',
        'data': e.response?.data
      };
    } else {
      log('Error sending request!');
      log(e.message.toString());
      return {
        'error': true,
        'message': e.message ?? 'An unknown error occurred',
      };
    }
  }
}
