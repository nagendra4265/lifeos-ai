import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/health_metric.dart';
import 'package:flutter_application_1/core/providers/health_provider.dart';
import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class HealthPage extends ConsumerWidget {
  const HealthPage({super.key});

  Future<void> _showHealthMenu(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health actions',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Keep track of your well-being.',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.insights_rounded),
                  title: const Text('View trend summary'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Health trends are ready to review.')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_rounded),
                  title: const Text('Add reading'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ref.read(healthProvider.notifier).addReading(
                      type: 'Heart Rate',
                      value: '75 bpm',
                      status: 'Normal',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Manual health reading saved locally.')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    final healthAsync = ref.watch(healthProvider);

    return LifeOsPage(
      title: 'Health',
      trailing: IconButton(
        onPressed: () => _showHealthMenu(context, ref),
        icon: const Icon(Icons.more_vert_rounded),
      ),
      children: [
        LifeOsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Score',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '86',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(' /100'),
                  ),
                ],
              ),
              const Text(
                'Good',
                style: TextStyle(
                  color: Color(0xFF18A058),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const LifeOsLineSpark(color: Color(0xFF18A058)),
            ],
          ),
        ),
        healthAsync.when(
          data: (metrics) {
            return GridView.count(
              crossAxisCount: compact ? 2 : 4,
              childAspectRatio: compact ? 1.25 : 1.45,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildMetricCard(metrics, 'Heart Rate', Icons.favorite_rounded, const Color(0xFFFF4AA2), '72 bpm'),
                _buildMetricCard(metrics, 'Blood Pressure', Icons.monitor_heart_rounded, const Color(0xFF6D4CFF), '120/80'),
                _buildMetricCard(metrics, 'Blood Sugar', Icons.bloodtype_rounded, const Color(0xFFFF7A45), '98 mg/dL'),
                _buildMetricCard(metrics, 'Weight', Icons.scale_rounded, const Color(0xFF3D5AFE), '68 kg'),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => Center(child: Text('Error: $err')),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    return switch (status.toLowerCase()) {
      'normal' => const Color(0xFF18A058),
      'high' => Colors.redAccent,
      'low' => Colors.orangeAccent,
      _ => lifeOsMuted,
    };
  }

  Widget _buildMetricCard(List<HealthMetric> metrics, String type, IconData icon, Color color, String fallbackValue) {
    final latest = metrics.where((m) => m.type == type).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final value = latest.isNotEmpty ? latest.first.value : fallbackValue;
    final status = latest.isNotEmpty ? latest.first.status : 'Normal';

    return LifeOsMetricCard(
      title: type,
      value: value,
      subtitle: status,
      icon: icon,
      color: color,
      subtitleColor: _getStatusColor(status ?? 'Normal'),
    );
  }
}
