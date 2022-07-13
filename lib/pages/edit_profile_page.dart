import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:room_finder/Utilities/snackbars.dart';
import 'package:room_finder/providers/profile_provider.dart';
import 'package:room_finder/services/shared_services.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  static const routeName = '/editProfilePage';

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  DateTime? selectedDate;
  String dob = DateFormat.yMd().format(
    DateTime.parse(
      SharedService.dob,
    ),
  );
  String _dobFormat = '';
  String userName = '';
  String gender = '';
  int contact = 0;

  List<String> genders = ['Male', 'Female', 'Other'];

  bool _isLoading = false;

  Future<void> updateProfile() async {
    if (!_key.currentState!.validate()) {
      return;
    } else if (userName ==
            Provider.of<ProfileProvider>(context, listen: false).userName &&
        contact ==
            Provider.of<ProfileProvider>(context, listen: false).contact &&
        _dobFormat ==
            Provider.of<ProfileProvider>(context, listen: false).dob &&
        gender == Provider.of<ProfileProvider>(context, listen: false).gender) {
      SnackBars.showNormalSnackbar(context, 'No changes to save!!!');
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ProfileProvider>(context, listen: false)
          .updateProfile(
        userName,
        contact,
        gender,
        _dobFormat,
      )
          .then((_) {
        SnackBars.showNormalSnackbar(
            context, 'Profile updated successfully!!!');
      });
    } on SocketException {
      SnackBars.showNormalSnackbar(context, 'No Internet Connection.');
    } catch (e) {
      SnackBars.showNormalSnackbar(context, 'Something went wrong.');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.parse(
          Provider.of<ProfileProvider>(context, listen: false).dob),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
        _dobFormat = selectedDate!.toIso8601String();
        dob = DateFormat.yMd().format(selectedDate!);
      });
    });
  }

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    _dobFormat = Provider.of<ProfileProvider>(context, listen: false).dob;
    userName = Provider.of<ProfileProvider>(context, listen: false).userName;
    contact = Provider.of<ProfileProvider>(context, listen: false).contact;
    gender = Provider.of<ProfileProvider>(context, listen: false).gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingActionButton.small(
                backgroundColor: Colors.blueGrey,
                child: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: false,
                        initialValue: SharedService.email,
                        decoration: const InputDecoration(
                          label: Text('Email'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        enabled: true,
                        initialValue:
                            Provider.of<ProfileProvider>(context).userName,
                        decoration: const InputDecoration(
                          label: Text('Fullname'),
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please enter your username.';
                          } else if (value.trim().length < 4) {
                            return 'Please enter at least 4 characters.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          userName = value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        enabled: true,
                        initialValue: Provider.of<ProfileProvider>(context)
                            .contact
                            .toString(),
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
                        onChanged: (value) {
                          contact = int.parse(value);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dob),
                            const SizedBox(
                              width: 10,
                            ),
                            TextButton(
                              onPressed: _presentDatePicker,
                              child: const Text(
                                'Choose Date',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      DropdownButtonFormField(
                        value: Provider.of<ProfileProvider>(context).gender,
                        items: genders.map(
                          (gender) {
                            return DropdownMenuItem(
                              child: Text(gender),
                              value: gender,
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          gender = value as String;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await updateProfile();
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
                              : const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
