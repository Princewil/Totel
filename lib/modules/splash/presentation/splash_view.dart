import 'package:cheffy/modules/splash/presentation/splash_view_model.dart';
import 'package:cheffy/r.g.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

BuildContext? buildContext;

class SplashView extends ViewModelBuilderWidget<SplashViewModel> {
  static const routeName = '/SplashView';
  const SplashView({super.key});

  @override
  void onViewModelReady(SplashViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.navigateToApp();
  }

  @override
  Widget builder(
      BuildContext context, SplashViewModel viewModel, Widget? child) {
    buildContext = context;
    return Scaffold(
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: R.image.img_logo()),
            const SizedBox(width: 16),
            Image(image: R.image.img_logo_name()),
          ],
        ),
      ),
    );
  }

  @override
  SplashViewModel viewModelBuilder(BuildContext context) => SplashViewModel();
}
