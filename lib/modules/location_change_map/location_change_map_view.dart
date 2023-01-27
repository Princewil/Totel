import 'package:cheffy/Utils/theme/styles.dart';
import 'package:cheffy/core/services/location_service.dart';
import 'package:cheffy/modules/location_change/location_change_view.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:stacked/stacked.dart';
import 'package:cheffy/r.g.dart';
import 'package:cheffy/modules/theme/color.dart';
import 'package:cheffy/modules/widgets/app_bar_action_button.dart';

import '../../core/models/data/locations_entity.dart';
import '../main/discover/presentation/pages/search_hotels_page.dart';
import 'location_change_map_view_model.dart';

class LocationChangeMapView
    extends ViewModelBuilderWidget<LocationChangeMapViewModel> {
  const LocationChangeMapView({super.key});

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget builder(BuildContext context, LocationChangeMapViewModel viewModel,
      Widget? child) {
    return Material(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: viewModel.onMapCreated,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  myLocationEnabled: true,
                  circles: location != null
                      ? {
                          Circle(
                              circleId: CircleId('C'),
                              radius: 50,
                              strokeColor: Colors.black.withOpacity(0.8),
                              strokeWidth: 20,
                              center: LatLng(
                                  location!.latitude, location!.longitude))
                        }
                      : {},
                  markers: location != null
                      ? {
                          Marker(
                            markerId: MarkerId('value'),
                            icon: BitmapDescriptor.defaultMarker,
                            position:
                                LatLng(location!.latitude, location!.longitude),
                          ),
                        }
                      : {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Select your location',
                      style: AppStyle.of(context)
                          .b5M
                          .wCRhythm!
                          .merge(headerTextFont),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       'Select your location',
                    //       style: AppStyle.of(context)
                    //           .b5M
                    //           .wCRhythm!
                    //           .merge(headerTextFont),
                    //     ),
                    //     const SizedBox(width: 8),
                    //     OutlinedButton(
                    //       //onPressed: widget.viewModel.onPressedChanged,
                    //       onPressed: () {
                    //         locationFromAddress(
                    //                 "Golden royale hotels enugu nigeria ")
                    //             .then((value) {
                    //           print(value.length);
                    //           print(value.first.latitude);
                    //           print(value.first.longitude);
                    //           placemarkFromCoordinates(value.first.latitude,
                    //                   value.first.longitude)
                    //               .then((value) {
                    //             print(value.first.street);
                    //             print(value.first.country);
                    //             print(value.first.name);
                    //             print(value.first.subLocality);
                    //             print(value.first.subAdministrativeArea);
                    //           });
                    //         });
                    //       },
                    //       style: OutlinedButton.styleFrom(
                    //         visualDensity: VisualDensity.compact,
                    //         side: BorderSide(color: AppColors.soap),
                    //       ),
                    //       child: Text(
                    //         'Change',
                    //         style: AppStyle.of(context)
                    //             .b5M
                    //             .wCChineseBlack!
                    //             .merge(headerTextFont),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 16),
                    LocationDetails(viewModel: viewModel),
                    const SizedBox(height: 16),
                    // ElevatedButton(
                    //   onPressed: viewModel.onSubmit,
                    //   child: const Text('Confirm Location'),
                    // ),
                    RoundedLoadingButton(
                        controller: RoundedLoadingButtonController(),
                        onPressed: viewModel.onSubmit,
                        animateOnTap: false,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Confirm Location',
                          style: headerTextFont,
                        ))
                  ],
                ),
              ),
            ],
          ),
          const Positioned(
            left: 8,
            top: 32,
            child: AppBarActionButton(),
          ),
        ],
      ),
    );
  }

  @override
  LocationChangeMapViewModel viewModelBuilder(BuildContext context) =>
      LocationChangeMapViewModel();
}

LocationEntity? locationEntity;

class LocationDetails extends StatefulWidget {
  final LocationChangeMapViewModel viewModel;
  LocationDetails({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  List<Placemark> locationInfo = [];
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Placemark? _info;
  getCurrentLocation() async {
    await Future.delayed(Duration(seconds: 3));
    if (location != null) {
      locationInfo = await placemarkFromCoordinates(
          location!.latitude, location!.longitude);
      _info = locationInfo.first;
      locationEntity = LocationEntity(
          name: fullAddress(_info!),
          latitude: location!.latitude,
          longitude: location!.longitude);
    } else {
      Position myLocation = await LocationService().determinePosition();
      locationInfo = await placemarkFromCoordinates(
          myLocation.latitude, myLocation.longitude);
      _info = locationInfo.first;
      locationEntity = LocationEntity(
          name: fullAddress(_info!),
          latitude: myLocation.latitude,
          longitude: myLocation.longitude);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                minLeadingWidth: 0,
                //horizontalTitleGap: 10,
                isThreeLine: false,
                leading: Image(
                  image: R.svg.ic_location(width: 17, height: 20),
                ),
                title: Text(
                  locationInfo.isEmpty
                      // ? 'Miami - Florida'
                      ? ' - '
                      : '${_info!.street}, ${_info!.subLocality}, ${_info!.subAdministrativeArea}',
                  style: AppStyle.of(context)
                      .b3B
                      .wCChineseBlack!
                      .merge(normaltextFont),
                  softWrap: true,
                ),
              ),
              // Row(
              //   children: [
              //     Image(
              //       image: R.svg.ic_location(width: 17, height: 20),
              //     ),
              //     const SizedBox(width: 8),
              //     Text(
              //       locationInfo.isEmpty
              //           // ? 'Miami - Florida'
              //           ? ' - '
              //           : '${_info!.street}, ${_info!.subLocality}, ${_info!.subAdministrativeArea}',
              //       style: AppStyle.of(context)
              //           .b3B
              //           .wCChineseBlack!
              //           .merge(normaltextFont),
              //       softWrap: true,
              //     ),
              //   ],
              // ),
              const SizedBox(height: 10),
              Text(
                locationInfo.isEmpty
                    // ? '4425 SW 8th St, Coral Gables, FL 33134'
                    ? ' - '
                    : fullAddress(_info!),
                style: AppStyle.of(context).b5.wCRhythm!.merge(headerTextFont),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String fullAddress(Placemark _info) =>
    "${_info.street}, ${_info.subLocality}, ${_info.subAdministrativeArea}, ${_info.administrativeArea}, ${_info.locality}, ${_info.country}";
