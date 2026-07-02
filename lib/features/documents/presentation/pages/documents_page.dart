import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';
import 'package:flutter_application_1/features/documents/data/documents_notifier.dart';
import 'package:flutter_application_1/features/documents/domain/document.dart';
import 'package:flutter_application_1/features/documents/presentation/pages/document_upload_sheet.dart';

class DocumentsPage extends ConsumerStatefulWidget {
  const DocumentsPage({super.key});

  @override
  ConsumerState<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends ConsumerState<DocumentsPage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _expiryAscending = true;

  static const _documentCategories = [
    'All',
    'Archived',
    'Favorites',
    'Identity',
    'Medical',
    'Travel',
    'Financial',
    'Other',
  ];

  int _compareExpiry(Document a, Document b) {
    final aExpiry = DateTime.tryParse(a.expiryDate);
    final bExpiry = DateTime.tryParse(b.expiryDate);
    if (aExpiry == null && bExpiry == null) return 0;
    if (aExpiry == null) return 1;
    if (bExpiry == null) return -1;
    return aExpiry.compareTo(bExpiry);
  }

  Color _statusColor(int daysUntilExpiry) {
    if (daysUntilExpiry < 0) {
      return Colors.redAccent;
    }
    if (daysUntilExpiry < 30) {
      return Colors.orangeAccent;
    }
    return Colors.greenAccent.shade700;
  }

  String _statusLabel(int daysUntilExpiry) {
    if (daysUntilExpiry < 0) {
      return 'Expired';
    }
    if (daysUntilExpiry == 0) {
      return 'Expires today';
    }
    if (daysUntilExpiry < 30) {
      return 'Expiring in $daysUntilExpiry days';
    }
    return 'Valid';
  }

  Future<void> _showDocumentUploader(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DocumentUploadSheet(ref: ref);
      },
    );
  }

  Future<void> _showFilterSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: StatefulBuilder(
              builder: (context, setSheetState) {
                void updateCategory(String category) {
                  setState(() => _selectedCategory = category);
                  setSheetState(() {});
                }

                void updateSort(bool ascending) {
                  setState(() => _expiryAscending = ascending);
                  setSheetState(() {});
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filters',
                      style: Theme.of(sheetContext).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Refine documents by category and expiry order.',
                      style: Theme.of(
                        sheetContext,
                      ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Category',
                      style: Theme.of(sheetContext).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _documentCategories.map((category) {
                        return ChoiceChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (_) => updateCategory(category),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sort',
                      style: Theme.of(sheetContext).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.arrow_upward_rounded),
                      title: const Text('Expiry ascending'),
                      trailing: _expiryAscending
                          ? const Icon(Icons.check_rounded)
                          : null,
                      onTap: () => updateSort(true),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.arrow_downward_rounded),
                      title: const Text('Expiry descending'),
                      trailing: !_expiryAscending
                          ? const Icon(Icons.check_rounded)
                          : null,
                      onTap: () => updateSort(false),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = 'All';
                              _expiryAscending = true;
                            });
                            Navigator.of(sheetContext).pop();
                          },
                          child: const Text('Reset'),
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  bool _matchesSearchQuery(Document document, String query) {
    if (query.isEmpty) return true;

    final metadataMatch = document.metadata.entries.any(
      (entry) =>
          entry.key.toLowerCase().contains(query) ||
          entry.value.toLowerCase().contains(query),
    );

    return document.title.toLowerCase().contains(query) ||
        document.category.toLowerCase().contains(query) ||
        document.holderName.toLowerCase().contains(query) ||
        document.documentNumber.toLowerCase().contains(query) ||
        document.summary.toLowerCase().contains(query) ||
        document.ocrExtractedText.toLowerCase().contains(query) ||
        metadataMatch;
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 500;
    final documents = ref.watch(documentsNotifierProvider);
    final query = _searchQuery.trim().toLowerCase();

    final filteredDocuments = documents.where((document) {
      if (_selectedCategory == 'Archived') {
        return document.isArchived && _matchesSearchQuery(document, query);
      }
      if (document.isArchived) {
        return false;
      }
      if (_selectedCategory == 'Favorites') {
        return document.isFavorite && _matchesSearchQuery(document, query);
      }
      if (_selectedCategory != 'All' &&
          document.category != _selectedCategory) {
        return false;
      }
      return _matchesSearchQuery(document, query);
    }).toList();

    final sortedDocuments = [...filteredDocuments]
      ..sort((a, b) {
        if (a.isPinned != b.isPinned) {
          return a.isPinned ? -1 : 1;
        }
        return _expiryAscending ? _compareExpiry(a, b) : _compareExpiry(b, a);
      });

    final expiringSoon = documents.where((document) {
      return !document.isArchived &&
          document.daysUntilExpiry >= 0 &&
          document.daysUntilExpiry < 30;
    }).length;

    final favorites = documents.where((document) => document.isFavorite).length;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDocumentUploader(context, ref),
        child: const Icon(Icons.upload_file_rounded),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Documents',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Search, track, and organize every file',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _showFilterSheet,
                    icon: const Icon(Icons.tune_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: compact ? 2 : 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: compact ? 1.85 : 2.25,
                children: [
                  LifeOsMetricCard(
                    title: 'Documents',
                    value: '${documents.length}',
                    subtitle: 'Saved',
                    icon: Icons.folder_open_rounded,
                    color: const Color(0xFF6D4CFF),
                  ),
                  LifeOsMetricCard(
                    title: 'Expiring soon',
                    value: '$expiringSoon',
                    subtitle: 'Under 30 days',
                    icon: Icons.schedule_rounded,
                    color: const Color(0xFFFF4AA2),
                  ),
                  if (!compact)
                    LifeOsMetricCard(
                      title: 'Favorites',
                      value: '$favorites',
                      subtitle: 'Pinned docs',
                      icon: Icons.favorite_rounded,
                      color: const Color(0xFF18A058),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              LifeOsSearchField(
                fieldKey: const Key('documentSearchField'),
                hintText: 'Search documents...',
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final category = _documentCategories[index];
                    return ChoiceChip(
                      key: Key('documentCategoryChip_$category'),
                      selected: _selectedCategory == category,
                      label: Text(category),
                      onSelected: (_) =>
                          setState(() => _selectedCategory = category),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemCount: _documentCategories.length,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Sort by expiry date',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  IconButton(
                    key: const Key('expirySortToggleButton'),
                    onPressed: () =>
                        setState(() => _expiryAscending = !_expiryAscending),
                    icon: Icon(
                      _expiryAscending
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                    ),
                    tooltip: _expiryAscending
                        ? 'Sort descending'
                        : 'Sort ascending',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filteredDocuments.isEmpty
                    ? Center(
                        child: Text(
                          query.isEmpty
                              ? 'No documents available.'
                              : 'No documents match your search.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.separated(
                        itemCount: sortedDocuments.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final document = sortedDocuments[index];
                          return compact
                              ? LifeOsCard(
                                  onTap: () =>
                                      context.go('/documents/${document.id}'),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(document.icon),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              document.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ),
                                          if (document.isFavorite)
                                            const Icon(
                                              Icons.favorite_rounded,
                                              size: 16,
                                              color: Colors.redAccent,
                                            ),
                                          if (document.isPinned)
                                            const Padding(
                                              padding: EdgeInsets.only(left: 6),
                                              child: Icon(
                                                Icons.push_pin_rounded,
                                                size: 17,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        document.category,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: lifeOsMuted),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Expires ${document.expiryDate}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: lifeOsMuted),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: _StatusPill(
                                          label: _statusLabel(
                                            document.daysUntilExpiry,
                                          ),
                                          color: _statusColor(
                                            document.daysUntilExpiry,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : LifeOsCard(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Icon(document.icon),
                                    title: Text(document.title),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(document.category),
                                        const SizedBox(height: 4),
                                        Text('Expires ${document.expiryDate}'),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (document.isFavorite)
                                          const Padding(
                                            padding: EdgeInsets.only(right: 6),
                                            child: Icon(
                                              Icons.favorite_rounded,
                                              size: 16,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        if (document.isPinned)
                                          const Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: Icon(
                                              Icons.push_pin_rounded,
                                              size: 18,
                                            ),
                                          ),
                                        Chip(
                                          label: Text(
                                            _statusLabel(
                                              document.daysUntilExpiry,
                                            ),
                                          ),
                                          backgroundColor: _statusColor(
                                            document.daysUntilExpiry,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () =>
                                        context.go('/documents/${document.id}'),
                                  ),
                                );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}
