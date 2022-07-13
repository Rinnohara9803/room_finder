import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_finder/widgets/rent_floor_widget.dart';

import '../providers/rooms_provider.dart';

class SearchPageAddress extends StatefulWidget {
  const SearchPageAddress({Key? key}) : super(key: key);
  static const routeName = '/searchPageByAddress';

  @override
  State<SearchPageAddress> createState() => _SearchPageAddressState();
}

class _SearchPageAddressState extends State<SearchPageAddress> {
  String _searchAddress = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                onChanged: (value) {},
                onFieldSubmitted: (value) {
                  setState(() {
                    _searchAddress = value;
                  });
                },
              ),
              Expanded(
                child: _searchAddress.isEmpty
                    ? const Center(
                        child: Text('Search for available rent floors...'),
                      )
                    : FutureBuilder(
                        future: Provider.of<Rooms>(context, listen: false)
                            .getAllRentsByAddress(_searchAddress),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                              return roomData.rentFloorByAddress.isEmpty
                                  ? const Center(
                                      child: Text('No rooms available.'),
                                    )
                                  : RefreshIndicator(
                                      onRefresh: () async {
                                        await roomData.getAllRentsByAddress(
                                            _searchAddress);
                                      },
                                      child: ListView.builder(
                                        itemCount:
                                            roomData.rentFloorByAddress.length,
                                        itemBuilder: (context, i) {
                                          return RentFloorWidget(
                                            showImage: roomData
                                                .rentFloorByAddress[i]
                                                .images[0],
                                            id: roomData
                                                .rentFloorByAddress[i].id,
                                            address: roomData
                                                .rentFloorByAddress[i].address,
                                            city: roomData
                                                .rentFloorByAddress[i].city,
                                            amount: roomData
                                                .rentFloorByAddress[i].amount,
                                            bhk: roomData
                                                .rentFloorByAddress[i].bhk,
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
