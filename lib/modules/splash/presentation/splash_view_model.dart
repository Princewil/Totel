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
    Future.delayed(
      Duration(seconds: 1),
      () async {
        var user = currentUser();
        if (user != null) {
          return _navigationService.replaceWith(Routes.mainView);
        }
        await cache(firstImage);
        await cache(secondImage);
        await cache(thirdImage);
        // Navigator.of(buildContext!).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => NewOnBoarding()),
        //     (route) => false);
        _navigationService.replaceWith(Routes.onBoardingView);
      },
    );
  }
}

Future cache(ImageProvider provider) async {
  return await precacheImage(provider, buildContext!);
}

AssetImage firstImage = AssetImage('assets/images/splashscreen_1.jpg');
AssetImage secondImage = AssetImage('assets/images/splashscreen_2.jpg');
AssetImage thirdImage = AssetImage('assets/images/splashscreen_3.jpg');
