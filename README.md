<p align="center">
<h1>
Flutter Razorpay Web Plugin
</h1>

Add this to `dependencies` in your app's `pubspec.yaml`

```yaml
razorpay_web: ^1.3.2
```

Run `flutter packages get` in the root directory of your app.

## Usage

Sample code to integrate

#### Import package

```dart
import 'package:flutter_razorpay_web/flutter_razorpay_web.dart';
```

create instance

```dart
late RazorpayWeb _razorpayWeb;
```

The handle events as per razorpay response

```dart
  void _onSuccess(RpaySuccessResponse response) {
    // todo: your logic
  }

  void _onCancel(RpayCancelResponse response) {
    // todo: your logic
  }

  void _onFailed(RpayFailedResponse response) {
    // todo: your logic
  }
```

Configure methods

```dart
  @override
  void initState() {
    super.initState();

    _razorpayWeb = RazorpayWeb(
      onSuccess: _onSuccess,
      onCancel: _onCancel,
      onFailed: _onFailed,
    );
  }
```

Close 

```dart
  @override
  void dispose() {
    _razorpayWeb.close();

    super.dispose();
  }
```

Now open razopay payment gateway
```dart
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

    // customise razorpay payment methods
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
```

