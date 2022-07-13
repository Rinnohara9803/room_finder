import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_finder/pages/search_page_by_address_page.dart';
import 'package:room_finder/repositories/google_maps_repository.dart';
import 'package:room_finder/widgets/rent_floor_widget.dart';

import '../providers/rooms_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    GoogleMapsRepository.determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(
            8,
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, SearchPageAddress.routeName);
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25,
                    ),
                    color: Colors.blueGrey.withOpacity(
                      0.4,
                    ),
                  ),
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Search by address....'),
                      Icon(
                        Icons.search,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: FutureBuilder(
                  future:
                      Provider.of<Rooms>(context, listen: false).getAllRents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.blueGrey,
                            strokeWidth: 2.0,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Check your Internet Connection'),
                            const Text('And'),
                            TextButton(
                              onPressed: () async {
                                setState(() {});
                              },
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Consumer<Rooms>(
                        builder: (context, roomData, child) {
                          return RefreshIndicator(
                            key: _refreshIndicatorKey,
                            onRefresh: () async {
                              await roomData.getAllRents();
                            },
                            child: roomData.rentFloors.isEmpty
                                ? const Center(
                                    child: Text('No rooms available.'),
                                  )
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: roomData.rentFloors.length,
                                    itemBuilder: (context, i) {
                                      return RentFloorWidget(
                                        showImage:
                                            roomData.rentFloors[i].images[0],
                                        id: roomData.rentFloors[i].id,
                                        address: roomData.rentFloors[i].address,
                                        city: roomData.rentFloors[i].city,
                                        amount: roomData.rentFloors[i].amount,
                                        bhk: roomData.rentFloors[i].bhk,
                                      );
                                    },
                                  ),
                          ); 
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
