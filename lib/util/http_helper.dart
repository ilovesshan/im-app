import 'package:dio/dio.dart';

import 'shared_preferences_util.dart';

class HttpHelper {
  static late Dio _instance;

  static init() {
    if (_instance == null) {
      BaseOptions baseOptions = BaseOptions(
        baseUrl: "https://63f13562.cpolar.io",
        sendTimeout: 5000,
        receiveTimeout: 5000,
      );
      _instance = Dio(baseOptions);

      // 添加拦截器
      _instance.interceptors.add(Interceptor());
    }
  }

  static Future<String> get(String url, {Map<String, String>? queryParameters}) {
      return _baseRequest("get",url, queryParameters: queryParameters);
  }

  static Future<String> post(String url, {Map<String, String>? data}) {
      return _baseRequest("post",url, data: data);
  }

  static Future<String> put(String url, {Map<String, String>? data}) {
      return _baseRequest("put",url, data: data);
  }

  static Future<String> delete(String url, {Map<String, String>? data}) {
      return _baseRequest("delete",url, data: data);
  }

  static Future<String> _baseRequest(String method, String url, {Map<String, String>? queryParameters, Map<String, String>? data}) async {
    Options options = Options(method: method);
    late Response<dynamic> response;
    if("get" == method){
      if(queryParameters!=null && queryParameters.isNotEmpty){
        response = await  _instance.request(url,queryParameters: queryParameters, options: options);
      }else{
        response = await  _instance.request(url, options: options);
      }
    }else{
      response = await  _instance.request(url,data: data, options: options);
    }
    return response.data;
  }
}


class DioInterceptor extends Interceptor{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("DioInterceptor onRequest===> ${options.data}");
    // 添加token
    if(!options.path.contains("/login")){
      String token =  SpUtil.getValue("token") as String;
      Map<String, String> headers = {"Authorization":"Bearer " + token};
      options.headers.addAll(headers);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("DioInterceptor onResponse===> ${response.data}");
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("DioInterceptor onError===> ${err.message}");
    handler.next(err);
  }
}
