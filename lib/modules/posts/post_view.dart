import 'package:cheffy/modules/auth/auth/domain/entities/user_entity.dart';
import 'package:cheffy/modules/main/main_view_model.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/create_finding_post_params.dart';
import 'package:cheffy/modules/posts/posts/posts_provider.dart';
import 'package:cheffy/modules/widgets/post_listing_item/post_listing_item_vertical_layout_view.dart';
import 'package:cheffy/modules/widgets/progress/background_progress.dart';
import 'package:cheffy/widgets/app_drawer.dart';
import 'package:cheffy/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: mainViewModel.appBarTitle,
        onNotificationPressed: mainViewModel.onPressedNotifications,
      ),
      drawer: AppDrawer(),
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
                  final postItem = FindingPostParams.fromMap(_);
                  final user = UserEntity.fromMap(_);
                  print(postItem.userUID);
                  return PostListingItemVerticalLayoutView(
                    post: postItem, userEntity: user,
                    onPress: () {
                      //postsProvider.onTapPost(postItem); //TODO
                    },
                    // Users can't delete public posts
                    onDelete: null,
                  );
                },
              ),
      ),
    );
  }
}
