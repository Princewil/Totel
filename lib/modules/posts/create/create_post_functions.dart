import 'package:flutter/material.dart';

class KeyboardUtil {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

String kDestination = 'Destination';
String kTimeOfDeparture = 'DepartureTime';
String kBudget = 'Budget';
String kMessg = 'Message';
String kTravelPartner = 'Travel Partner';
String kAvaliableHour = 'AvaliableHour';

class FindingPartnerInfo {
  String? destination;
  String? timeOfDeparture;
  String? budget;
  String? messg;
  String? travelPartner;
  String? avaliableHour;
  FindingPartnerInfo({
    this.avaliableHour,
    this.budget,
    this.destination,
    this.messg,
    this.timeOfDeparture,
    this.travelPartner,
  });

  Map<String, dynamic> toMap(FindingPartnerInfo _data) {
    var data = Map<String, dynamic>();
    data[kDestination] = _data.destination;
    data[kAvaliableHour] = _data.avaliableHour;
    data[kBudget] = _data.budget;
    data[kTravelPartner] = _data.travelPartner;
    data[kMessg] = _data.messg;
    return data;
  }

  FindingPartnerInfo.toclass(Map<String, dynamic> map) {
    this.destination = map[kDestination];
    this.avaliableHour = map[avaliableHour];
    this.budget = map[budget];
    this.travelPartner = map[travelPartner];
    this.messg = map[messg];
  }
}
//"com.totel.totel"
