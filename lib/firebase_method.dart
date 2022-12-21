import 'dart:io';

import 'package:cheffy/modules/auth/auth/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'modules/posts/posts/domain/entities/create_finding_post_params.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
User? currentUser() => auth.currentUser;

///For automatic google signIn
final GoogleSignIn _googleSignIn = GoogleSignIn();
Future<User?> signInWithGoogleAccnt() async {
  GoogleSignInAccount? _signInAccount = await _googleSignIn.signIn();
  GoogleSignInAuthentication _signInAuth = await _signInAccount!.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _signInAuth.idToken, accessToken: _signInAuth.accessToken);

  User? user = (await auth.signInWithCredential(credential)).user;
  return user;
}

Future<bool> authenticateUser(User user) async {
  DocumentSnapshot result = await firebaseFirestore
      .collection(userCollectionKey)
      .doc(user.email)
      .get();
  return result.exists ? true : false;
}

/// For Registering the new User using their Gmail Credentials
Future registerNewUser(UserEntity user) async {
  return await firebaseFirestore
      .collection(userCollectionKey)
      .doc(user.email)
      .set(user.toMap(user));
}

// Future signInWithEmail(String email, String password) async {
//   return await auth
//       .signInWithEmailAndPassword(email: email, password: password)
//       .catchError((e) => e);
// }

// Future registerWithEmailAndPassword(
//     String email, String password, String username, String phoneNumber) async {
//   return await auth
//       .createUserWithEmailAndPassword(email: email, password: password)
//       .then((value) async {
//     CurrentUser _user = CurrentUser(
//       uid: value.user?.uid,
//       email: email,
//       userName: username,
//       profilePhoto: '',
//       phoneNumber: phoneNumber,
//     );
//     await registerNewUser(_user);
//   });
// }

Future<Map<String, dynamic>?> getUserDetails(
    {bool getThisUserDetails = true, String? uid}) async {
  if (!getThisUserDetails) {
    //when we are getting other users using their UID
    return firebaseFirestore
        .collection(userCollectionKey)
        .where(userUIDkey, isEqualTo: uid)
        .get()
        .then((value) => value.docs.first.data());
  }
  var user = currentUser();
  return firebaseFirestore
      .collection(userCollectionKey)
      .doc(user!.email)
      .get()
      .then((value) => value.data());
}

Future<Map<String, dynamic>?> getUserPostDetails(String uid) async {
  return firebaseFirestore
      .collection(userCollectionKey)
      .where(updatedAtKey, isEqualTo: uid)
      .get()
      .then((value) => value.docs.first.data());
}

Future<void> updateProfile(UserEntity userEntity) async {
  var user = currentUser();
  return await firebaseFirestore
      .collection(userCollectionKey)
      .doc(user!.email)
      .set(userEntity.toMap(userEntity), SetOptions(merge: true));
}

Future<String> uploadFile(File file, String path) async {
  var user = currentUser();
  late String text;
  var task = firebaseStorage.ref(user!.email).child(path).putFile(file);
  await task.whenComplete(() async {
    if (task.snapshot.state == TaskState.success) {
      text = await task.snapshot.ref.getDownloadURL();
    } else {
      text = error;
    }
  });
  return text;
}

const error = 'Error';

Future uploadPost(Map<String, dynamic> data) async {
  return await firebaseFirestore.collection(findingPostCollection).add(data);
}

Future<List<QueryDocumentSnapshot>?> getThisUserPost() async {
  return await firebaseFirestore
      .collection(findingPostCollection)
      .where(userUIDkey, isEqualTo: currentUser()!.uid)
      .get()
      .then((value) => value.docs);
}

Future<List<QueryDocumentSnapshot>?> getAllUsersPost() async {
  return await firebaseFirestore
      .collection(findingPostCollection)
      .get()
      .then((value) => value.docs);
}

/// USER MODEL ///
// class CurrentUser {
//   String? uid;
//   String? email;
//   String? userName;
//   String? profilePhoto;
//   String? phoneNumber;

//   CurrentUser({
//     this.email,
//     this.uid,
//     this.userName,
//     this.profilePhoto,
//     this.phoneNumber,
//   });

//   Map<String, dynamic> toMap(CurrentUser user) {
//     Map<String, dynamic> data = <String, dynamic>{};
//     data[userUIDkey] = user.uid;
//     data[usersGmailkey] = user.email;
//     data[usernamekey] = user.userName;
//     data[profilePictureKey] = user.profilePhoto;
//     data[phoneNumberkey] = user.phoneNumber ?? '';
//     return data;
//   }

//   CurrentUser.fromMap(Map<String, dynamic> mapData) {
//     uid = mapData[userUIDkey];
//     email = mapData[usersGmailkey];
//     userName = mapData[usernamekey];
//     profilePhoto = mapData[profilePictureKey];
//     phoneNumber = mapData[phoneNumberkey] ?? '';
//   }
// }

const String userCollectionKey = 'TotelUsers';
const String userUIDkey = 'userUID';
const String usersGmailkey = 'usersGmail';
const String firstNamekey = 'firstName';
const String secondNamekey = 'secondName';
const String phoneNumberkey = 'PhoneNumber';
const String avartarKey = 'Profile_picture';
const String countryKey = "Country";
const String biokey = 'BioKey';
const String doBKey = 'date_of_brith';
const String cityKey = 'city';
const String ratingKey = 'Rating';
const String genderkey = 'gender';
const String createdAtKey = 'created_at';
const String updatedAtKey = 'updated_at';
const String hobbiesKey = 'hobbies';
const String occupationKey = 'occupation';
const String findingPostCollection = 'FindingPostCollection';
