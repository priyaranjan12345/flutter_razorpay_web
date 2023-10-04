import 'package:flutter/material.dart';
import 'package:flutter_razorpay_web/flutter_razorpay_web.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  late RazorpayWeb _razorpayWeb;
  final orderIdController = TextEditingController();
  final keyIdController = TextEditingController();
  final amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void getOrderId() {
    /// todo: generate order id as per razorpay official documentation.
    /// ref: https://razorpay.com/docs/payments/server-integration/nodejs/payment-gateway/build-integration/#13-create-an-order-in-server
    /// generate order id on your backend otherwise you may face CORS-policy issue in web.

    /// after generation of order id, then call _makePayment
    _makePayment(
      amount: amountController.text,
      orderId: orderIdController.text,
      keyId: keyIdController.text,
    );
  }

  void _makePayment({
    required String amount,
    required String orderId,
    required String keyId,
  }) {
    /// create payment options
    /// you can modify as per your requirements
    /// ref: https://razorpay.com/docs/payments/server-integration/nodejs/payment-gateway/build-integration/#code-to-add-pay-button
    final Map<String, dynamic> options = {
      "key": keyId,
      "amount": amount,
      "currency": "INR",
      // "order_id": orderId,
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

    /// config razorpay payment methods.
    /// This is a optional step if you want
    /// to customize your payment methods then use this
    /// step otherwise you can skip this step
    /// you can also modify as per your requirements
    /// ref: https://razorpay.com/docs/api/payments/payment-links/customise-payment-methods/
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Success: ${response.desc}'),
      ),
    );
  }

  void _onCancel(RpayCancelResponse response) {
    // todo: your logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Cancel: ${response.desc}'),
      ),
    );
  }

  void _onFailed(RpayFailedResponse response) {
    // todo: your logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.desc}'),
      ),
    );
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
    _razorpayWeb.clear();
    amountController.dispose();
    orderIdController.dispose();
    keyIdController.dispose();
    formKey.currentState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          vertical: 30.0,
          horizontal: 25.0,
        ),
        children: [
          Text(
            'Test Payment',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: amountController,
            decoration: const InputDecoration(
              hintText: "Enter amount",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: orderIdController,
            decoration: const InputDecoration(
              hintText: "Enter order id",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter order id';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: keyIdController,
            decoration: const InputDecoration(
              hintText: "Enter key id",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter key id';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  getOrderId();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Processing...'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter data to procced'),
                    ),
                  );
                }
              },
              child: const Text("Make Payment"),
            ),
          ),
        ],
      ),
    );
  }
}
