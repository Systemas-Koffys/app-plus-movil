class UserModel {
  final String id;
  final String fullName;
  final String roleLabel;
  final String passwordHash;

  UserModel({
    required this.id,
    required this.fullName,
    required this.roleLabel,
    required this.passwordHash,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      roleLabel: json['role_label'] as String,
      passwordHash: json['password_hash'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'role_label': roleLabel,
      'password_hash': passwordHash,
    };
  }
}
