import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:golden_balance_flutter/util/dio_logging_interceptor.dart';

import '../configuration.dart';

class PostApiProvider {
  final Dio _dio = Dio();

  PostApiProvider() {
    _dio.options = dioOptions;
    _dio.interceptors.add(DioLoggingInterceptors(_dio));
    _dio.options.headers['requirestoken'] = true;
  }

  Future<Response> getCommentList({required int postId, int? idCursor}) async {
    Map<String, dynamic> queryParameters = {};
    if (idCursor != null) queryParameters['id_cursor'] = idCursor;

    Response response = await _dio.get('post/$postId/comment',
        queryParameters: queryParameters);
    return response;
  }
}
