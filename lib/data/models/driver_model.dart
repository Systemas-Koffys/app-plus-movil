class DriverModel {
  final String id;
  final String mobileNumber;
  final String name;
  final String bloodType;
  final String licenseExpiry;
  final String soatExpiry;
  final double currentDebt;
  final String avatarUrl;
  // Estado dinámico para el Panel Operativo: 'activo', 'permiso', 'falta'
  final String status;

  DriverModel({
    required this.id,
    required this.mobileNumber,
    required this.name,
    required this.bloodType,
    required this.licenseExpiry,
    required this.soatExpiry,
    required this.currentDebt,
    required this.avatarUrl,
    this.status = 'activo', // por defecto en asistencia/activo
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String,
      mobileNumber: json['mobile_number'] as String,
      name: json['name'] as String,
      bloodType: json['blood_type'] as String,
      licenseExpiry: json['license_expiry'] as String,
      soatExpiry: json['soat_expiry'] as String,
      currentDebt: (json['current_debt'] as num).toDouble(),
      avatarUrl: json['avatar_url'] as String,
      status: json['status'] as String? ?? 'activo',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile_number': mobileNumber,
      'name': name,
      'blood_type': bloodType,
      'license_expiry': licenseExpiry,
      'soat_expiry': soatExpiry,
      'current_debt': currentDebt,
      'avatar_url': avatarUrl,
      'status': status,
    };
  }

  DriverModel copyWith({
    String? id,
    String? mobileNumber,
    String? name,
    String? bloodType,
    String? licenseExpiry,
    String? soatExpiry,
    double? currentDebt,
    String? avatarUrl,
    String? status,
  }) {
    return DriverModel(
      id: id ?? this.id,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      name: name ?? this.name,
      bloodType: bloodType ?? this.bloodType,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      soatExpiry: soatExpiry ?? this.soatExpiry,
      currentDebt: currentDebt ?? this.currentDebt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
    );
  }
}
