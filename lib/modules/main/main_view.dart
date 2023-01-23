import 'package:cheffy/Utils/key.dart';
import 'package:cheffy/Utils/stacked_nav_keys.dart';
import 'package:cheffy/core/enums/male_female_enum.dart';
import 'package:cheffy/firebase_method.dart';
import 'package:cheffy/modules/auth/register/register_form_view.dart';
import 'package:cheffy/modules/main/discover/presentation/pages/search_hotels_page.dart';
import 'package:cheffy/modules/main/profile/profile_provider.dart';
import 'package:cheffy/modules/main/profile/profile_view.dart';
import 'package:cheffy/modules/main/profile/tabs/posts_tab.dart';
import 'package:cheffy/modules/posts/post_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:cheffy/modules/theme/color.dart';
import 'package:cheffy/modules/theme/styles.dart';

import '../../../app/app.router.dart';
import '../auth/auth/domain/entities/user_entity.dart';
import '../widgets/post_listing_item/post_listing_item_vertical_layout_view.dart';
import 'main_view_model.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  int currentPage = 0;
  late TabController _tabController =
      TabController(length: 3, vsync: this, initialIndex: currentPage);
  late List<Widget> _pages = [
    PostsPageView(),
    PostsAddTab(),
    ProfileView(),
  ];
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final result = await getUserDetails();
    initialProfileDetails = UserEntity.fromMap(result!);
    regDOB = DateTime.tryParse(initialProfileDetails?.dateOfBrith ?? '');
    if (initialProfileDetails?.gender != '') {
      maleFemaleRegEnum =
          initialProfileDetails!.gender == MaleFemaleEnum.male.toString()
              ? MaleFemaleEnum.male
              : MaleFemaleEnum.female;
    }
    final mainViewModel = context.read<MainViewModel>();
    final profileProvider = context.read<ProfileProvider>();
    Future.delayed(Duration.zero, () {
      mainViewModel.init();
      // To get drawer profile and name
      profileProvider.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainViewModel = context.watch<MainViewModel>();
    //profileProvider = context.watch<ProfileProvider>().postEntity;
    return Scaffold(
      key: mainScreenScaffoldKey,
      extendBody: true,
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
        //width: 20,
        height: 55,
        child: Material(
          color: Colors.black.withOpacity(.7),
          elevation: 10,
          shadowColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: TabBar(
            onTap: (i) {
              if (i == 1) {
                mainViewModel.onAddPostHandler(context);
              }
              //setState(() {});
            },
            padding: const EdgeInsets.all(10),
            controller: _tabController,
            labelColor: Colors.blueGrey,
            splashBorderRadius: BorderRadius.circular(15),
            indicatorColor: Colors.transparent,
            unselectedLabelColor:
                Colors.white.withOpacity(0.6), //const Color(0xffB7B7B7)
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white, // const Color.fromARGB(255, 21, 48, 88)
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff000000).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(2, 8),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(
                height: 40,
                child: Center(
                  child: Icon(Icons.travel_explore_sharp),
                ),
              ),
              Tab(
                height: 40,
                child: Center(
                  child: Icon(Icons.add),
                ),
              ),
              Tab(
                height: 40,
                child: Center(
                  child: Icon(Icons.person),
                ),
              ),
            ],
          ),
        ),
      ),
      //drawer: AppDrawer(),
      // body: SafeArea(
      //   bottom: false, // To make the body extend behind bottom bar
      //   child: ExtendedNavigator(
      //     router: MainViewRouter(),
      //     navigatorKey:
      //         StackedService.nestedNavigationKey(StackedNavKeys.mainNavKey),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: ClipOval(
      //   child: FloatingActionButton(
      //     onPressed: () => mainViewModel.onAddPostHandler(context),
      //     elevation: 8,
      //     child: Icon(
      //       Icons.add,
      //     ),
      //   ),
      // ),

      // bottomNavigationBar: SizedBox(
      //   height: 65,
      //   child: BottomAppBar(
      //     // shape: CircularNotchedRectangle(),
      //     notchMargin: 5.0,
      //     clipBehavior: Clip.antiAlias,
      //     // color: Theme.of(context).primaryColor.withAlpha(0),
      //     // ↑ use .withAlpha(0) to debug/peek underneath ↑ BottomAppBar
      //     child: BottomNavigationBar(
      //       currentIndex: mainViewModel.index,
      //       //type: BottomNavigationBarType.fixed,
      //       showSelectedLabels: true,
      //       showUnselectedLabels: true,
      //       selectedLabelStyle: AppStyle.of(context).b5M!.merge(headerTextFont),
      //       unselectedLabelStyle:
      //           AppStyle.of(context).b5M!.merge(headerTextFont),
      //       selectedItemColor: AppColors.plumpPurplePrimary,
      //       unselectedItemColor: AppColors.rhythm,
      //       onTap: mainViewModel.onTapItem,
      //       items: [
      //         BottomNavigationBarItem(
      //           icon: FaIcon(
      //             FontAwesomeIcons.magnifyingGlass,
      //             color: AppColors.rhythm,
      //             size: 20,
      //           ),
      //           activeIcon: FaIcon(
      //             FontAwesomeIcons.magnifyingGlass,
      //             color: AppColors.plumpPurplePrimary,
      //             size: 20,
      //           ),
      //           label: 'Discover',
      //         ),
      //         // BottomNavigationBarItem(
      //         //   icon: FaIcon(
      //         //     FontAwesomeIcons.map,
      //         //     color: AppColors.rhythm,
      //         //     size: 20,
      //         //   ),
      //         //   activeIcon: FaIcon(
      //         //     FontAwesomeIcons.solidMap,
      //         //     color: AppColors.plumpPurplePrimary,
      //         //     size: 20,
      //         //   ),
      //         //   label: 'Map',
      //         // ),
      //         BottomNavigationBarItem(
      //           icon: FaIcon(
      //             FontAwesomeIcons.image,
      //             color: AppColors.rhythm,
      //             size: 20,
      //           ),
      //           activeIcon: FaIcon(
      //             FontAwesomeIcons.solidImage,
      //             color: AppColors.plumpPurplePrimary,
      //             size: 20,
      //           ),
      //           label: 'Posts',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: FaIcon(
      //             FontAwesomeIcons.user,
      //             color: AppColors.rhythm,
      //             size: 20,
      //           ),
      //           activeIcon: FaIcon(
      //             FontAwesomeIcons.solidUser,
      //             color: AppColors.plumpPurplePrimary,
      //             size: 20,
      //           ),
      //           label: 'Profile',
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

//Just a makeShift
class PostsAddTab extends StatefulWidget {
  const PostsAddTab({Key? key}) : super(key: key);

  @override
  State<PostsAddTab> createState() => _PostsAddTabState();
}

class _PostsAddTabState extends State<PostsAddTab> {
  bool loading = true;
  List<PostViewParams>? postEntity;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    try {
      List<PostViewParams> list = [];
      var resultData = await getThisUserPost();
      for (var element in resultData!) {
        final _ =
            PostViewParams.fromMap(element.data() as Map<String, dynamic>);
        list.add(_);
      }
      postEntity = list;
      loading = false;
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add post", style: headerTextFont),
        centerTitle: true,
      ),
      body: loading
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : PostsTab(postEntity: postEntity),
    );
  }
}
