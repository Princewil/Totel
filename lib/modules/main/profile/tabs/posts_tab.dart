// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cheffy/modules/main/discover/presentation/pages/search_hotels_page.dart';
import 'package:cheffy/modules/main/profile/profile_provider.dart';
import 'package:cheffy/modules/posts/detail/post_detail_view.dart';
import 'package:cheffy/modules/widgets/post_listing_item/post_listing_item_vertical_layout_view.dart';
import 'package:cheffy/modules/widgets/progress/provider_progress_loader.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class PostsTab extends StatelessWidget {
  final List<PostViewParams>? postEntity;

  const PostsTab({
    Key? key,
    required this.postEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    return ProviderProgressLoader(
      isLoading: profileProvider.busy(profileProvider.postEntity),
      child: postEntity == null || postEntity!.isEmpty
          ? Center(
              child: Text('You don\'t have a post yet.', style: headerTextFont),
            )
          : ListView.builder(
              itemCount: postEntity!.length,
              itemBuilder: (context, i) {
                final post = postEntity![i];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: GestureDetector(
                    onTap: () {
                      postDetailViewuserEntity = initialProfileDetails;
                      profileProvider.onTapPost(post);
                    },
                    child: Card(
                      elevation: 10,
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: PostListingItemVerticalLayoutView(
                        post: post,
                        userEntity: initialProfileDetails!,
                        onDelete: () async {
                          await profileProvider
                              .deletePost(post.locationLatLng!);
                        },
                      ),
                    ),
                  ),
                );
              },
              // separatorBuilder: (BuildContext context, int index) {
              //   return Divider();
              // },
            ),
    );
  }
}
