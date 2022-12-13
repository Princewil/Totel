import 'package:cheffy/modules/splash/presentation/splash_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case SplashView.routeName:
        return CupertinoPageRoute(builder: (_) => const SplashView());
      default:
        return _errorRoute();
    }
  }

  ///Error route
  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
