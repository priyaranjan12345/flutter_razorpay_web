import 'package:flutter/material.dart';
import 'package:flutter_razorpay_web_example/payment_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Razorpay Web'),
          centerTitle: true,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: Colors.black12,
            padding: constraints.maxWidth < 500
                ? EdgeInsets.zero
                : const EdgeInsets.all(30.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const PaymentForm(),
              ),
            ),
          );
        }),
      ),
    );
  }
}
