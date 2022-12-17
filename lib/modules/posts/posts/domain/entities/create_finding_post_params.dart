import 'package:cheffy/firebase_method.dart';

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

  FindingPostParams({
    this.isAcceptHourly,
    this.dateFrom,
    this.dateTo,
    this.gender,
    this.notes,
    this.partnerAmount,
    this.locationLatLng,
    this.userUID,
  });

  Map<String, dynamic> toMap(FindingPostParams params) => {
        postNoteKey: params.notes,
        postbudgetKey: params.partnerAmount,
        allowedGenderKey: params.gender,
        locationLatLngKey: params.locationLatLng,
        dateFromKey: params.dateFrom,
        dateToKey: params.dateTo,
        isAccptHourKey: params.isAcceptHourly,
        userUIDkey: params.userUID
      };

  FindingPostParams.fromMap(Map<String, dynamic> map) {
    this.notes = map[postNoteKey];
    this.partnerAmount = map[postbudgetKey];
    this.gender = map[allowedGenderKey];
    this.locationLatLng = map[locationLatLng];
    this.dateFrom = map[dateFromKey];
    this.dateTo = map[dateToKey];
    this.isAcceptHourly = map[isAccptHourKey];
    this.userUID = map[userUIDkey];
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
const postbudgetKey = "partner_amount";
const allowedGenderKey = "gender";
const locationLatLngKey = "locationLatLngKey";
const dateFromKey = 'date_from';
const dateToKey = 'date_to';
const isAccptHourKey = 'is_accept_hourly';
