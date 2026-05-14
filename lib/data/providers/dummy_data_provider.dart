import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import '../models/user_model.dart';
import '../models/driver_model.dart';
import '../models/shift_model.dart';
import '../models/transaction_model.dart';
import '../models/incident_model.dart';

class DummyDataProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  List<DriverModel> _drivers = [];
  List<ShiftModel> _shifts = [];
  List<TransactionModel> _transactions = [];
  List<IncidentModel> _incidents = [];

  UserModel? _currentUser;
  bool _isLoading = true;

  List<UserModel> get users => _users;
  List<DriverModel> get drivers => _drivers;
  List<ShiftModel> get shifts => _shifts;
  List<TransactionModel> get transactions => _transactions;
  List<IncidentModel> get incidents => _incidents;
  
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  DummyDataProvider() {
    _loadDummyData();
  }

  Future<void> _loadDummyData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Intentar cargar desde los assets locales
      final jsonString = await rootBundle.loadString('assets/data/dummy_data.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      _users = (data['users'] as List)
          .map((u) => UserModel.fromJson(u))
          .toList();

      _drivers = (data['drivers'] as List)
          .map((d) => DriverModel.fromJson(d))
          .toList();

      _shifts = (data['shifts'] as List)
          .map((s) => ShiftModel.fromJson(s))
          .toList();

      _transactions = (data['transactions'] as List)
          .map((t) => TransactionModel.fromJson(t))
          .toList();

      _incidents = (data['incidents'] as List)
          .map((i) => IncidentModel.fromJson(i))
          .toList();
    } catch (e) {
      // Si falla en ambiente de test, cargar datos por defecto simulados directamente
      _loadFallbackData();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _loadFallbackData() {
    _users = [
      UserModel(id: "usr_root", fullName: "Técnico Kevin Flores", roleLabel: "Super Administrador DB", passwordHash: "1234"),
      UserModel(id: "usr_dir", fullName: "Director Carlos Mendoza", roleLabel: "Administrador", passwordHash: "1234"),
      UserModel(id: "usr_fin", fullName: "Contadora Patricia Ríos", roleLabel: "Contadora", passwordHash: "1234"),
      UserModel(id: "usr_op1", fullName: "Operadora Melissa", roleLabel: "Operadora", passwordHash: "1234"),
    ];

    _drivers = [
      DriverModel(id: "drv_001", mobileNumber: "Móvil 01", name: "Juan Pérez", bloodType: "O+", licenseExpiry: "2027-05-20", soatExpiry: "2026-12-15", currentDebt: 150.0, avatarUrl: "https://api.dicebear.com/7.x/avataaars/svg?seed=Juan", status: 'activo'),
      DriverModel(id: "drv_002", mobileNumber: "Móvil 02", name: "Roberto Gómez", bloodType: "A+", licenseExpiry: "2026-06-01", soatExpiry: "2026-05-30", currentDebt: 0.0, avatarUrl: "https://api.dicebear.com/7.x/avataaars/svg?seed=Roberto", status: 'activo'),
      DriverModel(id: "drv_004", mobileNumber: "Móvil 10", name: "Miguel Ángel Castro", bloodType: "O-", licenseExpiry: "2026-05-18", soatExpiry: "2026-08-22", currentDebt: 320.0, avatarUrl: "https://api.dicebear.com/7.x/avataaars/svg?seed=Miguel", status: 'falta'),
    ];

    _shifts = [
      ShiftModel(id: "sh_001", operatorId: "usr_op1", startTime: "06:00", endTime: "14:00", totalCalls: 145, canceledCalls: 12),
    ];

    _transactions = [
      TransactionModel(id: "tx_001", driverId: "drv_001", operatorId: "usr_op1", amount: 50.0, reason: "Pago a cuenta de saldo deudor", type: "pago", status: "aprobado"),
    ];

    _incidents = [
      IncidentModel(id: "inc_001", driverId: "drv_002", type: "falta limpieza", date: "2026-05-13 08:30"),
    ];
  }

  // Lógica de autenticación
  bool login(UserModel user, String password) {
    if (user.passwordHash == password) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Actualizar el estado dinámico del chofer (Panel de Operadora)
  void updateDriverStatus(String driverId, String newStatus) {
    final index = _drivers.indexWhere((d) => d.id == driverId);
    if (index != -1) {
      _drivers[index] = _drivers[index].copyWith(status: newStatus);
      
      // Si pasa a falta, podemos registrar un incidente automático
      if (newStatus == 'falta') {
        _incidents.insert(0, IncidentModel(
          id: 'inc_${DateTime.now().millisecondsSinceEpoch}',
          driverId: driverId,
          type: 'No contesta / Auto Sucio',
          date: "${DateTime.now().toIso8601String().split('T')[0]} ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
        ));
      }

      notifyListeners();
    }
  }

  // Ingreso de dinero a caja o registro de multa
  void addTransaction({
    required String driverId,
    required double amount,
    required String reason,
    required String type, // 'pago' o 'multa'
  }) {
    final newTx = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      driverId: driverId,
      operatorId: _currentUser?.id ?? 'usr_op1',
      amount: amount,
      reason: reason,
      type: type,
      status: type == 'pago' ? 'aprobado' : 'pendiente',
    );

    _transactions.insert(0, newTx);

    // Actualizar la deuda actual del chofer
    final index = _drivers.indexWhere((d) => d.id == driverId);
    if (index != -1) {
      double currentDebt = _drivers[index].currentDebt;
      if (type == 'pago') {
        currentDebt = (currentDebt - amount).clamp(0.0, double.infinity);
      } else if (type == 'multa') {
        currentDebt += amount;
      }
      _drivers[index] = _drivers[index].copyWith(currentDebt: currentDebt);
    }

    notifyListeners();
  }

  // Aprobación de transacciones pendientes en el Módulo Financiero
  void approveTransaction(String transactionId) {
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index != -1) {
      _transactions[index] = _transactions[index].copyWith(status: 'aprobado');
      notifyListeners();
    }
  }
}
