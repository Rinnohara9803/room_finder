import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_finder/Utilities/snackbars.dart';
import 'package:room_finder/providers/rent_floor_response_one.dart';

class ChangeAvailabilityStatusWidget extends StatelessWidget {
  const ChangeAvailabilityStatusWidget({Key? key}) : super(key: key);

  Future<void> showChangeAvailabilityStatusBottomModalSheet(
      BuildContext theContext, RentFloorResponseModelOne rentFloor) async {
    showModalBottomSheet<void>(
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15,
          ),
          topRight: Radius.circular(
            15,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      context: theContext,
      builder: (BuildContext context) {
        return ChangeNotifierProvider.value(
          value: rentFloor,
          child: PhysicalModel(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(
                15,
              ),
              topRight: Radius.circular(
                15,
              ),
            ),
            color: Colors.white,
            shadowColor: Colors.grey,
            elevation: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(
                            4,
                          ),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black38,
                          ),
                          child: const Icon(
                            Icons.close,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: !rentFloor.availability ? true : false,
                        onChanged: (value) {},
                      ),
                      const Text(
                        'Is Available',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: rentFloor.availability ? true : false,
                        onChanged: (value) {},
                      ),
                      const Text(
                        'Is Unavailable',
                      ),
                    ],
                  ),
                  Consumer<RentFloorResponseModelOne>(
                      builder: (context, rentFloor, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await rentFloor
                              .changeAvailabilityStatus(
                                  rentFloor.id, !rentFloor.availability)
                              .then((_) {
                            Navigator.of(context).pop();
                            SnackBars.showNormalSnackbar(context,
                                'Availability status changed successfully!!!');
                          }).catchError((e) {
                            Navigator.of(context).pop();
                            SnackBars.showErrorSnackBar(context,
                                'Failed to updated Availability Status');
                          });
                        },
                        child: rentFloor.availability
                            ? const Text(
                                'Change Availability Status to " Unavailable "')
                            : const Text(
                                'Change Availability Status to " Available "'),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rentFloor = Provider.of<RentFloorResponseModelOne>(context);

    return InkWell(
      onTap: () async {
        await showChangeAvailabilityStatusBottomModalSheet(context, rentFloor);
      },
      child: Container(
        padding: const EdgeInsets.all(15.0),
        width: double.infinity,
        child: const Text(
          'Change Rent Floor Availability Status',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}
