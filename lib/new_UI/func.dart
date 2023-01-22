import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_method.dart';

Future<bool?> continueWithGoogleAccnt() async {
  return await signInWithGoogleAccnt().then((User? user) async {
    if (user != null) {
      bool notNew = await authenticateUser(user);
      return notNew;
    } else {
      return null;
    }
  }).catchError((e) {
    return null;
  });
}
