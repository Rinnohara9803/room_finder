import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:room_finder/models/push_notification_model.dart';
import 'package:room_finder/services/auth_service.dart';

import '../Utilities/local_notification_singleton.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  static const routeName = '/splashPage';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // late final FirebaseMessaging firebaseMessaging;
  // PushNotificationModel? pushNotification;

  // void registerNotification() async {
  //   await Firebase.initializeApp();
  //   firebaseMessaging = FirebaseMessaging.instance;

  //   NotificationSettings settings = await firebaseMessaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     provisional: false,
  //     sound: true,
  //   );

  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   print('Permisson granted');

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print(message.notification!.title);
  //     print(message.notification!.body);
  //     print(message.data['title']);
  //     print(message.data['body']);
  //     PushNotificationModel notificationModel = PushNotificationModel(
  //       title: message.notification!.title as String,
  //       body: message.notification!.body as String,
  //       dataTitle: message.notification!.title as String,
  //       databody: message.notification!.body as String,
  //     );
  //     LocalNotificationPluginSingleton
  //             .show(
  //           1,
  //           message.data['title'],
  //           message.data['body'],
  //           NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               LocalNotificationPluginSingleton.instance.channel.id,
  //               LocalNotificationPluginSingleton.instance.channel.name,
  //               LocalNotificationPluginSingleton
  //                   .instance.secondChannel.,
  //               playSound: true,
  //               enableVibration: true,
  //               icon: '@drawable/ic_stat_logo',

  //               importance: Importance.high,
  //             ),
  //           ),
  //         );
  //   });
  // }
  // }

  @override
  void initState() {
    // registerNotification();
    Future.delayed(const Duration(seconds: 3), () {
      AuthService.autoLogin(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Flexible(
                    child: Container(),
                  ),
                  Flexible(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffEDF0FA),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            40,
                          ),
                          topRight: Radius.circular(
                            40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.22,
                backgroundColor: const Color.fromARGB(255, 110, 128, 146),
                backgroundImage: const AssetImage('images/mainIcon.png'),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 128, 147, 163).withOpacity(
                    0.3,
                  ),
                  borderRadius: BorderRadius.circular(
                    9,
                  ),
                ),
                child: const Text(
                  'ABC Company',
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
