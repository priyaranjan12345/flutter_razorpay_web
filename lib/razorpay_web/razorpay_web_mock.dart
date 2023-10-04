import '../models/rpay_cancel_response.dart';
import '../models/rpay_failed_response.dart';
import '../models/rpay_success_response.dart';

/// Flutter plugin for Razorpay Web.
class RazorpayWeb {
  /// handle event on payment success.
  final void Function(RpaySuccessResponse)? onSuccess;

  /// handle event on payment cancel.
  final void Function(RpayCancelResponse)? onCancel;

  /// handle event on payment failed.
  final void Function(RpayFailedResponse)? onFailed;

  RazorpayWeb({
    this.onSuccess,
    this.onFailed,
    this.onCancel,
  });

  /// open razorpay checkout<br>
  /// usage:-
  /// ```dart
  /// RazorpayWeb.open(options);
  /// ```
  void open(Map<String, dynamic> options) {}

  /// close razorpay checkout<br>
  /// usage:-
  /// ```dart
  /// RazorpayWeb.close();
  /// ```
  void clear() {}
}
