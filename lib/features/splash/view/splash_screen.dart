import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/controller/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _orbitController;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    )..forward();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
    _fadeAnim =
        CurvedAnimation(parent: _introController, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic),
    );
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(AppConstants.splashDuration);
    if (!mounted) return;

    final authController = context.read<AuthController>();
    final isAuthenticated = authController.status == AuthStatus.authenticated;
    Navigator.of(context).pushReplacementNamed(
      isAuthenticated ? AppRoutes.home : AppRoutes.login,
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightSurface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              children: [
                const Spacer(flex: 2),
                _AtlasMark(animation: _orbitController),
                const SizedBox(height: 74),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: AppColors.primaryDark, size: 21),
                    const SizedBox(width: 5),
                    Text(
                      'FoodAtlas',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Text(
                  'Your global culinary\ncompass for discovery and\ncraft.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                    height: 1.35,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(flex: 3),
                AnimatedBuilder(
                  animation: _introController,
                  builder: (context, _) {
                    return SizedBox(
                      width: 112,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          minHeight: 2.6,
                          value: _introController.value.clamp(0.08, 1),
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.14),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 11),
                Text(
                  'INITIALIZING ATLAS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AtlasMark extends StatelessWidget {
  const _AtlasMark({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176,
      height: 176,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final angle = animation.value * math.pi * 2;
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.28),
                      blurRadius: 32,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CustomPaint(
                    painter: _AtlasPainter(),
                  ),
                ),
              ),
              _OrbitingIcon(
                angle: angle - math.pi / 2,
                radius: 70,
                icon: Icons.ramen_dining_rounded,
              ),
              _OrbitingIcon(
                angle: angle + math.pi * 0.95,
                radius: 68,
                icon: Icons.local_dining_rounded,
              ),
              _OrbitingIcon(
                angle: angle + math.pi * 0.05,
                radius: 72,
                icon: Icons.local_pizza_rounded,
              ),
              _OrbitingIcon(
                angle: angle + math.pi / 2,
                radius: 69,
                icon: Icons.bakery_dining_rounded,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrbitingIcon extends StatelessWidget {
  const _OrbitingIcon({
    required this.angle,
    required this.radius,
    required this.icon,
  });

  final double angle;
  final double radius;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(math.cos(angle) * radius, math.sin(angle) * radius),
      child: Transform.rotate(
        angle: -angle,
        child: _OrbitIcon(icon: icon),
      ),
    );
  }
}

class _OrbitIcon extends StatelessWidget {
  const _OrbitIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.24 : 0.11),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.primaryDark, size: 15),
    );
  }
}

class _AtlasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.width / 2;

    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFB03A), AppColors.primary, Color(0xFFE76D00)],
      ).createShader(rect);
    canvas.drawCircle(center, radius, basePaint);

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = -2; i <= 2; i++) {
      final x = center.dx + i * radius * 0.28;
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x, center.dy),
            width: radius * 1.1,
            height: radius * 2),
        gridPaint,
      );
    }

    for (var i = -2; i <= 2; i++) {
      final y = center.dy + i * radius * 0.24;
      canvas.drawArc(
        Rect.fromCenter(center: center, width: radius * 2, height: radius * 2),
        math.asin((y - center.dy) / radius),
        math.pi,
        false,
        gridPaint,
      );
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final landPaint = Paint()
      ..color = const Color(0xFFC85C00).withValues(alpha: 0.20);
    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.36)
      ..cubicTo(size.width * 0.34, size.height * 0.20, size.width * 0.52,
          size.height * 0.32, size.width * 0.45, size.height * 0.47)
      ..cubicTo(size.width * 0.58, size.height * 0.50, size.width * 0.55,
          size.height * 0.68, size.width * 0.38, size.height * 0.62)
      ..cubicTo(size.width * 0.24, size.height * 0.57, size.width * 0.13,
          size.height * 0.49, size.width * 0.18, size.height * 0.36);
    canvas.drawPath(path, landPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.62, size.height * 0.24)
      ..cubicTo(size.width * 0.82, size.height * 0.28, size.width * 0.90,
          size.height * 0.45, size.width * 0.74, size.height * 0.55)
      ..cubicTo(size.width * 0.64, size.height * 0.62, size.width * 0.70,
          size.height * 0.78, size.width * 0.84, size.height * 0.82)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height * 0.20)
      ..close();
    canvas.drawPath(path2, landPaint);

    final shadePaint = Paint()..color = Colors.black.withValues(alpha: 0.08);
    canvas.drawRect(
        Rect.fromLTWH(center.dx, 0, radius, size.height), shadePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
