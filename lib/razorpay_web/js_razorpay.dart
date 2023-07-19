import 'package:js/js.dart';
import 'package:js/js_util.dart';

class JsRazorpay {
  final Razorpay razorpay;

  JsRazorpay({
    required Map<dynamic, dynamic> options,
    required Function(dynamic) onFailed,
  }) : razorpay = Razorpay(
          jsify(options),
        )..on(
            'payment.failed',
            allowInterop(onFailed),
          );

  void open() => razorpay.open();
  void close() => razorpay.close();
}

@JS()
class Razorpay {
  external Razorpay(dynamic options);
  external open();
  external on(String type, Function(dynamic) onResponse);
  external close();
}

@JS('JSON.stringify')
external String stringify(Object obj);
