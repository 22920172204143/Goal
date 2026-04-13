import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../models/income_record.dart';
import '../utils/formatters.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({
    super.key,
    required this.controller,
    required this.onEdit,
  });

  final AppController controller;
  final ValueChanged<IncomeRecord> onEdit;

  @override
  Widget build(BuildContext context) {
    final records = controller.records;
    if (records.isEmpty) {
      return const _EmptyState(
        title: '还没有收入记录',
        message: '点击右下角的加号，先记下第一笔钱。',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      itemBuilder: (context, index) {
        final record = records[index];
        return Card(
          child: ListTile(
            onTap: () => onEdit(record),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
              child: Text(record.category.characters.first),
            ),
            title: Text(record.note.isEmpty ? record.category : record.note),
            subtitle: Text('${record.category} · ${formatDateTime(record.createdAt)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  formatCurrency(record.amount, symbol: controller.settings.currencySymbol),
                  style: const TextStyle(
                    color: Color(0xFF67E391),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.deleteIncome(record.id),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: records.length,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.receipt_long_outlined, size: 48, color: Colors.white54),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
