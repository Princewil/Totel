import 'package:cheffy/modules/main/discover/presentation/pages/search_hotels_page.dart';
import 'package:cheffy/modules/posts/create/create_post_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:stacked/stacked.dart';
import 'package:cheffy/core/models/data/locations_entity.dart';
import 'package:cheffy/r.g.dart';
import 'package:cheffy/modules/theme/color.dart';
import 'package:cheffy/modules/theme/styles.dart';
import 'package:cheffy/modules/widgets/stream_widget.dart';

import '../location_change_map/location_change_map_view.dart';
import '../location_change_map/location_change_map_view_model.dart';
import 'location_change_view_model.dart';

class LocationChangeView
    extends ViewModelBuilderWidget<LocationChangeViewModel> {
  const LocationChangeView({super.key});

  @override
  Widget builder(
      BuildContext context, LocationChangeViewModel viewModel, Widget? child) {
    return MyWidget(viewModel: viewModel);
  }

  @override
  LocationChangeViewModel viewModelBuilder(BuildContext context) =>
      LocationChangeViewModel();

  @override
  void onViewModelReady(LocationChangeViewModel viewModel) => viewModel.init();
}

class MyWidget extends StatefulWidget {
  final LocationChangeViewModel viewModel;
  const MyWidget({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<Placemark> result = [];
  List<Map<String, dynamic>> resultLatLng = [];
  bool error = false;
  final String locKey = 'location';
  final String placesKey = 'Places';
  String? _address;
  bool _searching = false;
  searchForLocation(String address) async {
    result.clear();
    error = false;
    _searching = true;
    setState(() {});
    var _result = await locationFromAddress(address).catchError((e) {
      error = true;
      _searching = false;
      setState(() {});
    });
    if (error) {
      return;
    }
    for (var element in _result) {
      var _places =
          await placemarkFromCoordinates(element.latitude, element.longitude);
      result.addAll(_places);
      resultLatLng.add({placesKey: _places.toList(), locKey: element});
    }
    setState(() {
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set your location',
          style: headerTextFont.copyWith(fontWeight: FontWeight.w400),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                style: headerTextFont,
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.send,
                onChanged: (val) {
                  _address = val;
                },
                onSubmitted: (val) => searchForLocation(val),
                decoration: InputDecoration(
                    hintText: 'Find Location',
                    filled: true,
                    fillColor: AppColors.soap,
                    hintStyle: AppStyle.of(context)
                        .b4
                        .wCCrayola!
                        .merge(headerTextFont),
                    suffix: GestureDetector(
                      child: FaIcon(FontAwesomeIcons.arrowRight, size: 16),
                      onTap: () {
                        if (_address != null && _address != '')
                          searchForLocation(_address!);
                      },
                    ),
                    prefixIcon: Image(
                      image: R.svg.ic_search(width: 24, height: 24),
                    )),
              ),
              const SizedBox(height: 8),
              ListTile(
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.zero,
                leading: Image(
                  alignment: Alignment.centerLeft,
                  image: R.svg.ic_current_location(width: 34, height: 34),
                ),
                title: Text(
                  'Use my current location',
                  style: AppStyle.of(context)
                      .b4M
                      .wCPlumpPurplePrimary!
                      .merge(headerTextFont),
                ),
                subtitle: Text(
                  'Using GPS',
                  style:
                      AppStyle.of(context).b5.wCCrayola!.merge(normaltextFont),
                ),
                onTap: () {
                  location = null;
                  widget.viewModel.onTapSetCurrentLocation();
                },
              ),
              Divider(
                thickness: 3,
                color: AppColors.soap,
              ),
              const SizedBox(height: 12),
              Text(
                'Search result',
                style: AppStyle.of(context).b5.wCRhythm!.merge(headerTextFont),
              ),
              Expanded(
                child: _searching
                    ? Center(
                        child: Text('Searching, please wait...',
                            style: headerTextFont),
                      )
                    : error
                        ? Center(
                            child: Text('An error occured, please try again...',
                                style: headerTextFont),
                          )
                        : ListView.separated(
                            itemCount: result.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider();
                            },
                            itemBuilder: (BuildContext context, int i) {
                              var _item = result[i];
                              return ListTile(
                                minLeadingWidth: 0,
                                title: Text(fullAddress(_item),
                                    style: headerTextFont),
                                trailing: Icon(Icons.location_on_outlined),
                                onTap: () {
                                  KeyboardUtil.hideKeyboard(context);
                                  var loc = resultLatLng.firstWhere((element) =>
                                      element[placesKey].toList().contains(
                                          _item)); //TODO: Compare accurately or better still get the the LatLng by calling geo location
                                  location = loc[locKey] as Location;
                                  widget.viewModel.onTapSetCurrentLocation();
                                },
                              );
                            },
                          ),
                // child: StreamWidget<List<LocationEntity>>(
                //   stream: viewModel.locations,
                //   done: (data) => ListView.separated(
                //     itemCount: data?.length ?? 0,
                //     separatorBuilder: (context, index) => Divider(
                //       color: AppColors.soap,
                //     ),
                //     itemBuilder: (context, index) => ListTile(
                //       visualDensity: VisualDensity.compact,
                //       contentPadding: EdgeInsets.zero,
                //       title: Text(
                //         data![index].name,
                //         style: AppStyle.of(context).b4M.wCChineseBlack,
                //       ),
                //       onTap: () =>
                //           viewModel.onTapLocationItem(index, data[index]),
                //     ),
                //   ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
