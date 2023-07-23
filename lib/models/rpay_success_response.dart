import 'dart:convert';

/// Razorpay success response
class RpaySuccessResponse {
  final String status;
  final String desc;
  final String paymentId;
  final String orderId;
  final String signature;
  RpaySuccessResponse({
    required this.status,
    required this.desc,
    required this.paymentId,
    required this.orderId,
    required this.signature,
  });

  RpaySuccessResponse copyWith({
    String? status,
    String? desc,
    String? paymentId,
    String? orderId,
    String? signature,
  }) {
    return RpaySuccessResponse(
      status: status ?? this.status,
      desc: desc ?? this.desc,
      paymentId: paymentId ?? this.paymentId,
      orderId: orderId ?? this.orderId,
      signature: signature ?? this.signature,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'desc': desc,
      'paymentId': paymentId,
      'orderId': orderId,
      'signature': signature,
    };
  }

  factory RpaySuccessResponse.fromMap(Map<String, dynamic> map) {
    return RpaySuccessResponse(
      status: map['status'] ?? '',
      desc: map['desc'] ?? '',
      paymentId: map['paymentId'] ?? '',
      orderId: map['orderId'] ?? '',
      signature: map['signature'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RpaySuccessResponse.fromJson(String source) =>
      RpaySuccessResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RpaySuccessResponse(status: $status, desc: $desc, paymentId: $paymentId, orderId: $orderId, signature: $signature)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RpaySuccessResponse &&
        other.status == status &&
        other.desc == desc &&
        other.paymentId == paymentId &&
        other.orderId == orderId &&
        other.signature == signature;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        desc.hashCode ^
        paymentId.hashCode ^
        orderId.hashCode ^
        signature.hashCode;
  }
}
