import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = context.watch<ProfileController>();
    final themeController = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    backgroundImage: profileController.photoUrl != null
                        ? NetworkImage(profileController.photoUrl!)
                        : null,
                    child: profileController.photoUrl == null
                        ? const Icon(Icons.person,
                            size: 44, color: AppColors.primary)
                        : null,
                  ),
                  const SizedBox(height: 14),
                  Text(profileController.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(profileController.email,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6))),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _SectionCard(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('الوضع الليلي'),
                  value: themeController.isDarkMode,
                  onChanged: (v) =>
                      context.read<ThemeController>().toggleTheme(v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              children: [
                _ProfileTile(
                    icon: Icons.favorite_border_rounded,
                    label: 'المفضلة',
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.favorites)),
                const Divider(height: 1),
                _ProfileTile(
                    icon: Icons.shopping_cart_outlined,
                    label: 'سلة التسوق',
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.cart)),
                const Divider(height: 1),
                _ProfileTile(
                    icon: Icons.notifications_none_rounded,
                    label: 'الإشعارات',
                    onTap: () {}),
                const Divider(height: 1),
                _ProfileTile(
                    icon: Icons.help_outline_rounded,
                    label: 'المساعدة والدعم',
                    onTap: () {}),
              ],
            ),
            const SizedBox(height: 24),
            _SectionCard(
              children: [
                _ProfileTile(
                  icon: Icons.logout_rounded,
                  label: 'تسجيل الخروج',
                  color: AppColors.error,
                  onTap: () => _confirmLogout(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('إلغاء')),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogCtx).pop();
              await context.read<ProfileController>().logout();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              }
            },
            child: const Text('تسجيل الخروج',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha:
                  Theme.of(context).brightness == Brightness.dark ? 0.20 : 0.05,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.color});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_left_rounded),
      onTap: onTap,
    );
  }
}
