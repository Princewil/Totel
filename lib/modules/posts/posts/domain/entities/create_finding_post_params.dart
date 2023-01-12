import 'package:cheffy/firebase_method.dart';
import 'package:cheffy/modules/posts/posts/domain/entities/create_booked_post_params.dart';

// To parse this JSON data, do
//
//     final createPostEntity = createPostEntityFromJson(jsonString);

class FindingPostParams {
  bool? isAcceptHourly;
  String? dateFrom;
  String? dateTo;
  String? gender;
  String? notes;
  num? partnerAmount;
  String? locationLatLng;
  String? userUID;
  String? postType;
  bool? alreadyBooked;
  String? bookUID;

  FindingPostParams({
    this.isAcceptHourly,
    this.dateFrom,
    this.dateTo,
    this.gender,
    this.notes,
    this.partnerAmount,
    this.locationLatLng,
    this.userUID,
    this.postType,
    this.alreadyBooked,
    this.bookUID,
  });

  Map<String, dynamic> toMap(FindingPostParams params) => {
        postNoteKey: params.notes,
        partnerAmountKey: params.partnerAmount,
        allowedGenderKey: params.gender,
        locationLatLngKey: params.locationLatLng,
        dateFromKey: params.dateFrom,
        dateToKey: params.dateTo,
        isAccptHourKey: params.isAcceptHourly,
        userUIDkey: params.userUID,
        postTypeKey: params.postType,
        bookerUIDKey: params.bookUID,
        alreadyBookedKey: params.alreadyBooked,
      };

  FindingPostParams.fromMap(Map<String, dynamic> map) {
    this.notes = map[postNoteKey];
    this.partnerAmount = map[partnerAmountKey];
    this.gender = map[allowedGenderKey];
    this.locationLatLng = map[locationLatLng];
    this.dateFrom = map[dateFromKey];
    this.dateTo = map[dateToKey];
    this.isAcceptHourly = map[isAccptHourKey];
    this.userUID = map[userUIDkey];
    this.postType = map[postTypeKey];
    this.alreadyBooked = map[alreadyBookedKey];
    this.bookUID = map[bookerUIDKey];
  }

  // FindingPostParams copyWith(
  //     {String? name,
  //     String? overview,
  //     num? rate,
  //     String? type,
  //     String? notes,
  //     num? partnerAmount,
  //     String? gender,
  //     List<int>? attachments,
  //     String? location,
  //     String? dateFrom,
  //     String? dateTo,
  //     double? lat,
  //     double? long,
  //     String? hotel,
  //     DateTime? bidEnds,
  //     String? checkIn,
  //     String? checkout,
  //     bool? isAcceptHourly,
  //     DateTime? bidStart}) {
  //   return FindingPostParams(
  //     dateFrom: dateFrom ?? this.dateFrom,
  //     dateTo: dateTo ?? this.dateTo,
  //     notes: notes ?? this.notes,
  //     partnerAmount: partnerAmount ?? this.partnerAmount,
  //     gender: gender ?? this.gender,
  //     location: location ?? this.location,
  //     isAcceptHourly: isAcceptHourly ?? this.isAcceptHourly,
  //   );
  // }
// copy with

}

const postNoteKey = "Note";
const partnerAmountKey = "partner_amount";
const allowedGenderKey = "gender";
const locationLatLngKey = "locationLatLngKey";
const dateFromKey = 'date_from';
const dateToKey = 'date_to';
const isAccptHourKey = 'is_accept_hourly';
const findingPostType = 'Find';
