// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:cheffy/core/models/data/app_user_entity.dart';
import 'package:cheffy/core/models/response/upload_attachment_entity.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:cheffy/core/models/data/app_user_entity.dart';
import 'package:cheffy/core/models/data/locations_entity.dart';
import 'package:cheffy/core/models/data/post_entity.dart';
import 'package:cheffy/core/models/request/create_post_entity.dart';
import 'package:cheffy/core/models/response/base_entity.dart';
import 'package:cheffy/core/models/response/login_entity.dart';
import 'package:cheffy/core/models/response/posts_entity.dart';
import 'package:cheffy/core/models/response/profile_entity.dart';

JsonConvert jsonConvert = JsonConvert();
typedef JsonConvertFunction<T> = T Function(Map<String, dynamic> json);

class JsonConvert {
  static final Map<String, JsonConvertFunction> _convertFuncMap = {
    (AppUserEntity).toString(): AppUserEntity.fromJson,
    (LocationEntity).toString(): LocationEntity.fromJson,
    (PostEntity).toString(): PostEntity.fromJson,
    (CreatePostEntity).toString(): CreatePostEntity.fromJson,
    (BaseEntity).toString(): BaseEntity.fromJson,
    (LoginEntity).toString(): LoginEntity.fromJson,
    (PostsEntity).toString(): PostsEntity.fromJson,
    (ProfileEntity).toString(): ProfileEntity.fromJson,
    (UploadAttachmentEntity).toString(): UploadAttachmentEntity.fromJson,
  };

  T? convert<T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return asT<T>(value);
  }

  List<T?>? convertList<T>(List<dynamic>? value) {
    if (value == null) {
      return null;
    }
    try {
      return value.map((dynamic e) => asT<T>(e)).toList();
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      return <T>[];
    }
  }

  List<T>? convertListNotNull<T>(dynamic value) {
    if (value == null) {
      return null;
    }
    try {
      return (value as List<dynamic>).map((dynamic e) => asT<T>(e)!).toList();
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      return <T>[];
    }
  }

  T? asT<T extends Object?>(dynamic value) {
    if (value is T) {
      return value;
    }
    final String type = T.toString();
    try {
      final String valueS = value.toString();
      if (type == "String") {
        return valueS as T;
      } else if (type == "int") {
        final int? intValue = int.tryParse(valueS);
        if (intValue == null) {
          return double.tryParse(valueS)?.toInt() as T?;
        } else {
          return intValue as T;
        }
      } else if (type == "double") {
        return double.parse(valueS) as T;
      } else if (type == "DateTime") {
        return DateTime.parse(valueS) as T;
      } else if (type == "bool") {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else if (type == "Map" || type.startsWith("Map<")) {
        return value as T;
      } else {
        if (_convertFuncMap.containsKey(type)) {
          return _convertFuncMap[type]!(value) as T;
        } else {
          throw UnimplementedError('$type unimplemented');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      return null;
    }
  }

  //list is returned by type
  static M? _getListChildType<M>(List<Map<String, dynamic>> data) {
    if (<AppUserEntity>[] is M) {
      return data
          .map<AppUserEntity>(
              (Map<String, dynamic> e) => AppUserEntity.fromJson(e))
          .toList() as M;
    }
    if (<LocationEntity>[] is M) {
      return data
          .map<LocationEntity>(
              (Map<String, dynamic> e) => LocationEntity.fromJson(e))
          .toList() as M;
    }
    if (<PostEntity>[] is M) {
      return data
          .map<PostEntity>((Map<String, dynamic> e) => PostEntity.fromJson(e))
          .toList() as M;
    }
    if (<CreatePostEntity>[] is M) {
      return data
          .map<CreatePostEntity>(
              (Map<String, dynamic> e) => CreatePostEntity.fromJson(e))
          .toList() as M;
    }
    if (<BaseEntity>[] is M) {
      return data
          .map<BaseEntity>((Map<String, dynamic> e) => BaseEntity.fromJson(e))
          .toList() as M;
    }
    if (<LoginEntity>[] is M) {
      return data
          .map<LoginEntity>((Map<String, dynamic> e) => LoginEntity.fromJson(e))
          .toList() as M;
    }
    if (<PostsEntity>[] is M) {
      return data
          .map<PostsEntity>((Map<String, dynamic> e) => PostsEntity.fromJson(e))
          .toList() as M;
    }
    if (<ProfileEntity>[] is M) {
      return data
          .map<ProfileEntity>(
              (Map<String, dynamic> e) => ProfileEntity.fromJson(e))
          .toList() as M;
    }
    if (<UploadAttachmentEntity>[] is M) {
      return data
          .map<UploadAttachmentEntity>(
              (Map<String, dynamic> e) => UploadAttachmentEntity.fromJson(e))
          .toList() as M;
    }

    debugPrint("${M.toString()} not found");

    return null;
  }

  static M? fromJsonAsT<M>(dynamic json) {
    if (json is List) {
      return _getListChildType<M>(
          json.map((e) => e as Map<String, dynamic>).toList());
    } else {
      return jsonConvert.asT<M>(json);
    }
  }
}
