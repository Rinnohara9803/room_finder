class RentFloorResponseModel {
  final List<String> images;
  final String id;
  final String city;
  final String address;
  final String ownerId;
  final String bhk;
  final int amount;
  final String preference;
  final String contact;
  final String description;
  final bool availability;
  final bool approved;
  final String ownerEmail;
  final String ownerContact;
  final String ownerName;
  final double latitude;
  final double longitude;

  RentFloorResponseModel({
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
    required this.ownerContact,
    required this.ownerEmail,
    required this.ownerName,
    required this.latitude,
    required this.longitude,
  });
}
