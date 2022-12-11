import 'dart:async';

import 'package:cheffy/modules/main/discover/presentation/pages/search_hotels_page.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:cheffy/core/models/data/locations_entity.dart';
import 'package:cheffy/r.g.dart';
import 'package:cheffy/modules/theme/color.dart';
import 'package:cheffy/modules/theme/styles.dart';
import 'package:cheffy/modules/widgets/stream_widget.dart';

import 'location_change_view_model.dart';

class LocationChangeView
    extends ViewModelBuilderWidget<LocationChangeViewModel> {
  const LocationChangeView({super.key});

  @override
  Widget builder(
      BuildContext context, LocationChangeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set your location',
          style: headerTextFont.copyWith(fontWeight: FontWeight.w400),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                style: headerTextFont,
                decoration: InputDecoration(
                  hintText: 'Find Location',
                  filled: true,
                  fillColor: AppColors.soap,
                  hintStyle:
                      AppStyle.of(context).b4.wCCrayola!.merge(headerTextFont),
                  suffixIcon: Image(
                    image: R.svg.ic_search(width: 24, height: 24),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.zero,
                leading: Image(
                  alignment: Alignment.centerLeft,
                  image: R.svg.ic_current_location(width: 34, height: 34),
                ),
                title: Text(
                  'Set Current location',
                  style: AppStyle.of(context)
                      .b4M
                      .wCPlumpPurplePrimary!
                      .merge(headerTextFont),
                ),
                subtitle: Text(
                  'Using GPS',
                  style:
                      AppStyle.of(context).b5.wCCrayola!.merge(normaltextFont),
                ),
                onTap: viewModel.onTapSetCurrentLocation,
              ),
              Divider(
                thickness: 3,
                color: AppColors.soap,
              ),
              const SizedBox(height: 12),
              Text(
                'Recently Search',
                style: AppStyle.of(context).b5.wCRhythm!.merge(headerTextFont),
              ),
              Expanded(
                child: MyWidget(viewModel: viewModel),
                // child: StreamWidget<List<LocationEntity>>(
                //   stream: viewModel.locations,
                //   done: (data) => ListView.separated(
                //     itemCount: data?.length ?? 0,
                //     separatorBuilder: (context, index) => Divider(
                //       color: AppColors.soap,
                //     ),
                //     itemBuilder: (context, index) => ListTile(
                //       visualDensity: VisualDensity.compact,
                //       contentPadding: EdgeInsets.zero,
                //       title: Text(
                //         data![index].name,
                //         style: AppStyle.of(context).b4M.wCChineseBlack,
                //       ),
                //       onTap: () =>
                //           viewModel.onTapLocationItem(index, data[index]),
                //     ),
                //   ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  LocationChangeViewModel viewModelBuilder(BuildContext context) =>
      LocationChangeViewModel();

  @override
  void onViewModelReady(LocationChangeViewModel viewModel) => viewModel.init();
}

List<LocationEntity> resentSearch = [];

class MyWidget extends StatefulWidget {
  final LocationChangeViewModel viewModel;
  const MyWidget({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {});
      }
      timer = t;
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: resentSearch.length,
      separatorBuilder: (context, index) => Divider(
        color: AppColors.soap,
      ),
      itemBuilder: (context, index) => ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.zero,
        title: Text(
          resentSearch[index].name,
          style: AppStyle.of(context).b4M.wCChineseBlack,
        ),
        onTap: () =>
            widget.viewModel.onTapLocationItem(index, resentSearch[index]),
      ),
    );
  }
}
