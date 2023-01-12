import 'package:carousel_slider/carousel_slider.dart';
import 'package:cheffy/Utils/Utils.dart';
import 'package:cheffy/core/enums/male_female_enum.dart';
import 'package:cheffy/firebase_method.dart';
import 'package:cheffy/modules/auth/auth/domain/entities/user_entity.dart';
import 'package:cheffy/modules/main/discover/presentation/pages/search_hotels_page.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/create_finding_post_params.dart';
import 'package:flutter/material.dart';
import 'package:cheffy/modules/theme/color.dart';
import 'package:cheffy/modules/theme/styles.dart';

import '../../posts/posts/domain/entities/create_booked_post_params.dart';

class PostListingItemVerticalLayoutView extends StatefulWidget {
  final PostViewParams post;
  final UserEntity userEntity;
  final VoidCallback? onPress;
  final VoidCallback? onDelete;

  const PostListingItemVerticalLayoutView({
    super.key,
    required this.post,
    this.onPress,
    this.onDelete,
    required this.userEntity,
  });

  @override
  State<PostListingItemVerticalLayoutView> createState() =>
      _PostListingItemVerticalLayoutViewState();
}

class _PostListingItemVerticalLayoutViewState
    extends State<PostListingItemVerticalLayoutView> {
  String? getGender(String param) {
    if (param.contains(MaleFemaleEnum.female.toString()) &&
        param.contains(MaleFemaleEnum.female.toString())) {
      return 'Males/Females';
    } else if (param.contains(MaleFemaleEnum.female.toString())) {
      return 'Females';
    } else
      return 'Males';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: widget.userEntity.avatar != null &&
                              widget.userEntity.avatar != ''
                          ? NetworkImage(widget.userEntity.avatar!)
                          : null,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      radius: 24,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.userEntity.firstName} ${widget.userEntity.lastName}',
                          style: AppStyle.of(context)
                              .b4M
                              .wCChineseBlack!
                              .merge(headerTextFont),
                        ),
                        Text(
                          widget.userEntity.occupation ?? '',
                          style: AppStyle.of(context)
                              .b6
                              .wCCrayola!
                              .merge(headerTextFont),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              (widget.post.alreadyBoooked != null &&
                          widget.post.alreadyBoooked == true) ||
                      (widget.post.bookerUID == currentUser()!.uid)
                  ? Card(
                      color: Colors.deepOrange,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Text('Booked',
                                style: headerTextFont.copyWith(
                                    color: Colors.white)),
                            SizedBox(width: 3),
                            Icon(Icons.check_circle,
                                color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    )
                  : PopupMenuButton<String>(
                      elevation: 16,
                      color: AppColors.soap,
                      itemBuilder: (context) {
                        return [
                          if (widget.onPress != null)
                            PopupMenuItem(
                              child: Text('View'),
                              onTap: widget.onPress,
                            ),
                          if (widget.onDelete != null)
                            PopupMenuItem(
                              child: Text('Delete'),
                              onTap: widget.onDelete,
                            ),
                        ];
                      },
                    ),
            ],
          ),
          SizedBox(height: 8),
          // Text(
          //   widget.post.notes ?? '',
          //   style: headerTextFont.copyWith(fontSize: 20),
          // ),
          // SizedBox(height: 8),
          Container(
            height: widget.post.postType == bookingPostType ? 260 : 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                widget.post.imagesURL!.length == 1
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          UniversalVariables.kPostRadius,
                        ),
                        child: Image.network(
                          widget.post.imagesURL![0],
                          fit: BoxFit.fill,
                        ),
                      )
                    : CarouselSlider.builder(
                        options: CarouselOptions(
                          height: 240,
                          autoPlay: true,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                        ),
                        itemCount: widget.post.imagesURL!.length,
                        itemBuilder: (context, int i, int pageViewIndex) {
                          final attach = widget.post.imagesURL![i];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(
                              UniversalVariables.kPostRadius,
                            ),
                            child: Image.network(
                              attach,
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                      ),
                // if (widget.post.postType == bookingPostType)
                //   Positioned(
                //     top: 8,
                //     right: 8,
                //     child: Chip(
                //       label: Text(
                //         widget.post.hotelRating.toString(),
                //         style: AppStyle.of(context)
                //             .b5M
                //             .wCWhite!
                //             .merge(headerTextFont),
                //       ),
                //       avatar: Image(
                //         image: R.svg.ic_user_filled(width: 14, height: 14),
                //       ),
                //       backgroundColor: widget.post.hotelRating! >= 3
                //           ? AppColors.ratingNormal
                //           : AppColors.ratingLow,
                //     ),
                //   ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Chip(
                    label: Text(
                      widget.post.postType == bookingPostType
                          ? 'In-search of a roommate'
                          : 'In-search of a travel partner',
                      style: AppStyle.of(context).b5M.wCWhite,
                    ),
                    backgroundColor: AppColors.plumpPurplePrimary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                //TODO: dont forget to include avaliable hours for the booked type
                label: Text(
                  '${UniversalVariables.dayMonthDateFormat.format(DateTime.tryParse(widget.post.dateFrom!)!)} - ${UniversalVariables.dayMonthDateFormat.format(DateTime.tryParse(widget.post.dateTo!)!)}',
                  style: AppStyle.of(context)
                      .b5M
                      .wCChineseBlack!
                      .merge(headerTextFont),
                ),
                side: BorderSide(color: AppColors.soap),
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              SizedBox(width: 10),
              Chip(
                label: Text(
                  // widget.post.hourAvaliable == null &&
                  //         widget.post.hourAvaliable != ''
                  //     ? '${widget.post.hourAvaliable!} each day'
                  //     : allDayAvaliable,
                  '${widget.post.hourAvaliable!} each day',
                  style: AppStyle.of(context)
                      .b5M
                      .wCChineseBlack!
                      .merge(headerTextFont),
                ),
                side: BorderSide(color: AppColors.soap),
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Text(
          //   'Partner Gender: ${getGender(widget.post.gender!)}',
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          //   style:
          //       AppStyle.of(context).b4.wCDarkGunmetal!.merge(headerTextFont),
          // ),
          //const SizedBox(height: 8),
          if (widget.post.postType == bookingPostType)
            Text(
              '${widget.post.nameOfHotel}', //TODO add location
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.of(context)
                  .b3B
                  .wCChineseBlack!
                  .merge(headerTextFont.copyWith(fontWeight: FontWeight.w600)),
            ),
          Text(
            '${widget.post.postType == bookingPostType ? "Cost:" : "Budget:"} \$${widget.post.partnerAmount!.toStringAsFixed(2)} / Night',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.of(context)
                .b4B
                .wCChineseBlack!
                .merge(headerTextFont.copyWith(fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}

String x = '24 hours each day';

class PostViewParams {
  bool? isAcceptHourly;
  String? dateFrom;
  String? dateTo;
  String? gender;
  String? notes;
  num? partnerAmount;
  String? locationLatLng;
  String? userUID;
  String? postType;
  String? nameOfHotel;
  List<String>? imagesURL;
  num? hotelRating;
  String? hourAvaliable;
  String? bookerUID;
  bool? alreadyBoooked;

  PostViewParams({
    this.isAcceptHourly,
    this.dateFrom,
    this.dateTo,
    this.gender,
    this.notes,
    this.partnerAmount,
    this.locationLatLng,
    this.userUID,
    this.postType,
    this.hotelRating,
    this.imagesURL,
    this.nameOfHotel,
    this.hourAvaliable,
    this.alreadyBoooked,
    this.bookerUID,
  });

  Map<String, dynamic> toMap(PostViewParams params) => {
        postNoteKey: params.notes,
        partnerAmountKey: params.partnerAmount,
        allowedGenderKey: params.gender,
        locationLatLngKey: params.locationLatLng,
        dateFromKey: params.dateFrom,
        dateToKey: params.dateTo,
        isAccptHourKey: params.isAcceptHourly,
        userUIDkey: params.userUID,
        postTypeKey: params.postType,
        imagesKey: params.imagesURL,
        hotelRatekey: params.hotelRating,
        hoursRangeKey: params.hourAvaliable,
        nameOfHotelKey: params.nameOfHotel,
        bookerUIDKey: params.bookerUID,
        alreadyBookedKey: params.alreadyBoooked,
      };

  PostViewParams.fromMap(Map<String, dynamic> map) {
    this.notes = map[postNoteKey];
    this.partnerAmount = map[partnerAmountKey];
    this.gender = map[allowedGenderKey];
    this.locationLatLng = map[locationLatLngKey];
    this.dateFrom = map[dateFromKey];
    this.dateTo = map[dateToKey];
    this.isAcceptHourly = map[isAccptHourKey];
    this.userUID = map[userUIDkey];
    this.postType = map[postTypeKey];
    this.imagesURL = List<String>.from(map[imagesKey] ?? []);
    this.hotelRating = map[hotelRatekey] ?? 0;
    this.hourAvaliable = map[hoursRangeKey];
    this.nameOfHotel = map[nameOfHotelKey];
    this.bookerUID = map[bookerUIDKey];
    this.alreadyBoooked = map[alreadyBookedKey];
  }
}
