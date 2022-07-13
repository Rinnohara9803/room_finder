import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:room_finder/providers/rooms_provider.dart';
import '../providers/rent_floor_response_one.dart';
import '../repositories/weather_repository.dart';
import '../services/shared_services.dart';
import '../widgets/rent_floor_bottom_modal_widget.dart';
import '../widgets/weather_show_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _googleMapController;

  List<Marker> _markers = [];
  Marker? _locationMarker;

  Marker getMarker(
    BuildContext context,
    double latitude,
    double longitude,
    String rentId,
  ) {
    RentFloorResponseModelOne rentFloor = Provider.of<Rooms>(
      context,
      listen: false,
    ).getAllRentFloorById(rentId);
    return Marker(
      onTap: () {
        showModalBottomSheet<void>(
          isDismissible: true,
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
          context: context,
          builder: (BuildContext context) {
            return RentFloorBottomModalWidget(rentFloor: rentFloor);
          },
        );
      },
      markerId: MarkerId(rentFloor.id),
      infoWindow: InfoWindow(
        title: rentFloor.bhk,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
      position: LatLng(
        latitude,
        longitude,
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

  Future<void> getWeatherReport() async {
    await WeatherRepository.getWeatherData().then(
      (_) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        showModalBottomSheet<void>(
          isDismissible: true,
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
          context: context,
          builder: (BuildContext context) {
            return const WeatherShowWidget();
          },
        );
      },
    ).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    _locationMarker = Marker(
      onTap: () {
        getWeatherReport();
      },
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
    _markers.add(_locationMarker!);
    List<Marker> markers =
        Provider.of<Rooms>(context, listen: false).rentFloors.map(
      (theRentFloor) {
        return getMarker(
          context,
          theRentFloor.latitude,
          theRentFloor.longitude,
          theRentFloor.id,
        );
      },
    ).toList();
    _markers = markers;
    _markers.add(_locationMarker!);
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
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.center_focus_strong,
            color: Colors.blueGrey,
          ),
          onPressed: () {
            _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(_cameraPosition),
            );
          },
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              markers: _markers.map((marker) {
                return marker;
              }).toSet(),
              initialCameraPosition: _cameraPosition,
              onMapCreated: (controller) => _googleMapController = controller,
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
                          SharedService.currentPosition.latitude,
                          SharedService.currentPosition.longitude,
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
            ),
            Positioned(
              left: 15,
              top: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        color: const Color.fromARGB(255, 72, 20, 195),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'My Location',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'Available rents',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
