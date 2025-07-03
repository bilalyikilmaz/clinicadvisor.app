import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/treatment_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static const String clinicsCollection = 'clinics';
  static const String treatmentsCollection = 'treatments';
  static const String categoriesCollection = 'categories';
  static const String clinicTreatmentsCollection = 'clinic_treatments';
  static const String usersCollection = 'users';
  static const String doctorsCollection = 'doctors';
  static const String appointmentsCollection = 'appointments';

  // Clinics
  Future<List<ClinicModel>> getClinics() async {
    try {
      final snapshot = await _firestore.collection(clinicsCollection).get();
      return snapshot.docs
          .map((doc) => ClinicModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting clinics: $e');
      return [];
    }
  }

  Future<void> addClinic(ClinicModel clinic) async {
    try {
      await _firestore
          .collection(clinicsCollection)
          .doc(clinic.id)
          .set(clinic.toJson());
    } catch (e) {
      print('Error adding clinic: $e');
    }
  }

  Stream<List<ClinicModel>> getClinicsStream() {
    return _firestore.collection(clinicsCollection).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ClinicModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Treatments
  Future<List<TreatmentModel>> getTreatments() async {
    try {
      final snapshot = await _firestore.collection(treatmentsCollection).get();
      return snapshot.docs
          .map((doc) => TreatmentModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting treatments: $e');
      return [];
    }
  }

  Future<void> addTreatment(TreatmentModel treatment) async {
    try {
      await _firestore
          .collection(treatmentsCollection)
          .doc(treatment.id)
          .set(treatment.toJson());
    } catch (e) {
      print('Error adding treatment: $e');
    }
  }

  Stream<List<TreatmentModel>> getTreatmentsStream() {
    return _firestore.collection(treatmentsCollection).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => TreatmentModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Treatment Categories
  Future<List<TreatmentCategory>> getCategories() async {
    try {
      final snapshot = await _firestore.collection(categoriesCollection).get();
      return snapshot.docs
          .map((doc) => TreatmentCategory.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  Future<void> addCategory(TreatmentCategory category) async {
    try {
      await _firestore
          .collection(categoriesCollection)
          .doc(category.id)
          .set(category.toJson());
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  // Clinic Treatments
  Future<List<ClinicTreatmentModel>> getClinicTreatments() async {
    try {
      final snapshot = await _firestore.collection(clinicTreatmentsCollection).get();
      return snapshot.docs
          .map((doc) => ClinicTreatmentModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting clinic treatments: $e');
      return [];
    }
  }

  Future<List<ClinicTreatmentModel>> getClinicTreatmentsByClinic(String clinicId) async {
    try {
      final snapshot = await _firestore
          .collection(clinicTreatmentsCollection)
          .where('clinicId', isEqualTo: clinicId)
          .get();
      return snapshot.docs
          .map((doc) => ClinicTreatmentModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting clinic treatments: $e');
      return [];
    }
  }

  Future<void> addClinicTreatment(ClinicTreatmentModel clinicTreatment) async {
    try {
      await _firestore
          .collection(clinicTreatmentsCollection)
          .doc(clinicTreatment.id)
          .set(clinicTreatment.toJson());
    } catch (e) {
      print('Error adding clinic treatment: $e');
    }
  }

  // Search
  Future<List<ClinicModel>> searchClinics(String query) async {
    try {
      final snapshot = await _firestore.collection(clinicsCollection).get();
      final clinics = snapshot.docs
          .map((doc) => ClinicModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      
      if (query.isEmpty) return clinics;
      
      return clinics.where((clinic) {
        return clinic.name.toLowerCase().contains(query.toLowerCase()) ||
               clinic.address.toLowerCase().contains(query.toLowerCase()) ||
               clinic.specialties.any((specialty) => 
                   specialty.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    } catch (e) {
      print('Error searching clinics: $e');
      return [];
    }
  }

  Future<List<TreatmentModel>> searchTreatments(String query) async {
    try {
      final snapshot = await _firestore.collection(treatmentsCollection).get();
      final treatments = snapshot.docs
          .map((doc) => TreatmentModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      
      if (query.isEmpty) return treatments;
      
      return treatments.where((treatment) {
        return treatment.name.toLowerCase().contains(query.toLowerCase()) ||
               treatment.description.toLowerCase().contains(query.toLowerCase()) ||
               treatment.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      print('Error searching treatments: $e');
      return [];
    }
  }

  // Popular and trending data
  Future<List<ClinicModel>> getPopularClinics({int limit = 6}) async {
    try {
      final snapshot = await _firestore
          .collection(clinicsCollection)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => ClinicModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting popular clinics: $e');
      return [];
    }
  }

  Future<List<TreatmentModel>> getPopularTreatments({int limit = 6}) async {
    try {
      final snapshot = await _firestore
          .collection(treatmentsCollection)
          .where('isPopular', isEqualTo: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => TreatmentModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting popular treatments: $e');
      return [];
    }
  }

  Future<List<TreatmentModel>> getTrendingTreatments({int limit = 6}) async {
    try {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      
      final snapshot = await _firestore
          .collection(treatmentsCollection)
          .where('createdAt', isGreaterThan: Timestamp.fromDate(weekAgo))
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => TreatmentModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting trending treatments: $e');
      return [];
    }
  }

  Future<List<TreatmentModel>> getDiscountedTreatments({int limit = 6}) async {
    try {
      final snapshot = await _firestore
          .collection(treatmentsCollection)
          .where('discountPrice', isNull: false)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => TreatmentModel.fromJson({...doc.data(), 'id': doc.id}))
          .where((treatment) => treatment.hasDiscount)
          .toList();
    } catch (e) {
      print('Error getting discounted treatments: $e');
      return [];
    }
  }

  // Initialize sample data
  Future<void> initializeSampleData() async {
    try {
      // Check if data already exists
      final clinicsSnapshot = await _firestore.collection(clinicsCollection).limit(1).get();
      if (clinicsSnapshot.docs.isNotEmpty) {
        print('Sample data already exists');
        return;
      }

      print('Initializing sample data...');
      await _addSampleCategories();
      await _addSampleClinics();
      await _addSampleTreatments();
      await _addSampleClinicTreatments();
      print('Sample data initialized successfully');
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }

  Future<void> _addSampleCategories() async {
    final categories = [
      TreatmentCategory(
        id: 'cardiology',
        name: 'Kardiyoloji',
        description: 'Kalp ve damar hastalıkları',
        icon: 'favorite',
        color: 'red',
        isPopular: true,
      ),
      TreatmentCategory(
        id: 'dermatology',
        name: 'Dermatoloji',
        description: 'Cilt hastalıkları ve estetik',
        icon: 'face',
        color: 'pink',
        isPopular: true,
      ),
      TreatmentCategory(
        id: 'orthopedics',
        name: 'Ortopedi',
        description: 'Kemik ve eklem hastalıkları',
        icon: 'accessibility',
        color: 'blue',
        isPopular: true,
      ),
      TreatmentCategory(
        id: 'neurology',
        name: 'Nöroloji',
        description: 'Beyin ve sinir hastalıkları',
        icon: 'psychology',
        color: 'purple',
      ),
      TreatmentCategory(
        id: 'ophthalmology',
        name: 'Göz Hastalıkları',
        description: 'Göz muayenesi ve tedavisi',
        icon: 'visibility',
        color: 'green',
      ),
      TreatmentCategory(
        id: 'dentistry',
        name: 'Diş Hekimliği',
        description: 'Ağız ve diş sağlığı',
        icon: 'medical_services',
        color: 'teal',
        isPopular: true,
      ),
    ];

    for (final category in categories) {
      await addCategory(category);
    }
  }

  Future<void> _addSampleClinics() async {
    final clinics = [
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

    for (final clinic in clinics) {
      await addClinic(clinic);
    }
  }

  Future<void> _addSampleTreatments() async {
    final treatments = [
      TreatmentModel(
        id: 'echo_cardio',
        name: 'Ekokardiyografi',
        description: 'Kalbin ultrason ile görüntülenmesi ve değerlendirilmesi',
        category: 'cardiology',
        price: 350.0,
        duration: 30,
        features: ['Non-invaziv', 'Anında sonuç', 'Uzman değerlendirmesi'],
        isPopular: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      TreatmentModel(
        id: 'stress_test',
        name: 'Stress Testi',
        description: 'Kalbin egzersiz sırasındaki performansının değerlendirilmesi',
        category: 'cardiology',
        price: 450.0,
        discountPrice: 380.0,
        duration: 45,
        features: ['EKG takibi', 'Kan basıncı ölçümü', 'Uzman eşliğinde'],
        requirements: ['Rahat spor kıyafeti', '4 saat açlık'],
        isPopular: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      TreatmentModel(
        id: 'skin_analysis',
        name: 'Cilt Analizi',
        description: 'Detaylı cilt incelemesi ve kişiselleştirilmiş bakım önerileri',
        category: 'dermatology',
        price: 250.0,
        duration: 30,
        features: ['Dijital cilt analizi', 'Kişisel bakım planı', 'Ürün önerileri'],
        isPopular: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      TreatmentModel(
        id: 'acne_treatment',
        name: 'Akne Tedavisi',
        description: 'Profesyonel akne tedavisi ve cilt bakımı',
        category: 'dermatology',
        price: 400.0,
        discountPrice: 320.0,
        duration: 60,
        features: ['Profesyonel temizlik', 'Medikal tedavi', '3 seans dahil'],
        requirements: ['Güneşe çıkmama', 'Özel kremler'],
        isPopular: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      TreatmentModel(
        id: 'mri_knee',
        name: 'Diz MR Çekimi',
        description: 'Diz ekleminin detaylı manyetik rezonans görüntülemesi',
        category: 'orthopedics',
        price: 600.0,
        duration: 45,
        features: ['Yüksek çözünürlük', 'Uzman raporu', 'CD teslimi'],
        requirements: ['Metal implant kontrolü', 'Kontrast madde bilgisi'],
        isPopular: true,
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
      ),
      TreatmentModel(
        id: 'physical_therapy',
        name: 'Fizik Tedavi',
        description: '10 seanslık kas-iskelet sistemi rehabilitasyonu',
        category: 'orthopedics',
        price: 800.0,
        discountPrice: 650.0,
        duration: 45,
        features: ['Kişisel program', '10 seans', 'Evde egzersiz planı'],
        isPopular: true,
        createdAt: DateTime.now().subtract(const Duration(days: 22)),
      ),
      TreatmentModel(
        id: 'eye_exam',
        name: 'Kapsamlı Göz Muayenesi',
        description: 'Görme keskinliği ve göz sağlığı kontrolü',
        category: 'ophthalmology',
        price: 200.0,
        duration: 30,
        features: ['Görme testi', 'Göz tabanı muayenesi', 'Göz basıncı ölçümü'],
        isPopular: true,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      TreatmentModel(
        id: 'dental_cleaning',
        name: 'Diş Temizliği',
        description: 'Profesyonel diş temizliği ve kontrolü',
        category: 'dentistry',
        price: 150.0,
        duration: 30,
        features: ['Tartar temizliği', 'Polisaj', 'Kontrol muayenesi'],
        isPopular: true,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
    ];

    for (final treatment in treatments) {
      await addTreatment(treatment);
    }
  }

  Future<void> _addSampleClinicTreatments() async {
    final clinicTreatments = [
      ClinicTreatmentModel(
        id: 'ct_1',
        clinicId: 'clinic_1',
        treatmentId: 'echo_cardio',
        customPrice: 350.0,
        availableDays: ['Pazartesi', 'Çarşamba', 'Cuma'],
        availableHours: ['09:00', '11:00', '14:00', '16:00'],
        rating: 5,
        reviewCount: 45,
      ),
      ClinicTreatmentModel(
        id: 'ct_2',
        clinicId: 'clinic_1',
        treatmentId: 'stress_test',
        customPrice: 420.0,
        availableDays: ['Salı', 'Perşembe'],
        availableHours: ['10:00', '14:00'],
        rating: 5,
        reviewCount: 23,
      ),
      ClinicTreatmentModel(
        id: 'ct_3',
        clinicId: 'clinic_2',
        treatmentId: 'skin_analysis',
        customPrice: 280.0,
        availableDays: ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma'],
        availableHours: ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00'],
        rating: 4,
        reviewCount: 67,
      ),
      ClinicTreatmentModel(
        id: 'ct_4',
        clinicId: 'clinic_2',
        treatmentId: 'acne_treatment',
        customPrice: 350.0,
        availableDays: ['Pazartesi', 'Çarşamba', 'Cuma'],
        availableHours: ['14:00', '15:00', '16:00'],
        rating: 4,
        reviewCount: 32,
      ),
      ClinicTreatmentModel(
        id: 'ct_5',
        clinicId: 'clinic_6',
        treatmentId: 'dental_cleaning',
        customPrice: 150.0,
        availableDays: ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma'],
        availableHours: ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00', '17:00'],
        rating: 5,
        reviewCount: 89,
      ),
    ];

    for (final clinicTreatment in clinicTreatments) {
      await addClinicTreatment(clinicTreatment);
    }
  }
} 