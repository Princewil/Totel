import 'package:cheffy/firebase_method.dart';
import 'package:cheffy/modules/main/main_view.dart';
import 'package:cheffy/modules/posts/create/create_post_view.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/create_booked_post_params.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/create_finding_post_params.dart';
import 'package:cheffy/modules/posts/posts/domain/repositories/post_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:cheffy/app/app.locator.dart';
import 'package:cheffy/app/app.router.dart';
import 'package:cheffy/core/enums/post_type.dart';
import 'package:cheffy/core/methods/extensions.dart';
import 'package:cheffy/core/models/data/locations_entity.dart';

import '../../../core/enums/male_female_enum.dart';
import '../../location_change_map/location_change_map_view.dart';

class CreatePostViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator.get();
  final SnackbarService _snackbarService = locator.get();
  final DialogService _dialogService = locator.get();
  final PostRepo _postsRepo;

  final ImagePicker _imagePicker = ImagePicker();
  final PostType type;
  final controls = _Controls();

  late final FormGroup form;

  List<XFile?> _attachments = [null];
  bool _isMalePartner = true;
  bool _isFemalePartner = true;
  String? _avaliableHour;

  CreatePostViewModel(
    this.type,
    this._postsRepo,
  ) {
    switch (type) {
      case PostType.booked:
        form = FormGroup({
          controls.attachments:
              FormControl(validators: [_validatorAttachments]),
          controls.location: FormControl(validators: [validateLocation]),
          // controls.hourlyRange: FormControl(validators: [validateHourlyRange]),
          controls.date:
              FormControl<DateTimeRange>(validators: [Validators.required]),
          controls.hotel:
              FormControl<String>(validators: [Validators.required]),
          controls.rating: FormControl<double>(),
          controls.price:
              FormControl<double>(validators: [Validators.required]),
          controls.message:
              FormControl<String>(validators: [Validators.required]),
        });
        break;
      case PostType.finding:
        form = FormGroup({
          controls.location: FormControl(validators: [Validators.required]),
          controls.date:
              FormControl<DateTimeRange>(validators: [Validators.required]),
          controls.price: FormControl<double>(),
          controls.message: FormControl<String>(),
          controls.hourly: FormControl<bool>(),
        });
        break;
    }
  }

  //region getters setters

  bool get isMalePartner => _isMalePartner;

  set isMalePartner(bool isMalePartner) {
    _isMalePartner = isMalePartner;
    notifyListeners();
  }

  bool get isFemalePartner => _isFemalePartner;

  set isFemalePartner(bool isFemalePartner) {
    _isFemalePartner = isFemalePartner;
    notifyListeners();
  }

  List<XFile?> get attachments => _attachments;

  set attachments(List<XFile?> attachments) {
    _attachments = attachments;
    notifyListeners();
  }

  //endregion

  /// Validates that attachment control's attachment count should
  /// be minimum 1 or maximum 3
  Map<String, dynamic>? _validatorAttachments(
      AbstractControl<dynamic> control) {
    return attachments.isNotEmpty &&
            (attachments.where((element) => element != null).isNotEmpty &&
                attachments.where((element) => element != null).length <= 3)
        ? null
        : {'Minimum 1 or maximum 3 pictures must attach': true};
  }

  Map<String, dynamic>? validateLocation(AbstractControl<dynamic> control) {
    if (locationEntity == null) {
      return {"Please specify the location": true};
    } else
      return null;
  }

  // String? get setAvaliableHour => _avaliableHour;

  // set setAvaliableHour(String? val) {
  //   _avaliableHour = val;
  //   notifyListeners();
  // }

  // Map<String, dynamic>? validateHourlyRange(AbstractControl<dynamic> control) {
  //   if (setAvaliableHour == null) {
  //     return {"Please specify the avaliable hours": true};
  //   } else
  //     return null;
  // }

  double get partnerAmount =>
      (double.tryParse(form.control(controls.price).value.toString()) ?? 0) / 2;

  void onTapMalePartner(bool val) => isMalePartner = !val;

  void onTapFemalePartner(bool val) => isFemalePartner = !val;
  //void a(String val) => setAvaliableHour = val;

  void onSubmit() async {
    print(form.valid);
    // form.markAsUntouched();

/*
    print('form is valid: ${form.valid}');
    print('form is valid: ${type}');

    return;
*/
/*
    print('type is $type');
    print('type is ${form.value}');
    return;
*/
    if (form.valid) {
      postItController.start();
      // final attch = attachments
      //     .where((element) => element != null)
      //     .map((e) => e!)
      //     .toList(growable: false);
      setBusy(true);
      try {
        switch (type) {
          case PostType.booked:
            final selectedAttachments = attachments
                .where((element) => element != null)
                .map((e) => e!)
                .toList(growable: false);
            await _postsRepo.createBookedPost(
                CreateBookedPostParams(
                  hotelRating:
                      0, //form.control(controls.rating).value as double,
                  hourAvaliable: avaliableHour,
                  nameOfHotel: form.control(controls.hotel).value,
                  imagesURL: [],
                  userUID: currentUser()!.uid,
                  locationLatLng:
                      '${locationEntity!.latitude}~${locationEntity!.longitude}',
                  gender: _getGender(),
                  // location: _selectedLocation!.id.toString(),
                  notes: form.control(controls.message).value,
                  partnerAmount: form.control(controls.price).value as double,
                  dateFrom: form.control(controls.date).value.start.toString(),
                  dateTo: form.control(controls.date).value.end.toString(),
                  postType: bookingPostType,
                  booked: false,
                  bookerUID: '',
                ),
                files: selectedAttachments);
            break;
          case PostType.finding:
            await _postsRepo.createFindingPost(FindingPostParams(
              gender: _getGender(), alreadyBooked: false, bookUID: '',
              locationLatLng:
                  '${locationEntity!.latitude}~${locationEntity!.longitude}',
              userUID: currentUser()!.uid,
              // location: _selectedLocation!.id.toString(),
              notes: form.control(controls.message).value,
              partnerAmount: form.control(controls.price).value,
              dateFrom: form.control(controls.date).value.start.toString(),
              dateTo: form.control(controls.date).value.end.toString(),
              isAcceptHourly: form.control(controls.hourly).value != null
                  ? form.control(controls.hourly).value
                  : false,
              postType: findingPostType,
            ));

            break;
        }

        await _dialogService.showDialog(
            title: 'Create Post',
            description: 'Your post has been successfully created.');

        _navigationService.clearStackAndShow(Routes.mainView);
      } catch (e) {
        _snackbarService.showSnackbar(
            message: 'An error occured, please try again');
        rethrow;
      } finally {
        postItController.reset();
        setBusy(false);
      }
    } else {
      form.markAllAsTouched();
    }
  }

  String _getGender() {
    if (_isMalePartner && _isFemalePartner) {
      return '${MaleFemaleEnum.male}/${MaleFemaleEnum.female}';
    } else if (_isFemalePartner) {
      return MaleFemaleEnum.female.toString();
    } else {
      return MaleFemaleEnum.male.toString();
    }
  }

  void onPressedRemove(int index) {
    var att =
        List<XFile?>.from(attachments.where((element) => element != null));
    att.removeAt(index);

    int remaining = 3 - att.length;
    if (remaining > 0) {
      att.add(null);
    }

    attachments = att;
    form.control(controls.attachments).value = attachments;
  }

  void onPressedAdd() async {
    var att =
        List<XFile?>.from(attachments.where((element) => element != null));

    if (att.length < 2) {
      var res = await _imagePicker.pickMultiImage();

      if (res.isListNotEmptyOrNull) {
        int remaining = 3 - att.length;
        att.addAll(res.take(remaining));

        remaining = 3 - att.length;
        if (remaining > 0) {
          att.add(null);
        }

        attachments = att;
      }
    } else {
      var res = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (res != null) {
        var att = List<XFile?>.from(attachments);
        att.removeLast();
        att.add(res);

        int remaining = 3 - att.length;
        if (remaining > 0) {
          att.add(null);
        }

        attachments = att;
      }
    }

    form.control(controls.attachments).value = attachments;
  }

  void onLocation(
      //FormControl control
      ) {
    _navigationService.navigateToLocationChangeView();
  }
}

class _Controls {
  String get location => 'location';

  String get date => 'date';

  String get hotel => 'hotel';

  String get rating => 'rating';

  String get price => 'price';

  String get message => 'message';

  String get hourly => 'hourly';

  String get attachments => 'attachments';

  String get hourlyRange => 'hourly_range';
}
