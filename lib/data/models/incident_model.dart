class IncidentModel {
  final String id;
  final String driverId;
  final String type; // 'falta limpieza', 'rechazo llamada'
  final String date;

  IncidentModel({
    required this.id,
    required this.driverId,
    required this.type,
    required this.date,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'] as String,
      driverId: json['driver_id'] as String,
      type: json['type'] as String,
      date: json['date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'type': type,
      'date': date,
    };
  }
}
