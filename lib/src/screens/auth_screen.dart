import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoginMode = true;
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const _FruitBowlAnimation(),
                  const SizedBox(height: 20),
                  Text(
                    _isLoginMode ? 'Welcome back' : 'Create account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.titleGreen(context),
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to save your kitchen inventory and preferences.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.readableMuted(context)),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  tooltip: _obscurePassword
                                      ? 'Show password'
                                      : 'Hide password',
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: _validatePassword,
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _errorMessage!,
                                style: const TextStyle(color: AppColors.danger),
                              ),
                            ],
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: _isSubmitting ? null : _submit,
                                icon: _isSubmitting
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Icon(
                                        _isLoginMode
                                            ? Icons.login
                                            : Icons.person_add_alt,
                                      ),
                                label: Text(
                                  _isLoginMode ? 'Log In' : 'Sign Up',
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _isSubmitting ? null : _toggleMode,
                              child: Text(
                                _isLoginMode
                                    ? 'Need an account? Sign up'
                                    : 'Already have an account? Log in',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      if (_isLoginMode) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } on FirebaseAuthException catch (error) {
      setState(() => _errorMessage = error.message ?? 'Authentication failed');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _errorMessage = null;
    });
  }
}

class _FruitBowlAnimation extends StatefulWidget {
  const _FruitBowlAnimation();

  @override
  State<_FruitBowlAnimation> createState() => _FruitBowlAnimationState();
}

class _FruitBowlAnimationState extends State<_FruitBowlAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Animated fruits bouncing into a bowl',
      child: SizedBox(
        width: 220,
        height: 120,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _FruitBowlPainter(
                progress: _controller.value,
                isDarkMode: AppColors.isDarkMode(context),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FruitBowlPainter extends CustomPainter {
  const _FruitBowlPainter({
    required this.progress,
    required this.isDarkMode,
  });

  final double progress;
  final bool isDarkMode;

  @override
  void paint(Canvas canvas, Size size) {
    final bowlPaint = Paint()
      ..color = isDarkMode ? AppColors.leafGreen : AppColors.darkGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final fillPaint = Paint()
      ..color = isDarkMode
          ? const Color(0xFF1E3B2B)
          : AppColors.mintGreen.withValues(alpha: 0.85);

    final bowlRect = Rect.fromLTWH(
      size.width * 0.27,
      size.height * 0.62,
      size.width * 0.46,
      size.height * 0.24,
    );

    final bowlPath = Path()
      ..moveTo(bowlRect.left, bowlRect.top)
      ..quadraticBezierTo(
        bowlRect.center.dx,
        bowlRect.bottom + 18,
        bowlRect.right,
        bowlRect.top,
      );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.74),
        width: size.width * 0.5,
        height: size.height * 0.18,
      ),
      fillPaint,
    );
    canvas.drawPath(bowlPath, bowlPaint);
    canvas.drawLine(
      Offset(bowlRect.left - 6, bowlRect.top),
      Offset(bowlRect.right + 6, bowlRect.top),
      bowlPaint,
    );

    _drawFruit(
      canvas,
      size,
      color: const Color(0xFFD9534F),
      start: Offset(-22, size.height * 0.24),
      end: Offset(size.width * 0.42, size.height * 0.56),
      delay: 0,
      radius: 12,
    );
    _drawFruit(
      canvas,
      size,
      color: const Color(0xFFE7A23B),
      start: Offset(size.width + 18, size.height * 0.18),
      end: Offset(size.width * 0.56, size.height * 0.53),
      delay: 0.22,
      radius: 11,
    );
    _drawFruit(
      canvas,
      size,
      color: AppColors.leafGreen,
      start: Offset(-18, size.height * 0.42),
      end: Offset(size.width * 0.5, size.height * 0.48),
      delay: 0.44,
      radius: 10,
    );
    _drawFruit(
      canvas,
      size,
      color: const Color(0xFFFFD166),
      start: Offset(size.width + 24, size.height * 0.36),
      end: Offset(size.width * 0.47, size.height * 0.52),
      delay: 0.66,
      radius: 9,
    );
  }

  void _drawFruit(
    Canvas canvas,
    Size size, {
    required Color color,
    required Offset start,
    required Offset end,
    required double delay,
    required double radius,
  }) {
    final raw = (progress + delay) % 1;
    final travel = raw < 0.78 ? Curves.easeOutCubic.transform(raw / 0.78) : 1.0;
    final settle = raw < 0.78 ? 0.0 : (raw - 0.78) / 0.22;
    final arc = -48 * math.sin(travel * math.pi);
    final bounce = raw < 0.78 ? arc : -7 * math.sin(settle * math.pi * 2);
    final position = Offset.lerp(start, end, travel)! + Offset(0, bounce);

    final fruitPaint = Paint()..color = color;
    final shinePaint = Paint()..color = Colors.white.withValues(alpha: 0.5);
    final leafPaint = Paint()
      ..color = isDarkMode ? AppColors.mintGreen : AppColors.forestGreen;

    canvas.drawCircle(position, radius, fruitPaint);
    canvas.drawCircle(
      position.translate(-radius * 0.32, -radius * 0.34),
      radius * 0.25,
      shinePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: position.translate(radius * 0.4, -radius * 0.92),
        width: radius * 0.8,
        height: radius * 0.42,
      ),
      leafPaint,
    );
  }

  @override
  bool shouldRepaint(_FruitBowlPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
