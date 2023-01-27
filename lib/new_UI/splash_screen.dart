import 'package:cheffy/modules/main/discover/presentation/pages/search_hotels_page.dart';
import 'package:cheffy/modules/main/main_view.dart';
import 'package:cheffy/modules/splash/presentation/splash_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../modules/auth/auth/domain/repositories/auth_repo.dart';
import '../modules/auth/login/login_view_model.dart';
import '../modules/auth/register/register_form_view.dart';
import '../modules/splash/presentation/splash_view.dart';
import '../modules/widgets/progress/background_progress.dart';
import 'func.dart';

class NewOnBoarding extends StatefulWidget {
  NewOnBoarding({Key? key}) : super(key: key);

  @override
  State<NewOnBoarding> createState() => _NewOnBoardingState();
}

class _NewOnBoardingState extends State<NewOnBoarding> {
  late PageController controller;
  int currentpage = 0;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentpage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            PageView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                image(thirdImage),
                image(secondImage),
                image(firstImage),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 20),
                      child: animate(Text(
                        text[currentpage],
                        textAlign: TextAlign.left,
                        style: normaltextFont.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25),
                      )),
                    ),
                    currentpage == 2
                        ? animate(LoginView())
                        : Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: InkWell(
                              onTap: () async {
                                if (currentpage <= 1) {
                                  currentpage = currentpage + 1;
                                  await controller.animateToPage(currentpage,
                                      duration: Duration(seconds: 1),
                                      curve: Curves.ease);
                                  setState(() {});
                                }
                                // else {
                                //   loading = true;
                                //   setState(() {});
                                //   try {
                                //     bool? notNew = await continueWithGoogleAccnt();
                                //     if (notNew == null) {
                                //       loading = false;
                                //       setState(() {});
                                //       Get.closeAllSnackbars();
                                //       Get.showSnackbar(GetSnackBar(
                                //         title: 'An error occured!',
                                //         message: 'Please try again',
                                //         backgroundColor: Colors.red,
                                //         duration: Duration(seconds: 3),
                                //       ));
                                //     } else if (notNew) {
                                //       Navigator.of(context).pushAndRemoveUntil(
                                //           CupertinoPageRoute(
                                //               builder: (context) => MainView()),
                                //           (route) => false);
                                //     } else {
                                //       Navigator.of(context).pushAndRemoveUntil(
                                //           CupertinoPageRoute(
                                //               builder: (context) =>
                                //                   RegisterFormView()),
                                //           (route) => false);
                                //     }
                                //   } catch (e) {
                                //     loading = false;
                                //     setState(() {});
                                //     Get.closeAllSnackbars();
                                //     Get.showSnackbar(GetSnackBar(
                                //       title: 'An error occured',
                                //       message: e.toString(),
                                //       backgroundColor: Colors.red,
                                //       duration: Duration(seconds: 3),
                                //     ));
                                //   }
                                // }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                  child: animate(
                                    // currentpage == 2 && !loading
                                    //     ? Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.center,
                                    //         children: [
                                    //           FaIcon(FontAwesomeIcons.google,
                                    //               color: Color(0xFFEA4335)),
                                    //           SizedBox(width: 15),
                                    //           Text(
                                    //             'Continue with Google',
                                    //             style: headerTextFont.copyWith(
                                    //                 color: Colors.black,
                                    //                 fontWeight: FontWeight.bold),
                                    //           )
                                    //         ],
                                    //       )
                                    //     :
                                    //     currentpage == 2 && loading
                                    //         ? CupertinoActivityIndicator()
                                    //         :
                                    Text(
                                      'Next',
                                      style: headerTextFont.copyWith(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          dotted(currentpage == 0),
                          dotted(currentpage == 1),
                          dotted(currentpage == 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  List<String> text = [
    'Looking for a place to stay\nFind places around you',
    'Rent your rooms or hotels\nfor others ',
    'Travel freely without\n bordering where to stay'
  ];
  Widget image(AssetImage asset) => Stack(
        fit: StackFit.expand,
        children: [
          Image(image: asset, fit: BoxFit.cover),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.5),
          )
        ],
      );
  Widget dotted(bool i) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: i ? Colors.white : Colors.black45,
          ),
        ),
      );
  Widget animate(Widget child) => AnimatedSwitcher(
        duration: Duration(seconds: 1),
        child: child,
      );
}

class LoginView extends ViewModelBuilderWidget<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
      BuildContext context, LoginViewModel viewModel, Widget? child) {
    return ContinueWithGoogleLoading(viewModel: viewModel);
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) =>
      LoginViewModel(locator.get<AuthRepo>());
}

class ContinueWithGoogleLoading extends StatefulWidget {
  final LoginViewModel viewModel;
  const ContinueWithGoogleLoading({super.key, required this.viewModel});

  @override
  State<ContinueWithGoogleLoading> createState() =>
      _ContinueWithGoogleLoadingState();
}

class _ContinueWithGoogleLoadingState extends State<ContinueWithGoogleLoading> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: InkWell(
        onTap: () async {
          if (loading) {
            return;
          }
          loading = true;
          setState(() {});
          bool x = await widget.viewModel.onGoogle();
          if (!x) {
            loading = false;
            setState(() {});
            Get.closeAllSnackbars();
            Get.showSnackbar(GetSnackBar(
              title: 'An error occured!',
              message: 'Please try again',
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ));
          }
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: loading
                ? CupertinoActivityIndicator(color: Colors.black)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.google, color: Color(0xFFEA4335)),
                      SizedBox(width: 15),
                      Text(
                        'Continue with Google',
                        style: headerTextFont.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
    ;
  }
}

//  try {
//               bool? notNew = await continueWithGoogleAccnt();
//               if (notNew == null) {
//                 loading = false;
//                 setState(() {});
//                 Get.closeAllSnackbars();
//                 Get.showSnackbar(GetSnackBar(
//                   title: 'An error occured!',
//                   message: 'Please try again',
//                   backgroundColor: Colors.red,
//                   duration: Duration(seconds: 3),
//                 ));
//               } else if (notNew) {
//                 Navigator.of(context).pushAndRemoveUntil(
//                     CupertinoPageRoute(builder: (context) => MainView()),
//                     (route) => false);
//               } else {
//                 Navigator.of(context).pushAndRemoveUntil(
//                     CupertinoPageRoute(
//                         builder: (context) => RegisterFormView()),
//                     (route) => false);
//               }
//             } catch (e) {
//               loading = false;
//               setState(() {});
//               Get.closeAllSnackbars();
//               Get.showSnackbar(GetSnackBar(
//                 title: 'An error occured',
//                 message: e.toString(),
//                 backgroundColor: Colors.red,
//                 duration: Duration(seconds: 3),
//               ));
//             }
