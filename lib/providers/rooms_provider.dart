import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:room_finder/config.dart';
import 'package:room_finder/models/rent_floor.dart';
import 'package:room_finder/models/rent_floor_response.dart';
import 'package:room_finder/providers/rent_floor_response_one.dart';
import 'package:room_finder/services/shared_services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
   
class Rooms with ChangeNotifier {
  List<RentFloorResponseModelOne> _rentFloors = [];

  List<RentFloorResponseModelOne> get rentFloors {
    return [..._rentFloors];
  }

  RentFloorResponseModelOne getAllRentFloorById(String id) {
    return _rentFloors.firstWhere((floor) => id == floor.id);
  }

  List<RentFloorResponseModelOne> _rentFloorsByCity = [];

  List<RentFloorResponseModelOne> get rentFloorsByCity {
    return [..._rentFloorsByCity];
  }

  List<RentFloorResponseModelOne> _rentFloorsByAddress = [];

  List<RentFloorResponseModelOne> get rentFloorByAddress {
    return [..._rentFloorsByAddress];
  }

  List<RentFloorResponseModelOne> _myRentFloors = [];

  List<RentFloorResponseModelOne> get myRentFloors {
    return [..._myRentFloors];
  }

  RentFloorResponseModel? _rentFloorById;

  RentFloorResponseModel? get rentFloor {
    return _rentFloorById;
  }

  RentFloorResponseModelOne getMyRentFloorById(String id) {
    return _myRentFloors.firstWhere((floor) => id == floor.id);
  }

  Future<void> getRentFloorById(String id) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      var responseData = await http.get(
        Uri.http(Config.authority, 'rentfloor/getdetails/$id'),
        headers: headers,
      );

      var jsonData = jsonDecode(responseData.body);

      var rentDetail = jsonData['resp'];
      if (rentDetail[0] == null) {
        return Future.error('No data found.');
      }
      List<String> images = [];
      for (var i in rentDetail[0]['Images']) {
        images.add(i['filename']);
      }       
      _rentFloorById = RentFloorResponseModel(
        images: images,
        id: rentDetail[0]['_id'],
        city: rentDetail[0]['City'],
        address: rentDetail[0]['Address'],
        bhk: rentDetail[0]['BHK'],
        amount: rentDetail[0]['Amountpm'],
        contact: rentDetail[0]['Contact'].toString(),
        ownerId: rentDetail[0]['userID']['_id'],
        preference: rentDetail[0]['Preference'],
        description: rentDetail[0]['Description'],
        availability: rentDetail[0]['Available'],
        approved: rentDetail[0]['Approved'],
        ownerContact: rentDetail[0]['userID']['Contact'].toString(),
        ownerEmail: rentDetail[0]['userID']['Email'],
        ownerName: rentDetail[0]['userID']['Fullname'],
        latitude: rentDetail[0]['Latitude'],
        longitude: rentDetail[0]['Longitude'],
      );
      notifyListeners();
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addRentFloorWithImage(RentFloor rentFloor) async {
    List imageList = [];
    for (var i in rentFloor.images) {
      imageList.add(
        await MultipartFile.fromFile(
          i.path,
          filename: path.basename(
            i.path,
          ),
        ),
      );
    }
    FormData data = FormData.fromMap(
      {
        "Images": imageList,
        "City": rentFloor.city,
        "Address": rentFloor.address,
        "userID": SharedService.userID,
        "Preference": rentFloor.preference,
        "BHK": rentFloor.bhk,
        "Amountpm": rentFloor.amount,
        "Contact": rentFloor.contact,
        "Description": rentFloor.description,
        "Latitude": rentFloor.latitude,
        "Longitude": rentFloor.longitude,
      },
    );

    Dio dio = Dio();

    try {
      var responseData = await dio.post(
        "http://${Config.authority}/rentfloor/postrent",
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${SharedService.token}',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        List<String> imageFiles = [];
        for (var i in responseData.data['result']['Images']) {
          imageFiles.add(i['filename']);
        }
        _myRentFloors.add(
          RentFloorResponseModelOne(
            images: imageFiles,
            id: responseData.data['result']['_id'],
            city: responseData.data['result']['City'],
            address: responseData.data['result']['Address'],
            bhk: responseData.data['result']['BHK'],
            amount: responseData.data['result']['Amountpm'],
            contact: responseData.data['result']['Contact'],
            ownerId: responseData.data['result']['userID'],
            preference: responseData.data['result']['Preference'],
            description: responseData.data['result']['Description'],
            availability: false,
            approved: false,
            latitude: rentFloor.latitude,
            longitude: rentFloor.longitude,
          ),
        );
        notifyListeners();
      }
    } on SocketException {
      return Future.error('No Internet Connection.');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addRentFloorWithoutImage(RentFloor rentFloor) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      var responseData = await http.post(
        Uri.http(Config.authority, 'rentfloor/postrent/withoutimage'),
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
            "Latitude": rentFloor.latitude,
            "Longitude": rentFloor.longitude,
          },
        ),
      );

      var jsonData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        _myRentFloors.add(
          RentFloorResponseModelOne(
            images: [],
            id: jsonData['result']['_id'],
            city: jsonData['result']['City'],
            address: jsonData['result']['Address'],
            bhk: jsonData['result']['BHK'],
            amount: jsonData['result']['Amountpm'],
            contact: jsonData['result']['Contact'],
            ownerId: jsonData['result']['userID'],
            preference: jsonData['result']['Preference'],
            description: jsonData['result']['Description'],
            availability: false,
            approved: false,
            latitude: rentFloor.latitude,
            longitude: rentFloor.longitude,
          ),
        );
        notifyListeners();
      }
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAllRents() async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      var responseData = await http.get(
        Uri.http(Config.authority, 'rentfloor/getallrent'),
        headers: headers,
      );
      var jsonData = jsonDecode(responseData.body);
      List<RentFloorResponseModelOne> _loadedRentFloors = [];

      for (var rentFloor in jsonData['resp']) {
        List<String> imageNames = [];
        for (var i in rentFloor['Images']) {
          imageNames.add(i['filename'].toString());
        }
        _loadedRentFloors.add(
          RentFloorResponseModelOne(
            images: imageNames,
            id: rentFloor['_id'],
            city: rentFloor['City'],
            address: rentFloor['Address'],
            bhk: rentFloor['BHK'],
            amount: rentFloor['Amountpm'],
            contact: rentFloor['Contact'].toString(),
            ownerId: rentFloor['userID']['_id'],
            preference: rentFloor['Preference'],
            description: rentFloor['Description'],
            availability: rentFloor['Available'],
            approved: rentFloor['Approved'],
            latitude: rentFloor['Latitude'],
            longitude: rentFloor['Longitude'],
          ),
        );
      }
      _rentFloors = _loadedRentFloors;
      notifyListeners();
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAllRentsByCity(String city) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      var responseData = await http.get(
        Uri.http(Config.authority, 'rentfloor/getrentinspecificarea/$city'),
        headers: headers,
      );
      var jsonData = jsonDecode(responseData.body);
      List<RentFloorResponseModelOne> _loadedRentFloors = [];
      _rentFloorsByCity = [];
      for (var rentFloor in jsonData['resp']) {
        List<String> imageNames = [];
        for (var i in rentFloor['Images']) {
          imageNames.add(i['filename']);
        }
        _loadedRentFloors.add(
          RentFloorResponseModelOne(
            images: imageNames,
            id: rentFloor['_id'],
            city: rentFloor['City'],
            address: rentFloor['Address'],
            bhk: rentFloor['BHK'],
            amount: rentFloor['Amountpm'],
            contact: rentFloor['Contact'].toString(),
            ownerId: rentFloor['userID']['_id'],
            preference: rentFloor['Preference'],
            description: rentFloor['Description'],
            availability: rentFloor['Available'],
            approved: rentFloor['Approved'],
            latitude: rentFloor['Latitude'],
            longitude: rentFloor['Longitude'],
          ),
        );
      }
      _rentFloorsByCity = _loadedRentFloors;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAllRentsByAddress(String address) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      var responseData = await http.get(
        Uri.http(Config.authority, 'rentfloor/gethouses/search/$address'),
        headers: headers,
      );
      var jsonData = jsonDecode(responseData.body);
      List<RentFloorResponseModelOne> _loadedRentFloors = [];
      _rentFloorsByAddress = [];
      for (var rentFloor in jsonData['resp']) {
        List<String> imageNames = [];
        for (var i in rentFloor['Images']) {
          imageNames.add(i['filename']);
        }
        _loadedRentFloors.add(
          RentFloorResponseModelOne(
            images: imageNames,
            id: rentFloor['_id'],
            city: rentFloor['City'],
            address: rentFloor['Address'],
            bhk: rentFloor['BHK'],
            amount: rentFloor['Amountpm'],
            contact: rentFloor['Contact'].toString(),
            ownerId: rentFloor['userID'],
            preference: rentFloor['Preference'],
            description: rentFloor['Description'],
            availability: rentFloor['Available'],
            approved: rentFloor['Approved'],
            latitude: rentFloor['Latitude'],
            longitude: rentFloor['Longitude'],
          ),
        );
      }

      _rentFloorsByAddress = _loadedRentFloors;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getMyRents() async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      var responseData = await http.get(
        Uri.http(Config.authority, 'rentfloor/getallmyhouserent'),
        headers: headers,
      );
      var jsonData = jsonDecode(responseData.body);
      List<RentFloorResponseModelOne> _loadedRentFloors = [];
      for (var rentFloor in jsonData['resp']) {
        List<String> imageNames = [];
        for (var i in rentFloor['Images']) {
          imageNames.add(i['filename']);
        }
        _loadedRentFloors.add(
          RentFloorResponseModelOne(
            images: imageNames,
            id: rentFloor['_id'],
            city: rentFloor['City'],
            address: rentFloor['Address'],
            bhk: rentFloor['BHK'],
            amount: rentFloor['Amountpm'],
            contact: rentFloor['Contact'].toString(),
            ownerId: rentFloor['userID'],
            preference: rentFloor['Preference'],
            description: rentFloor['Description'],
            availability: rentFloor['Available'],
            approved: rentFloor['Approved'],
            latitude: rentFloor['Latitude'],
            longitude: rentFloor['Longitude'],
          ),
        );
      }
      _myRentFloors = _loadedRentFloors;
      notifyListeners();
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRentFloorById(String id) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      await http
          .delete(
        Uri.http(Config.authority, 'rentfloor/deleterentalinfo/$id'),
        headers: headers,
        body: jsonEncode(
          {
            'userID': SharedService.userID,
          },
        ),
      )
          .then((_) {
        _myRentFloors.removeWhere((rentFloor) => id == rentFloor.id);
        notifyListeners();
      });
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      rethrow;
    }
  }
}
