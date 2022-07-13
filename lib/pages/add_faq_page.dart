import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_finder/Utilities/snackbars.dart';
import 'package:room_finder/providers/faq.dart';
import 'package:room_finder/providers/faqs.dart';
import 'package:room_finder/services/shared_services.dart';

class AddFAQPage extends StatefulWidget {
  const AddFAQPage({Key? key}) : super(key: key);

  static const routeName = '/addFaqPage';

  @override
  State<AddFAQPage> createState() => _AddFAQPageState();
}

class _AddFAQPageState extends State<AddFAQPage> {
  String _petFriendly = '';
  int _leaseTime = 0;
  bool _ableToLeaveBeforeLeasePeriod = false;
  bool _needToPayBeforeMoveIn = false;
  bool _needToPaySecurityDeposit = false;
  String _howToPayRentDue = '';
  String _reponsibilitiesForUtilities = '';
  String _waterAvailability = '';
  String _electricityAvailability = '';
  bool _parkingForCar = false;
  bool _parkingForMotorcycle = false;
  String _internet = '';
  final _formKey = GlobalKey<FormState>();

  final List<String> answers = ['Yes', 'No'];
  final List<String> _paymentMethods = ['Hand Cash', 'Online Payment'];
  final List<String> _responsibilitiesForUtilitiesList = ['Tenant', 'Owner'];
  final List<String> _waterAvailabilityOptions = [
    '24 / 7',
    '24 / 6',
    '24 / 5',
    '24 / 4'
  ];
  final List<String> _electricityAvailabilityOptions = [
    '24 /7',
    '24 / 6',
    '24 / 5',
    '24 / 4'
  ];

  bool _isLoading = false;
  final List<String> _internetOptions = ['Available', 'Unavailable'];

  Future<void> _saveFaq(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _formKey.currentState!.save();
    FAQ faq = FAQ(
      id: '',
      petFriendly: _petFriendly,
      leaseTime: _leaseTime.toString(),
      ableToLeaveBeforeLeasePeriod: _ableToLeaveBeforeLeasePeriod,
      needToPayBeforeMoveIn: _needToPayBeforeMoveIn,
      needToPaySecurityDeposit: _needToPaySecurityDeposit,
      howToPayRentDue: _howToPayRentDue,
      reponsibilitiesForUtilities: _reponsibilitiesForUtilities,
      waterAvailability: _waterAvailability,
      electricityAvailability: _electricityAvailability,
      parkingForCar: _parkingForCar,
      parkingForMotorcycle: _parkingForMotorcycle,
      internet: _internet,
      rentID: ModalRoute.of(context)!.settings.arguments as String,
      ownerID: SharedService.userID,
    );
    try {
      await Provider.of<Faqs>(context, listen: false).saveFaqs(faq).then((_) {
        SnackBars.showNormalSnackbar(context, 'FAQ added successfully!!!');
        Navigator.of(context).pop();
      });
    } on SocketException {
      SnackBars.showNoInternetConnectionSnackBar(context);
    } catch (e) {
      SnackBars.showErrorSnackBar(
        context,
        'Something went wrong.',
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add FAQ',
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 10.0,
              top: 10.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text(
                        'Pet Friendly',
                      ),
                    ),
                    items: answers.map(
                      (preference) {
                        return DropdownMenuItem(
                          child: Text(preference),
                          value: preference,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      _petFriendly = value as String;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select the preference type';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    key: const ValueKey('Lease Period in days'),
                    decoration: const InputDecoration(
                      labelText: 'Lease Period in days',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please enter the lease Period.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _leaseTime = int.parse(value!);
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text(
                        'Able to leave before lease period',
                      ),
                    ),
                    items: answers.map(
                      (answer) {
                        return DropdownMenuItem(
                          child: Text(answer),
                          value: answer,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      if (value == 'Yes') {
                        _ableToLeaveBeforeLeasePeriod = true;
                      } else {
                        _ableToLeaveBeforeLeasePeriod = false;
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text(
                        'Need to pay before move in',
                      ),
                    ),
                    items: answers.map(
                      (answer) {
                        return DropdownMenuItem(
                          child: Text(answer),
                          value: answer,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      if (value == 'Yes') {
                        _needToPayBeforeMoveIn = true;
                      } else {
                        _needToPayBeforeMoveIn = false;
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text(
                        'Need to pay security deposit',
                      ),
                    ),
                    items: answers.map(
                      (ntpsd) {
                        return DropdownMenuItem(
                          child: Text(ntpsd),
                          value: ntpsd,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      if (value == 'Yes') {
                        _needToPaySecurityDeposit = true;
                      } else {
                        _needToPaySecurityDeposit = false;
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text(
                        'How to pay rent due',
                      ),
                    ),
                    items: _paymentMethods.map(
                      (paymentMethod) {
                        return DropdownMenuItem(
                          child: Text(paymentMethod),
                          value: paymentMethod,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      _howToPayRentDue = value as String;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text(
                        'Responsibilites for utilities',
                      ),
                    ),
                    items: _responsibilitiesForUtilitiesList.map(
                      (rfu) {
                        return DropdownMenuItem(
                          child: Text(rfu),
                          value: rfu,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      _reponsibilitiesForUtilities = value as String;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text(
                        'Water Availability',
                      ),
                    ),
                    items: _waterAvailabilityOptions.map(
                      (wap) {
                        return DropdownMenuItem(
                          child: Text(wap),
                          value: wap,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      _waterAvailability = value as String;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text(
                        'Electricity Availability',
                      ),
                    ),
                    items: _electricityAvailabilityOptions.map(
                      (eap) {
                        return DropdownMenuItem(
                          child: Text(eap),
                          value: eap,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      _electricityAvailability = value as String;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text(
                        'Parking for car',
                      ),
                    ),
                    items: answers.map(
                      (preference) {
                        return DropdownMenuItem(
                          child: Text(preference),
                          value: preference,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      if (value == 'Yes') {
                        _parkingForCar = true;
                      } else {
                        _parkingForCar = false;
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text(
                        'Parking for Motorcycle',
                      ),
                    ),
                    items: answers.map(
                      (preference) {
                        return DropdownMenuItem(
                          child: Text(preference),
                          value: preference,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      if (value == 'Yes') {
                        _parkingForMotorcycle = true;
                      } else {
                        _parkingForMotorcycle = false;
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text(
                        'Internet',
                      ),
                    ),
                    items: _internetOptions.map(
                      (ip) {
                        return DropdownMenuItem(
                          child: Text(ip),
                          value: ip,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      _internet = value as String;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _saveFaq(context);
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
                              'Save FAQ',
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
