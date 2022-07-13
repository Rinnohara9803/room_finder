import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:room_finder/Utilities/snackbars.dart';
import 'package:room_finder/models/rent_floor.dart';
import 'package:room_finder/providers/rooms_provider.dart';
import 'package:room_finder/services/shared_services.dart';

import '../widgets/image_view_widget.dart';

class AddRentPage extends StatefulWidget {
  const AddRentPage({Key? key}) : super(key: key);
  static const routeName = '/addRentFloorPage';

  @override
  State<AddRentPage> createState() => _AddRentPageState();
}

class _AddRentPageState extends State<AddRentPage> {
  String _address = '';
  String _city = '';
  int _amountPm = 0;
  String _contant = '';
  String _description = '';
  String _preference = '';
  int _bhk = 0;
  double _latitude = SharedService.currentPosition.latitude;
  double _longitude = SharedService.currentPosition.longitude;
  final List<XFile> _imageFiles = [];

  File? _selectedImage;

  Future<void> _getUserPicture(ImageSource imageSource) async {
    ImagePicker _picker = ImagePicker();
    final images = await _picker.pickMultiImage();
    if (images == null) {
      return;
    } else if (images.length > 5) {
      SnackBars.showNormalSnackbar(context, 'You can only chooose 5 images.');
      return;
    }

    setState(() {
      _imageFiles.addAll(images);
    });
  }

  void showImageChooseOptions() async {
    await _getUserPicture(
      ImageSource.camera,
    ).then((value) {
      if (_selectedImage != null) {
        Navigator.of(context).pop();
      }
    });
  }

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

  Future<void> _onSaved() async {
    if (!_globalKey.currentState!.validate()) {
      SnackBars.showErrorSnackBar(
          context, 'Please fill in all the required fields!!!');
      return;
    } else if (_imageFiles.isEmpty) {
      SnackBars.showErrorSnackBar(context, 'Please choose a photo!!!');
      return;
    } else if (_imageFiles.length > 5) {
      SnackBars.showErrorSnackBar(context, 'You can only chooose 5 images.');
      return;
    } else if (_imageFiles.length < 2) {
      SnackBars.showErrorSnackBar(
          context, 'You have to choose at least 2 images.');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _globalKey.currentState!.save();
    RentFloor newRentFloor = RentFloor(
      images: _imageFiles,
      city: _city,
      address: _address,
      userId: SharedService.userID,
      preference: _preference,
      bhk: '${_bhk}BHK',
      amount: _amountPm,
      contact: int.parse(_contant),
      description: _description,
      latitude: _latitude,
      longitude: _longitude,
    );

    try {
      await Provider.of<Rooms>(context, listen: false)
          .addRentFloorWithImage(newRentFloor)
          .then((_) {
        SnackBars.showNormalSnackbar(
            context, 'Rent Floor added successfully!!!');
        Navigator.of(context).pop();
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

  late GoogleMapController _googleMapController;
  final _scrollController = ScrollController();

  final Marker _locationMarker = Marker(
    markerId: const MarkerId('rino'),
    infoWindow: const InfoWindow(
      title: 'CurrentLocation',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue,
    ),
    position: LatLng(SharedService.currentPosition.latitude,
        SharedService.currentPosition.longitude),
  );

  Marker getCurrentMarker(double lat, double long) {
    return Marker(
      markerId: const MarkerId('rino1'),
      infoWindow: const InfoWindow(
        title: 'Rent Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
      position: LatLng(
        lat,
        long,
      ),
    );
  }

  final _cameraPosition = CameraPosition(
    target: LatLng(
      SharedService.currentPosition.latitude,
      SharedService.currentPosition.longitude,
    ),
    zoom: 12.5,
    tilt: 0,
  );
  final List<Marker> _markers = [];

  @override
  void initState() {
    _markers.add(_locationMarker);

    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _globalKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Rent Floor',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        DropdownButtonFormField(
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
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a city';
                            }
                            return null;
                          },
                        ),
                        DropdownButtonFormField(
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
                          validator: (value) {
                            if (value == null) {
                              return 'Please select the preference type';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
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
                          key: const ValueKey('BHK'),
                          decoration: const InputDecoration(
                            labelText: 'BHK',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Please enter the BHK.';
                            } else if (int.tryParse(value) == null ||
                                int.parse(value) == 0 ||
                                int.parse(value) > 4) {
                              return 'Please provide BHK in between 1 - 4';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _bhk = int.parse(value!);
                          },
                        ),
                        TextFormField(
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.info,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          child: Container(
                            padding: const EdgeInsets.all(
                              8,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showImageChooseOptions();
                                    },
                                    child: const Text(
                                      'Add Images',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (_imageFiles.isEmpty)
                                  const Text(
                                    'No files chosen!!!',
                                  ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (_imageFiles.isNotEmpty)
                                  Column(
                                    children: _imageFiles.map((image) {
                                      return Container(
                                        margin: const EdgeInsets.all(
                                          8,
                                        ),
                                        height: 80,
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return ImageViewWidget(
                                                        isNetworkImage: false,
                                                        filePath: image.path,
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Card(
                                                  elevation: 6,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      5,
                                                    ),
                                                    child: Image(
                                                      fit: BoxFit.cover,
                                                      image: FileImage(
                                                        File(image.path),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _imageFiles.removeWhere(
                                                      (imagen) =>
                                                          imagen == image);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Stack(
                          children: [
                            SizedBox(
                              height: 350,
                              width: double.infinity,
                              child: GoogleMap(
                                gestureRecognizers:
                                    // ignore: prefer_collection_literals
                                    <Factory<OneSequenceGestureRecognizer>>[
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                ].toSet(),
                                onTap: (latLng) {
                                  setState(() {
                                    if (_markers.length > 1) {
                                      _markers.removeLast();
                                      _latitude = latLng.latitude;
                                      _longitude = latLng.longitude;
                                      _markers.add(
                                        getCurrentMarker(
                                          latLng.latitude,
                                          latLng.longitude,
                                        ),
                                      );
                                    } else {
                                      _latitude = latLng.latitude;
                                      _longitude = latLng.longitude;
                                      _markers.add(
                                        getCurrentMarker(
                                          latLng.latitude,
                                          latLng.longitude,
                                        ),
                                      );
                                    }
                                  });
                                },
                                mapType: MapType.normal,
                                markers: _markers.map((e) => e).toSet(),
                                initialCameraPosition: _cameraPosition,
                                onMapCreated: (controller) =>
                                    _googleMapController = controller,
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: IconButton(
                                color: Colors.blueGrey,
                                onPressed: () {
                                  _googleMapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: LatLng(
                                          SharedService
                                              .currentPosition.latitude,
                                          SharedService
                                              .currentPosition.longitude,
                                        ),
                                        zoom: 15.5,
                                        tilt: 50,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.location_on_outlined,
                                  size: 35,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await _onSaved();
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
                                    'Add Rent Floor',
                                  ),
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
      ),
    );
  }
}
