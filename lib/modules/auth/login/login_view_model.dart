import 'package:cheffy/modules/auth/auth/domain/repositories/auth_repo.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:cheffy/app/app.locator.dart';
import 'package:cheffy/app/app.router.dart';

class LoginViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator.get();
  final AuthRepo authRepo;
  final SnackbarService _snackbarService = locator.get();

  final controls = _Controls();

  late final FormGroup form;

  bool _obscureText = true;

  LoginViewModel(
    this.authRepo,
  ) {
    form = FormGroup({
      controls.username: FormControl(
          value: 'usertest@gmail.com', asyncValidators: [_usernameValidation]),
      controls.password:
          FormControl(value: '123456', validators: [Validators.required]),
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
    // if (exp.allMatches((control.value as String)).isNotEmpty) {
    //   try {
    //     var phoneNumber = PhoneNumber.fromRaw(control.value);
    //     if (!phoneNumber.validate(type: PhoneNumberType.mobile)) {
    //       control.markAsTouched();
    //       return phoneError;
    //     }
    //   } catch (e) {
    //     control.markAsTouched();
    //     return phoneError;
    //   }
    // }

    return null;
  }

  Future<void> onSubmit() async {
    try {
      if (form.valid) {
        setBusy(true);
        final result = await authRepo.loginWithEmail(
            form.control(controls.username).value,
            form.control(controls.password).value);
        if (result is bool) {
          _navigationService.clearStackAndShow(Routes.mainView);
        } else {
          _snackbarService.showSnackbar(
            title: 'Wrong Credentials',
            message: 'E-mail or password is wrong',
          );
        }

        // Goes to Main Screen
        _navigationService.clearStackAndShow(Routes.mainView);

        setBusy(false);
      } else {
        form.markAllAsTouched();
      }
    } catch (e) {
      setBusy(false);
      _snackbarService.showSnackbar(
        title: 'Wrong Credentials',
        message: 'E-mail or password is wrong',
      );
    }
  }

  void onGoogle() async {
    try {
      setBusy(true);
      bool _success = await authRepo.continueWithGoogleAccnt();
      if (_success) {
        // _navigationService.navigateToMainView();
        _navigationService.clearStackAndShow(Routes.mainView);
      } else {
        setBusy(false);
        _snackbarService.showSnackbar(
            message: 'An error occured. Try again later');
      }
    } catch (e) {
      setBusy(true);
      _snackbarService.showSnackbar(message: e.toString());
    }
  }

  void onFacebook() async {
    try {
      //await authRepo.signInWithGoogle();
    } catch (e) {
      _snackbarService.showSnackbar(message: e.toString());
    }
  }

  void onRegister() => _navigationService.navigateToRegisterView();

  void onShowPassword() => obscureText = !obscureText;

  void onResetPassword() {
    _navigationService.navigateTo(Routes.resetPasswordView);
  }
}

class _Controls {
  String get username => 'username';

  String get password => 'password';
}
