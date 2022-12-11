import 'package:cheffy/app/app.locator.dart';
import 'package:cheffy/modules/auth/auth/domain/repositories/auth_repo.dart';
import 'package:cheffy/modules/main/discover/presentation/pages/search_hotels_page.dart';
import 'package:flutter/material.dart';
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
                          const SizedBox(height: 64),
                          AppFormField(
                            label: 'Email / Phone',
                            field: ReactiveTextField(
                              formControlName: viewModel.controls.username,
                              textInputAction: TextInputAction.next,
                              style: normaltextFont,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.soap,
                              ),
                              validationMessages: {
                                ValidationMessage.required: (val) =>
                                    'Enter your E-mail',
                                ValidationMessage.email: (val) =>
                                    'Enter a valid E-mail',
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppFormField(
                            label: 'Password',
                            field: ReactiveTextField(
                              formControlName: viewModel.controls.password,
                              textInputAction: TextInputAction.done,
                              style: normaltextFont,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.soap,
                                suffixIcon: IconButton(
                                  onPressed: viewModel.onShowPassword,
                                  splashRadius: 1,
                                  icon: Icon(
                                    viewModel.obscureText
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                  ),
                                ),
                              ),
                              obscureText: viewModel.obscureText,
                              validationMessages: {
                                ValidationMessage.required: (val) =>
                                    'Enter your password',
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: viewModel.onResetPassword,
                              style: TextButton.styleFrom(
                                  textStyle: headerTextFont),
                              child: const Text('Reset password'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: viewModel.onSubmit,
                            style: ElevatedButton.styleFrom(
                                textStyle: headerTextFont),
                            child: const Text('Login'),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Or continue with',
                            textAlign: TextAlign.center,
                            style: AppStyle.of(context)
                                .b4
                                .wCRhythm!
                                .merge(headerTextFont),
                          ),
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
                          //     OutlinedButton(
                          //       onPressed: viewModel.onFacebook,
                          //       style: OutlinedButton.styleFrom(
                          //         padding: const EdgeInsets.all(16),
                          //       ),
                          //       child: Image(
                          //         image:
                          //             R.svg.ic_facebook(width: 24, height: 24),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: getValueForScreenType(
                                context: context, mobile: 16, tablet: 36),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have account?",
                        style: AppStyle.of(context).b4.wCRhythm,
                      ),
                      TextButton(
                        onPressed: viewModel.onRegister,
                        child: Text(
                          'Sign-up',
                          style: AppStyle.of(context)
                              .b4M
                              .wCPlumpPurplePrimary!
                              .merge(headerTextFont),
                        ),
                      ),
                    ],
                  ),
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
