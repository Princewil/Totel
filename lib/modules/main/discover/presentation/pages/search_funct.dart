import 'package:cheffy/Utils/Utils.dart';
import 'package:cheffy/firebase_method.dart';
import 'package:cheffy/modules/location_change_map/location_change_map_view.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/create_booked_post_params.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/create_finding_post_params.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

String? searchVal;
List<String> resultAddressFromLatLng = [];
Future<List<QueryDocumentSnapshot>> normalSearch() async {
  List<QueryDocumentSnapshot> result = [];
  resultAddressFromLatLng.clear();
  var locatn = await locationFromAddress(searchVal!);
  var docs = await FirebaseFirestore.instance
      .collection(findingPostCollection)
      .where(postTypeKey, isEqualTo: bookingPostType)
      .get()
      .then((value) => value.docs);

  for (var l in locatn) {
    for (var element in docs) {
      String latlag = element.get(locationLatLngKey);
      double? lat = double.tryParse(latlag.split(split).first);
      double? lng = double.tryParse(latlag.split(split).last);
      if ((lat!.round() == l.latitude.round() ||
              lat.toStringAsFixed(1) == l.latitude.toStringAsFixed(1)) &&
          (lng!.round() == l.longitude.round() ||
              lng.toStringAsFixed(1) == l.longitude.toStringAsFixed(1))) {
        result.add(element);
        String address = await placemarkFromCoordinates(
                double.parse(element.get(locationLatLngKey).split(split).first),
                double.parse(element.get(locationLatLngKey).split(split).last))
            .then((value) => fullAddress(value.first));
        resultAddressFromLatLng.add(address);
      }
    }
  }
  return result;
}

const split = '~';
//TODO: ReWrite the search code, by saving Lat and Lng seperately on Database