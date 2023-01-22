import 'package:cheffy/modules/auth/auth/domain/entities/user_entity.dart';
import 'package:cheffy/modules/main/main_view_model.dart';
import 'package:cheffy/modules/posts/posts/posts_provider.dart';
import 'package:cheffy/modules/widgets/post_listing_item/post_listing_item_vertical_layout_view.dart';
import 'package:cheffy/modules/widgets/progress/background_progress.dart';
import 'package:cheffy/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../Utils/Utils.dart';
import '../main/discover/presentation/pages/search_hotels_page.dart';
import 'detail/post_detail_view.dart';

class PostsPageView extends StatefulWidget {
  const PostsPageView({super.key});

  @override
  State<PostsPageView> createState() => _PostsPageViewState();
}

class _PostsPageViewState extends State<PostsPageView> {
  @override
  void initState() {
    super.initState();
    final postsProvider = context.read<PostsProvider>();
    Future.delayed(
      Duration.zero,
      () {
        postsProvider.getPosts();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainViewModel = context.watch<MainViewModel>();
    final postsProvider = context.watch<PostsProvider>();
    return Scaffold(
      appBar: SharedWidgets.buildHomeAppBar(
        //title: mainViewModel.appBarTitle,
        title: "Home",
        showBackBotton: false,
        onNotificationPressed: mainViewModel.onPressedNotifications,
      ),
      //drawer: AppDrawer(),
      body: BackgroundProgress<PostsProvider>(
        child: postsProvider.postEntity == null ||
                postsProvider.postEntity!.isEmpty
            ? Center(
                child: Text(
                  'No posts available, please try again later',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: postsProvider.postEntity!.length,
                itemBuilder: (context, i) {
                  final _ = postsProvider.postEntity![i];
                  final postItem = PostViewParams.fromMap(_);
                  final user = UserEntity.fromMap(_);
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: GestureDetector(
                      onTap: () {
                        postDetailViewuserEntity = user;
                        postsProvider.onTapPost(postItem);
                      },
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: PostListingItemVerticalLayoutView(
                          post: postItem, userEntity: user,
                          onPress: () {
                            postDetailViewuserEntity = user;
                            postsProvider.onTapPost(postItem);
                          },
                          // Users can't delete public posts
                          onDelete: null,
                        ),
                      ),
                    ),
                  );
                },
                // separatorBuilder: (BuildContext context, int index) {
                //   return Divider();
                // },
              ),
      ),
    );
  }
}
