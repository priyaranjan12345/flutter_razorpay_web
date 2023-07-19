import 'package:flutter/material.dart';
import 'package:flutter_razorpay_web/flutter_razorpay_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late RazorpayWeb _razorpayWeb;

  void getOrderId() {
    // todo: generate order id as per razorpay official documentation.
    // ref: https://razorpay.com/docs/payments/server-integration/nodejs/payment-gateway/build-integration/#13-create-an-order-in-server
    // implement this on your backend otherwise you may face CORS-policy issue in web

    // then call _makePayment
    _makePayment(
      amount: '100',
      orderId: 'order_DaZlswtdcn9UNV',
      keyId: 'test_Lxtrdfhfvdhja',
    );
  }

  void _makePayment({
    required String amount,
    required String orderId,
    required String keyId,
  }) {
    // create payment options
    // you can modify as per your requirements
    // ref: https://razorpay.com/docs/payments/server-integration/nodejs/payment-gateway/build-integration/#code-to-add-pay-button
    final Map<String, dynamic> options = {
      "key": keyId,
      "amount": amount,
      "currency": "INR",
      "order_id": orderId,
      "timeout": "240",
      "name": "Your Organization Name",
      "description": "your description",
      "prefill": {"contact": "+910000000000"},
      "readonly": {"contact": true, "email": true},
      "send_sms_hash": true,
      "remember_customer": false,
      "retry": {"enabled": false},
      "hidden": {"contact": false, "email": false}
    };

    // config razorpay payment methods
    // you can modify as per your requirements
    // ref: https://razorpay.com/docs/api/payments/payment-links/customise-payment-methods/
    options["config"] = {
      "display": {
        "blocks": {
          "utib": {
            "name": "Pay using Axis Bank",
            "instruments": [
              {
                "method": "card",
                "issuers": ["UTIB"]
              },
              {
                "method": "netbanking",
                "banks": ["UTIB"]
              }
            ]
          },
          "other": {
            "name": "Other Payment modes",
            "instruments": [
              {"method": "card"},
              {"method": "netbanking"},
              {"method": "wallet"}
            ]
          }
        },
        "hide": [
          {
            "method": "upi",
          },
          {"method": "emi"}
        ],
        "sequence": ["block.utib", "block.other"],
        "preferences": {"show_default_blocks": false}
      }
    };

    _razorpayWeb.open(options);
  }

  void _onSuccess(RpaySuccessResponse response) {
    // todo: your logic
  }

  void _onCancel(RpayCancelResponse response) {
    // todo: your logic
  }

  void _onFailed(RpayFailedResponse response) {
    // todo: your logic
  }

  @override
  void initState() {
    super.initState();

    _razorpayWeb = RazorpayWeb(
      onSuccess: _onSuccess,
      onCancel: _onCancel,
      onFailed: _onFailed,
    );
  }

  @override
  void dispose() {
    _razorpayWeb.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Running on: \n'),
            ElevatedButton(
              onPressed: () {
                getOrderId();
              },
              child: const Text("Make Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
