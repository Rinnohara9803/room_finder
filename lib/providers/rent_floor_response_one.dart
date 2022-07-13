import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../config.dart';
import '../models/rent_floor.dart';
import '../services/shared_services.dart';
import 'package:http/http.dart' as http;

class RentFloorResponseModelOne with ChangeNotifier {
  List<String> images;
  final String id;
  String city;
  String address;
  final String ownerId;
  String bhk;
  int amount;
  String preference;
  String contact;
  String description;
  bool availability;
  final bool approved;
  double latitude;
  double longitude;

  RentFloorResponseModelOne({
    required this.images,
    required this.id,
    required this.city,
    required this.address,
    required this.bhk,
    required this.amount,
    required this.contact,
    required this.ownerId,
    required this.preference,
    required this.description,
    required this.availability,
    required this.approved,
    required this.latitude,
    required this.longitude,
  });

  Future<void> changeAvailabilityStatus(
      String id, bool availabilityStatus) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      var responseData = await http.put(
        Uri.http(Config.authority, 'rentfloor/updateavailable/$id'),
        headers: headers,
        body: jsonEncode(
          {
            'userID': SharedService.userID,
            'Available': availabilityStatus,
          },
        ),
      );
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        availability = !availability;
        notifyListeners();
      }
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRentFloor(RentFloor rentFloor) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      var responseData = await http.put(
        Uri.http(Config.authority, 'rentfloor/updateinformation/$id'),
        headers: headers,
        body: jsonEncode(
          {
            "City": rentFloor.city,
            "Address": rentFloor.address,
            "userID": SharedService.userID,
            "Preference": rentFloor.preference,
            "BHK": rentFloor.bhk,
            "Amountpm": rentFloor.amount,
            "Contact": rentFloor.contact,
            "Description": rentFloor.description,
          },
        ),
      );

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        city = rentFloor.city;
        address = rentFloor.address;
        preference = rentFloor.preference;
        bhk = rentFloor.bhk;
        amount = rentFloor.amount;
        contact = rentFloor.contact.toString();
        description = rentFloor.description;
        notifyListeners();
      }
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }
}
