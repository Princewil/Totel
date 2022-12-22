import 'dart:io';

import 'package:cheffy/Models/occupation.dart';
import 'package:cheffy/modules/auth/auth/domain/entities/user_entity.dart';
import 'package:cheffy/modules/posts/create/create_post_functions.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/create_finding_post_params.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/post_entity.dart';

import '../../../../../widgets/post_listing_item/post_listing_item_vertical_layout_view.dart';

abstract class ProfileRepo {
  Future<UserEntity> get();

  Future<List<PostViewParams>> getUserPosts();

  Future<void> deletePostById(int postId);

  Future<List<Occupation>> getOccupations();

  Future<UserEntity?> update(UserEntity profileEntity, {File? newAvatar});
}
