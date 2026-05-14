class ShiftModel {
  final String id;
  final String operatorId;
  final String startTime;
  final String endTime;
  final int totalCalls;
  final int canceledCalls;

  ShiftModel({
    required this.id,
    required this.operatorId,
    required this.startTime,
    required this.endTime,
    required this.totalCalls,
    required this.canceledCalls,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'] as String,
      operatorId: json['operator_id'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      totalCalls: json['total_calls'] as int,
      canceledCalls: json['canceled_calls'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operator_id': operatorId,
      'start_time': startTime,
      'end_time': endTime,
      'total_calls': totalCalls,
      'canceled_calls': canceledCalls,
    };
  }
}
