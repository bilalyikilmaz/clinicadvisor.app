import 'package:flutter/material.dart';

enum UserRole {
  patient('patient', 'Hasta', 'Hasta kullanıcısı', Icons.person, Colors.orange),
  doctor('doctor', 'Doktor', 'Doktor kullanıcısı', Icons.medical_services, Colors.blue),
  clinicAdmin('clinic_admin', 'Klinik Yöneticisi', 'Klinik yöneticisi', Icons.business, Colors.green),
  admin('admin', 'Sistem Yöneticisi', 'Sistem yöneticisi', Icons.admin_panel_settings, Colors.red);

  const UserRole(this.value, this.displayName, this.description, this.icon, this.color);

  final String value;
  final String displayName;
  final String description;
  final IconData icon;
  final Color color;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.patient,
    );
  }
} 