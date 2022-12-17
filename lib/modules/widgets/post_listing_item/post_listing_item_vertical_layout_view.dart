import 'package:carousel_slider/carousel_slider.dart';
import 'package:cheffy/Utils/Utils.dart';
import 'package:cheffy/firebase_method.dart';
import 'package:cheffy/modules/auth/auth/domain/entities/user_entity.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/create_finding_post_params.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/post_entity.dart';
import 'package:flutter/material.dart';
import 'package:cheffy/r.g.dart';
import 'package:cheffy/modules/theme/color.dart';
import 'package:cheffy/modules/theme/styles.dart';

class PostListingItemVerticalLayoutView extends StatefulWidget {
  final FindingPostParams post;
  final VoidCallback? onPress;
  final VoidCallback? onDelete;

  const PostListingItemVerticalLayoutView({
    super.key,
    required this.post,
    this.onPress,
    this.onDelete,
  });

  @override
  State<PostListingItemVerticalLayoutView> createState() =>
      _PostListingItemVerticalLayoutViewState();
}

class _PostListingItemVerticalLayoutViewState
    extends State<PostListingItemVerticalLayoutView> {
  UserEntity? userEntity;
  @override
  void initState() {
    super.initState();
  }

  init() async {
    var user = await getUserPostDetails(widget.post.userUID!);
    userEntity = UserEntity.fromMap(user!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      child: Padding(
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
                        backgroundImage: NetworkImage(userEntity?.avatar ?? ''),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        radius: 24,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userEntity?.firstName} ${userEntity?.lastName}',
                            style: AppStyle.of(context).b4M.wCChineseBlack,
                          ),
                          Text(
                            userEntity?.occupation ?? '',
                            style: AppStyle.of(context).b6.wCCrayola,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
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
            Text(
              widget.post.notes ?? '',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 260,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // TODO
                  // widget.post.attachments.isEmpty
                  //     ? ClipRRect(
                  //         borderRadius: BorderRadius.circular(
                  //           UniversalVariables.kPostRadius,
                  //         ),
                  //         child: Image.network(
                  //           widget.post.hotel.imageUrl,
                  //           fit: BoxFit.fill,
                  //         ),
                  //       )
                  //     : CarouselSlider.builder(
                  //         options: CarouselOptions(
                  //           height: 240,
                  //           autoPlay: true,
                  //           enableInfiniteScroll: false,
                  //           enlargeCenterPage: true,
                  //         ),
                  //         itemCount: widget.post.attachments.length,
                  //         itemBuilder: (context, int i, int pageViewIndex) {
                  //           final attach = widget.post.attachments[i];
                  //           return ClipRRect(
                  //             borderRadius: BorderRadius.circular(
                  //               UniversalVariables.kPostRadius,
                  //             ),
                  //             child: Image.network(
                  //               attach.url,
                  //               fit: BoxFit.fill,
                  //             ),
                  //           );
                  //         },
                  //       ),
                  // if (widget.post.hotel.rating != null)
                  //   Positioned(
                  //     top: 8,
                  //     right: 8,
                  //     child: Chip(
                  //       label: Text(
                  //        // widget.post.hotel.rating.toString(),
                  //          'RRRR',
                  //         style: AppStyle.of(context).b5M.wCWhite,
                  //       ),
                  //       avatar: Image(
                  //         image: R.svg.ic_user_filled(width: 14, height: 14),
                  //       ),
                  //       backgroundColor: widget.post.hotel.rating! >= 3
                  //           ? AppColors.ratingNormal
                  //           : AppColors.ratingLow,
                  //     ),
                  //   ),
                  // Positioned(
                  //   left: 12,
                  //   bottom: 12,
                  //   child: Chip(
                  //     label: Text(
                  //      // widget.post.postingType,
                  //        'RRRR',
                  //       style: AppStyle.of(context).b5M.wCWhite,
                  //     ),
                  //     backgroundColor: AppColors.plumpPurplePrimary,
                  //   ),
                  // ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    '${UniversalVariables.dayMonthDateFormat.format(DateTime.tryParse(widget.post.dateFrom!)!)} - ${UniversalVariables.dayMonthDateFormat.format(DateTime.tryParse(widget.post.dateTo!)!)}',
                    style: AppStyle.of(context).b5M.wCChineseBlack,
                  ),
                  side: BorderSide(color: AppColors.soap),
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                Chip(
                  label: Text(
                    //widget.post.hotel.type ?? '',
                    'RRRR',
                    style: AppStyle.of(context).b5M.wCChineseBlack,
                  ),
                  side: BorderSide(color: AppColors.soap),
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Partner Gender: ${widget.post.gender}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.of(context).b4.wCDarkGunmetal,
            ),
            const SizedBox(height: 8),
            Text(
              //'${widget.post.hotel.name}, ${widget.post.location}',
              'FFFFF',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.of(context).b3B.wCChineseBlack,
            ),
            Text(
              '\$${widget.post.partnerAmount!.toStringAsFixed(2)} / Night',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.of(context).b4B.wCChineseBlack,
            ),
          ],
        ),
      ),
    );
  }
}
