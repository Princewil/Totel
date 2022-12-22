import 'package:cheffy/Models/occupation.dart';
import 'package:cheffy/Utils/Utils.dart';
import 'package:cheffy/core/enums/male_female_enum.dart';
import 'package:cheffy/core/services/secure_storage_service.dart';
import 'package:cheffy/modules/auth/auth/domain/entities/user_entity.dart';
import 'package:cheffy/modules/main/profile/profile/domain/repositories/profile_repo.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/create_finding_post_params.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/post_entity.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/image_file.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:cheffy/app/app.locator.dart';
import 'package:cheffy/app/app.router.dart';

import '../../auth/register/register_form_view.dart';
import '../../widgets/post_listing_item/post_listing_item_vertical_layout_view.dart';

UserEntity? initialProfileDetails;

class ProfileProvider extends BaseViewModel {
  final NavigationService _navigationService = locator.get();
  final BottomSheetService _bottomSheetService = locator.get();
  final SnackbarService _snackbarService = locator.get();
  final SecureStorageService _secureStorageService = locator.get();
  List<PostViewParams>? postEntity = [];

  bool isLoading = false;

  late final FormGroup editProfileForm;

  bool _isMalePartner = true;
  bool _isFemalePartner = true;

  final ProfileRepo profileRepo;

  UserEntity? profileEntity;
  List<Occupation> occupations = [];

  ProfileProvider(this.profileRepo) {
    editProfileForm = FormGroup({
      ReactiveFormControls.firstName: FormControl(
          validators: [Validators.required],
          value: initialProfileDetails!.firstName),
      ReactiveFormControls.lastName: FormControl(
          validators: [Validators.required],
          value: initialProfileDetails?.lastName),
      ReactiveFormControls.country: FormControl(
          validators: [Validators.required],
          value: initialProfileDetails?.country),
      ReactiveFormControls.city: FormControl(
          validators: [Validators.required],
          value: initialProfileDetails?.city),
      ReactiveFormControls.hobbies: FormControl(
          validators: [Validators.required],
          value: initialProfileDetails?.hobbies),
      ReactiveFormControls.avatar: FormControl<ImageFile>(),
      ReactiveFormControls.occupation: FormControl<String>(
          validators: [Validators.required],
          value: initialProfileDetails?.occupation),
      ReactiveFormControls.bio: FormControl(
          validators: [Validators.required], value: initialProfileDetails?.bio),
      ReactiveFormControls.gender: FormControl(
        validators: [Validators.required],
      ),
    });
  }

  //region getters setters

  MaleFemaleEnum maleFemaleEnum = MaleFemaleEnum.male;

  void onMaleFemaleChoice(MaleFemaleEnum? selMaleFemaleEnum) {
    if (selMaleFemaleEnum != null) {
      maleFemaleEnum = selMaleFemaleEnum;
      notifyListeners();
    }
  }

  //endregion

  Future<void> getProfile() async {
    try {
      setBusy(true);
      profileEntity = await profileRepo.get();
      initialProfileDetails = profileEntity;
      // await _secureStorageService.setAppUser(profileEntity);
      notifyListeners();
    } catch (e) {
      _snackbarService.showSnackbar(
          title: 'Error', message: 'Something went wrong, please try again');
    } finally {
      setBusy(false);
    }
  }

  Future<void> getOccupations() async {
    try {
      setBusy(true);
      occupations = await profileRepo.getOccupations();
      notifyListeners();
    } catch (e) {
      _snackbarService.showSnackbar(
          title: 'Error', message: 'Something went wrong, please try again');
    } finally {
      setBusy(false);
    }
  }

  Future<void> onEditSave() async {
    try {
      setBusy(true);

      if (true //TODO
          ) {
        //for now no parameter is required
        final editedProfile = UserEntity(
          //id: profileEntity!.id,
          uid: initialProfileDetails!.uid,
          firstName:
              editProfileForm.control(ReactiveFormControls.firstName).value,
          lastName:
              editProfileForm.control(ReactiveFormControls.lastName).value,
          // username:
          //     "${editProfileForm.control(ReactiveFormControls.lastName).value} ${editProfileForm.control(ReactiveFormControls.firstName).value}",
          email: initialProfileDetails!.email,
          country: editProfileForm.control(ReactiveFormControls.country).value,
          bio: editProfileForm.control(ReactiveFormControls.bio).value,
          phoneNo: initialProfileDetails?.phoneNo,
          dateOfBrith: regDOB.toString(),
          avatar: initialProfileDetails?.avatar,
          city: editProfileForm.control(ReactiveFormControls.city).value,
          rating: profileEntity?.rating ?? 0,
          gender: maleFemaleRegEnum.toString(),
          createdAt: initialProfileDetails?.createdAt,
          updatedAt: DateTime.now().toString(),
          hobbies: editProfileForm.control(ReactiveFormControls.hobbies).value,
          occupation:
              editProfileForm.control(ReactiveFormControls.occupation).value,
          // occupation: Occupation(
          //   id: (editProfileForm.control(ReactiveFormControls.occupation).value
          //       as int),
          //   name: '',
          // ),
        );

        await profileRepo
            .update(
          editedProfile,
          newAvatar: (editProfileForm.control(ReactiveFormControls.avatar).value
                  as ImageFile?)
              ?.image,
        )
            .then((value) {
          if (value == null) {
            //it will be null when profile picture(if updated) was successfully uploaded
            _snackbarService.showSnackbar(
              title: 'Error',
              message: 'Something went wrong, please try again',
            );
            return;
          }
          profileEntity = value;
          initialProfileDetails = value;
          notifyListeners();
          _navigationService.back();
          return;
        });
      } else {
        editProfileForm.markAllAsTouched();
      }
    } catch (e) {
      print(e);
      _snackbarService.showSnackbar(
        title: 'Error',
        message: 'Something went wrong, please try again',
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> getUserPosts() async {
    try {
      setBusyForObject(postEntity, true);
      var _ = await profileRepo.getUserPosts();
      postEntity = _;
      notifyListeners();
    } catch (e) {
      _snackbarService.showSnackbar(
        title: 'Error',
        message: 'Something went wrong, please try again',
      );
    } finally {
      setBusyForObject(postEntity, false);
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      setBusyForObject(postEntity, true);
      await profileRepo.deletePostById(postId);

      // Remove the deleted post
      //postEntity!.posts.removeWhere((element) => element.id == postId); //TODO

      _snackbarService.showSnackbar(message: 'Post deleted successfully');

      notifyListeners();
    } catch (e) {
      print(e);
      _snackbarService.showSnackbar(
        title: 'Error',
        message: 'Something went wrong, post couldn\'t be deleted',
      );
    } finally {
      setBusyForObject(postEntity, false);
    }
  }

  void onShare() {}

  void onWallet() => _navigationService.navigateToWalletView();

  void onEdit() => _navigationService.navigateToEditProfileView();

  void onPosts() {}

  void onBookmark() {}

  void onMessage() {}

  void onTapPost() {}
}
