import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPerLine = 200;

  @override
  // Future onRequest(
  //     RequestOptions options, RequestInterceptorHandler handler) async {
  //   if (kDebugMode) {
  //     log("--> ${options.method} ${options.path}");
  //     log("Headers: ${options.headers.toString()}");
  //     log("Query Params: ${options.queryParameters}");

  //     if (options.data != null) {
  //       String requestData = options.data.toString();
  //       if (requestData.length > maxCharactersPerLine) {
  //         int iterations = (requestData.length / maxCharactersPerLine).floor();
  //         for (int i = 0; i <= iterations; i++) {
  //           int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
  //           if (endingIndex > requestData.length) {
  //             endingIndex = requestData.length;
  //           }
  //           log(requestData.substring(i * maxCharactersPerLine, endingIndex));
  //         }
  //       } else {
  //         log("Request Data: $requestData");
  //       }
  //     }

  //     log("--> END ${options.method}");
  //   }

  //   return super.onRequest(options, handler);
  // }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    if (kDebugMode) {
      log("<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");
    }

    String responseAsString = response.data.toString();

    if (responseAsString.length > maxCharactersPerLine) {
      int iterations = (responseAsString.length / maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        log(responseAsString.substring(i * maxCharactersPerLine, endingIndex));
      }
    } else {
      if (kDebugMode) {
        log(response.data.toString());
      }
    }

    if (kDebugMode) {
      log("<-- END HTTP");
    }

    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      log("ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}");
    }
    return super.onError(err, handler);
  }
}
