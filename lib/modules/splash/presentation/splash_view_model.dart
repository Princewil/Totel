import 'package:cheffy/app/app.locator.dart';
import 'package:cheffy/app/app.router.dart';
import 'package:cheffy/firebase_method.dart';
import 'package:cheffy/modules/on_boarding/on_boarding_view.dart';
import 'package:cheffy/new_UI/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'splash_view.dart';

class SplashViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator.get();

  Future<void> navigateToApp() async {
    var user = currentUser();
    Future.delayed(
      Duration(seconds: 1),
      () {
        if (user != null) {
          return _navigationService.replaceWith(Routes.mainView);
        }
        Navigator.of(buildContext!).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => NewOnBoarding()),
            (route) => false);
        //_navigationService.replaceWith(Routes.onBoardingView);
      },
    );
  }
}
