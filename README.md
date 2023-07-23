<p align="center">
<h1>
Flutter Razorpay Web Plugin
</h1>

<p>
"flutter_razorpay_web" is a Flutter plugin designed to facilitate smooth integration of Razorpay's payment gateway services specifically for web-based Flutter applications.
</p>

![48184454-17c1bc80-e358-11e8-8821-269a30935a68](https://github.com/priyaranjan12345/flutter_razorpay_web/assets/47207977/7c107eed-5b02-40a5-b036-cfc21f58b19a)


Add this to `dependencies` in your app's `pubspec.yaml`

```yaml
flutter_razorpay_web: ^0.0.1
```

Run `flutter packages get` in the root directory of your app.

## Demo

![3](https://github.com/priyaranjan12345/flutter_razorpay_web/assets/47207977/29c76cb3-b5bb-406c-9d1d-0fb6844a937a)

## Important step

Include `checkout.js` in `index.html` file inside your `web folder`

```html
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
```
For e.g,-

```html
<body>
  <script>
    window.addEventListener('load', function(ev) {
      // Download main.dart.js
      _flutter.loader.loadEntrypoint({
        serviceWorker: {
          serviceWorkerVersion: serviceWorkerVersion,
        },
        onEntrypointLoaded: function(engineInitializer) {
          engineInitializer.initializeEngine().then(function(appRunner) {
            appRunner.runApp();
          });
        }
      });
    });
  </script>
  <!-- razorpay checkout lib -->
  <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
</body>
```

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
    // generate order id on your backend otherwise you may face CORS-policy issue in web.

    // after generation of order id, then call _makePayment
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
    // you can modify as per your requirements.
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

    // config razorpay payment methods.
    // This is a optional step if you want 
    // to customize your payment method then use this 
    // step otherwise you can skip this step
    // you can modify as per your requirements
    // ref: https://razorpay.com/docs/payments/payment-gateway/web-integration/standard/configure-payment-methods/
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

