import 'dart:async';
import 'dart:convert';

import 'package:js/js.dart';

import '../models/rpay_cancel_response.dart';
import '../models/rpay_failed_response.dart';
import '../models/rpay_success_response.dart';
import 'js_razorpay.dart';

/// Flutter plugin for Razorpay Web.
class RazorpayWeb {
  /// handle event on payment success.
  final void Function(RpaySuccessResponse)? onSuccess;

  /// handle event on payment cancel.
  final void Function(RpayCancelResponse)? onCancel;

  /// handle event on payment failed.
  final void Function(RpayFailedResponse)? onFailed;

  /// instance of JsRazorpay class.
  JsRazorpay? _jsRazorpay;

  RazorpayWeb({
    this.onSuccess,
    this.onFailed,
    this.onCancel,
  });

  /// Handles checkout response from razorpay gateway.
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

  /// Validate payment options.
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

  /// Convert LegacyJavaScriptObject to Dart Map.
  Map<String, dynamic>? _mapify(dynamic obj) {
    if (obj == null) return null;
    return jsonDecode(stringify(obj));
  }

  /// Opens Razorpay checkout.
  Future<Map<String, dynamic>> _stratPayment(Map<String, dynamic> options) {
    // required for sending value after the data has been populated
    final completer = Completer<Map<String, dynamic>>();

    // return map object
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

    // assign options
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
        data["orderId"] = response?['error']['metadata']['order_id'] as String?;
        data["paymentId"] =
            response?['error']['metadata']['payment_id'] as String?;
        completer.complete(data);
      },
    );

    // open payment gateway.
    // _jsRazorpay not null.
    _jsRazorpay?.open();

    return completer.future;
  }

  /// open razorpay checkout.<br>
  /// usage:-
  /// ```dart
  /// razorpayWeb.open(options);
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

  /// close razorpay checkout.<br>
  /// usage:-
  /// ```dart
  /// razorpayWeb.close();
  /// ```
  void close() {
    if (_jsRazorpay != null) {
      _jsRazorpay?.close();
    }
  }
}
