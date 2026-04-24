import 'dart:io';

import 'package:dio/dio.dart';

import '../../app/config/constants.dart';
import '../storage/secure_storage_service.dart';
import 'auth_interceptor.dart';
import 'network_exception.dart';

class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(
          seconds: AppConstants.connectTimeoutSeconds,
        ),
        receiveTimeout: const Duration(
          seconds: AppConstants.receiveTimeoutSeconds,
        ),
        sendTimeout: const Duration(
          seconds: AppConstants.connectTimeoutSeconds,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      AuthInterceptor(
        secureStorage: SecureStorageService.instance,
      ),
    );
  }

  static final ApiClient instance = ApiClient._();

  late final Dio _dio;

  /// Android Emulator : http://10.0.2.2:3000/api
  /// Chrome / Web local : http://localhost:3000/api
  /// Téléphone physique : http://IP_DE_TON_PC:3000/api
  static const String baseUrl = 'http://localhost:3000/api';

  Dio get dio => _dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _handleDioException(error);
    }
  }

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _handleDioException(error);
    }
  }

  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _handleDioException(error);
    }
  }

  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _handleDioException(error);
    }
  }

  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _handleDioException(error);
    }
  }

  NetworkException _handleDioException(DioException error) {
    if (error.error is SocketException) {
      return const NoInternetException();
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const TimeoutNetworkException();

      case DioExceptionType.connectionError:
        return const NoInternetException();

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return const UnknownNetworkException('La requête a été annulée.');

      case DioExceptionType.badCertificate:
        return const UnknownNetworkException(
          'Certificat de sécurité invalide.',
        );

      case DioExceptionType.unknown:
        return const UnknownNetworkException(
          'Une erreur réseau inconnue est survenue.',
        );
    }
  }

  NetworkException _handleBadResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode;
    final message = _extractMessage(response?.data);

    switch (statusCode) {
      case 400:
        return BadRequestException(
          message ?? 'Requête invalide.',
          statusCode: statusCode,
        );

      case 401:
        return UnauthorizedException(
          message ?? 'Session expirée. Veuillez vous reconnecter.',
          statusCode: statusCode,
        );

      case 403:
        return ForbiddenException(
          message ?? 'Vous n’avez pas les droits nécessaires.',
          statusCode: statusCode,
        );

      case 404:
        return NotFoundException(
          message ?? 'Ressource introuvable.',
          statusCode: statusCode,
        );

      case 500:
      case 502:
      case 503:
        return ServerException(
          message ?? 'Erreur serveur. Veuillez réessayer plus tard.',
          statusCode: statusCode,
        );

      default:
        return UnknownNetworkException(
          message ?? 'Erreur réseau inattendue.',
          statusCode: statusCode,
        );
    }
  }

  String? _extractMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      final message = data['message'] ??
          data['error'] ??
          data['detail'] ??
          data['msg'];

      return message?.toString();
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return null;
  }
}