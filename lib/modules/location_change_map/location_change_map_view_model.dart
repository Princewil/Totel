import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:cheffy/app/app.locator.dart';
import 'package:cheffy/app/app.router.dart';
import 'package:cheffy/core/services/location_service.dart';

import '../../core/enums/post_type.dart';
import '../location_change/location_change_view.dart';
import 'location_change_map_view.dart';

Location? location;

class LocationChangeMapViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator.get();
  final LocationService _locationService = locator.get();
  final DialogService _dialogService = locator.get();

  late final GoogleMapController _controller;

  void onTapSetCurrentLocation() =>
      _navigationService.navigateToLocationChangeMapView();

  void onPressedChanged() {}

  void onSubmit() {
    //_navigationService.back(result: locationEntity);
    _navigationService.navigateToCreatePostView(type: PostType.finding);
  }

  void onPressedBack() => _navigationService.back();

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
    if (location != null) {
      _navigateToLocation(location!);
    } else {
      _navigateToCurrent();
    }
  }

  void _navigateToCurrent() {
    _locationService.determinePosition().then((value) {
      _controller.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(value.latitude, value.longitude), 14));
    },
        onError: (error) =>
            _dialogService.showDialog(description: error.toString()));
  }

  void _navigateToLocation(Location location) {
    _locationService.determinePosition().then((_) {
      _controller.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(location.latitude, location.longitude), 14));
    },
        onError: (error) =>
            _dialogService.showDialog(description: error.toString()));
  }
}
