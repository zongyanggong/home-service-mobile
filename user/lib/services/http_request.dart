import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:user/services/config.dart';


class HttpRequest {
  static final BaseOptions baseOptions = BaseOptions(
      baseUrl: HttpConfig.baseURL,
      connectTimeout: const Duration(milliseconds: HttpConfig.timeout));
  static final Dio dio = Dio(baseOptions);

  static Future<T> request<T>(String url,
      {String method = "get", Map<String, dynamic>? params, Interceptor? inter}) async {
    final options = Options(method: method);

    InterceptorsWrapper dInter = InterceptorsWrapper(
      onRequest: (options, handle){
        debugPrint("request interceptor");
        handle.next(options);
      },
      onResponse: (response,handle){
        debugPrint("response interceptor");
        handle.next(response);
      },
      onError: (err,handle){
        debugPrint("error interceptor");
        handle.next(err);
      }
    );
    List<Interceptor> inters = [dInter];
    if (inter!=null){
      inters.add(inter);
    }

    dio.interceptors.addAll(inters);
    try {
      Response response =
          await dio.request(url, queryParameters: params, options: options);
      return response.data;
    } on DioException catch (e) {
      return Future.error(e);
    }
  }
}
