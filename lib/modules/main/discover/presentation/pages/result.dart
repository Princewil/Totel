import 'dart:math';
import 'package:card_swiper/card_swiper.dart';
import 'package:cheffy/Utils/Utils.dart';
import 'package:cheffy/core/enums/male_female_enum.dart';
import 'package:cheffy/modules/location_change_map/location_change_map_view.dart';
import 'package:cheffy/modules/main/discover/presentation/pages/search_funct.dart';
import 'package:cheffy/modules/main/map/map_view_model.dart';
import 'package:cheffy/modules/posts/detail/post_detail_view.dart';
import 'package:cheffy/modules/theme/styles.dart';
import 'package:cheffy/modules/widgets/post_listing_item/post_listing_item_vertical_layout_view.dart';
import 'package:cheffy/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:we_slide/we_slide.dart';

import 'search_hotels_page.dart';

class Result extends StatefulWidget {
  final PostViewParams postViewParams;
  const Result({Key? key, required this.postViewParams}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late final controller = WeSlideController();
  String address = '';
  late final footerController = WeSlideController(initial: true);
  @override
  void initState() {
    super.initState();
    placemarkFromCoordinates(
            double.parse(
                widget.postViewParams.locationLatLng!.split(split).first),
            double.parse(
                widget.postViewParams.locationLatLng!.split(split).last))
        .then((value) => setState(() => address = fullAddress(value.first)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WeSlide(
        controller: controller,
        footerController: footerController,
        hidePanelHeader: true,
        panelMinSize: 0,
        footerHeight: MediaQuery.of(context).size.height * 0.08,
        panelMaxSize: MediaQuery.of(context).size.height * 0.6,
        blur: true,
        overlay: true,
        overlayOpacity: 0.4,
        blurSigma: 30,
        appBar: SharedWidgets.buildHomeAppBar(
            title: widget.postViewParams.nameOfHotel ?? ''),
        backgroundColor: Theme.of(context).canvasColor,
        isUpSlide: false,
        panel: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: SizedBox(
                child: Direction(), height: MediaQuery.of(context).size.width),
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
                  onPressed: () {},
                  child: Text('Book now',
                      style: headerTextFont.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: 2)),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100, 150),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextButton(
                    onPressed: () => controller.show(),
                    style: TextButton.styleFrom(
                      fixedSize: Size(100, 150),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    child: Text('Get direction',
                        style: headerTextFont.copyWith(letterSpacing: 1.5))),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
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
                    Text(address, style: headerTextFont.copyWith(fontSize: 16)),
                    //if (smallScreen)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 8),
                      child: Row(
                        children: [
                          Card(
                            color: iconColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
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
                        'Avaliable Hours: ${widget.postViewParams.hourAvaliable != null && widget.postViewParams.hourAvaliable != '' ? widget.postViewParams.hourAvaliable : allDayAvaliable}',
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
        ),
      ),
    );
  }
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
          'Roommate profile:',
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

class Direction extends ViewModelBuilderWidget<MapViewModel> {
  const Direction({Key? key}) : super(key: key);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget builder(BuildContext context, viewModel, Widget? child) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        onMapCreated: viewModel.onMapCreated,
      ),
    );
  }

  @override
  MapViewModel viewModelBuilder(BuildContext context) => MapViewModel();
}
