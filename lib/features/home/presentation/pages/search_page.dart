import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tümü';
  String _selectedLocation = 'Tüm Lokasyonlar';
  RangeValues _priceRange = const RangeValues(0, 1000);
  bool _isMapView = false;
  
  final List<String> _categories = [
    'Tümü', 'Kardiyoloji', 'Dermatoloji', 'Nöroloji', 'Ortopedi',
    'Göz Hastalıkları', 'Kulak Burun Boğaz', 'Üroloji', 'Kadın Hastalıkları'
  ];
  
  final List<String> _locations = [
    'Tüm Lokasyonlar', 'Kadıköy', 'Beşiktaş', 'Şişli', 'Bakırköy',
    'Üsküdar', 'Beylikdüzü', 'Pendik', 'Maltepe'
  ];
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    
    return Scaffold(
      body: Column(
        children: [
          // Arama çubuğu
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.backgroundLight,
            child: Column(
              children: [
                // Ana arama çubuğu
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Klinik, doktor veya uzmanlık alanı ara...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isMapView ? Icons.list : Icons.map,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isMapView = !_isMapView;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list, color: AppColors.primary),
                          onPressed: () => _showFilterBottomSheet(context),
                        ),
                      ],
                    ),
                  ),
                  onChanged: (value) {
                    // Arama filtresi
                  },
                ),
                const SizedBox(height: 16),
                
                // Kategori filtreleri
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          selectedColor: AppColors.primary.withOpacity(0.1),
                          checkmarkColor: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Sonuç başlığı
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.background,
            child: Row(
              children: [
                Text(
                  '156 sonuç bulundu',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Sırala'),
                      const SizedBox(width: 4),
                      const Icon(Icons.sort, size: 16),
                    ],
                  ),
                  onSelected: (value) {
                    // Sıralama işlemi
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'distance',
                      child: Text('Mesafeye göre'),
                    ),
                    const PopupMenuItem(
                      value: 'rating',
                      child: Text('Puana göre'),
                    ),
                    const PopupMenuItem(
                      value: 'price',
                      child: Text('Fiyata göre'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Sonuçlar listesi
          Expanded(
            child: _isMapView ? _buildMapView() : _buildListView(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // Örnek veri
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildClinicCard(
            name: 'Acıbadem Hastanesi ${index + 1}',
            specialty: _categories[(index % (_categories.length - 1)) + 1],
            distance: '${(index + 1) * 0.5} km',
            rating: 4.5 + (index * 0.1),
            price: '${(index + 1) * 50}₺',
            image: 'https://via.placeholder.com/100x100',
          ),
        );
      },
    );
  }
  
  Widget _buildMapView() {
    return Container(
      color: AppColors.background,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 64,
              color: AppColors.textLight,
            ),
            SizedBox(height: 16),
            Text(
              'Harita Görünümü',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Harita entegrasyonu yakında geliyor...',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildClinicCard({
    required String name,
    required String specialty,
    required String distance,
    required double rating,
    required String price,
    required String image,
  }) {
    return Card(
      child: InkWell(
        onTap: () {
          // Klinik detayına git
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Klinik resmi
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Klinik bilgileri
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          specialty,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              distance,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Fiyat ve buton
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Randevu al
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Randevu Al'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Özellikler
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _buildFeatureChip('Online Randevu', Icons.calendar_today),
                  _buildFeatureChip('Otopark', Icons.local_parking),
                  _buildFeatureChip('Engelli Erişimi', Icons.accessible),
                  _buildFeatureChip('Laboratuvar', Icons.biotech),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFeatureChip(String label, IconData icon) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      labelStyle: Theme.of(context).textTheme.bodySmall,
      backgroundColor: AppColors.background,
      side: const BorderSide(color: AppColors.border),
    );
  }
  
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Row(
                children: [
                  Text(
                    'Filtreler',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _selectedCategory = 'Tümü';
                        _selectedLocation = 'Tüm Lokasyonlar';
                        _priceRange = const RangeValues(0, 1000);
                      });
                      setState(() {});
                    },
                    child: const Text('Temizle'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Lokasyon filtresi
              Text(
                'Lokasyon',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: _locations.map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (value) {
                  setModalState(() {
                    _selectedLocation = value!;
                  });
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              
              // Fiyat aralığı
              Text(
                'Fiyat Aralığı',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 1000,
                divisions: 20,
                labels: RangeLabels(
                  '${_priceRange.start.round()}₺',
                  '${_priceRange.end.round()}₺',
                ),
                onChanged: (values) {
                  setModalState(() {
                    _priceRange = values;
                  });
                  setState(() {});
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_priceRange.start.round()}₺'),
                  Text('${_priceRange.end.round()}₺'),
                ],
              ),
              const SizedBox(height: 20),
              
              // Özellikler
              Text(
                'Özellikler',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  FilterChip(
                    label: const Text('Online Randevu'),
                    selected: false,
                    onSelected: (selected) {
                      // Feature filter
                    },
                  ),
                  FilterChip(
                    label: const Text('Otopark'),
                    selected: false,
                    onSelected: (selected) {
                      // Feature filter
                    },
                  ),
                  FilterChip(
                    label: const Text('Engelli Erişimi'),
                    selected: false,
                    onSelected: (selected) {
                      // Feature filter
                    },
                  ),
                  FilterChip(
                    label: const Text('Laboratuvar'),
                    selected: false,
                    onSelected: (selected) {
                      // Feature filter
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Uygula butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Filtreleri uygula
                  },
                  child: const Text('Filtreleri Uygula'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
} 