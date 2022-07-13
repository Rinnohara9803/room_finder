import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/rooms_provider.dart';
import '../widgets/rent_floor_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchCity = 'Kathmandu';
  Widget searchCityContainers(String city, Function onpressed) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onpressed();
        },
        child: Container(
          margin: const EdgeInsets.all(
            10,
          ),
          height: 40,
          decoration: BoxDecoration(
            color: city == _searchCity ? Colors.blueGrey : Colors.grey,
            borderRadius: BorderRadius.circular(
              8,
            ),
          ),
          child: Center(
            child: Text(
              city,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  searchCityContainers(
                    'Kathmandu',
                    () {
                      if (_searchCity == 'Kathmandu') {
                        return;
                      }
                      setState(() {
                        _searchCity = 'Kathmandu';
                      });
                    },
                  ),
                  searchCityContainers(
                    'Bhaktapur',
                    () {
                      if (_searchCity == 'Bhaktapur') {
                        return;
                      }
                      setState(() {
                        _searchCity = 'Bhaktapur';
                      });
                    },
                  ),
                  searchCityContainers(
                    'Lalitpur',
                    () {
                      if (_searchCity == 'Lalitpur') {
                        return;
                      }
                      setState(() {
                        _searchCity = 'Lalitpur';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: FutureBuilder(
                  future: Provider.of<Rooms>(context, listen: false)
                      .getAllRentsByCity(_searchCity),
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
                              onPressed: () {
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
                        return roomData.rentFloorsByCity.isEmpty
                            ? const Center(
                                child: Text('No rooms available.'),
                              )
                            : RefreshIndicator(
                                onRefresh: () async {
                                  await roomData.getAllRentsByCity(_searchCity);
                                },
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: roomData.rentFloorsByCity.length,
                                  itemBuilder: (context, i) {
                                    return RentFloorWidget(
                                      showImage: roomData
                                          .rentFloorsByCity[i].images[0],
                                      id: roomData.rentFloorsByCity[i].id,
                                      address:
                                          roomData.rentFloorsByCity[i].address,
                                      city: roomData.rentFloorsByCity[i].city,
                                      amount:
                                          roomData.rentFloorsByCity[i].amount,
                                      bhk: roomData.rentFloorsByCity[i].bhk,
                                    );
                                  },
                                ),
                              );
                      });
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
