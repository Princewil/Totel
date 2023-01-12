import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import 'firebase_method.dart';

Map<String, dynamic>? paymentIntent;

Future makePayment(String cost, String locationLatLng) async {
  paymentIntent = await createPaymentIntent(cost, "USD");
  await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Admin'));
  return displayPaymentSheet(locationLatLng);
}

createPaymentIntent(String amount, String currency) async {
  try {
    Map<String, dynamic> body = {
      'amount': calculateAmount(amount),
      "currency": currency,
      "payment_method_types[]": 'card'
    };
    var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          "Authorization": "Bearer $SECRET_KEY",
          'Content-Type': 'application/x-www-form-urlencoded'
        });
    return jsonDecode(response.body);
  } catch (e) {}
}

String calculateAmount(String amount) {
  final calculateAmount = (int.parse(amount)) * 100;
  return calculateAmount.toString();
}

displayPaymentSheet(String locationLatLng) async {
  return await Stripe.instance.presentPaymentSheet().then((value) async {
    paymentIntent = null;
    return await updateBooked(locationLatLng);
  });
}

const SECRET_KEY = 'sk_test_M5Hmfwb5Xb8ZD1lmedG3dmXD003y6owZ8D';
