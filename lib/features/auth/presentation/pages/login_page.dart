import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({this.initialPage = 1, super.key});

  final int initialPage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    _pageIndex = widget.initialPage;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splashNext = widget.initialPage == 0
        ? () => context.go('/login')
        : () => _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );

    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (value) => setState(() => _pageIndex = value),
          children: [
            _SplashPage(onNext: splashNext),
            _SignInPage(
              onDemoSignIn: () => context.go('/'),
              onGoToSignUp: () => context.go('/register'),
            ),
            _SignUpPage(
              onRegister: () => context.go('/'),
              onGoToSignIn: () => context.go('/login'),
            ),
            _FaceIdPage(onUsePassword: () => context.go('/login')),
            _IntroPage(onNext: () => context.go('/')),
          ],
        ),
      ),
      bottomNavigationBar: _AuthDots(
        index: _pageIndex,
        onTap: (index) => _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
        ),
      ),
    );
  }
}

class _SplashPage extends StatefulWidget {
  const _SplashPage({required this.onNext});

  final VoidCallback onNext;

  @override
  State<_SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<_SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onNext();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF07162F), Color(0xFF15274B), Color(0xFF1D335D)],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: _StarField()),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const LifeOsGradientIcon(size: 96),
                  const SizedBox(height: 18),
                  Text(
                    'LifeOS AI',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your Life. Organized.\nEnhanced by AI.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: .92),
                      height: 1.35,
                    ),
                  ),
                  const Spacer(),
                  const _LoadingRing(),
                  const SizedBox(height: 28),
                  TextButton(
                    onPressed: widget.onNext,
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignInPage extends StatelessWidget {
  const _SignInPage({required this.onDemoSignIn, required this.onGoToSignUp});

  final VoidCallback onDemoSignIn;
  final VoidCallback onGoToSignUp;

  @override
  Widget build(BuildContext context) {
    return _AuthPageShell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LifeOsGradientIcon(size: 72),
          const SizedBox(height: 24),
          Text(
            'Welcome Back',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Sign in to continue to LifeOS AI',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
          ),
          const SizedBox(height: 22),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Email or Phone',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock_outline_rounded),
              suffixIcon: Icon(Icons.visibility_off_outlined),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onDemoSignIn,
              child: const Text('Sign In'),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'or continue with',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(
                child: _SocialButton(
                  icon: Icons.g_mobiledata_rounded,
                  label: 'Google',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _SocialButton(icon: Icons.apple_rounded, label: 'Apple'),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _SocialButton(
                  icon: Icons.fingerprint_rounded,
                  label: 'Face ID',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account? ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextButton(
                onPressed: onGoToSignUp,
                child: const Text('Register'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignUpPage extends StatelessWidget {
  const _SignUpPage({required this.onRegister, required this.onGoToSignIn});

  final VoidCallback onRegister;
  final VoidCallback onGoToSignIn;

  @override
  Widget build(BuildContext context) {
    return _AuthPageShell(
      topTitle: 'Create Account',
      topSubtitle: 'Join LifeOS AI and organize your life',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TextField(
            decoration: InputDecoration(
              hintText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Phone Number',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock_outline_rounded),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
              prefixIcon: Icon(Icons.lock_outline_rounded),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(value: true, onChanged: (value) {}),
              const Expanded(
                child: Text('I agree to the Terms & Privacy Policy'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onRegister,
              child: const Text('Register'),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'or continue with',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(
                child: _SocialButton(
                  icon: Icons.g_mobiledata_rounded,
                  label: 'Google',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _SocialButton(icon: Icons.apple_rounded, label: 'Apple'),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _SocialButton(
                  icon: Icons.fingerprint_rounded,
                  label: 'Face ID',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextButton(onPressed: onGoToSignIn, child: const Text('Login')),
            ],
          ),
        ],
      ),
    );
  }
}

class _FaceIdPage extends StatelessWidget {
  const _FaceIdPage({required this.onUsePassword});

  final VoidCallback onUsePassword;

  @override
  Widget build(BuildContext context) {
    return _AuthPageShell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome Back',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 32),
          const _FaceRing(),
          const SizedBox(height: 32),
          Text(
            'Login with Face ID',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: onUsePassword,
            child: const Text('Use Password Instead'),
          ),
        ],
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _AuthPageShell(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _IntroIllustration(),
                const SizedBox(height: 28),
                Text(
                  'All Your Life\nIn One Place',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Notes, Expenses, Documents, Health, Calendar & more. Everything organized and AI powered.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: lifeOsMuted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const _Dot(active: true),
              const _Dot(),
              const _Dot(),
              const _Dot(),
              const Spacer(),
              FilledButton(onPressed: onNext, child: const Text('Next')),
            ],
          ),
        ],
      ),
    );
  }
}

class _AuthPageShell extends StatelessWidget {
  const _AuthPageShell({
    required this.child,
    this.topTitle = 'LifeOS AI',
    this.topSubtitle = 'Your Life. Organized. Enhanced by AI.',
  });

  final Widget child;
  final String topTitle;
  final String topSubtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                Text(
                  topTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  topSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                ),
                const SizedBox(height: 20),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StarField extends StatelessWidget {
  const _StarField();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _StarPainter());
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: .75);
    final dots = [
      const Offset(0.08, 0.1),
      const Offset(0.2, 0.22),
      const Offset(0.82, 0.16),
      const Offset(0.76, 0.3),
      const Offset(0.12, 0.36),
      const Offset(0.9, 0.46),
      const Offset(0.16, 0.62),
      const Offset(0.7, 0.68),
      const Offset(0.86, 0.76),
    ];
    for (final dot in dots) {
      canvas.drawCircle(
        Offset(size.width * dot.dx, size.height * dot.dy),
        1.4,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LoadingRing extends StatelessWidget {
  const _LoadingRing();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: CircularProgressIndicator(
        strokeWidth: 2.2,
        color: Colors.white.withValues(alpha: .9),
      ),
    );
  }
}

class _FaceRing extends StatelessWidget {
  const _FaceRing();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFBBA7FF), width: 2),
      ),
      child: Center(
        child: Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFCDBEFF), width: 10),
          ),
          child: const Icon(
            Icons.face_rounded,
            size: 42,
            color: Color(0xFF6D4CFF),
          ),
        ),
      ),
    );
  }
}

class _IntroIllustration extends StatelessWidget {
  const _IntroIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 8,
            top: 6,
            child: _BubbleCard(
              icon: Icons.chat_bubble_outline_rounded,
              color: const Color(0xFFEFE8FF),
            ),
          ),
          Positioned(
            right: 36,
            top: 38,
            child: _BubbleCard(
              icon: Icons.timeline_rounded,
              color: const Color(0xFFE7F1FF),
            ),
          ),
          Positioned(
            left: 8,
            top: 24,
            child: _BubbleCard(
              icon: Icons.shield_rounded,
              color: const Color(0xFFF2ECFF),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 220,
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFFF7F3FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 168,
              height: 168,
              decoration: const BoxDecoration(
                color: Color(0xFFEDE8FF),
                shape: BoxShape.circle,
              ),
              child: const Center(child: LifeOsGradientIcon(size: 74)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleCard extends StatelessWidget {
  const _BubbleCard({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: lifeOsPurple, size: 22),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: lifeOsBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthDots extends StatelessWidget {
  const _AuthDots({required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
        child: Row(
          children: List.generate(5, (dotIndex) {
            final active = index == dotIndex;
            return GestureDetector(
              onTap: () => onTap(dotIndex),
              child: Container(
                width: active ? 18 : 6,
                height: 6,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: active ? lifeOsPurple : const Color(0xFFD7DCEB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 18 : 6,
      height: 6,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: active ? lifeOsPurple : const Color(0xFFD7DCEB),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
