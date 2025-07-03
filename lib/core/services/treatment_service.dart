import '../models/treatment_model.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';

class TreatmentService {
  static final TreatmentService _instance = TreatmentService._internal();
  factory TreatmentService() => _instance;
  TreatmentService._internal();

  final FirebaseService _firebaseService = FirebaseService();

  List<TreatmentCategory> _categories = [];
  List<TreatmentModel> _treatments = [];
  List<ClinicTreatmentModel> _clinicTreatments = [];

  List<TreatmentCategory> get categories => _categories;
  List<TreatmentModel> get treatments => _treatments;
  List<ClinicTreatmentModel> get clinicTreatments => _clinicTreatments;

  // Initialize data from Firebase
  Future<void> initializeData() async {
    try {
      // Initialize sample data if needed
      await _firebaseService.initializeSampleData();
      
      // Load data from Firebase
      await loadCategories();
      await loadTreatments();
      await loadClinicTreatments();
    } catch (e) {
      print('Error initializing treatment data: $e');
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _firebaseService.getCategories();
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> loadTreatments() async {
    try {
      _treatments = await _firebaseService.getTreatments();
    } catch (e) {
      print('Error loading treatments: $e');
    }
  }

  Future<void> loadClinicTreatments() async {
    try {
      _clinicTreatments = await _firebaseService.getClinicTreatments();
    } catch (e) {
      print('Error loading clinic treatments: $e');
    }
  }

  // Firebase-based methods
  Future<List<TreatmentCategory>> getPopularCategories() async {
    try {
      if (_categories.isEmpty) await loadCategories();
      return _categories.where((category) => category.isPopular).toList();
    } catch (e) {
      print('Error getting popular categories: $e');
      return [];
    }
  }

  Future<List<TreatmentModel>> getPopularTreatments() async {
    try {
      return await _firebaseService.getPopularTreatments();
    } catch (e) {
      print('Error getting popular treatments: $e');
      return [];
    }
  }

  Future<List<TreatmentModel>> getTreatmentsByCategory(String categoryId) async {
    try {
      if (_treatments.isEmpty) await loadTreatments();
      return _treatments.where((treatment) => treatment.category == categoryId).toList();
    } catch (e) {
      print('Error getting treatments by category: $e');
      return [];
    }
  }

  Future<List<TreatmentModel>> getMostSearchedTreatments() async {
    try {
      // Mock: En çok aranan tedaviler (normalde analytics'ten gelecek)
      if (_treatments.isEmpty) await loadTreatments();
      return _treatments.where((t) => ['echo_cardio', 'skin_analysis', 'dental_cleaning', 'eye_exam'].contains(t.id)).toList();
    } catch (e) {
      print('Error getting most searched treatments: $e');
      return [];
    }
  }

  Future<List<ClinicModel>> getPopularClinics() async {
    try {
      return await _firebaseService.getPopularClinics();
    } catch (e) {
      print('Error getting popular clinics: $e');
      return [];
    }
  }

  Future<List<TreatmentModel>> searchTreatments(String query) async {
    try {
      return await _firebaseService.searchTreatments(query);
    } catch (e) {
      print('Error searching treatments: $e');
      return [];
    }
  }

  Future<List<ClinicTreatmentModel>> getTreatmentsByClinic(String clinicId) async {
    try {
      return await _firebaseService.getClinicTreatmentsByClinic(clinicId);
    } catch (e) {
      print('Error getting treatments by clinic: $e');
      return [];
    }
  }

  TreatmentModel? getTreatmentById(String treatmentId) {
    try {
      return _treatments.firstWhere((t) => t.id == treatmentId);
    } catch (e) {
      return null;
    }
  }

  // Trending treatments (son 7 günde en çok arananlar)
  Future<List<TreatmentModel>> getTrendingTreatments() async {
    try {
      return await _firebaseService.getTrendingTreatments();
    } catch (e) {
      print('Error getting trending treatments: $e');
      return [];
    }
  }

  // Discount'lu tedaviler
  Future<List<TreatmentModel>> getDiscountedTreatments() async {
    try {
      return await _firebaseService.getDiscountedTreatments();
    } catch (e) {
      print('Error getting discounted treatments: $e');
      return [];
    }
  }

  // Sync methods (for compatibility with existing code)
  List<TreatmentCategory> getPopularCategoriesSync() {
    return _categories.where((category) => category.isPopular).toList();
  }

  List<TreatmentModel> getPopularTreatmentsSync() {
    return _treatments.where((treatment) => treatment.isPopular).toList();
  }

  List<TreatmentModel> getTrendingTreatmentsSync() {
    return _treatments.where((t) => ['acne_treatment', 'physical_therapy', 'stress_test'].contains(t.id)).toList();
  }

  List<TreatmentModel> getDiscountedTreatmentsSync() {
    return _treatments.where((t) => t.hasDiscount).toList();
  }

  List<ClinicModel> getPopularClinicsSync() {
    // Return empty list for sync version - use async version instead
    return [];
  }
} 