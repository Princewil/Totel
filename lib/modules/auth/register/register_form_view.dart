import 'package:cheffy/core/enums/male_female_enum.dart';
import 'package:cheffy/modules/main/discover/presentation/pages/search_hotels_page.dart';
import 'package:cheffy/modules/posts/create/create_post_functions.dart';
import 'package:cheffy/widgets/shared_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_phone_form_field/reactive_phone_form_field.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:cheffy/modules/theme/color.dart';
import 'package:cheffy/modules/theme/styles.dart';
import 'package:cheffy/modules/widgets/app_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'register_view_model.dart';

class RegisterFormView extends ViewModelWidget<RegisterViewModel> {
  const RegisterFormView({super.key});

  @override
  Widget build(BuildContext context, RegisterViewModel viewModel) {
    double size() => MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            32,
            getValueForScreenType(context: context, mobile: 16, tablet: 36),
            32,
            getValueForScreenType(context: context, mobile: 16, tablet: 36),
          ),
          child: ReactiveForm(
            formGroup: viewModel.accountForm,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sign up',
                    style: AppStyle.of(context)
                        .b1B
                        .wCChineseBlack!
                        .merge(normaltextFont),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We want some basic information about you',
                    style:
                        AppStyle.of(context).b4.wCRhythm!.merge(headerTextFont),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: AppFormField(
                          label: 'First Name',
                          field: ReactiveTextField(
                            formControlName: viewModel.controls.firstName,
                            style: headerTextFont,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.soap,
                              hintText: 'E.g. Wade',
                            ),
                            validationMessages: {
                              ValidationMessage.required: (val) =>
                                  'Enter first name',
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: AppFormField(
                          label: 'Last Name',
                          field: ReactiveTextField(
                            formControlName: viewModel.controls.lastName,
                            style: headerTextFont,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.soap,
                              hintText: 'E.g. Warren',
                            ),
                            validationMessages: {
                              ValidationMessage.required: (val) =>
                                  'Enter last name',
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppFormField(
                    label: 'Enter your phone number',
                    field: ReactivePhoneFormField(
                      formControlName: viewModel.controls.phone,
                      style: headerTextFont,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.soap,
                        hintText: 'E.g. 64888 88245',
                      ),
                      validationMessages: {
                        ValidationMessage.required: (val) =>
                            'Enter phone number',
                        ValidationMessage.minLength: (val) =>
                            'Phone number must be 10 characters',
                        ValidationMessage.maxLength: (val) =>
                            'Phone number must be 10 characters',
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppFormField(
                          label: 'City (optional)',
                          field: ReactiveTextField(
                            formControlName: viewModel.controls.city,
                            style: headerTextFont,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.soap,
                              hintText: 'E.g. New York',
                            ),
                            validationMessages: {
                              ValidationMessage.required: (val) =>
                                  'Enter your city',
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: AppFormField(
                          label: 'Country (optional)',
                          field: ReactiveTextField(
                            formControlName: viewModel.controls.contry,
                            style: headerTextFont,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.soap,
                              hintText: 'E.g. USA',
                            ),
                            validationMessages: {
                              ValidationMessage.required: (val) =>
                                  'Enter your country',
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppFormField(
                    label: 'Bio (optional)',
                    field: ReactiveTextField(
                      formControlName: viewModel.controls.bio,
                      style: headerTextFont, maxLines: 5, minLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.soap,
                        hintText: 'E.g. I am a travel freak',
                      ),
                      // validationMessages: {
                      //   ValidationMessage.required: (val) =>
                      //       'Enter your bio',
                      // },
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (size() < 600)
                    AppFormField(
                      label: 'Occupation (optional)',
                      field: ReactiveTextField(
                        formControlName: viewModel.controls.occupation,
                        style: headerTextFont,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.soap,
                          hintText: 'E.g. Banker',
                        ),
                        validationMessages: {
                          ValidationMessage.required: (val) =>
                              'Enter your occupation',
                        },
                      ),
                    ),
                  if (size() < 600) const SizedBox(height: 16),
                  if (size() < 600)
                    AppFormField(
                      label: 'Hobbies (optional)',
                      field: ReactiveTextField(
                        formControlName: viewModel.controls.hobbies,
                        style: headerTextFont,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.soap,
                          hintText: 'E.g. Movies, skating',
                        ),
                        validationMessages: {
                          ValidationMessage.required: (val) =>
                              'Enter your hobbies',
                        },
                      ),
                    ),
                  if (size() > 600)
                    Row(
                      children: [
                        Expanded(
                          child: AppFormField(
                            label: 'Occupation (optional)',
                            field: ReactiveTextField(
                              formControlName: viewModel.controls.occupation,
                              style: headerTextFont,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.soap,
                                hintText: 'E.g. Banker',
                              ),
                              validationMessages: {
                                ValidationMessage.required: (val) =>
                                    'Enter your occupation',
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: AppFormField(
                            label: 'Hobbies (optional)',
                            field: ReactiveTextField(
                              formControlName: viewModel.controls.hobbies,
                              style: headerTextFont,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.soap,
                                hintText: 'E.g. Movies, skating',
                              ),
                              validationMessages: {
                                ValidationMessage.required: (val) =>
                                    'Enter your hobbies',
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                  // AppFormField(
                  //   label: 'Email Address',
                  //   field: ReactiveTextField(
                  //     formControlName: viewModel.controls.email,
                  //     style: headerTextFont,
                  //     decoration: InputDecoration(
                  //       filled: true,
                  //       fillColor: AppColors.soap,
                  //       hintText: 'E.g. willie.jennings@example.com',
                  //     ),
                  //     validationMessages: {
                  //       ValidationMessage.required: (val) =>
                  //           'Enter your E-mail',
                  //       ValidationMessage.email: (val) =>
                  //           'Enter a valid E-mail',
                  //     },
                  //   ),
                  // ),
                  const SizedBox(height: 16),
                  if (size() < 600)
                    SharedWidgets.buildListTileTitle(title: 'Date of Birth'),
                  if (size() < 600) DateOfBirth(),
                  if (size() < 600)
                    SharedWidgets.buildListTileTitle(title: 'Gender'),
                  if (size() < 600) Gender(),
                  if (size() > 600)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SharedWidgets.buildListTileTitle(
                                  title: 'Date of Birth'),
                              DateOfBirth(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SharedWidgets.buildListTileTitle(title: 'Gender'),
                              Gender(),
                            ],
                          ),
                        ),
                      ],
                    ),

                  // const SizedBox(height: 16),
                  // AppFormField(
                  //   label: 'Password',
                  //   field: ReactiveTextField(
                  //     formControlName: viewModel.controls.password,
                  //     style: headerTextFont,
                  //     obscureText: viewModel.obscureText,
                  //     validationMessages: {
                  //       ValidationMessage.required: (val) =>
                  //           'Enter your password',
                  //       ValidationMessage.minLength: (val) =>
                  //           'Password must be 6 characters or more',
                  //     },
                  //     decoration: InputDecoration(
                  //       filled: true,
                  //       fillColor: AppColors.soap,
                  //       hintText: 'Set your password',
                  //       suffixIcon: IconButton(
                  //         onPressed: viewModel.onShowPassword,
                  //         splashRadius: 1,
                  //         icon: Icon(viewModel.obscureText
                  //             ? Icons.visibility_off_rounded
                  //             : Icons.visibility_rounded),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // AppFormField(
                  //   label: 'Confirm Password',
                  //   field: ReactiveTextField(
                  //     formControlName: viewModel.controls.confirmPassword,
                  //     style: headerTextFont,
                  //     obscureText: viewModel.obscureText,
                  //     validationMessages: {
                  //       ValidationMessage.required: (val) =>
                  //           'Confirm password is required',
                  //       ValidationMessage.minLength: (val) =>
                  //           'Password must be 6 characters or more',
                  //       ValidationMessage.mustMatch: (val) =>
                  //           'Confirmation password doesn\'t match',
                  //     },
                  //     decoration: InputDecoration(
                  //       filled: true,
                  //       fillColor: AppColors.soap,
                  //       hintText: 'Confirm Password',
                  //       suffixIcon: IconButton(
                  //         onPressed: viewModel.onShowPassword,
                  //         splashRadius: 1,
                  //         icon: Icon(viewModel.obscureText
                  //             ? Icons.visibility_off_rounded
                  //             : Icons.visibility_rounded),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 52),
                  FinishButton(viewModel: viewModel),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     KeyboardUtil.hideKeyboard(context);
                  //     viewModel.onRegisterSubmit();
                  //   },
                  //   style: ElevatedButton.styleFrom(textStyle: headerTextFont),
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 17),
                  //     child: Text(
                  //       'Finish',
                  //       style: headerTextFont.copyWith(
                  //           fontSize: 16, letterSpacing: 1),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: getValueForScreenType(
                        context: context, mobile: 16, tablet: 36),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FinishButton extends StatefulWidget {
  final RegisterViewModel viewModel;
  const FinishButton({super.key, required this.viewModel});

  @override
  State<FinishButton> createState() => _FinishButtonState();
}

class _FinishButtonState extends State<FinishButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        KeyboardUtil.hideKeyboard(context);
        if (loading) {
          return;
        }
        loading = true;
        setState(() {});
        var b = await widget.viewModel.onRegisterSubmit();
        if (b is bool && !b) {
          loading = false;
          setState(() {});
        }
      },
      style: ElevatedButton.styleFrom(textStyle: headerTextFont),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: loading
            ? CupertinoActivityIndicator(color: Colors.black)
            : Text(
                'Finish',
                style: headerTextFont.copyWith(fontSize: 16, letterSpacing: 1),
              ),
      ),
    );
  }
}

class Gender extends StatefulWidget {
  Gender({Key? key}) : super(key: key);

  @override
  State<Gender> createState() => _GenderState();
}

MaleFemaleEnum? maleFemaleRegEnum;

class _GenderState extends State<Gender> {
  void onMaleFemaleChoice(MaleFemaleEnum? selMaleFemaleEnum) {
    KeyboardUtil.hideKeyboard(context);
    if (selMaleFemaleEnum != null) {
      maleFemaleRegEnum = selMaleFemaleEnum;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.blueGrey.shade100.withOpacity(0.4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: RadioListTile<MaleFemaleEnum>(
              value: MaleFemaleEnum.male,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                'Male',
                style: headerTextFont,
              ),
              groupValue: maleFemaleRegEnum,
              onChanged: onMaleFemaleChoice,
            ),
          ),
          Expanded(
            child: RadioListTile<MaleFemaleEnum>(
              value: MaleFemaleEnum.female,
              contentPadding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text(
                'Female',
                style: headerTextFont,
              ),
              groupValue: maleFemaleRegEnum,
              onChanged: onMaleFemaleChoice,
            ),
          ),
        ],
      ),
    );
  }
}

DateTime? regDOB;

class DateOfBirth extends StatefulWidget {
  const DateOfBirth({Key? key}) : super(key: key);

  @override
  State<DateOfBirth> createState() => _DateOfBirthState();
}

class _DateOfBirthState extends State<DateOfBirth> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade100.withOpacity(0.4),
      elevation: 0,
      child: ListTile(
        title: regDOB != null
            ? Text(DateFormat.yMMMEd().format(regDOB!), style: headerTextFont)
            : Text('Tap to fill',
                style: headerTextFont.copyWith(color: Colors.grey)),
        // subtitle:
        //     regDOB != null ? null : Text('Tap to fill', style: headerTextFont),
        // trailing: regDOB != null
        //     ? Text(DateFormat.yMd().format(regDOB!), style: headerTextFont)
        //     : null,
        onTap: () {
          KeyboardUtil.hideKeyboard(context);
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 36534)),
            lastDate: DateTime.now().add(Duration(days: 1)),
          ).then((value) {
            regDOB = value;
            setState(() {});
          });
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}
