import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_finder/models/rent_floor.dart';
import 'package:room_finder/providers/rent_floor_response_one.dart';

import '../Utilities/snackbars.dart';
import '../providers/rooms_provider.dart';
import '../services/shared_services.dart';

class EditRentFloorPage extends StatefulWidget {
  const EditRentFloorPage({Key? key}) : super(key: key);
  static const routeName = '/editRentFloorPage';

  @override
  State<EditRentFloorPage> createState() => _EditRentFloorPageState();
}

class _EditRentFloorPageState extends State<EditRentFloorPage> {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final rentFloor = Provider.of<Rooms>(context).getMyRentFloorById(id);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ChangeNotifierProvider.value(
            value: rentFloor,
            child: const UpdateRentForm(),
          ),
        ),
      ),
    );
  }
}

class UpdateRentForm extends StatefulWidget {
  const UpdateRentForm({Key? key}) : super(key: key);

  @override
  State<UpdateRentForm> createState() => _UpdateRentFormState();
}

class _UpdateRentFormState extends State<UpdateRentForm> {
  String _address = '';

  String _city = '';

  int _amountPm = 0;

  String _contant = '';

  String _description = '';

  String _preference = '';

  int _bhk = 0;

  List<String> preferences = [
    'Family',
    'Friends',
    'Couple',
    'Students',
  ];

  List<String> cities = [
    'Kathmandu',
    'Bhaktapur',
    'Lalitpur',
  ];

  final _globalKey = GlobalKey<FormState>();

  bool _isLoading = false;

  Future<void> _onSaved(RentFloorResponseModelOne rentFloor) async {
    if (!_globalKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _globalKey.currentState!.save();
    RentFloor newRentFloor = RentFloor(
      images: [],
      city: _city,
      address: _address,
      userId: SharedService.userID,
      preference: _preference,
      bhk: '${_bhk}BHK',
      amount: _amountPm,
      contact: int.parse(_contant),
      description: _description,
      latitude: rentFloor.latitude,
      longitude: rentFloor.longitude,
    );

    try {
      await rentFloor.updateRentFloor(newRentFloor).then((_) {
        Navigator.of(context).pop();
        SnackBars.showNormalSnackbar(
            context, 'Rent floor updated successfully!!!');
      });
    } on SocketException {
      SnackBars.showNoInternetConnectionSnackBar(context);
    } catch (e) {
      SnackBars.showErrorSnackBar(context, e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rentFloor = Provider.of<RentFloorResponseModelOne>(context);
    return Form(
      key: _globalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FloatingActionButton.small(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 15,
                ),
                child: Text(
                  'Edit Rent Floor',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField(
                    value: rentFloor.city,
                    decoration: const InputDecoration(
                      label: Text(
                        'City',
                      ),
                    ),
                    items: cities.map(
                      (city) {
                        return DropdownMenuItem(
                          child: Text(city),
                          value: city,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      _city = value as String;
                    },
                    onSaved: (value) {
                      _city = value as String;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a city';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    value: rentFloor.preference,
                    decoration: const InputDecoration(
                      label: Text(
                        'Preferences',
                      ),
                    ),
                    items: preferences.map(
                      (preference) {
                        return DropdownMenuItem(
                          child: Text(preference),
                          value: preference,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      _preference = value as String;
                    },
                    onSaved: (value) {
                      _preference = value as String;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select the preference type';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: rentFloor.address,
                    key: const ValueKey('Address'),
                    decoration: const InputDecoration(
                      labelText: 'Address',
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please enter your address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _address = value!;
                    },
                  ),
                  TextFormField(
                    initialValue: rentFloor.bhk.replaceRange(1, 4, ''),
                    key: const ValueKey('BHK'),
                    decoration: const InputDecoration(
                      labelText: 'BHK',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please enter the BHK.';
                      }
                      if (int.parse(value) == 0 || int.parse(value) > 4) {
                        return 'Please provide valid BHK.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _bhk = int.parse(value!);
                    },
                  ),
                  TextFormField(
                    initialValue: rentFloor.amount.toString(),
                    key: const ValueKey('Amount/month'),
                    decoration: const InputDecoration(
                      labelText: 'Amount/month',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please enter rent/permonth.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _amountPm = int.parse(value!);
                    },
                  ),
                  TextFormField(
                    initialValue: rentFloor.contact,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text('Contact'),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please provide your Contact Number';
                      } else if (value.length < 10) {
                        return 'Please provide valid Contact Numer';
                      }
                      return null;
                    },
                    maxLength: 10,
                    onSaved: (value) {
                      _contant = value!;
                    },
                  ),
                  TextFormField(
                    initialValue: rentFloor.description,
                    maxLines: 5,
                    key: const ValueKey('Description'),
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please provider some description.';
                      } else if (value.trim().length < 5) {
                        return 'Description is too short.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description = value!;
                    },
                    onChanged: (value) {
                      _description = value;
                    },
                  ),
                  Consumer<RentFloorResponseModelOne>(
                      builder: (context, rentFlor, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _onSaved(rentFloor);
                        },
                        child: _isLoading
                            ? const SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              )
                            : const Text(
                                'Update Rent Floor',
                              ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
