import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      author: _ChatAuthor.assistant,
      text:
          'I can help with your calendar, expenses, notes, documents, and reminders.',
    ),
    const _ChatMessage(
      author: _ChatAuthor.assistant,
      text:
          'Try asking about what you spent this month, where your passport is saved, or what is coming up today.',
    ),
  ];

  final List<String> _prompts = const [
    'What did I spend on food this month?',
    'Where is my passport?',
    'Show my upcoming reminders.',
    'What is on my calendar today?',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage(String rawInput) {
    final input = rawInput.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(author: _ChatAuthor.user, text: input));
      _messages.add(
        _ChatMessage(author: _ChatAuthor.assistant, text: _buildReply(input)),
      );
    });
    _inputController.clear();
    _scrollToBottom();
  }

  String _buildReply(String input) {
    final lowered = input.toLowerCase();

    if (lowered.contains('passport') || lowered.contains('document')) {
      return 'Your passport is in Documents > Identity. It is marked as pinned and expires on 2028-06-15.';
    }

    if (lowered.contains('spend') ||
        lowered.contains('expense') ||
        lowered.contains('food')) {
      return 'You spent about ₹48,650 this month. Food & Dining is the largest category, followed by transport and shopping.';
    }

    if (lowered.contains('remind') || lowered.contains('task')) {
      return 'You have reminders for car insurance renewal, a doctor appointment, passport expiry, and birthday plans.';
    }

    if (lowered.contains('calendar') || lowered.contains('today')) {
      return 'Today you have Doctor Appointment at 11:00 AM, Team Standup at 2:00 PM, and Dinner with Rahul at 8:00 PM.';
    }

    if (lowered.contains('health') || lowered.contains('sleep')) {
      return 'Your health score is 86 out of 100, with a stable heart rate and everything in the normal range.';
    }

    if (lowered.contains('note')) {
      return 'Your recent notes include Goa Trip Plan, Project Ideas, and Daily Thoughts. All are searchable from Notes.';
    }

    return 'I checked the core LifeOS views. I can connect that request to your docs, notes, reminders, expenses, or calendar next.';
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LifeOsGradientIcon(size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Assistant',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Ask anything about your life',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LifeOsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today in brief',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 420;
                    final cards = [
                      _SummaryPill(
                        title: 'Spent',
                        value: '₹48,650',
                        icon: Icons.receipt_long_rounded,
                        color: const Color(0xFF6D4CFF),
                      ),
                      _SummaryPill(
                        title: 'Reminders',
                        value: '5 active',
                        icon: Icons.notifications_none_rounded,
                        color: const Color(0xFFFF4AA2),
                      ),
                      _SummaryPill(
                        title: 'Docs',
                        value: '12 saved',
                        icon: Icons.folder_open_rounded,
                        color: const Color(0xFF18A058),
                      ),
                    ];

                    if (compact) {
                      return Column(
                        children: [
                          for (final card in cards) ...[
                            card,
                            const SizedBox(height: 10),
                          ],
                        ],
                      );
                    }

                    return Row(
                      children: [
                        for (var i = 0; i < cards.length; i++) ...[
                          Expanded(child: cards[i]),
                          if (i != cards.length - 1) const SizedBox(width: 10),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _prompts
            .map(
              (prompt) => ActionChip(
                label: Text(prompt, overflow: TextOverflow.ellipsis),
                onPressed: () => _sendMessage(prompt),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: LifeOsCard(
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(4),
            itemCount: _messages.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isUser = message.author == _ChatAuthor.user;
              return Align(
                alignment: isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? lifeOsPurple.withValues(alpha: .12)
                          : const Color(0xFFF6F7FB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isUser
                            ? lifeOsPurple.withValues(alpha: .18)
                            : lifeOsBorder,
                      ),
                    ),
                    child: Text(
                      message.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isUser ? lifeOsInk : lifeOsMuted,
                        fontWeight: isUser ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          TextButton.icon(
            onPressed: () => context.go('/documents'),
            icon: const Icon(Icons.folder_open_rounded),
            label: const Text('Documents'),
          ),
          TextButton.icon(
            onPressed: () => context.go('/expenses'),
            icon: const Icon(Icons.receipt_long_rounded),
            label: const Text('Expenses'),
          ),
          TextButton.icon(
            onPressed: () => context.go('/reminders'),
            icon: const Icon(Icons.notifications_none_rounded),
            label: const Text('Reminders'),
          ),
        ],
      ),
    );
  }

  Widget _buildComposer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              textInputAction: TextInputAction.send,
              onSubmitted: _sendMessage,
              decoration: const InputDecoration(
                hintText: 'Ask LifeOS AI...',
                prefixIcon: Icon(Icons.auto_awesome_rounded),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: () => _sendMessage(_inputController.text),
            icon: const Icon(Icons.send_rounded),
            label: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildPromptRow(context),
            _buildQuickLinks(context),
            _buildMessageList(context),
            _buildComposer(context),
          ],
        ),
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: .12)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: lifeOsMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.author, required this.text});

  final _ChatAuthor author;
  final String text;
}

enum _ChatAuthor { user, assistant }
