import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
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
Future registerNewUser(CurrentUser user) async {
  return await firebaseFirestore
      .collection(userCollectionKey)
      .doc(user.email)
      .set(user.toMap(user));
}

Future signInWithEmail(String email, String password) async {
  return await auth
      .signInWithEmailAndPassword(email: email, password: password)
      .catchError((e) => e);
}

Future registerWithEmailAndPassword(
    String email, String password, String username, String phoneNumber) async {
  return await auth
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((value) async {
    CurrentUser _user = CurrentUser(
      uid: value.user?.uid,
      email: email,
      userName: username,
      profilePhoto: '',
      phoneNumber: phoneNumber,
    );
    await registerNewUser(_user);
  });
}

Future<Map<String, dynamic>?> getUserDetails() async {
  var user = currentUser();
  return firebaseFirestore
      .collection(userCollectionKey)
      .doc(user!.email)
      .get()
      .then((value) => value.data());
}

/// USER MODEL ///
class CurrentUser {
  String? uid;
  String? email;
  String? userName;
  String? profilePhoto;
  String? phoneNumber;

  CurrentUser({
    this.email,
    this.uid,
    this.userName,
    this.profilePhoto,
    this.phoneNumber,
  });

  Map<String, dynamic> toMap(CurrentUser user) {
    Map<String, dynamic> data = <String, dynamic>{};
    data[userUIDkey] = user.uid;
    data[usersGmailkey] = user.email;
    data[usernamekey] = user.userName;
    data[profilePictureKey] = user.profilePhoto;
    data[phoneNumberkey] = user.phoneNumber ?? '';
    return data;
  }

  CurrentUser.fromMap(Map<String, dynamic> mapData) {
    uid = mapData[userUIDkey];
    email = mapData[usersGmailkey];
    userName = mapData[usernamekey];
    profilePhoto = mapData[profilePictureKey];
    phoneNumber = mapData[phoneNumberkey] ?? '';
  }
}

String userCollectionKey = 'TotelUsers';
String userUIDkey = 'userUIDkey';
String usersGmailkey = 'usersGmailkey';
String usernamekey = 'usernamekey';
String profilePictureKey = 'profilePictureKey';
String phoneNumberkey = 'PhoneNumberKey';
