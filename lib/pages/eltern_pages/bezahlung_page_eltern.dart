

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

import '../../helper/payment_configurations.dart';

// Pay Package
const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];
///////// Pay Package


class BezahlungPage extends StatefulWidget {


  const BezahlungPage({super.key});

  @override
  State<BezahlungPage> createState() => BezahlungPageState();
}

class BezahlungPageState extends State<BezahlungPage> {


  ///////// Pay Package
  final Future<PaymentConfiguration> _googlePayConfigFuture =
  PaymentConfiguration.fromAsset('google_pay_config.json');


  final Future<PaymentConfiguration> _applePayConfigFuture =
  PaymentConfiguration.fromAsset('apple_pay_config.json');


  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }


  ///////// Pay Package


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    bottom: PreferredSize(
    preferredSize: const Size.fromHeight(4.0),
    child: Container(
    color: Colors.black,
    height: 1.0,
    ),
    ),
    title: Text("Abonnement",
    style: TextStyle(color:Colors.black),
    ),
    ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      /// Payment


                      Container(
                        child: Text(
                          "Test",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FutureBuilder<PaymentConfiguration>(
                          future: _googlePayConfigFuture,
                          builder: (context, snapshot) => snapshot.hasData
                              ? GooglePayButton(
                            paymentConfiguration: snapshot.data!,
                            paymentItems: _paymentItems,
                            type: GooglePayButtonType.buy,
                            margin: const EdgeInsets.only(top: 15.0),
                            onPaymentResult: onGooglePayResult,
                            loadingIndicator: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                              : const SizedBox.shrink()),
                      GooglePayButton(
                        paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
                        paymentItems: _paymentItems,
                      ),

                      FutureBuilder<PaymentConfiguration>(
                          future: _applePayConfigFuture,
                          builder: (context, snapshot) => snapshot.hasData
                              ? ApplePayButton(
                            paymentConfiguration: snapshot.data!,
                            paymentItems: _paymentItems,
                            type: ApplePayButtonType.buy,
                            margin: const EdgeInsets.only(top: 15.0),
                            onPaymentResult: onApplePayResult,
                            loadingIndicator: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                              : const SizedBox.shrink()),
                      ApplePayButton(
                        paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
                        paymentItems: _paymentItems,
                      )

                      /// Payment

                    ],
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }


}

