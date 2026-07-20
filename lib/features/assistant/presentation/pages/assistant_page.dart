import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/features/assistant/domain/context_search_service.dart';
import 'package:flutter_application_1/core/providers/expenses_provider.dart';
import 'package:flutter_application_1/core/providers/reminders_provider.dart';
import 'package:flutter_application_1/core/providers/user_profile_provider.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class AssistantPage extends ConsumerStatefulWidget {
  const AssistantPage({super.key});

  @override
  ConsumerState<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends ConsumerState<AssistantPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late List<_ChatMessage> _messages;
  bool _isThinking = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _messages = [
      _ChatMessage(
        author: _ChatAuthor.assistant,
        text:
            'Hello ${profile.name.split(' ')[0]}! I am your LifeOS Assistant. I have real-time access to your notes, expenses, tasks, and reminders.',
      ),
      const _ChatMessage(
        author: _ChatAuthor.assistant,
        text:
            'Ask me anything about your life data. For example: "How much did I spend total?" or "What are my pending tasks?"',
      ),
    ];
  }

  final List<String> _prompts = const [
    'How much did I spend total?',
    'What are my pending tasks?',
    'Show my upcoming reminders.',
    'Search my notes.',
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

  Future<void> _sendMessage(String rawInput) async {
    final input = rawInput.trim();
    if (input.isEmpty || _isThinking) return;

    setState(() {
      _messages.add(_ChatMessage(author: _ChatAuthor.user, text: input));
      _isThinking = true;
    });
    _inputController.clear();
    _scrollToBottom();

    final response = await ref.read(contextSearchServiceProvider).query(input);
    
    if (mounted) {
      setState(() {
        _isThinking = false;
        _messages.add(_ChatMessage(author: _ChatAuthor.assistant, text: response));
      });
      _scrollToBottom();
    }
  }

  Widget _buildHeader(BuildContext context) {
    final expenses = ref.watch(expensesProvider).valueOrNull ?? [];
    final totalSpent = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    final reminders = ref.watch(remindersProvider).valueOrNull ?? [];

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
                      'Real-time life intelligence',
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
                        value: NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0).format(totalSpent),
                        icon: Icons.receipt_long_rounded,
                        color: const Color(0xFF6D4CFF),
                      ),
                      _SummaryPill(
                        title: 'Reminders',
                        value: '${reminders.length} active',
                        icon: Icons.notifications_none_rounded,
                        color: const Color(0xFFFF4AA2),
                      ),
                      const _SummaryPill(
                        title: 'Status',
                        value: 'Connected',
                        icon: Icons.check_circle_outline_rounded,
                        color: Color(0xFF18A058),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LifeOsCard(
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(4),
          itemCount: _messages.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final message = _messages[index];
            final isUser = message.author == _ChatAuthor.user;
            return Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
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
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                children: [
                  _buildHeader(context),
                  _buildPromptRow(context),
                  _buildQuickLinks(context),
                  _buildMessageList(context),
                  if (_isThinking)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: lifeOsPurple),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'AI is thinking...',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: lifeOsMuted, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
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
