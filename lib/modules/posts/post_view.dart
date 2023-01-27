import 'package:cheffy/modules/auth/auth/domain/entities/user_entity.dart';
import 'package:cheffy/modules/main/main_view_model.dart';
import 'package:cheffy/modules/posts/create/create_post_functions.dart';
import 'package:cheffy/modules/posts/posts/posts_provider.dart';
import 'package:cheffy/modules/widgets/post_listing_item/post_listing_item_vertical_layout_view.dart';
import 'package:cheffy/modules/widgets/progress/background_progress.dart';
import 'package:cheffy/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../Utils/Utils.dart';
import '../main/discover/presentation/pages/search_funct.dart';
import '../main/discover/presentation/pages/search_hotels_page.dart';
import '../main/discover/presentation/search_provider.dart';
import 'detail/post_detail_view.dart';

class PostsPageView extends StatefulWidget {
  const PostsPageView({super.key});

  @override
  State<PostsPageView> createState() => _PostsPageViewState();
}

class _PostsPageViewState extends State<PostsPageView> {
  String searchKey = '';
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
    final searchProvider = context.watch<SearchProvider>();
    return Scaffold(
      // appBar: SharedWidgets.buildHomeAppBar(
      //   //title: mainViewModel.appBarTitle,
      //   title: "Home",
      //   showBackBotton: false,
      //   onNotificationPressed: mainViewModel.onPressedNotifications,
      // ),
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
            : Column(
                children: [
                  SizedBox(height: kToolbarHeight),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          //height: kToolbarHeight,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: TextFormField(
                              maxLines: 1,
                              onChanged: (v) => searchKey = v,
                              decoration: InputDecoration(
                                hintText: 'Search anywhere',
                                hintStyle:
                                    headerTextFont.copyWith(color: Colors.grey),
                                prefixIcon:
                                    Icon(Icons.search_outlined, size: 30),
                                suffix: InkWell(
                                  child: Icon(Icons.forward),
                                  onTap: () {
                                    if (searchKey.isNotEmpty) {
                                      searchVal = searchKey;
                                      KeyboardUtil.hideKeyboard(context);
                                      searchProvider
                                          .onNormalSearchLocationSubmit();
                                      return;
                                    }
                                    Get.showSnackbar(GetSnackBar(
                                      title: 'First input your search detail',
                                      duration: Duration(seconds: 2),
                                    ));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: IconButton(
                            onPressed: () {
                              if (searchKey.isNotEmpty) {
                                searchVal = searchKey;
                                KeyboardUtil.hideKeyboard(context);
                                searchProvider.onAdvancedSearchLocationSubmit();
                              }
                            },
                            visualDensity: VisualDensity.compact,
                            icon: Icon(Icons.tune_rounded, size: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: postsProvider.postEntity!.length,
                      itemBuilder: (context, i) {
                        final _ = postsProvider.postEntity![i];
                        final postItem = PostViewParams.fromMap(_);
                        final user = UserEntity.fromMap(_);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
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
                ],
              ),
      ),
    );
  }
}
