import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:room_finder/config.dart';
import 'package:room_finder/services/shared_services.dart';
import 'package:http/http.dart' as http;

class ProfileProvider with ChangeNotifier {
  String _userName = SharedService.userName;
  int _contact = SharedService.contact;
  String _gender = SharedService.gender;
  String _dob = SharedService.dob;

  // void setProfileDetails(
  //     String userName, int contact, String gender, String dob) {
  //   _userName = userName;
  //   notifyListeners();
  //   _contact = contact;
  //   notifyListeners();
  //   _gender = gender;
  //   notifyListeners();
  //   _dob = dob;
  //   notifyListeners();
  // }

  String get userName {
    return _userName;
  }

  int get contact {
    return _contact;
  }

  String get gender {
    return _gender;
  }

  String get dob {
    return _dob;
  }

  Future<void> updateProfile(
      String fullName, int contact, String gender, String dob) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      await http
          .put(
        Uri.http(Config.authority, 'user'),
        headers: headers,
        body: jsonEncode(
          {
            'Fullname': fullName,
            'Contact': contact,
            'Gender': gender,
            'DOB': dob,
          },
        ),
      )
          .then((_) {
        _userName = fullName;
        notifyListeners();
        _gender = gender;
        notifyListeners();
        SharedService.dob = dob;
        _dob = dob;
        notifyListeners();
        _contact = contact;
        notifyListeners();
      });
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getMyProfile() async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      var responseData = await http.get(
        Uri.http(Config.authority, 'user/myprofile'),
        headers: headers,
      );

      var jsonData = jsonDecode(responseData.body);

      SharedService.userName = jsonData['data']['Fullname'];
      SharedService.email = jsonData['data']['Email'];
      SharedService.contact = int.parse(jsonData['data']['Contact']);
      SharedService.dob = jsonData['data']['DOB'];
      SharedService.gender = jsonData['data']['Gender'];
      _userName = SharedService.userName;
      _contact = SharedService.contact;
      _dob = SharedService.dob;
      _gender = SharedService.gender;
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createNewPassword(String newPassword) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      await http.put(
        Uri.http(Config.authority, 'user/updatepassword'),
        headers: headers,
        body: jsonEncode(
          {
            'Password': newPassword,
          },
        ),
      );
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }
}
