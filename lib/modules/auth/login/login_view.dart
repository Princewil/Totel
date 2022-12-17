import 'package:cheffy/app/app.locator.dart';
import 'package:cheffy/firebase_method.dart';
import 'package:cheffy/modules/auth/auth/domain/repositories/auth_repo.dart';
import 'package:cheffy/modules/main/discover/presentation/pages/search_hotels_page.dart';
import 'package:cheffy/modules/posts/create/create_post_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:r_dart_library/asset_svg.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:cheffy/r.g.dart';
import 'package:cheffy/modules/theme/color.dart';
import 'package:cheffy/modules/theme/styles.dart';
import 'package:cheffy/modules/widgets/app_form_field.dart';
import 'package:cheffy/modules/widgets/progress/background_progress.dart';

import 'login_view_model.dart';

class LoginView extends ViewModelBuilderWidget<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
      BuildContext context, LoginViewModel viewModel, Widget? child) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BackgroundProgress<LoginViewModel>(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: ReactiveForm(
              formGroup: viewModel.form,
              child: Column(
                children: [
                  SizedBox(height: kToolbarHeight * 0.6),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image(image: R.image.img_logo()),
                              const SizedBox(width: 16),
                              Image(image: R.image.img_logo_name()),
                            ],
                          ),
                          const SizedBox(height: 52),
                          Text(
                            'Login to Continue',
                            style: AppStyle.of(context)
                                .b1B
                                .wCChineseBlack!
                                .merge(normaltextFont),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. ',
                            style: AppStyle.of(context)
                                .b4
                                .wCRhythm!
                                .merge(headerTextFont),
                          ),
                          // const SizedBox(height: 18),
                          // LottieBuilder.asset('assets/images/building.json',
                          //     animate: true, height: 150, repeat: false,),
                          const SizedBox(height: 64),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: AppFormField(
                              label: '',
                              field: ReactiveTextField(
                                formControlName: viewModel.controls.username,
                                textInputAction: TextInputAction.done,
                                style: normaltextFont,
                                onSubmitted: (v) {
                                  viewModel.onSubmit();
                                },
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.emailAddress,
                                minLines: 1,
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: 'Continue with email',
                                    hintStyle: headerTextFont,
                                    fillColor: AppColors.soap,
                                    suffix: GestureDetector(
                                      onTap: () {
                                        KeyboardUtil.hideKeyboard(context);
                                        viewModel.onSubmit();
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.arrowRight,
                                        size: 20,
                                        color: Colors.blueGrey,
                                      ),
                                    )),
                                validationMessages: {
                                  ValidationMessage.required: (val) =>
                                      'Enter your E-mail',
                                  ValidationMessage.email: (val) =>
                                      'Enter a valid E-mail',
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextButton(
                              onPressed: viewModel.onGoogle,
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Color(0xFFEA4335)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Image(
                                    //   image: R.svg
                                    //       .ic_google(width: 24, height: 24),
                                    // ),
                                    FaIcon(FontAwesomeIcons.google,
                                        color: Colors.white),
                                    SizedBox(width: 15),
                                    Text('Continue with Google',
                                        style: headerTextFont.copyWith(
                                            color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Color(0xFF1DA1F2)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(FontAwesomeIcons.twitter,
                                        color: Colors.white),
                                    SizedBox(width: 15),
                                    Text('Continue with Twitter',
                                        style: headerTextFont.copyWith(
                                            color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Color(0xFF3B5998)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Image(
                                    //   image: R.svg
                                    //       .ic_google(width: 24, height: 24),
                                    // ),
                                    FaIcon(FontAwesomeIcons.facebook,
                                        color: Colors.white),
                                    SizedBox(width: 15),
                                    Text('Continue with Facebook',
                                        style: headerTextFont.copyWith(
                                            color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Colors.black),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Image(
                                    //   image: R.svg
                                    //       .ic_google(width: 24, height: 24),
                                    // ),
                                    FaIcon(FontAwesomeIcons.apple,
                                        color: Colors.white),
                                    SizedBox(width: 15),
                                    Text('Continue with Apple',
                                        style: headerTextFont.copyWith(
                                            color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // const SizedBox(height: 16),
                          // AppFormField(
                          //   label: 'Password',
                          //   field: ReactiveTextField(
                          //     formControlName: viewModel.controls.password,
                          //     textInputAction: TextInputAction.done,
                          //     style: normaltextFont,
                          //     decoration: InputDecoration(
                          //       filled: true,
                          //       fillColor: AppColors.soap,
                          //       suffixIcon: IconButton(
                          //         onPressed: viewModel.onShowPassword,
                          //         splashRadius: 1,
                          //         icon: Icon(
                          //           viewModel.obscureText
                          //               ? Icons.visibility_off_rounded
                          //               : Icons.visibility_rounded,
                          //         ),
                          //       ),
                          //     ),
                          //     obscureText: viewModel.obscureText,
                          //     validationMessages: {
                          //       ValidationMessage.required: (val) =>
                          //           'Enter your password',
                          //     },
                          //   ),
                          // ),
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: TextButton(
                          //     onPressed: viewModel.onResetPassword,
                          //     style: TextButton.styleFrom(
                          //         textStyle: headerTextFont),
                          //     child: const Text('Reset password'),
                          //   ),
                          // ),
                          // const SizedBox(height: 24),
                          //PasswordlessAuth(viewModel: viewModel),
                          // ElevatedButton(
                          //   onPressed: viewModel.onSubmit,
                          //   style: ElevatedButton.styleFrom(
                          //       textStyle: headerTextFont),
                          //   child: const Text('Login'),
                          // ),
                          // const SizedBox(height: 24),
                          // Text(
                          //   'Or continue with',
                          //   textAlign: TextAlign.center,
                          //   style: AppStyle.of(context)
                          //       .b4
                          //       .wCRhythm!
                          //       .merge(headerTextFont),
                          // ),
                          // const SizedBox(height: 16),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     OutlinedButton(
                          //       onPressed: viewModel.onGoogle,
                          //       style: OutlinedButton.styleFrom(
                          //         padding: const EdgeInsets.all(16),
                          //       ),
                          //       child: Image(
                          //         image: R.svg.ic_google(width: 24, height: 24),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 16),
                          //     // OutlinedButton(
                          //     //   onPressed: viewModel.onFacebook,
                          //     //   style: OutlinedButton.styleFrom(
                          //     //     padding: const EdgeInsets.all(16),
                          //     //   ),
                          //     //   child: Image(
                          //     //     image:
                          //     //         R.svg.ic_facebook(width: 24, height: 24),
                          //     //   ),
                          //     // ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: getValueForScreenType(
                          //       context: context, mobile: 16, tablet: 36),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       "Don't have account?",
                  //       style: AppStyle.of(context).b4.wCRhythm,
                  //     ),
                  //     TextButton(
                  //       onPressed: viewModel.onRegister,
                  //       child: Text(
                  //         'Sign-up',
                  //         style: AppStyle.of(context)
                  //             .b4M
                  //             .wCPlumpPurplePrimary!
                  //             .merge(headerTextFont),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) =>
      LoginViewModel(locator.get<AuthRepo>());
}

class PasswordlessAuth extends StatefulWidget {
  final LoginViewModel viewModel;
  PasswordlessAuth({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<PasswordlessAuth> createState() => _PasswordlessAuthState();
}

class _PasswordlessAuthState extends State<PasswordlessAuth>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future siginin() async {
    print('Pls wait.....');

    var email =
        widget.viewModel.form.control(widget.viewModel.controls.username).value;
    print(email);
    return await auth
        .sendSignInLinkToEmail(
            email: email,
            actionCodeSettings: ActionCodeSettings(
              url: 'https://ktotel.page.link/totel?email=$email',
              handleCodeInApp: true,
              androidPackageName: 'com.ktotel.ktotel',
            ))
        .then((value) => print("Email sent..........."))
        .catchError((e) {
      print(e);
      print('Error.....');
      return e;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        check(from: false);
        break;
      default:
    }
    //super.didChangeAppLifecycleState(state);
  }

  check({required bool from}) async {
    PendingDynamicLinkData? x;
    if (from) {
      x = await FirebaseDynamicLinks.instance.getInitialLink();
    } else {
      x = await FirebaseDynamicLinks.instance.onLink.first;
    }
    try {
      print("Resumed........");
      bool isv = auth.isSignInWithEmailLink(x!.link.toString());
      if (isv) {
        final cont = x.link.queryParameters['continueUrl'] ?? '';
        final mail = Uri.parse(cont).queryParameters['email'] ?? '';
        final UserCredential u = await auth.signInWithEmailLink(
            email: mail, emailLink: x.link.toString());
        print(u.credential?.asMap());
      } else
        print('not valid.....');
    } catch (e) {
      print('Error.....');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return Container(
            child: Center(child: Text('I am in')),
          );
        } else {
          return ElevatedButton(
            onPressed: () {
              siginin();
            },
            style: ElevatedButton.styleFrom(textStyle: headerTextFont),
            child: const Text('Login'),
          );
        }
      },
    );
  }
}
