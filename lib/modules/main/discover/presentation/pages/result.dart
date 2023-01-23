import 'dart:async';
import 'dart:math';
import 'package:card_swiper/card_swiper.dart';
import 'package:cheffy/Utils/Utils.dart';
import 'package:cheffy/app/constants/common_constants.dart';
import 'package:cheffy/core/enums/male_female_enum.dart';
import 'package:cheffy/core/enums/post_type.dart';
import 'package:cheffy/core/services/location_service.dart';
import 'package:cheffy/firebase_method.dart';
import 'package:cheffy/modules/location_change_map/location_change_map_view.dart';
import 'package:cheffy/modules/main/discover/presentation/pages/search_funct.dart';
import 'package:cheffy/modules/main/map/map_view_model.dart';
import 'package:cheffy/modules/posts/detail/post_detail_view.dart';
import 'package:cheffy/modules/theme/styles.dart';
import 'package:cheffy/modules/widgets/post_listing_item/post_listing_item_vertical_layout_view.dart';
import 'package:cheffy/pay.dart';
import 'package:cheffy/widgets/shared_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:stacked/stacked.dart';
import 'package:we_slide/we_slide.dart';

import '../../../main_view.dart';
import 'search_hotels_page.dart';

class Result extends StatefulWidget {
  final PostViewParams postViewParams;
  const Result({Key? key, required this.postViewParams}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

bool? isFind;
double? lat;
double? lng;

class _ResultState extends State<Result> {
  late final controller = WeSlideController();
  bool loadingPayment = false;
  String address = '';
  late final footerController = WeSlideController(initial: true);
  @override
  void initState() {
    super.initState();
    lat =
        double.parse(widget.postViewParams.locationLatLng!.split(split).first);
    lng = double.parse(widget.postViewParams.locationLatLng!.split(split).last);
    destination = LatLng(lat!, lng!);
    placemarkFromCoordinates(lat!, lng!)
        .then((value) => setState(() => address = fullAddress(value.first)));
  }

  @override
  Widget build(BuildContext context) {
    isFind = widget.postViewParams.postType!.toLowerCase() == 'find';
    return Scaffold(
      body: WeSlide(
        controller: controller,
        footerController: footerController,
        hidePanelHeader: true,
        panelMinSize: 0,
        parallax: true,
        footerHeight: MediaQuery.of(context).size.height * 0.08,
        panelMaxSize: MediaQuery.of(context).size.height * 0.9,
        blur: true,
        overlay: true,
        overlayOpacity: 0.4,
        blurSigma: 30,
        appBar: SharedWidgets.buildHomeAppBar(
            title: isFind!
                ? 'Finding travel partner'
                : widget.postViewParams.nameOfHotel ?? '',
            showBackBotton: true),
        backgroundColor: Theme.of(context).canvasColor,
        isUpSlide: false,
        panel: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: SizedBox(
                child: DirectionFullpage(),
                height: MediaQuery.of(context).size.height),
          ),
        ),
        footer: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          elevation: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () async {
                    if (loadingPayment &&
                            widget.postViewParams.userUID ==
                                currentUser()!.uid ||
                        widget.postViewParams.bookerUID == currentUser()!.uid) {
                      return;
                    }
                    try {
                      loadingPayment = true;
                      setState(() {});
                      await makePayment(
                        widget.postViewParams.partnerAmount.toString(),
                        widget.postViewParams.locationLatLng!,
                      );
                      await next(context);
                    } catch (e) {
                      loadingPayment = false;
                      setState(() {});
                    }
                  },
                  child: loadingPayment
                      ? Center(
                          child: const CupertinoActivityIndicator(
                              color: Colors.white))
                      : Text('Book now',
                          style: headerTextFont.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: widget.postViewParams.userUID ==
                                          currentUser()!.uid ||
                                      widget.postViewParams.bookerUID ==
                                          currentUser()!.uid
                                  ? Colors.grey.shade200
                                  : null,
                              letterSpacing: 2)),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100, 150),
                    primary:
                        widget.postViewParams.userUID == currentUser()!.uid ||
                                widget.postViewParams.bookerUID ==
                                    currentUser()!.uid
                            ? Colors.grey
                            : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextButton(
                    // onPressed: () => controller.show(),
                    onPressed: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (context) => DirectionFullpage())),
                    style: TextButton.styleFrom(
                      fixedSize: Size(100, 150),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    child:
                        Text('View on map', style: headerTextFont.copyWith())),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (isFind!) findPostTypeWidget(),
              if (!isFind!)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Swiper(
                      itemCount: widget.postViewParams.imagesURL!.length,
                      itemBuilder: (context, i) => imageView(
                          widget.postViewParams.imagesURL![i],
                          BorderRadius.all(Radius.circular(20))),
                      curve: Curves.easeIn,
                      autoplayDisableOnInteraction: false,
                      itemHeight: 400,
                      // autoplay: true,
                      itemWidth: double.infinity,
                      layout: SwiperLayout.TINDER,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50)
                          .copyWith(top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //if (smallScreen)
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 10),
                            child: Text(
                              widget.postViewParams.nameOfHotel!,
                              style: headerTextFont.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                          Text(address,
                              style: headerTextFont.copyWith(fontSize: 16)),
                          //if (smallScreen)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 8),
                            child: Row(
                              children: [
                                Card(
                                  color: iconColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            "\$${widget.postViewParams.partnerAmount}",
                                            style: headerTextFont.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '${UniversalVariables.dayMonthDateFormat.format(DateTime.tryParse(widget.postViewParams.dateFrom!)!)} - ${UniversalVariables.dayMonthDateFormat.format(DateTime.tryParse(widget.postViewParams.dateTo!)!)}',
                                    style: headerTextFont.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                              '${widget.postViewParams.hourAvaliable!} each day',
                              // widget.postViewParams.hourAvaliable != null &&
                              //         widget.postViewParams.hourAvaliable != ''
                              //     ? 'Avaliable Hours: ${widget.postViewParams.hourAvaliable}'
                              //     : 'Avaliable Hours: $allDayAvaliable',
                              style: headerTextFont),
                          SizedBox(height: 30),
                          // if (!smallScreen)
                          //   cost(widget
                          //       .postViewParams), //TODO: i will remove this code, i am owk with the ui for small screen
                          Divider(),
                          overview(widget.postViewParams.notes!),
                          Divider(),
                          SizedBox(height: 40),
                          owner(context),
                          SizedBox(height: 40)
                          //amenities(),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget findPostTypeWidget() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50).copyWith(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            owner(context),
            Divider(),
            ListTile(
              visualDensity: VisualDensity.compact,
              horizontalTitleGap: 0,
              minLeadingWidth: 0,
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              subtitle: Text('Traveling details:', style: headerTextFont),
            ),
            Text(address, style: headerTextFont.copyWith(fontSize: 16)),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 8),
              child: Row(
                children: [
                  Card(
                    color: iconColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "\$${widget.postViewParams.partnerAmount}",
                              style: headerTextFont.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '${UniversalVariables.dayMonthDateFormat.format(DateTime.tryParse(widget.postViewParams.dateFrom!)!)} - ${UniversalVariables.dayMonthDateFormat.format(DateTime.tryParse(widget.postViewParams.dateTo!)!)}',
                      style:
                          headerTextFont.copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Text('${widget.postViewParams.hourAvaliable!} each day',
                // widget.postViewParams.hourAvaliable == null &&
                //         widget.postViewParams.hourAvaliable != ''
                //     ? '${widget.postViewParams.hourAvaliable!} each day'
                // : allDayAvaliable,
                style: headerTextFont),
            Divider(),
            overview(widget.postViewParams.notes!),
          ],
        ),
      );
}

Widget cost(PostViewParams postViewParams) => Row(
      children: [
        Text(
          postViewParams.nameOfHotel!,
          style: headerTextFont.copyWith(
              fontWeight: FontWeight.bold, fontSize: 17),
        ),
        Spacer(),
        Card(
          color: iconColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "\$${Random().nextInt(100)}",
                    style: headerTextFont.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                Text(
                  '2pm-3pm',
                  style: headerTextFont.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        )
      ],
    );

Widget amenities() {
  Widget iconDecor(IconData icons) => Card(
        color: iconColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Icon(icons, color: Colors.white),
          ),
        ),
      );
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Amenities:',
          style: headerTextFont.copyWith(fontSize: 16),
        ),
      ),
      Row(
        children: [
          iconDecor(Icons.wifi),
          Spacer(),
          iconDecor(Icons.tv),
          Spacer(),
          iconDecor(Icons.laptop),
          Spacer(),
          iconDecor(Icons.phone_android_outlined),
          Spacer(flex: 15),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "- Smoke detector\n- Carbon monoxide",
              style: headerTextFont,
            ),
            Spacer(),
            Text(
              "- Private entrance\n- Air conditioning",
              style: headerTextFont,
            ),
            Spacer(),
            Spacer(flex: 15),
          ],
        ),
      ),
    ],
  );
}

Widget owner(BuildContext context) {
  String occupation = postDetailViewuserEntity?.occupation != ''
      ? 'Occupation: ${postDetailViewuserEntity?.occupation}'
      : '';
  String bio = postDetailViewuserEntity?.bio != ''
      ? 'Bio: ${postDetailViewuserEntity?.bio}'
      : '';
  String hobbies = postDetailViewuserEntity?.hobbies != ''
      ? 'Hobbies: ${postDetailViewuserEntity?.hobbies}'
      : '';
  String gender = postDetailViewuserEntity?.gender != ''
      ? 'Gender: ${postDetailViewuserEntity?.gender == MaleFemaleEnum.male.toString() ? 'Male' : 'Female'}'
      : '';
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          isFind! ? 'Profile' : 'Roommate profile:',
          style: headerTextFont.copyWith(fontSize: 16),
        ),
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
        leading: CircleAvatar(
          backgroundImage: postDetailViewuserEntity!.avatar != null &&
                  postDetailViewuserEntity!.avatar != ''
              ? NetworkImage(postDetailViewuserEntity!.avatar!)
              : null,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          radius: 24,
        ),
        title: Text(
          '${postDetailViewuserEntity!.firstName} ${postDetailViewuserEntity!.lastName}',
          style: AppStyle.of(context).b4M.wCChineseBlack!.merge(headerTextFont),
        ),
        subtitle: Text(
          '$gender\n$occupation\n$bio\n$hobbies',
          style: AppStyle.of(context).b6.wCCrayola!.merge(headerTextFont),
        ),
      ),
    ],
  );
}

Widget overview(String note) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Notes:',
            style: headerTextFont.copyWith(fontSize: 16),
          ),
        ),
        Text(
          note,
          style: headerTextFont,
        )
      ],
    );

Future next(BuildContext context) async => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline_rounded,
                    size: 100, color: Colors.green),
                Text('You have succesfully booked!', style: headerTextFont),
                RoundedLoadingButton(
                    controller: RoundedLoadingButtonController(),
                    animateOnTap: false,
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainView()),
                        (route) => false),
                    child: Text('Alright!', style: headerTextFont))
              ],
            ),
          ),
        ));

class Direction extends ViewModelBuilderWidget<MapViewModel> {
  const Direction({Key? key}) : super(key: key);

  static CameraPosition _kGooglePlex = CameraPosition(
    //target: LatLng(lat!, lng!),
    target: LatLng(destination!.latitude, destination!.longitude),
    zoom: 14.5,
  );

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        rotateGesturesEnabled: true,
        circles: {
          Circle(
              circleId: CircleId('circleId'),
              radius: 100,
              strokeColor: Colors.blue.withOpacity(0.3),
              fillColor: Colors.blue.withOpacity(0.3),
              center: LatLng(destination!.latitude, destination!.longitude))
        },
        //onMapCreated: viewModel.onMapCreated,
        polylines: {
          // Polyline(polylineId: PolylineId('route'), points: polyLineCoordinates)
        },
        markers: {
          // Marker(
          //     markerId: MarkerId('Current_Location'),
          //     //position: LatLng(lat!, lng!),
          //     position: d,
          //     icon: BitmapDescriptor.defaultMarkerWithHue(
          //         BitmapDescriptor.hueBlue)),
          Marker(
              markerId: MarkerId('Destination'),
              //position: LatLng(lat!, lng!),
              position: LatLng(destination!.latitude, destination!.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet)),
        },
      ),
    );
  }

  @override
  MapViewModel viewModelBuilder(BuildContext context) => MapViewModel();
}

class DirectionFullpage extends StatefulWidget {
  DirectionFullpage({Key? key}) : super(key: key);

  @override
  State<DirectionFullpage> createState() => _DirectionFullpageState();
}

class _DirectionFullpageState extends State<DirectionFullpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Direction(),
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight),
            Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_rounded))),
          ],
        ),
      )
    ]));
  }
}

// class NewGooglemap extends StatefulWidget {
//   NewGooglemap({Key? key}) : super(key: key);

//   @override
//   State<NewGooglemap> createState() => _NewGooglemapState();
// }

// class _NewGooglemapState extends State<NewGooglemap> {
//   List<LatLng> polyLineCoordinates = [];
//   Position? currentPosition;
//   final Completer<GoogleMapController> contr = Completer();
//   getPolyPoints() async {
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         googleApiKey,
//         PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
//         PointLatLng(destination!.latitude, destination!.longitude));
//     if (result.points.isNotEmpty) {
//       for (var e in result.points) {
//         polyLineCoordinates.add(LatLng(e.latitude, e.longitude));
//       }
//     }
//     setState(() {});
//   }

//   getLoc() async {
//     try {
//       await LocationService().determinePosition();
//       currentPosition = await Geolocator.getCurrentPosition();
//       GoogleMapController mapController = await contr.future;
//       getPolyPoints();
//       Geolocator.getPositionStream().listen((e) {
//         currentPosition = e;
//         mapController.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               zoom: 14.5,
//               target: LatLng(e.latitude, e.longitude),
//             ),
//           ),
//         );
//         setState(() {});
//       });
//     } catch (e) {}
//   }

//   @override
//   void initState() {
//     super.initState();
//     getLoc();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           currentPosition == null
//               ? Center(
//                   child: Text(
//                     'Loading...',
//                     style: headerTextFont,
//                   ),
//                 )
//               : GoogleMap(
//                   onMapCreated: (c) {
//                     contr.complete(c);
//                   },
//                   initialCameraPosition: CameraPosition(
//                     //target: LatLng(lat!, lng!),
//                     target: LatLng(
//                         currentPosition!.latitude, currentPosition!.longitude),
//                     zoom: 14.5,
//                   ),
//                   zoomControlsEnabled: true,
//                   zoomGesturesEnabled: true,
//                   scrollGesturesEnabled: true,
//                   rotateGesturesEnabled: true,
//                   polylines: {
//                     Polyline(
//                       polylineId: PolylineId('route'),
//                       points: polyLineCoordinates,
//                       color: Colors.red,
//                     )
//                   },
//                   markers: {
//                     Marker(
//                         markerId: MarkerId('CurrentLocation'),
//                         //position: LatLng(lat!, lng!),
//                         position: LatLng(currentPosition!.latitude,
//                             currentPosition!.longitude),
//                         icon: BitmapDescriptor.defaultMarkerWithHue(
//                             BitmapDescriptor.hueBlue)),
//                     Marker(
//                         markerId: MarkerId('Destination'),
//                         //position: LatLng(lat!, lng!),
//                         position: destination!,
//                         icon: BitmapDescriptor.defaultMarkerWithHue(
//                             BitmapDescriptor.hueBlue)),
//                   },
//                 ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10),
//             child: Column(
//               children: [
//                 SizedBox(height: kToolbarHeight),
//                 Card(
//                     elevation: 5,
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(20))),
//                     child: IconButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         icon: Icon(Icons.arrow_back_rounded))),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

LatLng? destination;
