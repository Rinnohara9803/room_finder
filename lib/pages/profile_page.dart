import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:room_finder/pages/edit_profile_page.dart';
import 'package:room_finder/pages/update_password_page.dart';
import 'package:room_finder/providers/profile_provider.dart';
import 'package:room_finder/services/auth_service.dart';
import 'package:room_finder/services/shared_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> profileImages = [
    'https://cdn.dribbble.com/users/1577045/screenshots/4914645/media/028d394ffb00cb7a4b2ef9915a384fd9.png?compress=1&resize=400x300&vertical=top',
    'https://www.maxpixel.net/static/photo/640/Icon-Female-Avatar-Female-Icon-Red-Icon-Avatar-6007530.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Gay_Pride_Flag.svg/1200px-Gay_Pride_Flag.svg.png',
  ];

  String getGenderImage() {
    String gender = Provider.of<ProfileProvider>(context).gender;
    if (gender == 'Male') {
      return profileImages[0];
    } else if (gender == 'Female') {
      return profileImages[1];
    } else {
      return profileImages[2];
    }
  }

  Widget profileDetailBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.lightBlue,
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theHeight = MediaQuery.of(context).size.height;
    final theWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.blueGrey,
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 60,
                      top: 50,
                      right: 40,
                      bottom: 10,
                    ),
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileDetailBox(
                            'Your email',
                            SharedService.email,
                          ),
                          profileDetailBox('Your password', '*********'),
                          profileDetailBox('Your phone',
                              '+977 - ${Provider.of<ProfileProvider>(context).contact}'),
                          profileDetailBox('Gender',
                              Provider.of<ProfileProvider>(context).gender),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: theHeight * 0.10,
              left: theWidth * 0.09,
              child: CircleAvatar(
                radius: theWidth * 0.14,
                backgroundColor: Colors.grey,
                child: CircleAvatar(
                  radius: theWidth * 0.135,
                  backgroundColor: Colors.black12,
                  backgroundImage: NetworkImage(
                    getGenderImage(),
                  ),
                ),
              ),
            ),
            Positioned(
              top: theHeight * 0.145,
              left: theWidth * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Provider.of<ProfileProvider>(
                      context,
                    ).userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Date of Birth: ${DateFormat.yMd().format(
                      DateTime.parse(Provider.of<ProfileProvider>(context).dob),
                    )}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: theHeight * 0.01,
              left: 30,
              child: TextButton.icon(
                onPressed: () {
                  AuthService.logOut(context);
                },
                icon: const Icon(
                  Icons.logout,
                ),
                label: const Text(
                  'Log out',
                ),
              ),
            ),
            Positioned(
              bottom: theHeight * 0.008,
              right: 30,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, UpdatePasswordPage.routeName);
                },
                child: const Text(
                  'Update Password',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, EditProfilePage.routeName);
                },
                icon: const Icon(
                  Icons.edit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
