import 'package:cheffy/ui/views/main/map/map_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_phone_form_field/reactive_phone_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:cheffy/app/app.locator.dart';
import 'package:cheffy/app/app.router.dart';
import 'package:cheffy/core/services/authentication_service.dart';

class LoginViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator.get();
  final AuthenticationService _authenticationService = locator.get();
  final SnackbarService _snackbarService = locator.get();

  final controls = _Controls();

  late final FormGroup form;

  bool _obscureText = true;

  LoginViewModel() {
    form = FormGroup({
      controls.username: FormControl(
          value: 'testuser1@mail.com', asyncValidators: [_usernameValidation]),
      controls.password:
          FormControl(value: '456456', validators: [Validators.required]),
    });
  }

  //region getters setters

  bool get obscureText => _obscureText;

  set obscureText(bool obscureText) {
    _obscureText = obscureText;
    notifyListeners();
  }

  //endregion

  Future<Map<String, dynamic>?> _usernameValidation(
      AbstractControl<dynamic> control) async {
    final emailError = {'Invalid email address': false};
    final phoneError = {'Invalid phone number': false};

    var error = Validators.required(control);

    if (error != null) {
      return error;
    }

    // email validation
    if (control.value is String && (control.value as String).contains('@')) {
      control.markAsTouched();
      return Validators.email(control);
    }

    RegExp exp = RegExp(r'[\s\d\+]+');
    if (exp.allMatches((control.value as String)).isNotEmpty) {
      try {
        var phoneNumber = PhoneNumber.fromRaw(control.value);
        if (!phoneNumber.validate(type: PhoneNumberType.mobile)) {
          control.markAsTouched();
          return phoneError;
        }
      } catch (e) {
        control.markAsTouched();
        return phoneError;
      }
    }

    return null;
  }

  void onSubmit() {
    if (form.valid) {
      setBusy(true);
      _authenticationService
          .logInUser(form.control(controls.username).value,
              form.control(controls.password).value)
          .then((value) => _navigationService.navigateToMainView(),
              onError: (error) {
        _navigationService.navigateToMainView();
        _snackbarService.showSnackbar(message: error.toString());
      }).whenComplete(() => setBusy(false));
    } else {
      form.markAllAsTouched();
    }
  }

  void onGoogle() async {
    try {
      await _authenticationService.signInWithGoogle();
    } catch (e) {
      _snackbarService.showSnackbar(message: e.toString());
    }
  }

  void onFacebook() async {
    try {
      await _authenticationService.signInWithGoogle();
    } catch (e) {
      _snackbarService.showSnackbar(message: e.toString());
    }
  }

  void onRegister() => _navigationService.navigateToRegisterView();

  void onShowPassword() => obscureText = !obscureText;

  void onResetPassword() {}
}

class _Controls {
  String get username => 'username';

  String get password => 'password';
}
