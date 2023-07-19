import 'dart:convert';

class RpayFailedResponse {
  final String status;
  final String desc;
  final String reason;
  final String orderId;
  final String paymentId;
  RpayFailedResponse({
    required this.status,
    required this.desc,
    required this.reason,
    required this.orderId,
    required this.paymentId,
  });

  RpayFailedResponse copyWith({
    String? status,
    String? desc,
    String? reason,
    String? orderId,
    String? paymentId,
  }) {
    return RpayFailedResponse(
      status: status ?? this.status,
      desc: desc ?? this.desc,
      reason: reason ?? this.reason,
      orderId: orderId ?? this.orderId,
      paymentId: paymentId ?? this.paymentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'desc': desc,
      'reason': reason,
      'orderId': orderId,
      'paymentId': paymentId,
    };
  }

  factory RpayFailedResponse.fromMap(Map<String, dynamic> map) {
    return RpayFailedResponse(
      status: map['status'] ?? '',
      desc: map['desc'] ?? '',
      reason: map['reason'] ?? '',
      orderId: map['orderId'] ?? '',
      paymentId: map['paymentId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RpayFailedResponse.fromJson(String source) =>
      RpayFailedResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RpayFailedResponse(status: $status, desc: $desc, reason: $reason, orderId: $orderId, paymentId: $paymentId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RpayFailedResponse &&
        other.status == status &&
        other.desc == desc &&
        other.reason == reason &&
        other.orderId == orderId &&
        other.paymentId == paymentId;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        desc.hashCode ^
        reason.hashCode ^
        orderId.hashCode ^
        paymentId.hashCode;
  }
}
