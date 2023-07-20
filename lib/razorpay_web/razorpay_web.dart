import 'dart:async';
import 'dart:convert';

import 'package:js/js.dart';

import '../models/rpay_cancel_response.dart';
import '../models/rpay_failed_response.dart';
import '../models/rpay_success_response.dart';
import 'js_razorpay.dart';

class RazorpayWeb {
  final void Function(RpaySuccessResponse)? onSuccess;
  final void Function(RpayCancelResponse)? onCancel;
  final void Function(RpayFailedResponse)? onFailed;

  JsRazorpay? _jsRazorpay;

  RazorpayWeb({
    this.onSuccess,
    this.onFailed,
    this.onCancel,
  });

  void _handleResponse(Map<String, dynamic> result) {
    switch (result['status']) {
      case 'success':
        final response = RpaySuccessResponse.fromMap(result);
        onSuccess?.call(response);
        break;
      case 'failed':
        final response = RpayFailedResponse.fromMap(result);
        onFailed?.call(response);
        break;
      case 'cancelled':
        final response = RpayCancelResponse.fromMap(result);
        onCancel?.call(response);
        break;
    }
  }

  Map<String, dynamic> _validateOptions(Map<String, dynamic> options) {
    if (options['key'] == null) {
      return {
        'success': false,
        'message':
            'Key is required. Please check if key is present in options.',
      };
    }
    return {
      'success': true,
    };
  }

  Map<String, dynamic>? _mapify(dynamic obj) {
    if (obj == null) return null;
    return jsonDecode(stringify(obj));
  }

  Future<Map<String, dynamic>> _stratPayment(Map<String, dynamic> options) {
    final completer = Completer<Map<String, dynamic>>();
    Map<String, dynamic> data = {};

    options['handler'] = allowInterop((dynamic res) {
      final response = _mapify(res);

      data['status'] = "success";
      data['desc'] = "Payment success.";
      data['paymentId'] = response?['razorpay_payment_id'] as String?;
      data['orderId'] = response?['razorpay_order_id'] as String?;
      data['signature'] = response?['razorpay_signature'] as String?;
      completer.complete(data);
    });
    options['modal.ondismiss'] = allowInterop((response) {
      if (!completer.isCompleted) {
        data['status'] = "cancelled";
        data['desc'] = "Payment processing cancelled by user.";
        completer.complete(data);
      }
    });

    _jsRazorpay = JsRazorpay(
        options: options,
        onFailed: (res) {
          final response = _mapify(res);

          data["status"] = "failed";
          data["code"] = response?['error']['code'] as String?;
          data["desc"] = response?['error']['description'] as String?;
          data["source"] = response?['error']['source'] as String?;
          data["step"] = response?['error']['step'] as String?;
          data["reason"] = response?['error']['reason'] as String?;
          data["orderId"] =
              response?['error']['metadata']['order_id'] as String?;
          data["paymentId"] =
              response?['error']['metadata']['payment_id'] as String?;
          completer.complete(data);
        });

    // open
    // _jsRazorpay not null
    _jsRazorpay?.open();

    return completer.future;
  }

  /// open razorpay checkout<br>
  /// usage:-
  /// ```dart
  /// RazorpayWeb.open(options);
  /// ```
  void open(Map<String, dynamic> options) async {
    Map<String, dynamic> validationResult = _validateOptions(options);

    if (!validationResult['success']) {
      _handleResponse({
        "status": "failed",
        "desc": "Key is required. Please check if key is present in options.",
      });
      return;
    }

    final response = await _stratPayment(options);

    if (response.isNotEmpty) {
      _handleResponse(response);
    } else {
      _handleResponse({
        "status'": "failed",
        "desc": "Payment failed due to interruption.",
      });
    }
  }

  /// close razorpay checkout<br>
  /// usage:-
  /// ```dart
  /// RazorpayWeb.close();
  /// ```
  void close() {
    if (_jsRazorpay != null) {
      _jsRazorpay?.close();
    }
  }
}
