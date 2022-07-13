import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:room_finder/config.dart';
import 'package:room_finder/models/user_request_model.dart';
import 'package:room_finder/pages/auth_page.dart';
import 'package:room_finder/pages/dashboard_page.dart';
import 'package:room_finder/pages/splash_page.dart';
import 'package:room_finder/providers/profile_provider.dart';
import 'package:room_finder/services/shared_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> registerUser(UserRequestModel user) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    try {
      var responseData = await http.post(
        Uri.http(Config.authority, 'user/register'),
        headers: headers,      
        body: jsonEncode(
          {
            "Fullname": user.name,
            "Contact": user.contact,
            "Email": user.email,
            "Password": user.password,
            "Gender": user.gender,
            "DOB": user.dob,
          },   
        ),
      );
      var jsonData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
      } else {
        return Future.error(
          jsonData['msg'],
        );
      }
    } on SocketException {
      return Future.error('No Internet Connection');
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<void> signInuser(String email, String password) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
    };
    try {
      var responseData = await http.post(
        Uri.http(Config.authority, 'user/login'),
        headers: headers,
        body: jsonEncode(
          {
            "Email": email,
            "Password": password,
          },
        ),
      );
      var jsonData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', jsonData['token']);
        await prefs.setString('userID', jsonData['userData']['_id']);
        SharedService.token = jsonData['token'];
        SharedService.userID = jsonData['userData']['_id'];
      } else {
        return Future.error(
          'Unauthorized user',
        );
      }
    } on SocketException {
      return Future.error('No Internet Connection');
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<void> autoLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      Navigator.pushReplacementNamed(context, AuthPage.routeName);
    } else {
      SharedService.token = prefs.getString('token')!;
      SharedService.userID = prefs.getString('userID')!;
      try {
        await Provider.of<ProfileProvider>(context, listen: false)
            .getMyProfile()
            .then((_) {
          Navigator.pushReplacementNamed(context, DashboardPage.routeName);
        });
      } on SocketException {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No Internet connection'),
            action: SnackBarAction(
              label: 'Refresh',
              onPressed: () {
                Navigator.pushReplacementNamed(context, SplashPage.routeName);
              }, 
            ),
          ),
        );
      } catch (e) {
        Navigator.pushReplacementNamed(context, AuthPage.routeName);
      }
    }
  }

  static Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, AuthPage.routeName);
  }
}
