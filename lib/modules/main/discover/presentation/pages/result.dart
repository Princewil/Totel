import 'dart:math';
import 'package:card_swiper/card_swiper.dart';
import 'package:cheffy/modules/main/discover/presentation/search_provider.dart';
import 'package:cheffy/modules/main/map/map_view_model.dart';
import 'package:cheffy/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:we_slide/we_slide.dart';

import 'search_hotels_page.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late final controller = WeSlideController();

  late final footerController = WeSlideController(initial: true);
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
        appBar: SharedWidgets.buildHomeAppBar(title: selected!.title!),
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
                itemCount: selected!.images!.length,
                itemBuilder: (context, i) => imageView(selected!.images![i],
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
                    Text('Strand Place hotel',
                        style: headerTextFont.copyWith(fontSize: 16)),
                    if (smallScreen)
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 20),
                        child: Text(
                          selected!.title!,
                          style: headerTextFont.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                    if (smallScreen)
                      Row(
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
                                      "\$${Random().nextInt(100)}",
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
                              '2pm-3pm',
                              style: headerTextFont.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    if (!smallScreen) cost(),
                    overview(),
                    SizedBox(height: 50),
                    amenities(),
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

Widget cost() => Row(
      children: [
        Text(
          selected!.title!,
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

Widget overview() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Overview',
            style: headerTextFont.copyWith(fontSize: 16),
          ),
        ),
        Text(
          roomDescription,
          style: headerTextFont,
        )
      ],
    );

String roomDescription =
    'The living room is furnished with the standard-issue accoutrements supplied to all Victorian grandmothers; if only you could see any of them beneath the morass of doilies.\nThe living room was a rambling semicircle arranged around Grandmother’s vast paisley-print sofa. Sunlight, dappled and blued, filtered dirtily through the dusty lace curtains, highlighting the pits and scratches in the furniture (made of the broken bodies of distant forests), the doilies (made of wasted hours and old lace), and the photographs (made of stiff smiles and shadows on silver).';

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
