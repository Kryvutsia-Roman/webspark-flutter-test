import 'package:dio/dio.dart';

/// Network client wrapper using Dio for handling HTTP GET and POST requests.
class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio}) : _dio = dio ?? Dio();

  /// Executes a GET request to [url].
  ///
  /// [url] accepts a dynamic base URL provided at runtime.
  Future<Response<dynamic>> get(String url) async {
    try {
      final response = await _dio.get(url);
      return response;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Executes a POST request to [url] with payload [data].
  ///
  /// [url] accepts a dynamic base URL provided at runtime.
  Future<Response<dynamic>> post(String url, dynamic data) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Maps [DioException] instances to readable error message strings.
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final dynamic resData = error.response?.data;
        String? serverMsg;
        if (resData is Map<String, dynamic>) {
          serverMsg = resData['message']?.toString();
        }
        return 'Server error ($statusCode)${serverMsg != null ? ": $serverMsg" : ""}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      default:
        return error.message ?? 'Unexpected network error occurred';
    }
  }
}
