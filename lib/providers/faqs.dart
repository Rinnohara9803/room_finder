import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import '../config.dart';
import '../services/shared_services.dart';
import 'faq.dart';

class Faqs with ChangeNotifier {
  FAQ? _theFAQ;

  FAQ? get faq {
    return _theFAQ;
  }

  Future<void> saveFaqs(FAQ faq) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      var responseData = await http.post(
        Uri.http(Config.authority, 'faq/savefaq'),
        headers: headers,
        body: jsonEncode(
          {
            "Pet_Friendly": faq.petFriendly,
            "Lease_time": faq.leaseTime,
            "Able_leave_before_leasePeriod": faq.ableToLeaveBeforeLeasePeriod,
            "Need_to_Pay_Before_Move_In": faq.needToPayBeforeMoveIn,
            "Need_to_pay_Security_Deposite": faq.needToPayBeforeMoveIn,
            "How_to_Pay_rent_due": faq.howToPayRentDue,
            "Responsiblilites_For_Utilies": faq.reponsibilitiesForUtilities,
            "Water_Availablity": faq.waterAvailability,
            "Electricity_Availiblity": faq.electricityAvailability,
            "ParkingForMotorCycle": faq.parkingForMotorcycle,
            "ParkingForCar": faq.parkingForCar,
            "Internet": faq.internet,
            "RentId": faq.rentID,
            "OwnerId": faq.ownerID,
          },
        ),
      );
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {}
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getFaqs(String rentId) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      var responseData = await http.get(
        Uri.http(Config.authority, 'faq/GetFAQ/$rentId'),
        headers: headers,
      );
      var jsonData = json.decode(responseData.body);
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        if (jsonData['reponceData'] == null) {
          return Future.error('No Data Found');
        } else {
          _theFAQ = FAQ(
            id: jsonData['reponceData']['_id'],
            petFriendly: jsonData['reponceData']['Pet_Friendly'],
            leaseTime: jsonData['reponceData']['Lease_time'],
            ableToLeaveBeforeLeasePeriod: jsonData['reponceData']
                ['Able_leave_before_leasePeriod'],
            needToPayBeforeMoveIn: jsonData['reponceData']
                ['Need_to_Pay_Before_Move_In'],
            needToPaySecurityDeposit: jsonData['reponceData']
                ['Need_to_pay_Security_Deposite'],
            howToPayRentDue: jsonData['reponceData']['How_to_Pay_rent_due'],
            reponsibilitiesForUtilities: jsonData['reponceData']
                ['Responsiblilites_For_Utilies'],
            waterAvailability: jsonData['reponceData']['Water_Availablity'],
            electricityAvailability: jsonData['reponceData']
                ['Electricity_Availiblity'],
            parkingForCar: jsonData['reponceData']['ParkingForCar'],
            parkingForMotorcycle: jsonData['reponceData']
                ['ParkingForMotorCycle'],
            internet: jsonData['reponceData']['Internet'],
            rentID: jsonData['reponceData']['RentId'],
            ownerID: jsonData['reponceData']['OwnerId'],
          );
          notifyListeners();
        }
      }
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateFaqs(FAQ faq) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      var responseData = await http.put(
        Uri.http(Config.authority, 'faq/editFAQ/${faq.id}'),
        headers: headers,
        body: jsonEncode(
          {
            "Pet_Friendly": faq.petFriendly,
            "Lease_time": faq.leaseTime,
            "Able_leave_before_leasePeriod": faq.ableToLeaveBeforeLeasePeriod,
            "Need_to_Pay_Before_Move_In": faq.needToPayBeforeMoveIn,
            "Need_to_pay_Security_Deposite": faq.needToPayBeforeMoveIn,
            "How_to_Pay_rent_due": faq.howToPayRentDue,
            "Responsiblilites_For_Utilies": faq.reponsibilitiesForUtilities,
            "Water_Availablity": faq.waterAvailability,
            "Electricity_Availiblity": faq.electricityAvailability,
            "ParkingForMotorCycle": faq.parkingForMotorcycle,
            "ParkingForCar": faq.parkingForCar,
            "Internet": faq.internet,
            "RentId": faq.rentID,
            "OwnerId": faq.ownerID,
          },
        ),
      );

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {}
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }
}
