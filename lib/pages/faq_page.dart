import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_finder/pages/add_faq_page.dart';
import 'package:room_finder/pages/edit_faq_page.dart';
import 'package:room_finder/widgets/faq_detail_widget.dart';

import '../providers/faqs.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);
  static const routeName = '/faqPage';

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String rentId = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: Provider.of<Faqs>(context, listen: false).getFaqs(rentId),
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
              if (snapshot.error.toString() == 'No Data Found') {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No FAQ\'s added for this Rent Floor.'),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AddFAQPage.routeName,
                            arguments: rentId,
                          );
                        },
                        child: const Text('Add FAQ'),
                      ),
                    ],
                  ),
                );
              } else {
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
              }
            }
            return Consumer<Faqs>(
              builder: (context, faqData, child) {
                final faq = faqData.faq;
                return SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text(
                        'FAQ Details',
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                EditFaqPage.routeName,
                                arguments: rentId);
                          },
                          icon: const Icon(
                            Icons.edit,
                          ),
                        )
                      ],
                    ),
                    body: RefreshIndicator(
                        onRefresh: () async {
                          await faqData.getFaqs(rentId);
                        },
                        child: FaqDetailWidget(faq: faq!)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
