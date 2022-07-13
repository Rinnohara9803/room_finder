import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_finder/pages/add_rent_floor_page.dart';
import 'package:room_finder/widgets/my_rent_floor_widget.dart';

import '../providers/rooms_provider.dart';

class MyRentFloors extends StatefulWidget {
  const MyRentFloors({Key? key}) : super(key: key);

  @override
  State<MyRentFloors> createState() => MyRentFloorsState();
}

class MyRentFloorsState extends State<MyRentFloors> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Rent Floors',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AddRentPage.routeName);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Add rent floor',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future:
                      Provider.of<Rooms>(context, listen: false).getMyRents(),
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
                            onRefresh: () async {
                              await roomData.getMyRents();
                            },
                            child: roomData.myRentFloors.isEmpty
                                ? const Center(
                                    child:
                                        Text('You have no added rent floors.'),
                                  )
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: roomData.myRentFloors.length,
                                    itemBuilder: (context, i) {
                                      return ChangeNotifierProvider.value(
                                        value: roomData.myRentFloors[i],
                                        child: const MyRentFloorWidget(),
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
