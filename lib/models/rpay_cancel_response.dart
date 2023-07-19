import 'dart:convert';

class RpayCancelResponse {
  final String status;
  final String desc;
  RpayCancelResponse({
    required this.status,
    required this.desc,
  });

  RpayCancelResponse copyWith({
    String? status,
    String? desc,
  }) {
    return RpayCancelResponse(
      status: status ?? this.status,
      desc: desc ?? this.desc,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'desc': desc,
    };
  }

  factory RpayCancelResponse.fromMap(Map<String, dynamic> map) {
    return RpayCancelResponse(
      status: map['status'] ?? '',
      desc: map['desc'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RpayCancelResponse.fromJson(String source) =>
      RpayCancelResponse.fromMap(json.decode(source));

  @override
  String toString() => 'RpayCancelResponse(status: $status, desc: $desc)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RpayCancelResponse &&
        other.status == status &&
        other.desc == desc;
  }

  @override
  int get hashCode => status.hashCode ^ desc.hashCode;
}
