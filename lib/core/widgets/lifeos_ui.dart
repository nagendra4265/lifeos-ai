import 'dart:math' as math;

import 'package:flutter/material.dart';

const lifeOsPurple = Color(0xFF6D4CFF);
const lifeOsIndigo = Color(0xFF3D5AFE);
const lifeOsInk = Color(0xFF12172A);
const lifeOsMuted = Color(0xFF68708A);
const lifeOsSurface = Color(0xFFF8F9FD);
const lifeOsBorder = Color(0xFFE8EAF3);

class LifeOsGradientIcon extends StatelessWidget {
  const LifeOsGradientIcon({this.size = 58, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: const _LifeOsLogoPainter(),
    );
  }
}

class _LifeOsLogoPainter extends CustomPainter {
  const _LifeOsLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * .22;
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [
          Color(0xFF6D4CFF),
          Color(0xFFFF4AA2),
          Color(0xFF00B8FF),
          Color(0xFF6D4CFF),
        ],
      ).createShader(rect);

    canvas.drawArc(rect.deflate(stroke / 2), -.9, math.pi * 1.72, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LifeOsPage extends StatelessWidget {
  const LifeOsPage({
    required this.title,
    required this.children,
    this.subtitle,
    this.trailing,
    this.floatingActionButton,
    this.padding = const EdgeInsets.all(20),
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final List<Widget> children;
  final Widget? floatingActionButton;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: padding.copyWith(bottom: 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: lifeOsMuted),
                            ),
                          ],
                        ],
                      ),
                    ),
                    ?trailing,
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: padding.copyWith(top: 8),
              sliver: SliverList.separated(
                itemBuilder: (context, index) => children[index],
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemCount: children.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LifeOsCard extends StatelessWidget {
  const LifeOsCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: lifeOsBorder),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: card,
      ),
    );
  }
}

class LifeOsSearchField extends StatelessWidget {
  const LifeOsSearchField({
    required this.hintText,
    this.onChanged,
    this.controller,
    this.fieldKey,
    super.key,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: fieldKey,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: const Color(0xFFF6F7FB),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class LifeOsMetricCard extends StatelessWidget {
  const LifeOsMetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    super.key,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LifeOsCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: color),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LifeOsListTile extends StatelessWidget {
  const LifeOsListTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.color = lifeOsPurple,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LifeOsCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}

class LifeOsSectionTitle extends StatelessWidget {
  const LifeOsSectionTitle({required this.title, this.action, super.key});

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        if (action != null)
          Text(
            action!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: lifeOsPurple,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

class LifeOsDonutChart extends StatelessWidget {
  const LifeOsDonutChart({required this.colors, this.size = 116, super.key});

  final List<Color> colors;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _DonutPainter(colors));
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.colors);

  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final stroke = size.width * .18;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    var start = -math.pi / 2;
    final values = [.28, .2, .18, .16, .1, .08];
    for (var i = 0; i < values.length; i++) {
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        rect.deflate(stroke / 2),
        start,
        math.pi * 2 * values[i] - .08,
        false,
        paint,
      );
      start += math.pi * 2 * values[i];
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => false;
}

class LifeOsLineSpark extends StatelessWidget {
  const LifeOsLineSpark({required this.color, this.height = 54, super.key});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: _SparkPainter(color),
    );
  }
}

class _SparkPainter extends CustomPainter {
  const _SparkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final points = [0.62, .7, .58, .64, .48, .54, .42, .5, .34, .38, .24, .3];
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final y = size.height * points[i];
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SparkPainter oldDelegate) => false;
}
