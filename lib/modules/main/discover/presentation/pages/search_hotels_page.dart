import 'dart:math';
import 'package:animations/animations.dart';
import 'package:cheffy/modules/main/discover/presentation/pages/result.dart';
import 'package:cheffy/modules/main/discover/presentation/pages/search_funct.dart';
import 'package:cheffy/modules/main/discover/presentation/search_provider.dart';
import 'package:cheffy/modules/widgets/post_listing_item/post_listing_item_vertical_layout_view.dart';
import 'package:cheffy/widgets/shared_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_fade/image_fade.dart';

class SearchHotelsPage extends StatefulWidget {
  const SearchHotelsPage({super.key});

  @override
  State<SearchHotelsPage> createState() => _SearchHotelsPageState();
}

class _SearchHotelsPageState extends State<SearchHotelsPage> {
  bool loading = true;
  bool error = false;
  List<QueryDocumentSnapshot> list = [];
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    loading = true;
    error = false;
    setState(() {});
    try {
      list = await normalSearch();
      loading = false;
      setState(() {});
    } catch (e) {
      print(e);
      loading = false;
      error = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedWidgets.buildHomeAppBar(
          title: 'Discover Hotels', showBackBotton: true),
      body: loading
          ? Center(child: CupertinoActivityIndicator())
          // : error
          //     ? Center(
          //         child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text('An error occurred', style: headerTextFont),
          //           TextButton(
          //               onPressed: init,
          //               child: Text('Try again', style: headerTextFont))
          //         ],
          //       ))
          : list.isEmpty || error
              ? Center(
                  child: Text(
                    'No results found!\nEnsure you provide enough address information as possible.',
                    style: headerTextFont,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int i) {
                    PostViewParams item = PostViewParams.fromMap(
                        list[i].data() as Map<String, dynamic>);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 30),
                      child: OpenContainer(
                        openBuilder: (_, __) {
                          return Result(postViewParams: item);
                        },
                        closedBuilder: (_, openContainer) {
                          return GestureDetector(
                            onTap: openContainer,
                            child: Container(
                              height: smallScreen
                                  ? MediaQuery.of(context).size.height * 0.45
                                  : MediaQuery.of(context).size.height * 0.35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.all(
                                    width: 1.5, color: Colors.blueGrey),
                              ),
                              child: Column(
                                children: [
                                  Flexible(
                                    child: imageView(
                                        item.imagesURL!.first,
                                        BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20)),
                                        alreadyLoaded: false),
                                    flex: 4,
                                  ),
                                  if (smallScreen)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: ListTile(
                                        title: Text(item.nameOfHotel!,
                                            style: headerTextFont),
                                        subtitle: Text(
                                            resultAddressFromLatLng[i],
                                            style: headerTextFont),
                                        trailing: Text(
                                            "\$${item.partnerAmount}",
                                            style: headerTextFont.copyWith(
                                                fontSize: 16)),
                                      ),
                                    ),
                                  if (smallScreen)
                                    ListTile(
                                      title: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              //size: 30,
                                              color: iconColor,
                                            ),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(left: 2.0),
                                          //   child: Text(
                                          //     '${Random().nextInt(50)} km from here',
                                          //     style: headerTextFont.copyWith(),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                  if (!smallScreen)
                                    Flexible(
                                      child: roomDetails(
                                          context,
                                          item.nameOfHotel!,
                                          resultAddressFromLatLng[i]),
                                    ),
                                  if (!smallScreen)
                                    Flexible(
                                      child: distance(),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                        closedElevation: 0,
                        transitionType: ContainerTransitionType.fadeThrough,
                        closedShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        transitionDuration: const Duration(milliseconds: 700),
                      ),
                    );
                  },
                ),
    );
  }
}

Widget imageView(String image, BorderRadius borderRadius,
    {bool alreadyLoaded = true}) {
  return ClipRRect(
    clipBehavior: Clip.antiAlias,
    borderRadius: borderRadius,
    child: ImageFade(
      image: NetworkImage(image),
      curve: Curves.linear,
      fit: BoxFit.cover,
      syncDuration: alreadyLoaded ? Duration.zero : null,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      placeholder: Container(
        child: Center(child: Icon(Icons.image)),
        color: Colors.grey[300],
        width: double.infinity,
        height: double.infinity,
      ),
      loadingBuilder: (_, __, ___) => SizedBox(),
      errorBuilder: (context, error) => Container(
        child: Center(child: Icon(Icons.error, color: Colors.red)),
        color: Colors.grey[300],
        width: double.infinity,
        height: double.infinity,
      ),
    ),
  );
}

Widget roomDetails(BuildContext context, String title, String subtitle) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Container(
                  child: Text(
                    subtitle,
                    style: headerTextFont,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                ),
              ],
            ),
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${Random().nextInt(100)}',
                  style: headerTextFont.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 25)),
              Text("Hours avaliable: 2pm-5pm", style: normaltextFont)
            ],
          )
        ],
      ),
    );

Widget distance() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(width: 1.3, color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Icon(
                Icons.location_on_outlined,
                size: 30,
                color: iconColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              '${Random().nextInt(50)} km from here',
              style: headerTextFont.copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );

//Font style for Logo
final logoFont = GoogleFonts.rubik();

//Font style for normal text
final normaltextFont = GoogleFonts.nunito();

//Font style for other text
final headerTextFont = GoogleFonts.varelaRound();
const iconColor = const Color.fromARGB(255, 39, 82, 176);
