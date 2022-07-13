import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:room_finder/config.dart';
import 'package:room_finder/pages/khalti_payment_page.dart';
import 'package:room_finder/pages/room_detail_map_page.dart';
import 'package:room_finder/providers/faqs.dart';
import 'package:room_finder/widgets/image_view_widget.dart';
import 'package:room_finder/widgets/rent_detail_shimmer_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../providers/rooms_provider.dart';
import '../widgets/faq_detail_widget.dart';

class RentFloorDetailPage extends StatefulWidget {
  const RentFloorDetailPage({Key? key}) : super(key: key);

  static const routeName = '/rentFloorDetailPage';

  @override
  State<RentFloorDetailPage> createState() => _RentFloorDetailPageState();
}

class _RentFloorDetailPageState extends State<RentFloorDetailPage> {
  final _pageController = PageController();

  _launchPhoneURL(String phoneNumber) async {
    String url = 'tel: $phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchSMSURL(String phoneNumber) async {
    String url = 'sms: $phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchMailURL(String gmail) async {
    String url = 'mailto: $gmail';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget floorDetailContainers(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as String;

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: Provider.of<Rooms>(context, listen: false)
              .getRentFloorById(routeArgs),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const RentDetailShimmerWidget();
            } else if (snapshot.hasError) {
              if (snapshot.error.toString() ==
                  'RangeError (index): Invalid value: Valid value range is empty: 0') {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No data found for this Rent Floor.'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Sorry',
                        ),
                      ),
                    ],
                  ),
                );
              }
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
                  final floor = roomData.rentFloor;
                  return Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                              8,
                            ),
                            child: CarouselSlider(
                              items: floor!.images.map((image) {
                                return InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ImageViewWidget(
                                          isNetworkImage: true,
                                          filePath: image,
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      child: FadeInImage(
                                        placeholder: const AssetImage(
                                            'images/mainIcon.png'),
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                          'http://${Config.authority}/Images/$image',
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              options: CarouselOptions(
                                height: 260,
                                viewportFraction: 0.8,
                                aspectRatio: 8 / 10,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 13,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          floor.bhk,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          'Rs. ${floor.amount} per month',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        floorDetailContainers(
                                          'Preference',
                                          floor.preference,
                                        ),
                                        Text(
                                          floor.availability
                                              ? 'Available'
                                              : 'Unavailable At The Moment',
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        floorDetailContainers(
                                          'Address',
                                          floor.address,
                                        ),
                                        FloatingActionButton.small(
                                          heroTag: 'faq info',
                                          backgroundColor: Colors.white,
                                          onPressed: () {
                                            showModalBottomSheet<void>(
                                              isDismissible: true,
                                              enableDrag: true,
                                              shape:
                                                  const RoundedRectangleBorder(
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
                                                return Stack(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: const [
                                                              Text(
                                                                'FAQ\'s',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Divider(
                                                          thickness: 1.5,
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            child:
                                                                FutureBuilder(
                                                              future: Provider.of<
                                                                          Faqs>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getFaqs(
                                                                      routeArgs),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return const Center(
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        strokeWidth:
                                                                            2.0,
                                                                      ),
                                                                    ),
                                                                  );
                                                                } else if (snapshot
                                                                    .hasError) {
                                                                  if (snapshot
                                                                          .error
                                                                          .toString() ==
                                                                      'No Data Found') {
                                                                    return Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          const Text(
                                                                              'No FAQ\'s added for this Rent Floor.'),
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text('Ccntact the owner for details.'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          const Text(
                                                                              'Check your Internet Connection'),
                                                                          const Text(
                                                                              'And'),
                                                                          TextButton(
                                                                            onPressed:
                                                                                () async {
                                                                              setState(() {});
                                                                            },
                                                                            child:
                                                                                const Text('Try Again'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }
                                                                }
                                                                return Consumer<
                                                                    Faqs>(
                                                                  builder: (context,
                                                                      faqData,
                                                                      child) {
                                                                    final faq =
                                                                        faqData
                                                                            .faq;
                                                                    return FaqDetailWidget(
                                                                        faq:
                                                                            faq!);
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Positioned(
                                                      top: 3,
                                                      right: 5,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(
                                                            4,
                                                          ),
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                Colors.black38,
                                                          ),
                                                          child: const Icon(
                                                            Icons.close,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: const Icon(
                                            Icons.info_outline_rounded,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    floorDetailContainers(
                                      'City',
                                      floor.city,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'More about me: ',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      floor.description,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 80,
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            color: Colors.black12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      floor.ownerName,
                                      style: const TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Owner',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    FloatingActionButton.small(
                                      heroTag: 'Call',
                                      backgroundColor: Colors.white,
                                      onPressed: () {
                                        _launchPhoneURL(floor.ownerContact);
                                      },
                                      child: const Icon(
                                        Icons.phone,
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    FloatingActionButton.small(
                                      heroTag: 'Message',
                                      backgroundColor: Colors.white,
                                      onPressed: () {
                                        _launchSMSURL(floor.ownerContact);
                                      },
                                      child: const Icon(
                                        Icons.message,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    FloatingActionButton.small(
                                      heroTag: 'Email',
                                      backgroundColor: Colors.white,
                                      onPressed: () {
                                        _launchMailURL(floor.ownerEmail);
                                      },
                                      child: const Icon(
                                        Icons.email,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        child: IconButton(
                          iconSize: 40,
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              RoomDetailMapPage.routeName,
                              arguments: LatLng(
                                floor.latitude,
                                floor.longitude,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.location_on_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 5,
                        child: FloatingActionButton.small(
                          heroTag: 'payment',
                          backgroundColor: Colors.purple,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              KhaltiPaymentPage.routeName,
                              arguments: floor.amount,
                            );
                          },
                          child: const Icon(
                            Icons.payment,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
