import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/models/treatment_model.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/services/treatment_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../admin/presentation/pages/admin_dashboard.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/utils/auth_guard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserService _userService = UserService();
  final TreatmentService _treatmentService = TreatmentService();
  final TextEditingController _searchController = TextEditingController();
  
  bool _isLoading = true;
  List<TreatmentCategory> _categories = [];
  List<TreatmentModel> _popularTreatments = [];
  List<TreatmentModel> _trendingTreatments = [];
  List<TreatmentModel> _discountedTreatments = [];
  List<ClinicModel> _popularClinics = [];
  final isGuest = _userService.isGuest;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Initialize Firebase data
      await _treatmentService.initializeData();
      
      // Load all required data
      final categories = await _treatmentService.getPopularCategories();
      final popularTreatments = await _treatmentService.getPopularTreatments();
      final trendingTreatments = await _treatmentService.getTrendingTreatments();
      final discountedTreatments = await _treatmentService.getDiscountedTreatments();
      final popularClinics = await _treatmentService.getPopularClinics([]);

      setState(() {
        _categories = categories;
        _popularTreatments = popularTreatments;
        _trendingTreatments = trendingTreatments;
        _discountedTreatments = discountedTreatments;
        _popularClinics = popularClinics;
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentUser = _userService.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.local_hospital, size: 28),
            const SizedBox(width: 8),
            Text(
              'ClinicAdvisor',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          // Guest kullanıcı için giriş/kayıt butonları
          if (isGuest) ...[
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text(
                'Giriş Yap',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => context.go('/register'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                foregroundColor: Colors.white,
              ),
              child: const Text('Kayıt Ol'),
            ),
          ]
          // Authenticated kullanıcı için rol menüsü
          else ...[
            PopupMenuButton<UserRole>(
              icon: Icon(Icons.person_outline),
              onSelected: (UserRole role) {
                _userService.setCurrentUserRole(role);
                setState(() {});
              },
              itemBuilder: (context) => UserRole.values.map((role) {
                return PopupMenuItem(
                  value: role,
                  child: Row(
                    children: [
                      Icon(
                        role.icon,
                        color: role.color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(role.displayName),
                      if (currentUser?.role == role) ...[
                        const Spacer(),
                        Icon(Icons.check, color: role.color, size: 16),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await _userService.logout();
                setState(() {});
              },
            ),
          ],
          const SizedBox(width: 8),
        ],
      ),
      body: _buildRoleBasedContent(currentUser),
    );
  }

  Widget _buildRoleBasedContent(UserModel? user) {
    if (user == null) return _buildPatientContent();

    switch (user.role) {
      case UserRole.admin:
        return const AdminDashboard();
      case UserRole.doctor:
        return _buildDoctorDashboard();
      case UserRole.clinicAdmin:
        return _buildClinicAdminDashboard();
      case UserRole.patient:
      default:
        return _buildPatientContent();
    }
  }

  Widget _buildPatientContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Klinikler ve tedaviler yükleniyor...'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchHeader(),
          const SizedBox(height: 16),
          _buildQuickActions(),
          const SizedBox(height: 24),
          _buildPopularCategories(),
          const SizedBox(height: 24),
          _buildPopularTreatments(),
          const SizedBox(height: 24),
          _buildTrendingTreatments(),
          const SizedBox(height: 24),
          _buildDiscountedTreatments(),
          const SizedBox(height: 24),
          _buildPopularClinics(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    final isGuest = _userService.isGuest;
    final currentUser = _userService.currentUser;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isGuest 
                        ? 'Sağlık Hizmetlerini Keşfedin! 🏥' 
                        : 'Hoşgeldin, ${currentUser?.name.split(' ').first}! 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isGuest 
                        ? 'Fiyatları görün, klinikleri inceleyin, sonra giriş yapın'
                        : 'Kişisel öneriler ve randevu alma hizmetinizde',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isGuest ? Icons.explore : Icons.person_outline,
                color: Colors.white,
                size: 40,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: isGuest 
                  ? 'Tedavi, klinik arayın...'
                  : 'Kişisel öneriler için arama yapın...',
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              onSubmitted: (value) async {
                // Arama yap
                try {
                  final results = await _treatmentService.searchTreatments(value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${results.length} sonuç bulundu')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Arama hatası: $e')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.calendar_today,
              title: 'Randevu Al',
              color: AppColors.primary,
              onTap: () {
                AuthGuard.requireAuth(
                  context,
                  message: 'Randevu almak için giriş yapmanız gerekiyor',
                  onAuthenticated: () {
                    // Randevu alma sayfasına yönlendir
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Randevu sayfasına yönlendiriliyorsunuz...')),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.search,
              title: 'Klinik Ara',
              color: AppColors.secondary,
              onTap: () {
                // Arama sayfasına yönlendir
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Arama sayfasına yönlendiriliyorsunuz...')),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.local_offer,
              title: 'İndirimler',
              color: AppColors.accent,
              onTap: () {
                AuthGuard.requireAuth(
                  context,
                  message: 'Kişisel indirimler için giriş yapmanız gerekiyor',
                  onAuthenticated: () {
                    // İndirimler sayfasına yönlendir
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kişisel indirimler sayfasına yönlendiriliyorsunuz...')),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popüler Kategoriler (${_categories.length})',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Tümünü Gör'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return _buildCategoryCard(category);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(TreatmentCategory category) {
    final color = _getCategoryColor(category.color);
    
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          // Kategori sayfasına yönlendir
        },
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Icon(
                _getCategoryIcon(category.icon),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularTreatments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popüler Tedaviler (${_popularTreatments.length})',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Tümünü Gör'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _popularTreatments.length,
            itemBuilder: (context, index) {
              final treatment = _popularTreatments[index];
              return _buildTreatmentCard(treatment);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentCard(TreatmentModel treatment) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      treatment.name,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (treatment.hasDiscount)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '%${treatment.discountPercentage.toInt()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                treatment.description,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${treatment.duration} dk',
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (treatment.hasDiscount)
                        Text(
                          '₺${treatment.price.toInt()}',
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey[600],
                          ),
                        ),
                      Text(
                        '₺${treatment.finalPrice.toInt()}',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingTreatments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.trending_up, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text(
                    'Trend Tedaviler (${_trendingTreatments.length})',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text('Tümünü Gör'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _trendingTreatments.length,
            itemBuilder: (context, index) {
              final treatment = _trendingTreatments[index];
              return _buildTreatmentCard(treatment);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountedTreatments() {
    if (_discountedTreatments.isEmpty) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.local_offer, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    'İndirimli Tedaviler (${_discountedTreatments.length})',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text('Tümünü Gör'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _discountedTreatments.length,
            itemBuilder: (context, index) {
              final treatment = _discountedTreatments[index];
              return _buildTreatmentCard(treatment);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularClinics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popüler Klinikler (${_popularClinics.length})',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Tümünü Gör'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _popularClinics.length,
            itemBuilder: (context, index) {
              final clinic = _popularClinics[index];
              return _buildClinicCard(clinic);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildClinicCard(ClinicModel clinic) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.local_hospital,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clinic.name,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              clinic.rating.toString(),
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                clinic.address,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                clinic.specialties.take(2).join(', '),
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${clinic.doctorCount} doktor',
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorDashboard() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services, size: 64, color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Doktor Paneli',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Hasta yönetimi ve randevu sistemleri burada olacak.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicAdminDashboard() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business, size: 64, color: AppColors.secondary),
          SizedBox(height: 16),
          Text(
            'Klinik Yönetim Paneli',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Klinik yönetimi ve doktor koordinasyonu burada olacak.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'pink':
        return Colors.pink;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      case 'green':
        return Colors.green;
      case 'teal':
        return Colors.teal;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'favorite':
        return Icons.favorite;
      case 'face':
        return Icons.face;
      case 'accessibility':
        return Icons.accessibility;
      case 'psychology':
        return Icons.psychology;
      case 'visibility':
        return Icons.visibility;
      case 'medical_services':
        return Icons.medical_services;
      default:
        return Icons.local_hospital;
    }
  }
} 