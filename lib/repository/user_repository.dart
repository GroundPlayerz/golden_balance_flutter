import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:golden_balance_flutter/model/media_for_upload.dart';

import '../api_provider/user_api_provider.dart';

class UserRepository {
  final userApiProvider = UserApiProvider();

  Future<Response> uploadPost({
    required String title,
    required String firstContentText,
    required String secondContentText,
    required List<MediaForUpload> mediaList,
  }) async =>
      await userApiProvider.uploadPost(
          title: title,
          firstContentText: firstContentText,
          secondContentText: secondContentText,
          mediaList: mediaList);

  Future<Response> uploadProfilePhoto({required Uint8List imageBytes}) async =>
      await userApiProvider.uploadProfilePhoto(imageBytes: imageBytes);

  Future<Response> uploadProfileName({required String profileName}) async =>
      await userApiProvider.uploadProfileName(profileName: profileName);

  Future<Response> getHomeFeed({int? idCursor, double? scoreCursor}) async =>
      await userApiProvider.getHomeFeed(
          idCursor: idCursor, scoreCursor: scoreCursor);

  Future<Response> viewPost({required int postId}) async =>
      await userApiProvider.viewPost(postId: postId);

  Future<Response> voteToPost(
          {required int postId, required int choice}) async =>
      await userApiProvider.voteToPost(postId: postId, choice: choice);

  Future<Response> likePost({required int postId}) async =>
      await userApiProvider.likePost(postId: postId);

  Future<Response> cancelLikePost({required int postId}) async =>
      await userApiProvider.cancelLikePost(postId: postId);

  //------댓글------
  Future<Response> createComment({required int postId, required text}) async =>
      await userApiProvider.createComment(postId: postId, text: text);

  Future<Response> likeComment({required int commentId}) async =>
      await userApiProvider.likeComment(commentId: commentId);

  Future<Response> cancelLikeComment({required int commentId}) async =>
      await userApiProvider.cancelLikeComment(commentId: commentId);

  //------대댓글------

  Future<Response> createNestedComment(
          {required int commentId, required String text}) async =>
      await userApiProvider.createNestedComment(
          commentId: commentId, text: text);

  Future<Response> likeNestedComment({required int nestedCommentId}) async =>
      await userApiProvider.likeNestedComment(nestedCommentId: nestedCommentId);

  Future<Response> cancelLikeNestedComment(
          {required int nestedCommentId}) async =>
      await userApiProvider.cancelLikeNestedComment(
          nestedCommentId: nestedCommentId);
}
