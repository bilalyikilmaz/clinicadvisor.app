import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: ResponsiveScaledBox(
        width: isDesktop ? 800 : null,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.textWhite,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Kullanıcı Adı',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'kullanici@example.com',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            // Edit profile
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Profili Düzenle'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Menu items
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.calendar_today,
                      title: l10n.myAppointments,
                      onTap: () {
                        // My appointments
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.history,
                      title: 'Geçmiş Randevular',
                      onTap: () {
                        // Past appointments
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.favorite,
                      title: 'Favoriler',
                      onTap: () {
                        // Favorites
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.star,
                      title: 'Değerlendirmelerim',
                      onTap: () {
                        // My reviews
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Settings
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.settings,
                      title: l10n.settings,
                      onTap: () {
                        // Settings
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.notifications,
                      title: 'Bildirimler',
                      onTap: () {
                        // Notifications
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.language,
                      title: 'Dil Seçenekleri',
                      onTap: () {
                        // Language settings
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.help,
                      title: 'Yardım',
                      onTap: () {
                        // Help
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Logout
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: _buildMenuItem(
                  icon: Icons.logout,
                  title: l10n.logout,
                  textColor: AppColors.error,
                  iconColor: AppColors.error,
                  onTap: () {
                    _showLogoutDialog(context, l10n);
                  },
                ),
              ),

              const SizedBox(height: 32),

              // App version
              Text(
                'ClinicAdvisor v1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textLight,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: const Text('Çıkış yapmak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textWhite,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
} 