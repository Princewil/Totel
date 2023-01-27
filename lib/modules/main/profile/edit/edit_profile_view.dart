import 'package:cheffy/Utils/Utils.dart';
import 'package:cheffy/core/enums/male_female_enum.dart';
import 'package:cheffy/firebase_method.dart';
import 'package:cheffy/modules/auth/login/login_view.dart';
import 'package:cheffy/modules/main/discover/presentation/pages/search_hotels_page.dart';
import 'package:cheffy/modules/main/profile/profile_provider.dart';
import 'package:cheffy/modules/widgets/progress/background_progress.dart';
import 'package:cheffy/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/reactive_image_picker.dart';
import 'package:cheffy/modules/widgets/app_form_field.dart';

import '../../../../new_UI/splash_screen.dart';
import '../../../auth/register/register_form_view.dart';

class EditProfileView extends StatefulWidget {
  EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  @override
  void initState() {
    super.initState();
    final profileProvider = context.read<ProfileProvider>();
    Future.delayed(Duration.zero, () {
      //profileProvider.getOccupations();
    });
  }

  @override
  Widget build(BuildContext context) {
    double size() => MediaQuery.of(context).size.width;
    final profileProvider = context.watch<ProfileProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: headerTextFont.copyWith(fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Text('Are sure you want to logout?',
                              style: headerTextFont),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('No', style: headerTextFont)),
                            TextButton(
                                onPressed: () {
                                  logOut();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewOnBoarding()),
                                      (route) => false);
                                },
                                child: Text('Yes', style: headerTextFont)),
                          ],
                        ));
              },
              icon: Icon(Icons.logout, color: Colors.deepOrange))
        ],
      ),
      body: BackgroundProgress<ProfileProvider>(
        child: SafeArea(
          child: ReactiveForm(
            formGroup: profileProvider.editProfileForm,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    AppFormField(
                      label: 'Avatar',
                      field: ReactiveImagePicker(
                        formControlName: ReactiveFormControls.avatar,
                        inputBuilder: (onPressed) => TextButton.icon(
                          onPressed: onPressed,
                          icon: const Icon(Icons.add),
                          label: Text(
                            'Add an avatar',
                            style: normaltextFont,
                          ),
                        ),
                        imageQuality: 40,
                        validationMessages: {
                          ValidationMessage.required: (val) =>
                              'Select your avatar',
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppFormField(
                            label: 'First Name',
                            field: ReactiveTextField(
                              formControlName: ReactiveFormControls.firstName,
                              style: headerTextFont,
                              decoration: InputDecoration(
                                  hintText: 'ex: John',
                                  hintStyle: normaltextFont),
                              validationMessages: {
                                ValidationMessage.required: (val) =>
                                    'Enter first name',
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: AppFormField(
                            label: 'Last Name',
                            field: ReactiveTextField(
                              formControlName: ReactiveFormControls.lastName,
                              style: headerTextFont,
                              decoration: InputDecoration(
                                  hintText: 'ex: Doe',
                                  hintStyle: normaltextFont),
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
                    if (size() < 600)
                      AppFormField(
                        label: 'Occupation',
                        field: ReactiveTextField(
                          formControlName: ReactiveFormControls.occupation,
                          style: headerTextFont,
                          decoration: InputDecoration(
                              hintText: 'eg: Banker',
                              hintStyle: normaltextFont),
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
                          formControlName: ReactiveFormControls.hobbies,
                          style: normaltextFont,
                          decoration: InputDecoration(
                            hintStyle: headerTextFont,
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
                              label: 'Occupation',
                              field: ReactiveTextField(
                                formControlName:
                                    ReactiveFormControls.occupation,
                                style: headerTextFont,
                                decoration: InputDecoration(
                                    hintText: 'eg: Banker',
                                    hintStyle: normaltextFont),
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
                                formControlName: ReactiveFormControls.hobbies,
                                style: normaltextFont,
                                decoration: InputDecoration(
                                  hintStyle: headerTextFont,
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppFormField(
                            label: 'City',
                            field: ReactiveTextField(
                              formControlName: ReactiveFormControls.city,
                              style: headerTextFont,
                              decoration: InputDecoration(
                                  hintText: 'ex: New York',
                                  hintStyle: normaltextFont),
                              validationMessages: {
                                ValidationMessage.required: (val) =>
                                    'Enter your city',
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: AppFormField(
                            label: 'Country',
                            field: ReactiveTextField(
                              formControlName: ReactiveFormControls.country,
                              style: headerTextFont,
                              decoration: InputDecoration(
                                  hintText: 'ex: USA',
                                  hintStyle: normaltextFont),
                              validationMessages: {
                                ValidationMessage.required: (val) =>
                                    'Enter your country',
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    // AppFormField(
                    //   label: 'Occupation',
                    //   field: ReactiveDropdownField(
                    //     formControlName: ReactiveFormControls.occupation,
                    //     style: headerTextFont,
                    //     hint: Text(
                    //       'Occupation',
                    //       style: normaltextFont,
                    //     ),
                    //     validationMessages: {
                    //       ValidationMessage.required: (val) =>
                    //           'Enter your occupation',
                    //     },
                    //     items: profileProvider.occupations
                    //         .map(
                    //           (occ) => DropdownMenuItem<int>(
                    //             value: occ.id,
                    //             child: Text(occ.name),
                    //           ),
                    //         )
                    //         .toList(),
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    AppFormField(
                      label: 'Bio',
                      field: ReactiveTextField(
                        formControlName: ReactiveFormControls.bio,
                        style: headerTextFont,
                        decoration: InputDecoration(
                            hintText:
                                'ex: I\'m a student looking for rental rooms',
                            hintStyle: normaltextFont),
                        maxLines: 5,
                        validationMessages: {
                          ValidationMessage.required: (val) => 'Enter your bio',
                        },
                      ),
                    ),
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
                                SharedWidgets.buildListTileTitle(
                                    title: 'Gender'),
                                Gender(),
                              ],
                            ),
                          ),
                        ],
                      ),

                    // SharedWidgets.buildListTileTitle(title: 'Who are you'),
                    // RadioListTile<MaleFemaleEnum>(
                    //   value: MaleFemaleEnum.male,
                    //   contentPadding: const EdgeInsets.all(0),
                    //   title: Text(
                    //     'Male',
                    //     style: headerTextFont,
                    //   ),
                    //   groupValue: profileProvider.maleFemaleEnum,
                    //   onChanged: profileProvider.onMaleFemaleChoice,
                    // ),
                    // RadioListTile<MaleFemaleEnum>(
                    //   value: MaleFemaleEnum.female,
                    //   contentPadding: const EdgeInsets.all(0),
                    //   title: Text(
                    //     'Female',
                    //     style: headerTextFont,
                    //   ),
                    //   groupValue: profileProvider.maleFemaleEnum,
                    //   onChanged: profileProvider.onMaleFemaleChoice,
                    // ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SharedWidgets.buildRoundedElevatedButton(
                        btnChild: Text(
                          'Save',
                          style: headerTextFont,
                        ),
                        onPress: () async {
                          FocusScope.of(context).unfocus();
                          await profileProvider.onEditSave();
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
