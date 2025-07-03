import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/user_service.dart';

class AuthGuard {
  static final UserService _userService = UserService();

  /// Protected action kontrolü - giriş yapılması gereken işlemler için
  static Future<bool> requireAuth(
    BuildContext context, {
    String? message,
    VoidCallback? onAuthenticated,
  }) async {
    if (_userService.isAuthenticated) {
      onAuthenticated?.call();
      return true;
    }

    // Guest kullanıcıysa auth modal göster
    final result = await showAuthDialog(
      context,
      message: message ?? 'Bu işlem için giriş yapmanız gerekiyor',
    );

    if (result == true && onAuthenticated != null) {
      onAuthenticated();
    }

    return result ?? false;
  }

  /// Authentication dialog göster
  static Future<bool?> showAuthDialog(
    BuildContext context, {
    String? message,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AuthDialog(message: message),
    );
  }

  /// Direkt login sayfasına yönlendir
  static void redirectToLogin(BuildContext context) {
    context.go('/login');
  }
}

class AuthDialog extends StatelessWidget {
  final String? message;

  const AuthDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.lock_outline, color: Colors.orange),
          SizedBox(width: 8),
          Text('Giriş Gerekli'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message ?? 'Bu işlem için giriş yapmanız gerekiyor',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          const Text(
            'Giriş yaptıktan sonra:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('• Randevu alabilirsiniz'),
          const Text('• Klinikleri favorilere ekleyebilirsiniz'),
          const Text('• Yorumları görebilirsiniz'),
          const Text('• Kişisel öneriler alabilirsiniz'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('İptal'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Kayıt Ol'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            context.go('/login');
          },
          child: const Text('Giriş Yap'),
        ),
      ],
    );
  }
} 