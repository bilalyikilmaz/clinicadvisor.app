enum UserRole {
  patient('patient', 'Hasta', 'Hasta kullanıcısı'),
  doctor('doctor', 'Doktor', 'Doktor kullanıcısı'),
  clinicAdmin('clinic_admin', 'Klinik Yöneticisi', 'Klinik yöneticisi'),
  admin('admin', 'Sistem Yöneticisi', 'Sistem yöneticisi');

  const UserRole(this.value, this.displayName, this.description);

  final String value;
  final String displayName;
  final String description;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.patient,
    );
  }
} 