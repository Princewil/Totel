import 'package:cheffy/app/app.locator.dart';
import 'package:cheffy/modules/location_change_map/location_change_map_view.dart';
import 'package:cheffy/modules/main/discover/presentation/pages/search_hotels_page.dart';
import 'package:cheffy/modules/posts/create/create_post_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_support_pack/flutter_support_pack.dart';
import 'package:flutter_time_range/flutter_time_range.dart';
import 'package:reactive_date_range_picker/reactive_date_range_picker.dart';
import 'package:reactive_flutter_rating_bar/reactive_flutter_rating_bar.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:stacked/stacked.dart';
import 'package:cheffy/core/enums/post_type.dart';
import 'package:cheffy/r.g.dart';
import 'package:cheffy/modules/theme/color.dart';
import 'package:cheffy/modules/theme/styles.dart';
import 'package:cheffy/modules/widgets/app_form_field.dart';
import 'package:cheffy/modules/widgets/app_toggle_button.dart';
import 'package:cheffy/modules/widgets/progress/background_progress.dart';

import 'create_post_view_model.dart';
import 'image_item_view.dart';

String avaliable = '';

class CreatePostView extends ViewModelBuilderWidget<CreatePostViewModel> {
  final PostType type;

  const CreatePostView({super.key, required this.type});

  @override
  Widget builder(
      BuildContext context, CreatePostViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Add Travel Details',
        style: normaltextFont.copyWith(fontWeight: FontWeight.bold),
      )),
      body: BackgroundProgress<CreatePostViewModel>(
        child: SafeArea(
          child: SingleChildScrollView(
            child: ReactiveForm(
              formGroup: viewModel.form,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //region image
                    if (viewModel.type == PostType.booked) ...[
                      ReactiveFormField(
                        formControlName: viewModel.controls.attachments,
                        builder: (state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return ImageItemView(
                                      image: viewModel.attachments[index],
                                      onPressedAdd: () =>
                                          viewModel.onPressedAdd(),
                                      onPressedRemove: () =>
                                          viewModel.onPressedRemove(index),
                                    );
                                  },
                                  itemCount: viewModel.attachments.length,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                              if (state.errorText.isNotNullOrEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  '${state.errorText}',
                                  style: AppStyle.of(context)
                                      .b5
                                      .wCError!
                                      .merge(headerTextFont),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                    //endregion
                    //region location
                    // AppFormField(
                    //   label: viewModel.type == PostType.booked
                    //       ? 'Where you are going'
                    //       : 'Where you want to go',
                    //   field: ReactiveTextField(
                    //     formControlName: viewModel.controls.location,
                    //     onTap: viewModel.onLocation,
                    //     style: headerTextFont,
                    //     readOnly: true,
                    //   ),
                    // ),
                    Card(
                      elevation: 0,
                      child: ListTile(
                        onTap: viewModel.onLocation,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 0.6, color: Colors.grey.shade400),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        title:
                            Text('Where you are going?', style: headerTextFont),
                        subtitle: locationEntity != null
                            ? Text(locationEntity!.name)
                            : Text('Tap to edit',
                                style: headerTextFont.copyWith(
                                    fontStyle: FontStyle.italic)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    //endregion
                    //region date
                    AppFormField(
                      label: viewModel.type == PostType.booked
                          ? 'When you going'
                          : 'When you want to go',
                      field: Theme(
                        data: Theme.of(context).copyWith(useMaterial3: false),
                        child: ReactiveDateRangePicker(
                          style: headerTextFont,
                          formControlName: viewModel.controls.date,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    //endregion
                    //region name
                    if (viewModel.type == PostType.booked) ...[
                      AppFormField(
                        label: 'Enter Hotel Name',
                        field: ReactiveTextField(
                          formControlName: viewModel.controls.hotel,
                          textInputAction: TextInputAction.next,
                          style: headerTextFont,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    //endregion
                    //region rate
                    if (viewModel.type == PostType.booked) ...[
                      AppFormField(
                        label: 'Rate Hotel',
                        field: ReactiveRatingBar<double>(
                          formControlName: viewModel.controls.rating,
                          allowHalfRating: true,
                          decoration: const InputDecoration(
                            filled: false,
                            isDense: true,
                            isCollapsed: true,
                            border: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ),
                          ratingWidget: RatingWidget(
                            full: Icon(
                              Icons.star_rounded,
                              color: AppColors.plumpPurplePrimary,
                            ),
                            half: Icon(
                              Icons.star_half_rounded,
                              color: AppColors.plumpPurplePrimary,
                            ),
                            empty: Icon(
                              Icons.star_border_rounded,
                              color: AppColors.plumpPurplePrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    //endregion
                    //region price
                    AppFormField(
                      label: viewModel.type == PostType.booked
                          ? 'How much you pay for one night stay'
                          : 'Your budget for hotel (optional)',
                      field: ReactiveTextField(
                        formControlName: viewModel.controls.price,
                        keyboardType: TextInputType.number,
                        style: headerTextFont,
                        decoration: const InputDecoration(prefixText: '\$'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    if (viewModel.type == PostType.booked) ...[
                      const SizedBox(height: 4),
                      ReactiveFormConsumer(
                        builder: (context, form, child) => Text.rich(
                          TextSpan(children: [
                            const TextSpan(text: 'Your Partner Pay '),
                            TextSpan(
                              text: viewModel.partnerAmount.currency,
                              style:
                                  AppStyle.of(context).b5.wCPlumpPurplePrimary,
                            ),
                            const TextSpan(text: ' to you'),
                          ]),
                          style: AppStyle.of(context)
                              .b5
                              .wCRhythm!
                              .merge(headerTextFont),
                        ),
                      ),
                    ],
                    //endregion
                    const SizedBox(height: 24),
                    //region message
                    AppFormField(
                      label: 'Message for your partner',
                      field: ReactiveTextField(
                        formControlName: viewModel.controls.message,
                        style: headerTextFont,
                      ),
                    ),
                    //endregion
                    const SizedBox(height: 24),
                    //region partner
                    AppFormField(
                      label: 'Type of travel partner looking for',
                      field: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppToggleButton(
                            icon: R.svg.ic_male(width: 21, height: 28),
                            name: 'Male',
                            isSelected: viewModel.isMalePartner,
                            callback: () {
                              KeyboardUtil.hideKeyboard(context);
                              viewModel
                                  .onTapMalePartner(viewModel.isMalePartner);
                            },
                          ),
                          const SizedBox(width: 16),
                          AppToggleButton(
                            icon: R.svg.ic_female(width: 21, height: 28),
                            name: 'Female',
                            isSelected: viewModel.isFemalePartner,
                            callback: () {
                              KeyboardUtil.hideKeyboard(context);
                              viewModel.onTapFemalePartner(
                                  viewModel.isFemalePartner);
                            },
                          ),
                        ],
                      ),
                    ),
                    //endregion
                    const SizedBox(height: 24),
                    if (viewModel.type == PostType.finding) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: AppFormField(
                          field: ReactiveSwitchListTile(
                            formControlName: viewModel.controls.hourly,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Available to Hourly?',
                              style: AppStyle.of(context)
                                  .b4
                                  .wCRhythm!
                                  .merge(headerTextFont),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    AvaliableHour(viewModel: viewModel),
                    const SizedBox(height: 24),

                    // ElevatedButton(
                    //   onPressed: viewModel.onSubmit,
                    //   child: const Text('Post it'),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  CreatePostViewModel viewModelBuilder(BuildContext context) =>
      CreatePostViewModel(type, locator.get());
}

Future<List<TimeOfDay>?> showTimeRange(BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose event', style: headerTextFont),
          content: TimeRangePicker(
            initialFromHour: 1,
            initialToHour: 2,
            initialFromMinutes: 3,
            initialToMinutes: 4,
            is24Format: false,
            onSelect: (from, to) {
              Navigator.pop(context, [from, to]);
            },
          ),
        );
      });
}

String avaliableHour = '';
final RoundedLoadingButtonController postItController =
    RoundedLoadingButtonController();

class AvaliableHour extends StatefulWidget {
  final CreatePostViewModel viewModel;
  AvaliableHour({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<AvaliableHour> createState() => _AvaliableHourState();
}

class _AvaliableHourState extends State<AvaliableHour> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.viewModel.type == PostType.booked) ...[
          ListTile(
            title: Text(
              'Avaliable Hour:',
              style: headerTextFont.copyWith(fontWeight: FontWeight.w400),
            ),
            subtitle: avaliableHour.isEmpty
                ? Text(
                    'Tap to adjust',
                    style: headerTextFont.copyWith(
                        color: Colors.blueGrey, fontSize: 11),
                  )
                : null,
            trailing: Text(
              avaliableHour.isEmpty ? "-- : --" : avaliableHour,
              style: headerTextFont.copyWith(fontWeight: FontWeight.w400),
            ),
            onTap: () {
              KeyboardUtil.hideKeyboard(context);
              showTimeRange(context).then(
                (value) {
                  if (value != null) {
                    String from = '${value.first.format(context)}';
                    String to = '${value.last.format(context)}';
                    avaliableHour = "$from - $to";
                    setState(() {});
                  }
                },
              );
            },
          ),
        ],
        const SizedBox(height: 20),
        RoundedLoadingButton(
            controller: postItController,
            animateOnTap: false,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              KeyboardUtil.hideKeyboard(context);
              widget.viewModel.onSubmit();
            },
            child: Text(
              'Post it',
              style: headerTextFont,
            ))
      ],
    );
  }
}
