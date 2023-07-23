import '../models/rpay_cancel_response.dart';
import '../models/rpay_failed_response.dart';
import '../models/rpay_success_response.dart';

/// Flutter plugin for Razorpay Web.
class RazorpayWeb {
  final void Function(RpaySuccessResponse)? onSuccess;
  final void Function(RpayCancelResponse)? onCancel;
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
  void close() {}
}
