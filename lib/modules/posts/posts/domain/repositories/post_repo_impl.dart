import 'dart:convert';
import 'dart:io';

import 'package:cheffy/core/services/api/api_client.dart';
import 'package:cheffy/core/services/api/api_routes.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/create_finding_post_params.dart';
import 'package:cheffy/modules/posts/posts/domain/repositories/post_repo.dart';
import 'package:dio/dio.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/post_entity.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/create_booked_post_params.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/attachment_entity.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../firebase_method.dart';

class PostRepoImpl implements PostRepo {
  PostRepoImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<void> createBookedPost(CreateBookedPostParams params,
      {List<XFile> files = const []}) async {
    try {
      final List<String> attachments = [];
      Map<String, dynamic> data = params.toMap(params);
      if (files.isNotEmpty) {
        attachments.addAll(await _uploadAttachments(files));
      }
      data.update(imagesKey, (value) => attachments,
          ifAbsent: () => attachments);
      await uploadPost(data);
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllPosts() async {
    List<Map<String, dynamic>> list = [];
    final res = await getAllUsersPost();
    for (var element in res!) {
      final _ =
          FindingPostParams.fromMap(element.data() as Map<String, dynamic>);
      var user =
          await getUserDetails(getThisUserDetails: false, uid: _.userUID);
      Map<String, dynamic> map = {};
      map.addAll(user!);
      map.addAll(element.data() as Map<String, dynamic>);
      list.add(map);
    }
    return list;
  }

  @override
  Future<String> uploadAttachment(String path, XFile file) async {
    return await uploadFile(File(file.path), path);
  }

  Future<List<String>> _uploadAttachments(List<XFile>? attachments) async {
    if (attachments != null) {
      final List<String> result = [];
      for (var e in attachments) {
        try {
          var time = DateTime.now().millisecondsSinceEpoch;
          String res = await uploadAttachment('$time', e);
          result.add(res);
        } catch (e) {
          rethrow;
        }
      }

      return result;
    }

    return [];
  }

  @override
  Future createFindingPost(FindingPostParams entity) async {
    return await uploadPost(entity.toMap(entity));
    //final res = await _apiClient.post('post', data: body);
  }
}
