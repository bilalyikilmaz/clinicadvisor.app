import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../enums/user_role.dart';
import '../enums/appointment_status.dart';
import '../theme/app_colors.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal() {
    // Demo için başlangıçta guest kullanıcı
    _currentUser = null; // Guest mode
  }

  UserModel? _currentUser;
  
  // Getter methods
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isGuest => _currentUser == null;
  
  // Mock kullanıcılar - Gerçek uygulamada Firebase'den gelecek
  final List<UserModel> _mockUsers = [
    UserModel(
      id: '1',
      email: 'admin@clinicadvisor.com',
      name: 'Sistem Yöneticisi',
      role: UserRole.admin,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    UserModel(
      id: '2',
      email: 'dr.ahmet@acibadem.com',
      name: 'Dr. Ahmet Yılmaz',
      phone: '+90 532 123 4567',
      role: UserRole.doctor,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      metadata: {
        'specialty': 'Kardiyoloji',
        'clinicId': 'clinic_1',
        'experience': '15 yıl',
      },
    ),
    UserModel(
      id: '3',
      email: 'klinik@acibadem.com',
      name: 'Acıbadem Klinik Yöneticisi',
      role: UserRole.clinicAdmin,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      metadata: {
        'clinicId': 'clinic_1',
      },
    ),
    UserModel(
      id: '4',
      email: 'hasta@example.com',
      name: 'Mehmet Demir',
      phone: '+90 531 987 6543',
      role: UserRole.patient,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // Mock klinikler
  final List<ClinicModel> _mockClinics = [
    ClinicModel(
      id: 'clinic_1',
      name: 'Acıbadem Hastanesi',
      description: 'Türkiye\'nin önde gelen sağlık kurumlarından biri',
      address: 'Kadıköy, İstanbul',
      phone: '+90 216 544 4444',
      email: 'info@acibadem.com.tr',
      specialties: ['Kardiyoloji', 'Nöroloji', 'Ortopedi'],
      rating: 4.8,
      reviewCount: 1247,
      doctorCount: 45,
      city: 'İstanbul',
      features: ['Online Randevu', 'Otopark', 'Laboratuvar', 'Eczane'],
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    ClinicModel(
      id: 'clinic_2',
      name: 'Memorial Hastanesi',
      description: 'Uluslararası standartlarda sağlık hizmeti',
      address: 'Şişli, İstanbul',
      phone: '+90 212 314 6666',
      email: 'info@memorial.com.tr',
      specialties: ['Onkoloji', 'Kalp Cerrahisi', 'Beyin Cerrahisi'],
      rating: 4.7,
      reviewCount: 892,
      doctorCount: 32,
      city: 'İstanbul',
      features: ['VIP Odalar', 'Otopark', 'Kafeterya', 'WiFi'],
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
    ),
    ClinicModel(
      id: 'clinic_3',
      name: 'Medipol Hastanesi',
      description: 'Modern tıbbi teknolojilerle donatılmış hastane',
      address: 'Bağcılar, İstanbul',
      phone: '+90 212 460 7777',
      email: 'info@medipol.com.tr',
      specialties: ['Dermatoloji', 'Plastik Cerrahi', 'Göz Hastalıkları'],
      rating: 4.5,
      reviewCount: 654,
      doctorCount: 28,
      city: 'İstanbul',
      features: ['Estetik Merkezi', 'Otopark', 'Cafe', 'Çocuk Oyun Alanı'],
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
    ),
    ClinicModel(
      id: 'clinic_4',
      name: 'Ankara Üniversitesi Hastanesi',
      description: 'Üniversite hastanesi kalitesinde hizmet',
      address: 'Çankaya, Ankara',
      phone: '+90 312 508 2000',
      email: 'info@ankara.edu.tr',
      specialties: ['Tüm Branşlar', 'Acil Tıp', 'Transplantasyon'],
      rating: 4.6,
      reviewCount: 987,
      doctorCount: 120,
      city: 'Ankara',
      features: ['7/24 Acil', 'Ambulans', 'Yoğun Bakım', 'Laboratuvar'],
      createdAt: DateTime.now().subtract(const Duration(days: 500)),
    ),
    ClinicModel(
      id: 'clinic_5',
      name: 'Ege Üniversitesi Hastanesi',
      description: 'Ege bölgesinin en büyük sağlık merkezi',
      address: 'Bornova, İzmir',
      phone: '+90 232 390 4040',
      email: 'info@ege.edu.tr',
      specialties: ['Onkoloji', 'Kalp Cerrahisi', 'Nöroloji'],
      rating: 4.4,
      reviewCount: 723,
      doctorCount: 85,
      city: 'İzmir',
      features: ['Kanser Merkezi', 'Otopark', 'Sosyal Tesisler', 'Konuk Evi'],
      createdAt: DateTime.now().subtract(const Duration(days: 400)),
    ),
    ClinicModel(
      id: 'clinic_6',
      name: 'Özel Diş Kliniği',
      description: 'Dental implant ve estetik diş hekimliği',
      address: 'Nişantaşı, İstanbul',
      phone: '+90 212 225 0000',
      email: 'info@dentalclinic.com.tr',
      specialties: ['Diş Hekimliği', 'Oral Cerrahi', 'Estetik'],
      rating: 4.9,
      reviewCount: 345,
      doctorCount: 8,
      city: 'İstanbul',
      features: ['Dijital Röntgen', 'Lazer Tedavi', 'Sedasyon', 'Valet'],
      createdAt: DateTime.now().subtract(const Duration(days: 150)),
    ),
  ];

  // Mock doktorlar
  final List<DoctorModel> _mockDoctors = [
    DoctorModel(
      id: 'doctor_1',
      userId: '2',
      clinicId: 'clinic_1',
      title: 'Prof. Dr.',
      specialty: 'Kardiyoloji',
      experience: '15 yıl',
      education: ['İstanbul Üniversitesi Tıp Fakültesi', 'Harvard Medical School'],
      languages: ['Türkçe', 'İngilizce'],
      rating: 4.9,
      reviewCount: 234,
      consultationFee: 500.0,
      availability: {
        'Pazartesi': ['09:00', '10:00', '11:00', '14:00', '15:00'],
        'Salı': ['09:00', '10:00', '11:00', '14:00', '15:00'],
        'Çarşamba': ['09:00', '10:00', '11:00'],
      },
    ),
  ];

  // Mock randevular
  final List<AppointmentModel> _mockAppointments = [
    AppointmentModel(
      id: 'apt_1',
      patientId: '4',
      doctorId: 'doctor_1',
      clinicId: 'clinic_1',
      appointmentDate: DateTime.now().add(const Duration(days: 1)),
      timeSlot: '14:00',
      status: AppointmentStatus.confirmed,
      fee: 500.0,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      notes: 'Kalp kontrol muayenesi',
    ),
  ];

  List<ClinicModel> get clinics => _mockClinics;
  List<DoctorModel> get doctors => _mockDoctors;
  List<AppointmentModel> get appointments => _mockAppointments;

  // Login simulation
  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    final user = _mockUsers.firstWhere(
      (user) => user.email == email,
      orElse: () => _mockUsers[3], // Default to patient for demo
    );
    
    _currentUser = user;
    return user;
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
  }

  // Switch user role for demo purposes
  void switchToRole(UserRole role) {
    final user = _mockUsers.firstWhere(
      (user) => user.role == role,
      orElse: () => _mockUsers[3],
    );
    _currentUser = user;
  }

  // Get user statistics
  Map<String, dynamic> getUserStats() {
    switch (_currentUser?.role) {
      case UserRole.admin:
        return {
          'totalUsers': _mockUsers.length,
          'totalClinics': _mockClinics.length,
          'totalDoctors': _mockDoctors.length,
          'totalAppointments': _mockAppointments.length,
          'activeUsers': _mockUsers.where((u) => u.isActive).length,
          'revenue': 25000.0,
        };
      case UserRole.doctor:
        final doctorAppointments = _mockAppointments.where(
          (apt) => apt.doctorId == 'doctor_1',
        ).toList();
        return {
          'todayAppointments': doctorAppointments.length,
          'weeklyAppointments': doctorAppointments.length * 5,
          'monthlyRevenue': doctorAppointments.length * 500.0,
          'patientCount': doctorAppointments.length,
          'rating': 4.9,
        };
      case UserRole.clinicAdmin:
        final clinicAppointments = _mockAppointments.where(
          (apt) => apt.clinicId == 'clinic_1',
        ).toList();
        return {
          'totalDoctors': _mockDoctors.where((d) => d.clinicId == 'clinic_1').length,
          'todayAppointments': clinicAppointments.length,
          'monthlyRevenue': clinicAppointments.length * 500.0,
          'rating': 4.8,
          'reviewCount': 1247,
        };
      case UserRole.patient:
        final patientAppointments = _mockAppointments.where(
          (apt) => apt.patientId == '4',
        ).toList();
        return {
          'upcomingAppointments': patientAppointments.length,
          'completedAppointments': 5,
          'favoritesDoctors': 3,
          'totalSpent': 2500.0,
        };
      default:
        return {};
    }
  }

  // Get role-specific notifications
  List<Map<String, dynamic>> getNotifications() {
    switch (_currentUser?.role) {
      case UserRole.admin:
        return [
          {
            'title': 'Yeni Klinik Başvurusu',
            'message': 'Medilife Hastanesi onay bekliyor',
            'time': '10 dk önce',
            'icon': Icons.business,
            'color': AppColors.primary,
          },
          {
            'title': 'Sistem Güncellemesi',
            'message': 'v2.1.0 güncellemesi hazır',
            'time': '1 saat önce',
            'icon': Icons.system_update,
            'color': AppColors.info,
          },
        ];
      case UserRole.doctor:
        return [
          {
            'title': 'Yeni Randevu',
            'message': 'Ayşe Kaya yarın 15:00 randevusu',
            'time': '5 dk önce',
            'icon': Icons.calendar_today,
            'color': AppColors.primary,
          },
          {
            'title': 'Hasta Notları',
            'message': 'Mehmet Demir için rapor hazır',
            'time': '30 dk önce',
            'icon': Icons.note_alt,
            'color': AppColors.secondary,
          },
        ];
      case UserRole.clinicAdmin:
        return [
          {
            'title': 'Doktor Başvurusu',
            'message': 'Dr. Zeynep Kaya başvuru yaptı',
            'time': '15 dk önce',
            'icon': Icons.person_add,
            'color': AppColors.primary,
          },
          {
            'title': 'Aylık Rapor',
            'message': 'Mart ayı performans raporu hazır',
            'time': '2 saat önce',
            'icon': Icons.assessment,
            'color': AppColors.accent,
          },
        ];
      case UserRole.patient:
        return [
          {
            'title': 'Randevu Hatırlatması',
            'message': 'Yarın 14:00 Dr. Yılmaz randevunuz',
            'time': '1 saat önce',
            'icon': Icons.schedule,
            'color': AppColors.primary,
          },
          {
            'title': 'Test Sonuçları',
            'message': 'Kan tahlili sonuçlarınız hazır',
            'time': '3 saat önce',
            'icon': Icons.biotech,
            'color': AppColors.secondary,
          },
        ];
      default:
        return [];
    }
  }

  // Clinic Methods
  ClinicModel? getClinicById(String clinicId) {
    try {
      return _mockClinics.firstWhere((clinic) => clinic.id == clinicId);
    } catch (e) {
      return null;
    }
  }

  List<ClinicModel> getClinicsBySpecialty(String specialty) {
    return _mockClinics.where((clinic) => clinic.specialties.contains(specialty)).toList();
  }

  List<ClinicModel> getClinicsByCity(String city) {
    return _mockClinics.where((clinic) => clinic.address.contains(city)).toList();
  }

  List<ClinicModel> searchClinics(String query) {
    if (query.isEmpty) return _mockClinics;
    
    return _mockClinics.where((clinic) {
      return clinic.name.toLowerCase().contains(query.toLowerCase()) ||
             clinic.address.toLowerCase().contains(query.toLowerCase()) ||
             clinic.specialties.any((specialty) => specialty.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  // Set current user role for demo purposes
  void setCurrentUserRole(UserRole role) {
    final user = _mockUsers.firstWhere(
      (user) => user.role == role,
      orElse: () => _mockUsers[3],
    );
    _currentUser = user;
  }
} 