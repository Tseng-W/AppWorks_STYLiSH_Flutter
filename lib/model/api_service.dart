import 'package:stylish_wen/model/request.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

abstract class APIServiceProtocol {
  Future<T> fetchRequest<T>(Request<T> request);
}

class APIService implements APIServiceProtocol {
  static final shared = APIService();

  final Dio dio = Dio();

  APIService() {
    dio
      ..options.baseUrl = 'https://api.appworks-school.tw/api/1.0'
      ..options.connectTimeout = const Duration(seconds: 5)
      ..options.receiveTimeout = const Duration(seconds: 3);
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        Logger().d(options);
        return handler.next(options);
      },
      onResponse: (e, handler) {
        Logger().d(e);
        return handler.next(e);
      },
      onError: (e, handler) {
        Logger().w(e);
        return handler.next(e);
      },
    ));
  }

  @override
  Future<T> fetchRequest<T>(Request<T> request) {
    Future<Response<Map>> response;
    switch (request.method) {
      case RequestMethod.GET:
        response = dio.get(request.endpoint, queryParameters: request.queries);
        break;
      case RequestMethod.POST:
        response = dio.post(request.endpoint,
            queryParameters: request.queries,
            options: Options(responseType: request.type));
        break;
      default:
        throw Exception('Not implemented');
    }

    return response.catchError((error) {
      throw Exception('Failed to load hots');
    }).then((response) {
      if (response.statusCode == 200) {
        try {
          if (response.data == null) {
            throw Exception('Data unexpected found nil');
          }
          return request.decode(response.data!);
        } catch (e) {
          if (e is FormatException) {
            throw Exception('Format error');
          } else {
            throw Exception('Unexpected error');
          }
        }
      } else {
        throw Exception('Failed to load hots');
      }
    });
  }
}
