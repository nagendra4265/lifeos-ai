import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  Future<void> _showUpgradeSheet(BuildContext context) async {
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
                  'Upgrade to Premium',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Unlock a few more polished tools and AI features.',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.workspace_premium_rounded),
                  title: const Text('Monthly plan'),
                  subtitle: const Text('Best for trying LifeOS AI'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Premium checkout is ready to integrate.')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month_rounded),
                  title: const Text('Annual plan'),
                  subtitle: const Text('Best value for regular use'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Annual plan preview opened.')),
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
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    return LifeOsPage(
      title: 'LifeOS AI',
      subtitle: 'Your Life. Organized. Enhanced by AI.',
      children: [
        Center(child: LifeOsGradientIcon(size: compact ? 72 : 82)),
        const LifeOsListTile(
          title: 'AI Powered Search',
          subtitle: 'Find anything across your life instantly',
          icon: Icons.search_rounded,
        ),
        const LifeOsListTile(
          title: 'Offline Access',
          subtitle: 'Keep key data available anywhere',
          icon: Icons.offline_bolt_rounded,
        ),
        const LifeOsListTile(
          title: 'Secure & Private',
          subtitle: 'Local vault patterns for sensitive records',
          icon: Icons.shield_rounded,
        ),
        const LifeOsListTile(
          title: 'All Your Data in One Place',
          subtitle: 'Notes, expenses, documents, health, and more',
          icon: Icons.all_inbox_rounded,
        ),
        FilledButton(
          onPressed: () => _showUpgradeSheet(context),
          child: const Text('Upgrade to Premium'),
        ),
      ],
    );
  }
}
