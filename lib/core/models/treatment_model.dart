class TreatmentModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> images;
  final double price;
  final double? discountPrice;
  final int duration; // dakika cinsinden
  final List<String> features;
  final List<String> requirements;
  final bool isPopular;
  final bool isActive;
  final DateTime createdAt;

  const TreatmentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.images = const [],
    required this.price,
    this.discountPrice,
    required this.duration,
    this.features = const [],
    this.requirements = const [],
    this.isPopular = false,
    this.isActive = true,
    required this.createdAt,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      price: (json['price'] ?? 0.0).toDouble(),
      discountPrice: json['discountPrice']?.toDouble(),
      duration: json['duration'] ?? 0,
      features: List<String>.from(json['features'] ?? []),
      requirements: List<String>.from(json['requirements'] ?? []),
      isPopular: json['isPopular'] ?? false,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'images': images,
      'price': price,
      'discountPrice': discountPrice,
      'duration': duration,
      'features': features,
      'requirements': requirements,
      'isPopular': isPopular,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get hasDiscount => discountPrice != null && discountPrice! < price;
  double get finalPrice => discountPrice ?? price;
  double get discountPercentage => hasDiscount ? ((price - discountPrice!) / price * 100) : 0;
}

class ClinicTreatmentModel {
  final String id;
  final String clinicId;
  final String treatmentId;
  final double customPrice;
  final String? customDescription;
  final List<String> availableDays;
  final List<String> availableHours;
  final bool isAvailable;
  final int rating;
  final int reviewCount;

  const ClinicTreatmentModel({
    required this.id,
    required this.clinicId,
    required this.treatmentId,
    required this.customPrice,
    this.customDescription,
    this.availableDays = const [],
    this.availableHours = const [],
    this.isAvailable = true,
    this.rating = 0,
    this.reviewCount = 0,
  });

  factory ClinicTreatmentModel.fromJson(Map<String, dynamic> json) {
    return ClinicTreatmentModel(
      id: json['id'] ?? '',
      clinicId: json['clinicId'] ?? '',
      treatmentId: json['treatmentId'] ?? '',
      customPrice: (json['customPrice'] ?? 0.0).toDouble(),
      customDescription: json['customDescription'],
      availableDays: List<String>.from(json['availableDays'] ?? []),
      availableHours: List<String>.from(json['availableHours'] ?? []),
      isAvailable: json['isAvailable'] ?? true,
      rating: json['rating'] ?? 0,
      reviewCount: json['reviewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clinicId': clinicId,
      'treatmentId': treatmentId,
      'customPrice': customPrice,
      'customDescription': customDescription,
      'availableDays': availableDays,
      'availableHours': availableHours,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}

class TreatmentCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final bool isPopular;

  const TreatmentCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.isPopular = false,
  });

  factory TreatmentCategory.fromJson(Map<String, dynamic> json) {
    return TreatmentCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '',
      isPopular: json['isPopular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'isPopular': isPopular,
    };
  }
} 