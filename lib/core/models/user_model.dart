import '../enums/user_role.dart';
import '../enums/appointment_status.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? avatar;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.avatar,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    this.metadata,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      role: UserRole.fromString(json['role'] ?? 'patient'),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'avatar': avatar,
      'role': role.value,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? avatar,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

class ClinicModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final List<String> images;
  final List<String> specialties;
  final double rating;
  final int reviewCount;
  final int doctorCount;
  final String city;
  final Map<String, String> workingHours;
  final List<String> features;
  final bool isActive;
  final DateTime createdAt;

  const ClinicModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    this.images = const [],
    this.specialties = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.doctorCount = 0,
    this.city = '',
    this.workingHours = const {},
    this.features = const [],
    this.isActive = true,
    required this.createdAt,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      specialties: List<String>.from(json['specialties'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      doctorCount: json['doctorCount'] ?? 0,
      city: json['city'] ?? '',
      workingHours: Map<String, String>.from(json['workingHours'] ?? {}),
      features: List<String>.from(json['features'] ?? []),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'images': images,
      'specialties': specialties,
      'rating': rating,
      'reviewCount': reviewCount,
      'doctorCount': doctorCount,
      'city': city,
      'workingHours': workingHours,
      'features': features,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class DoctorModel {
  final String id;
  final String userId;
  final String clinicId;
  final String title;
  final String specialty;
  final String experience;
  final List<String> education;
  final List<String> languages;
  final double rating;
  final int reviewCount;
  final double consultationFee;
  final Map<String, List<String>> availability;
  final bool isActive;

  const DoctorModel({
    required this.id,
    required this.userId,
    required this.clinicId,
    required this.title,
    required this.specialty,
    required this.experience,
    this.education = const [],
    this.languages = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.consultationFee = 0.0,
    this.availability = const {},
    this.isActive = true,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      clinicId: json['clinicId'] ?? '',
      title: json['title'] ?? '',
      specialty: json['specialty'] ?? '',
      experience: json['experience'] ?? '',
      education: List<String>.from(json['education'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      consultationFee: (json['consultationFee'] ?? 0.0).toDouble(),
      availability: Map<String, List<String>>.from(json['availability'] ?? {}),
      isActive: json['isActive'] ?? true,
    );
  }
}

class AppointmentModel {
  final String id;
  final String patientId;
  final String doctorId;
  final String clinicId;
  final DateTime appointmentDate;
  final String timeSlot;
  final AppointmentStatus status;
  final String? notes;
  final double fee;
  final DateTime createdAt;

  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.clinicId,
    required this.appointmentDate,
    required this.timeSlot,
    required this.status,
    this.notes,
    required this.fee,
    required this.createdAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      clinicId: json['clinicId'] ?? '',
      appointmentDate: DateTime.parse(json['appointmentDate']),
      timeSlot: json['timeSlot'] ?? '',
      status: AppointmentStatus.fromString(json['status'] ?? 'pending'),
      notes: json['notes'],
      fee: (json['fee'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
} 