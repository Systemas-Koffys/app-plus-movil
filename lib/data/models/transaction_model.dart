class TransactionModel {
  final String id;
  final String driverId;
  final String operatorId;
  final double amount;
  final String reason;
  final String type; // 'multa' o 'pago'
  final String status; // 'pendiente' o 'aprobado'

  TransactionModel({
    required this.id,
    required this.driverId,
    required this.operatorId,
    required this.amount,
    required this.reason,
    required this.type,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      driverId: json['driver_id'] as String,
      operatorId: json['operator_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      reason: json['reason'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'operator_id': operatorId,
      'amount': amount,
      'reason': reason,
      'type': type,
      'status': status,
    };
  }

  TransactionModel copyWith({
    String? id,
    String? driverId,
    String? operatorId,
    double? amount,
    String? reason,
    String? type,
    String? status,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      operatorId: operatorId ?? this.operatorId,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }
}
