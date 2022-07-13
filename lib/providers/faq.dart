class FAQ {
  String id;
  String petFriendly;
  String leaseTime;
  bool ableToLeaveBeforeLeasePeriod;
  bool needToPayBeforeMoveIn;
  bool needToPaySecurityDeposit;
  String howToPayRentDue;
  String reponsibilitiesForUtilities;
  String waterAvailability;
  String electricityAvailability;
  bool parkingForCar;
  bool parkingForMotorcycle;
  String internet;
  String rentID;
  String ownerID;
  FAQ({
    required this.id,
    required this.petFriendly,
    required this.leaseTime,
    required this.ableToLeaveBeforeLeasePeriod,
    required this.needToPayBeforeMoveIn,
    required this.needToPaySecurityDeposit,
    required this.howToPayRentDue,
    required this.reponsibilitiesForUtilities,
    required this.waterAvailability,
    required this.electricityAvailability,
    required this.parkingForCar,
    required this.parkingForMotorcycle,
    required this.internet,
    required this.rentID,
    required this.ownerID,
  });
}
