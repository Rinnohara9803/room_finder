import 'package:image_picker/image_picker.dart';

class RentFloor {
  final List<XFile> images;
  final String city;
  final String address;
  final String userId;
  final String preference;
  final String bhk;
  final int amount;
  final int contact;
  final String description;
  final double latitude;
  final double longitude;
  RentFloor({
    required this.images,
    required this.city,
    required this.address,
    required this.userId,
    required this.preference,
    required this.bhk,
    required this.amount,
    required this.contact,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}
