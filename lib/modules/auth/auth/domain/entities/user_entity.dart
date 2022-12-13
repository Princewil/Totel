import 'package:cheffy/Models/occupation.dart';
import 'package:cheffy/app/app.dart';
import 'package:cheffy/firebase_method.dart';

class UserEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? native;
  final String? bio;
  final String? phoneNo;
  final DateTime? dateOfBrith;
  final String? avatar;
  final String? city;
  final int rating;
  final String? gender;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? hobbies;
  final Occupation? occupation;

  UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.native,
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
        id: 1,
        firstName: json[usernamekey].split(' ').last,
        lastName: json[usernamekey].split(' ').first,
        username: json[usernamekey],
        email: json[usersGmailkey],
        native: json["native"],
        bio: json["bio"],
        phoneNo: json[phoneNumberkey],
        dateOfBrith: json["date_of_brith"] == null
            ? null
            : DateTime.tryParse(json["date_of_brith"]),
        avatar: json["avatar"].toString().replaceAll('public/', ''),
        city: json["city"],
        // rating: json["rating"],
        rating: 3,
        gender: json["gender"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        hobbies: json["hobbies"],
        occupation: json["occupation"] == null
            ? null
            : Occupation.fromMap(json["occupation"]),
      );

  Map<String, dynamic> toJson() => {
        // "first_name": firstName,
        // "last_name": lastName,
        usernamekey: '$lastName $firstName',
        usersGmailkey: email,
        "native": native,
        "bio": bio,
        "gender": gender,
        "occupation": occupation?.id,
      };

  // String getImgFullUrlPath(String avatarUrl) {
  //   final fixedAvatarUrl = avatarUrl.replaceAll('public/', '');
  //   return '${Application.imgBaseUrl}/$fixedAvatarUrl';
  // }
}
