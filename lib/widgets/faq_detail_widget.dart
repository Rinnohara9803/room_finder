import 'package:flutter/material.dart';
import 'package:room_finder/providers/faq.dart';

class FaqDetailWidget extends StatelessWidget {
  final FAQ faq;

  const FaqDetailWidget({
    Key? key,
    required this.faq,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget theContainer(bool theBool, String text) {
      return Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8,
            ),
          ),
          padding: const EdgeInsets.all(
            8,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Icon(
                  theBool == true
                      ? Icons.check_circle
                      : Icons.not_interested_outlined,
                  size: 35,
                  color: theBool == true ? Colors.green : Colors.red,
                ),
                const VerticalDivider(
                  color: Colors.black,
                  thickness: 1,
                  width: 25,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget theContainer1(String value, String text) {
      return Card(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const VerticalDivider(
                  color: Colors.black,
                  thickness: 1,
                  width: 25,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                ),
                padding: const EdgeInsets.all(
                  8,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Icon(
                        faq.petFriendly == 'Yes'
                            ? Icons.pets_outlined
                            : Icons.not_interested_outlined,
                        size: 35,
                        color: faq.petFriendly == 'Yes'
                            ? Colors.green
                            : Colors.red,
                      ),
                      const VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                        width: 25,
                      ),
                      const Text(
                        'Pet Friendly',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Text(
                        faq.leaseTime + ' days',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                        width: 25,
                      ),
                      const Text(
                        'Lease Period',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            theContainer(faq.ableToLeaveBeforeLeasePeriod,
                'Able to move before Lease Period'),
            const SizedBox(
              height: 10,
            ),
            theContainer(
                faq.needToPaySecurityDeposit, 'Need to pay Security Deposit'),
            const SizedBox(
              height: 10,
            ),
            theContainer(
                faq.needToPayBeforeMoveIn, 'Need to pay before Move In'),
            const SizedBox(
              height: 10,
            ),
            theContainer1(faq.howToPayRentDue, 'How to pay Rent Due'),
            const SizedBox(
              height: 10,
            ),
            theContainer1(faq.reponsibilitiesForUtilities,
                'Responsibilities for Utilities'),
            const SizedBox(
              height: 10,
            ),
            theContainer1(faq.waterAvailability, 'Water Availability'),
            const SizedBox(
              height: 10,
            ),
            theContainer1(
                faq.electricityAvailability, 'Electricity Availability'),
            const SizedBox(
              height: 10,
            ),
            theContainer(faq.parkingForMotorcycle, 'Parking for Motorcycle'),
            const SizedBox(
              height: 10,
            ),
            theContainer(faq.parkingForCar, 'Parking for Car'),
            const SizedBox(
              height: 10,
            ),
            theContainer1(faq.internet, 'Internet'),
          ],
        ),
      ),
    );
  }
}
