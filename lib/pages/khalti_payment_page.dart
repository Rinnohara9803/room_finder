import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class KhaltiPaymentPage extends StatelessWidget {
  const KhaltiPaymentPage({Key? key}) : super(key: key);
  static const routeName = 'khaltiPaymentPage';

  @override
  Widget build(BuildContext context) {
    final amount = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pay With Khalti',
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            const SizedBox(height: 15),
            // For Amount
            TextFormField(
              enabled: false,
              initialValue: amount.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount to pay",
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      8,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  5,
                ),
              ),
              height: 50,
              color: Colors.blueGrey,
              child: const Text(
                'Pay With Khalti',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                KhaltiScope.of(context).pay(
                  config: PaymentConfig(
                    amount: amount * 100,
                    productIdentity: 'rino',
                    productName: 'rino',
                    // mobile: '9841937556',
                    // mobileReadOnly: true,
                  ),
                  preferences: [
                    PaymentPreference.khalti,
                    PaymentPreference.connectIPS,
                  ],
                  onSuccess: (su) {
                    const successsnackBar = SnackBar(
                      content: Text('Payment Successful'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(successsnackBar);
                  },
                  onFailure: (fa) {
                    const failedsnackBar = SnackBar(
                      content: Text('Payment Failed'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(failedsnackBar);
                  },
                  onCancel: () {
                    const cancelsnackBar = SnackBar(
                      content: Text('Payment Cancelled'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(cancelsnackBar);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
