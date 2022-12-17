import 'package:cheffy/Models/occupation.dart';
import 'package:cheffy/app/app.dart';
import 'package:cheffy/firebase_method.dart';

class UserEntity {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String? country;
  final String? bio;
  final String? phoneNo;
  final String? dateOfBrith;
  final String? avatar;
  final String? city;
  final int rating;
  final String? gender;
  final String? createdAt;
  final String? updatedAt;
  final String? hobbies;
  // final Occupation? occupation;
  final String? occupation;

  UserEntity({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.country,
    required this.bio,
    required this.phoneNo,
    required this.dateOfBrith,
    required this.avatar,
    required this.city,
    required this.rating,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
    required this.hobbies,
    required this.occupation,
  });

  factory UserEntity.fromMap(Map<String, dynamic> json) => UserEntity(
        uid: json[userUIDkey],
        firstName: json[firstNamekey],
        lastName: json[secondNamekey],
        email: json[usersGmailkey],
        country: json[countryKey] ?? '',
        bio: json[biokey] ?? '',
        phoneNo: json[phoneNumberkey] ?? '0',
        dateOfBrith: json[doBKey],
        // avatar: json[profilePictureKey].toString().replaceAll('public/', ''),
        avatar: json[avartarKey] ?? '',
        city: json[cityKey] ?? '',
        rating: json[ratingKey] ?? 0,
        gender: json[genderkey],
        createdAt: json[createdAtKey],
        updatedAt: json[updatedAtKey],
        hobbies: json[hobbiesKey] ?? '',
        // occupation: json[occupationKey] == null
        //     ? null
        //     : Occupation.fromMap(json[occupationKey]),
        occupation: json[occupationKey],
      );

  Map<String, dynamic> toMap(UserEntity userEntity) => {
        firstNamekey: userEntity.firstName,
        secondNamekey: userEntity.lastName,
        usersGmailkey: userEntity.email,
        countryKey: userEntity.country ?? '',
        biokey: userEntity.bio ?? '',
        genderkey: userEntity.gender ?? '',
        occupationKey: userEntity.occupation,
        userUIDkey: userEntity.uid,
        ratingKey: userEntity.rating,
        hobbiesKey: userEntity.hobbies,
        updatedAtKey: userEntity.updatedAt,
        createdAtKey: userEntity.createdAt,
        cityKey: userEntity.city,
        phoneNumberkey: userEntity.phoneNo,
        doBKey: userEntity.dateOfBrith,
        avartarKey: userEntity.avatar ?? "",
      };

  // String getImgFullUrlPath(String avatarUrl) {
  //   final fixedAvatarUrl = avatarUrl.replaceAll('public/', '');
  //   return '${Application.imgBaseUrl}/$fixedAvatarUrl';
  // }
}
