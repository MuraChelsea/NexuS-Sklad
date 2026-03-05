import 'package:flutter/material.dart';

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 12),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorStateCard extends StatelessWidget {
  const ErrorStateCard({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: onRetry,
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SyncIssueCard extends StatelessWidget {
  const SyncIssueCard({
    super.key,
    required this.message,
    required this.hasConflict,
    this.onClearConflict,
  });

  final String message;
  final bool hasConflict;
  final VoidCallback? onClearConflict;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hasConflict ? 'Нужна ручная проверка' : 'Синхронизация ожидает повторной отправки',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: hasConflict ? const Color(0xFF9C2F1F) : null,
                fontWeight: hasConflict ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasConflict
                  ? 'Очисти конфликтную очередь, если хочешь принять текущее состояние сервера и повторить изменение заново.'
                  : 'Как только сеть появится, попробуй синхронизировать изменения еще раз.',
            ),
            if (hasConflict && onClearConflict != null) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: onClearConflict,
                icon: const Icon(Icons.delete_sweep_rounded),
                label: const Text('Очистить и принять серверное состояние'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
