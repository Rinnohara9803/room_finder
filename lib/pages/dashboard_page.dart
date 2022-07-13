import 'package:flutter/material.dart';
import 'package:room_finder/pages/home_page.dart';
import 'package:room_finder/pages/map_page.dart';
import 'package:room_finder/pages/my_rent_floors_page.dart';
import 'package:room_finder/pages/profile_page.dart';
import 'package:room_finder/pages/search_page.dart';

import '../services/shared_services.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  static const routeName = '/homePage';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  Widget tabBuilder(IconData icon, String text) {
    return Tab(
      icon: Icon(
        icon,
        size: 26,
      ),
      text: text,
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration.zero,
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${greeting()}  ${SharedService.userName}'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 5,
        initialIndex: 2,
        child: Scaffold(
          bottomNavigationBar: Container(
            color: Colors.blueGrey,
            child: TabBar(
              labelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: [
                tabBuilder(Icons.location_on_outlined, 'Near me'),
                tabBuilder(Icons.search, 'Search'),
                tabBuilder(Icons.home, 'Home'),
                tabBuilder(Icons.add_box_outlined, 'Add Yours'),
                tabBuilder(Icons.person, 'Profile'),
              ],
            ),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              MapPage(),
              SearchPage(),
              HomePage(),
              MyRentFloors(),
              ProfilePage(),
            ],
          ),
        ),
      ),
    );
  }
}
