import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';

import 'shared_preferences_util.dart';

class HttpHelper {
  late final Dio _dio = initDio();

  static HttpHelper _instance = HttpHelper();
  static HttpHelper get instance => _instance;

  Dio initDio(){
    BaseOptions baseOptions = BaseOptions(
      baseUrl: "https://63f13562.cpolar.io",
      sendTimeout: 5000,
      receiveTimeout: 5000,
    );
    Dio  dio = Dio(baseOptions);
    // 添加拦截器
    dio.interceptors.add(DioInterceptor());
    return dio;
  }

  Future<Map<String, dynamic>> get(String url, {Map<String, String>? queryParameters}) {
      return _baseRequest("get",url, queryParameters: queryParameters);
  }

  Future<Map<String, dynamic>> post(String url, {Map<String, String>? data}) {
      return _baseRequest("post",url, data: data);
  }

  Future<Map<String, dynamic>> put(String url, {Map<String, String>? data}) {
      return _baseRequest("put",url, data: data);
  }

  Future<Map<String, dynamic>> delete(String url, {Map<String, String>? data}) {
      return _baseRequest("delete",url, data: data);
  }

  Future<Map<String, dynamic>> _baseRequest(String method, String url, {Map<String, String>? queryParameters, Map<String, String>? data}) async {
    Options options = Options(method: method);
    late Response<dynamic> response;
    if("get" == method){
      if(queryParameters!=null && queryParameters.isNotEmpty){
        response = await  _dio.request(url,queryParameters: queryParameters, options: options);
      }else{
        response = await  _dio.request(url, options: options);
      }
    }else{
      response = await  _dio.request(url,data: data, options: options);
    }
    return response.data as Map<String,dynamic>;
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
    if(response.data["code"] !=200){
      EasyLoading.showToast(response.data["message"]);
      return;
    }
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("DioInterceptor onError===> ${err.message}");
    handler.next(err);
  }
}
