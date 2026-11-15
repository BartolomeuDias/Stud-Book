import 'package:dio/dio.dart';

import 'api_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient(this._dio);

  factory ApiClient.create() => ApiClient(
    Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    ),
  );

  static const _errorKey = 'error';

  final Dio _dio;

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send(() => _dio.get<dynamic>(path, queryParameters: query));

  Future<dynamic> post(String path, {Object? body}) =>
      _send(() => _dio.post<dynamic>(path, data: body));

  Future<dynamic> put(String path, {Object? body}) =>
      _send(() => _dio.put<dynamic>(path, data: body));

  Future<dynamic> patch(String path, {Object? body}) =>
      _send(() => _dio.patch<dynamic>(path, data: body));

  Future<dynamic> delete(String path) => _send(() => _dio.delete<dynamic>(path));

  Future<dynamic> _send(Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      return response.data;
    } on DioException catch (error) {
      throw _map(error);
    }
  }

  AppException _map(DioException error) {
    final response = error.response;
    if (response == null) return NetworkException(error.message);
    final data = response.data;
    final message = data is Map && data[_errorKey] is String ? data[_errorKey] as String : null;
    return ApiException(response.statusCode, message);
  }
}
