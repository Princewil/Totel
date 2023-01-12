// To parse this JSON data, do
//
//     final createPostEntity = createPostEntityFromJson(jsonString);

import 'package:cheffy/firebase_method.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import 'create_finding_post_params.dart';

class CreateBookedPostParams {
  String? nameOfHotel;
  List<String>? imagesURL;
  num? hotelRating;
  String? dateFrom;
  String? dateTo;
  String? gender;
  String? notes;
  num? partnerAmount;
  String? locationLatLng;
  String? userUID;
  String? hourAvaliable;
  String? postType;
  bool? booked;
  String? bookerUID;

  CreateBookedPostParams({
    this.dateFrom,
    this.dateTo,
    this.gender,
    this.notes,
    this.partnerAmount,
    this.locationLatLng,
    this.userUID,
    this.hotelRating,
    this.imagesURL,
    this.nameOfHotel,
    this.hourAvaliable,
    this.postType,
    this.booked,
    this.bookerUID,
  });

  Map<String, dynamic> toMap(CreateBookedPostParams params) => {
        postNoteKey: params.notes,
        partnerAmountKey: params.partnerAmount,
        allowedGenderKey: params.gender,
        locationLatLngKey: params.locationLatLng,
        dateFromKey: params.dateFrom,
        dateToKey: params.dateTo,
        userUIDkey: params.userUID,
        imagesKey: params.imagesURL,
        hotelRatekey: params.hotelRating,
        hoursRangeKey: params.hourAvaliable,
        nameOfHotelKey: params.nameOfHotel,
        postTypeKey: params.postType,
        alreadyBookedKey: params.booked,
        bookerUIDKey: params.bookerUID,
      };

  CreateBookedPostParams.fromMap(Map<String, dynamic> map) {
    this.notes = map[postNoteKey];
    this.partnerAmount = map[partnerAmountKey];
    this.gender = map[allowedGenderKey];
    this.locationLatLng = map[locationLatLng];
    this.dateFrom = map[dateFromKey];
    this.dateTo = map[dateToKey];
    this.imagesURL = map[imagesKey];
    this.userUID = map[userUIDkey];
    this.hotelRating = map[hotelRatekey];
    this.hourAvaliable = map[hoursRangeKey];
    this.nameOfHotel = map[nameOfHotelKey];
    this.postType = map[postTypeKey];
    this.booked = map[alreadyBookedKey];
    this.bookerUID = map[bookerUIDKey];
  }
}

// class CreateBookedPostParams {
//   CreateBookedPostParams({
//     required this.lat,
//     required this.bidStart,
//     required this.bidEnds,
//     required this.hotel,
//     required this.checkIn,
//     required this.checkout,
//     required this.long,
//     required this.name,
//     required this.dateFrom,
//     required this.dateTo,
//     required this.overview,
//     this.rate = 0,
//     this.type = 'romantic',
//     required this.notes,
//     required this.partnerAmount,
//     required this.gender,
//     this.attachments = const [],
//     required this.location,
//   });

//   final DateTime dateFrom;
//   final DateTime dateTo;
//   final DateTime bidEnds;
//   final DateTime bidStart;
//   final String name;
//   final String overview;
//   final num rate;
//   final String type;
//   final String? notes;
//   final String hotel;
//   final num partnerAmount;
//   final String gender;
//   final List<int> attachments;
//   final String location;
//   final double lat, long;
//   final String checkIn;
//   final String checkout;
//   final bool isAcceptHourly = false;

//   Map<String, dynamic> toMap() => {
//         "name": name,
//         "overview": overview,
//         "rate": rate,
//         "type": type,
//         "notes": notes,
//         "partner_amount": partnerAmount,
//         "gender": gender,
//         "attachments": List<dynamic>.from(attachments.map((x) => x)),
//         "location": location,
//         'date_from': dateFrom.toIso8601String(),
//         'date_to': dateTo.toIso8601String(),
//         'latitude': lat,
//         'longitude': long,
//         'hotel': hotel,
//         'bid_start': bidStart.toIso8601String(),
//         'bid_ends': bidEnds.toIso8601String(),
//         'checkin': checkIn,
//         'checkout': checkout,
//         'is_accept_hourly': isAcceptHourly,
//       };

//   CreateBookedPostParams copyWith(
//       {String? name,
//       String? overview,
//       num? rate,
//       String? type,
//       String? notes,
//       num? partnerAmount,
//       String? gender,
//       List<int>? attachments,
//       String? location,
//       DateTime? dateFrom,
//       DateTime? dateTo,
//       double? lat,
//       double? long,
//       String? hotel,
//       DateTime? bidEnds,
//       String? checkIn,
//       String? checkout,
//       bool? isAcceptHourly,
//       DateTime? bidStart}) {
//     return CreateBookedPostParams(
//       dateFrom: dateFrom ?? this.dateFrom,
//       dateTo: dateTo ?? this.dateTo,
//       name: name ?? this.name,
//       overview: overview ?? this.overview,
//       rate: rate ?? this.rate,
//       type: type ?? this.type,
//       notes: notes ?? this.notes,
//       partnerAmount: partnerAmount ?? this.partnerAmount,
//       gender: gender ?? this.gender,
//       attachments: attachments ?? this.attachments,
//       location: location ?? this.location,
//       lat: lat ?? this.lat,
//       long: long ?? this.long,
//       hotel: hotel ?? this.hotel,
//       bidEnds: bidEnds ?? this.bidEnds,
//       checkIn: checkIn ?? this.checkIn,
//       checkout: checkout ?? this.checkout,
//       bidStart: bidStart ?? this.bidStart,
//     );
//   }
// // copy with

// }

const String nameOfHotelKey = 'Hotel Name';
const String imagesKey = 'Hotel images';
const String hotelRatekey = 'Hotel Rate';
const String hoursRangeKey = 'Avaliable hours';
const postTypeKey = 'Post type';
const bookingPostType = 'Booked';
const alreadyBookedKey = 'AlreadyBooked';
const bookerUIDKey = 'BookerUID';
