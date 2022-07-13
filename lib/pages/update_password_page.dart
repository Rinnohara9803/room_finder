import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_finder/Utilities/snackbars.dart';
import 'package:room_finder/providers/profile_provider.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);
  static const routeName = '/forgotPasswordPage';

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  String newPassword = '';

  final _key = GlobalKey<FormState>();

  Future<void> createNewPassword(String updatedPassword) async {
    if (!_key.currentState!.validate()) {
      return;
    }
    try {
      Provider.of<ProfileProvider>(context, listen: false)
          .createNewPassword(updatedPassword)
          .then((_) {
        SnackBars.showNormalSnackbar(
            context, 'New password created successfully!!!');
      });
    } on SocketException {
      SnackBars.showNoInternetConnectionSnackBar(context);
    } catch (e) {
      SnackBars.showNormalSnackbar(context, 'Something went wrong.');
    }
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
              const Text(
                'Create New Password',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      enabled: true,
                      decoration: const InputDecoration(
                        label: Text('Password'),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter your new password.';
                        } else if (value.trim().length < 7) {
                          return 'Please enter at least 7 characters.';
                        } else if (!value.contains('@')) {
                          return 'Please provide a special character.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        newPassword = value;
                      },
                      onSaved: (value) {
                        newPassword = value as String;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      enabled: true,
                      decoration: const InputDecoration(
                        label: Text('Confirm password'),
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please re-enter your new password.';
                        } else if (value != newPassword) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await createNewPassword(newPassword);
                  },
                  child: const Text(
                    'Update Password',
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
