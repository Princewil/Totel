import 'package:cheffy/Utils/stacked_nav_keys.dart';
import 'package:cheffy/core/exceptions/custom_exceptions.dart';
import 'package:cheffy/firebase_method.dart';
import 'package:cheffy/modules/auth/auth/domain/repositories/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_phone_form_field/reactive_phone_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:cheffy/app/app.locator.dart';
import 'package:cheffy/app/app.router.dart';

import '../auth/domain/entities/user_entity.dart';
import 'register_form_view.dart';

class RegisterViewModel extends BaseViewModel {
  UserEntity userEntity() {
    var now = DateTime.now();
    return UserEntity(
      avatar: '',
      bio: accountForm.control(controls.bio).value ?? '',
      city: accountForm.control(controls.city).value ?? '',
      country: accountForm.control(controls.contry).value ?? '',
      createdAt: now.toString(),
      dateOfBrith: regDOB.toString(),
      email: currentUser()?.email ?? '',
      firstName: accountForm.control(controls.firstName).value ?? '',
      gender: maleFemaleRegEnum.toString(),
      hobbies: accountForm.control(controls.hobbies).value ?? '',
      lastName: accountForm.control(controls.lastName).value ?? '',
      occupation: accountForm.control(controls.occupation).value ?? '',
      phoneNo: accountForm.control(controls.phone).value?.toString() ?? '',
      rating: 0,
      uid: currentUser()?.uid ?? '',
      updatedAt: now.toString(),
    );
  }

  RegisterViewModel(this.authRepo) {
    accountForm = FormGroup(
      {
        controls.firstName: FormControl<String>(validators: [
          Validators.required,
        ]),
        controls.lastName: FormControl<String>(validators: [
          Validators.required,
        ]),
        controls.city: FormControl<String>(validators: [
          Validators.required,
        ]),
        controls.contry: FormControl<String>(validators: [
          Validators.required,
        ]),
        controls.bio: FormControl<String>(),
        controls.hobbies: FormControl<String>(),
        controls.occupation: FormControl<String>(),
        // controls.email: FormControl<String>(validators: [
        //   Validators.required,
        //   Validators.email,
        // ]),
        // controls.password: FormControl<String>(validators: [
        //   Validators.required,
        //   Validators.minLength(6),
        // ]),
        //controls.confirmPassword: FormControl<String>(),
        controls.phone: FormControl<PhoneNumber>(validators: [
          Validators.required,
          // Validators.maxLength(12),
          // Validators.minLength(10),
        ]),
      },
      validators: [
        //Validators.mustMatch(controls.password, controls.confirmPassword),
      ],
    );
  }

  final NavigationService _navigationService = locator.get();
  final SnackbarService _snackbarService = locator.get();

  FirebaseAuth auth = FirebaseAuth.instance;

  final controls = _Controls();

  final AuthRepo authRepo;

  late FormGroup accountForm;

  String _verificationId = "";
  int? _resendToken;

  bool _obscureText = true;

  //region getters setters

  bool get obscureText => _obscureText;

  set obscureText(bool obscureText) {
    _obscureText = obscureText;
    notifyListeners();
  }

  //endregion

  void onShowPassword() => obscureText = !obscureText;

  void onSubmitOtp() => _navigationService.navigateToNestedRegisterFormView(
      routerId: StackedNavKeys.registerNavKey);

  Future onRegisterSubmit() async {
    try {
      if (accountForm.valid) {
        if (maleFemaleRegEnum == null) {
          _snackbarService.showSnackbar(
              message: 'You forgot to state your gender');
          return;
        }
        setBusy(true);
        await Future.delayed(Duration(seconds: 2));
        final phoneNumberWithCountryCode = '+' +
            accountForm.control(controls.phone).value.countryCode +
            accountForm.control(controls.phone).value.nsn;
        await authRepo.sendOtp(
          phoneNumber: phoneNumberWithCountryCode,
          onVerificationCompleted: (PhoneAuthCredential credential) async {
            //await auth.signInWithCredential(credential);
            await authRepo.createWithEmail(
                // email: accountForm.control(controls.email).value,
                // password: accountForm.control(controls.password).value,
                // firstName: accountForm.control(controls.firstName).value,
                // lastName: accountForm.control(controls.lastName).value,
                // phoneNumber: phoneNumberWithCountryCode,
                userEntity: userEntity());
            _navigationService.clearStackAndShow(Routes.mainView);
          },
          onVerificationFailed: (FirebaseAuthException e) {
            _snackbarService.showSnackbar(
              title: "Wrong Credentials - ${e.code}",
              message: "${e.message}",
            );
          },
          onCodeSent: (String verificationId, int? resendToken) async {
            _verificationId = verificationId;
            _resendToken = resendToken;

            final otpArg = await _navigationService.navigateToOTPView();

            await signInWithFirebaseCredentials(
                otpArg, phoneNumberWithCountryCode);
          },
          forceResendingToken: _resendToken,
          onCodeAutoRetrievalTimeout: (String verificationId) {
            verificationId = _verificationId;
          },
        );
      } else {
        accountForm.markAllAsTouched();
        return false;
      }
    } on UserAlreadyRegisteredException catch (e) {
      _snackbarService.showSnackbar(message: 'User is already registered');
      return false;
    } on FirebaseAuthException catch (e) {
      _snackbarService.showSnackbar(
        title: 'Wrong OTP',
        message: 'Wrong OTP, please try again',
      );
      return false;
    } catch (e) {
      _snackbarService.showSnackbar(
        title: 'Error',
        message: 'Something went wrong, please try again',
      );
      return false;
    } finally {
      setBusy(false);
    }
  }

  void onLogin() => _navigationService.back();

  Future<void> signInWithFirebaseCredentials(
      String otp, String phoneNumberWithCountryCode) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: otp.toString(),
    );
    // Sign the user in (or link) with the credential
    //await auth.signInWithCredential(credential);

    // final registerMsg = await authRepo.register(
    //   email: accountForm.control(controls.email).value,
    //   password: accountForm.control(controls.password).value,
    //   firstName: accountForm.control(controls.firstName).value,
    //   lastName: accountForm.control(controls.lastName).value,
    // );

    var registerMsg = await authRepo.createWithEmail(
        // email: accountForm.control(controls.email).value,
        // password: accountForm.control(controls.password).value,
        // firstName: accountForm.control(controls.firstName).value,
        // lastName: accountForm.control(controls.lastName).value,
        // phoneNumber: phoneNumberWithCountryCode,
        userEntity: userEntity());
    _navigationService.clearStackAndShow(Routes.mainView);
    //_snackbarService.showSnackbar(message: registerMsg.toString());
  }
}

class _Controls {
  String get phone => 'phone';

  String get firstName => 'first_name';

  String get lastName => 'last_name';
  String get city => 'city';
  String get contry => 'Country';
  String get bio => 'Bio';
  String get occupation => 'Occupation';
  String get hobbies => 'Hobbies';

  // String get email => 'email';

  // String get password => 'password';
  // String get confirmPassword => 'confirmPassword';
}
