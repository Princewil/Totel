import 'dart:io';
import 'package:cheffy/Models/occupation.dart';
import 'package:cheffy/app/app.locator.dart';
import 'package:cheffy/core/services/api/api_routes.dart';
import 'package:cheffy/firebase_method.dart';
import 'package:cheffy/modules/auth/auth/domain/entities/user_entity.dart';
import 'package:cheffy/modules/main/profile/profile/domain/repositories/profile_repo.dart';
import 'package:cheffy/core/services/api/api_client.dart';
import 'package:dio/dio.dart';

import '../../../../../widgets/post_listing_item/post_listing_item_vertical_layout_view.dart';

class ProfileRepoImpl extends ProfileRepo {
  final ApiClient _apiClient = locator.get();

  @override
  Future<UserEntity> get() async {
    try {
      // final result = await _apiClient.get(ApiRoutes.profile);
      final result = await getUserDetails();
      // print(result);
      var x = UserEntity.fromMap(result!);
      return x;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<PostViewParams>> getUserPosts() async {
    try {
      // final result = await _apiClient.get(ApiRoutes.postsByCurrentUser);
      // final resultData = result.data;
      List<PostViewParams> list = [];
      var resultData = await getThisUserPost();
      for (var element in resultData!) {
        final _ =
            PostViewParams.fromMap(element.data() as Map<String, dynamic>);
        list.add(_);
      }
      return list;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> deletePostById(int postId) async {
    await _apiClient.delete(ApiRoutes.deleteCurrentUserPost(postId));
  }

  @override
  Future<List<Occupation>> getOccupations() async {
    try {
      final result = await _apiClient.get(ApiRoutes.occupation);
      final resultData = result.data;

      return (resultData as List)
          .map((occ) => Occupation.fromMap(occ))
          .toList();
    } on DioError catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<UserEntity?> update(UserEntity profileEntity,
      {File? newAvatar}) async {
    Map<String, dynamic> _profileEntity = profileEntity.toMap(profileEntity);
    try {
      if (newAvatar != null) {
        String url = await uploadFile(newAvatar, 'myProfilePic');
        if (url == error) {
          return null;
        } else {
          _profileEntity.update(avartarKey, (value) => url);
        }
      }
      await updateProfile(UserEntity.fromMap(_profileEntity));
      return UserEntity.fromMap(_profileEntity);

      // Map<String, MultipartFile>? avatarMap;
      // if (newAvatar != null) {
      //   String fileName = newAvatar.path.split('/').last;
      //   avatarMap = {
      //     "avatar": await MultipartFile.fromFile(
      //       newAvatar.path,
      //       filename: fileName,
      //     ),
      //   };
      // }

      // FormData formData = FormData.fromMap({
      //   ...profileEntity.toJson(),
      //   if (avatarMap != null) ...avatarMap,
      // });

      // final result = await _apiClient.put(
      //   ApiRoutes.profile,
      //   data: formData,
      // );

      // final resultData = result.data;

    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<PostViewParams>> getUserBookedPosts() async {
    try {
      List<PostViewParams> list = [];
      var resultData = await getThisUserBookedPost();
      for (var element in resultData!) {
        final _ =
            PostViewParams.fromMap(element.data() as Map<String, dynamic>);
        list.add(_);
      }
      return list;
    } catch (e) {
      throw e;
    }
  }
}
