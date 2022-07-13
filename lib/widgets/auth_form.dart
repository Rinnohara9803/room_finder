import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:room_finder/Utilities/snackbars.dart';

class AuthForm extends StatefulWidget {
  final Function submitAuthForm;
  final bool isLoading;
  const AuthForm({
    required this.submitAuthForm,
    required this.isLoading,
    Key? key,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isSignIn = true;
  String _userName = '';
  String _userEmail = '';
  String _userPassword = '';
  bool _isMaleSelected = false;
  bool _isFemaleSelected = false;
  bool _isOthersSelected = false;
  String _gender = '';
  DateTime? selectedDate;
  String _dob = '';
  int _contact = 0;

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),   
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
        _dob = selectedDate!.toIso8601String();
      });
    });
  }

  void _changeAuthState() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  void _submitForm() {
    if (_gender.isEmpty && !_isSignIn || _dob.isEmpty && !_isSignIn) {
      SnackBars.showErrorSnackBar(
          context, 'Please provide necessary credentials.');
      return;
    } else if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    widget.submitAuthForm(
      _contact,
      _userEmail,
      _userPassword,
      _userName,
      _isSignIn,
      _gender,
      _dob,
      _changeAuthState,
    );
  }

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isSignIn)
                      TextFormField(
                        key: const ValueKey('userName'),
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please enter your username.';
                          } else if (value.trim().length < 4) {
                            return 'Please enter at least 4 characters.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userName = value!;
                        },
                      ),
                    if (!_isSignIn)
                      TextFormField(
                        keyboardType: TextInputType.number,
                        key: const ValueKey('contact'),
                        decoration: const InputDecoration(
                          labelText: 'Contact',
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
                          _contact = int.parse(value!);
                        },
                      ),
                    TextFormField(
                      key: _isSignIn
                          ? const ValueKey('signInEmail')
                          : const ValueKey('signUpEmail'),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter your username.';
                        } else if (!value.contains('@') ||
                            !value.endsWith('.com')) {
                          return 'Please provide a valid email.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value!;
                      },
                    ),
                    TextFormField(
                      obscureText: isVisible,
                      key: _isSignIn
                          ? const ValueKey('signInPassword')
                          : const ValueKey('signUpPassword'),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: isVisible
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter your password.';
                        } else if (value.trim().length < 7) {
                          return 'Please enter at least 7 characters.';
                        } else if (!value.contains('@')) {
                          return 'Please provide a special character.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (!_isSignIn)
                      Row(
                        children: [
                          Checkbox(
                            value: _isMaleSelected,
                            onChanged: (value) {
                              if (_isMaleSelected) {
                                return;
                              }
                              setState(() {
                                _isMaleSelected = !_isMaleSelected;
                                _isFemaleSelected = false;
                                _isOthersSelected = false;
                                _gender = 'Male';
                              });
                            },
                          ),
                          const Text(
                            'Male',
                          ),
                          Checkbox(
                            value: _isFemaleSelected,
                            onChanged: (value) {
                              if (_isFemaleSelected) {
                                return;
                              }
                              setState(() {
                                _isFemaleSelected = !_isFemaleSelected;
                                _isMaleSelected = false;
                                _isOthersSelected = false;
                                _gender = 'Female';
                              });
                            },
                          ),
                          const Text(
                            'Female',
                          ),
                          Checkbox(
                            value: _isOthersSelected,
                            onChanged: (value) {
                              if (_isOthersSelected) {
                                return;
                              }
                              setState(() {
                                _isOthersSelected = !_isOthersSelected;
                                _isFemaleSelected = false;
                                _isMaleSelected = false;
                                _gender = 'Other';
                              });
                            },
                          ),
                          const Text(
                            'Others',
                          ),
                        ],
                      ),
                    if (!_isSignIn)
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? 'No Date Chosen!!!'
                                  : DateFormat.yMd().format(
                                      DateTime.parse(_dob),
                                    ),
                            ),
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: widget.isLoading
                            ? const SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              )
                            : Text(
                                _isSignIn ? 'Sign In' : 'Sign Up',
                              ),
                      ),
                    ),
                    TextButton(
                      child: Text(
                        _isSignIn ? 'Create new account' : 'Sign In',
                      ),
                      onPressed: _changeAuthState,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
