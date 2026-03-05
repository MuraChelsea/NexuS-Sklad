import 'package:flutter/material.dart';

import 'info_cards.dart';
import 'state_cards.dart';

class PendingOperationAction {
  const PendingOperationAction({
    required this.id,
    required this.label,
    this.onRetry,
    this.onDiscard,
  });

  final String id;
  final String label;
  final VoidCallback? onRetry;
  final VoidCallback? onDiscard;
}

class DashboardNoActivityCard extends StatelessWidget {
  const DashboardNoActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoMessageCard(
      message:
          'За сегодня еще нет движений и критичных остатков. '
          'Начни с прихода, расхода или короткой сверки остатков.',
    );
  }
}

class EmptyMovementsCard extends StatelessWidget {
  const EmptyMovementsCard({
    super.key,
    this.onCreateIncome,
  });

  final VoidCallback? onCreateIncome;

  @override
  Widget build(BuildContext context) {
    return EmptyStateCard(
      title: 'Движений пока нет',
      subtitle:
          'Зафиксируй первый приход, расход или корректировку, чтобы журнал начал наполняться.',
      actionLabel: 'Зафиксировать приход',
      onAction: onCreateIncome,
    );
  }
}

class PendingInventoryStartCard extends StatelessWidget {
  const PendingInventoryStartCard({
    super.key,
    required this.createdAtLabel,
    this.onRetry,
    this.onDiscard,
  });

  final String createdAtLabel;
  final VoidCallback? onRetry;
  final VoidCallback? onDiscard;

  @override
  Widget build(BuildContext context) {
    return PendingActionCard(
      title: 'Отложенный старт инвентаризации',
      subtitle:
          'Запрос на открытие сессии сохранен локально. Создано: $createdAtLabel',
      primaryLabel: 'Отправить сейчас',
      secondaryLabel: 'Убрать из очереди',
      onPrimary: onRetry,
      onSecondary: onDiscard,
    );
  }
}

class ProductPendingOperationsCard extends StatelessWidget {
  const ProductPendingOperationsCard({
    super.key,
    required this.categoryCreates,
    required this.productCreates,
    required this.productUpdates,
    this.syncMessage,
    this.hasConflict = false,
    this.onSyncAll,
    this.onClearAll,
    this.onClearConflict,
  });

  final List<PendingOperationAction> categoryCreates;
  final List<PendingOperationAction> productCreates;
  final List<PendingOperationAction> productUpdates;
  final String? syncMessage;
  final bool hasConflict;
  final VoidCallback? onSyncAll;
  final VoidCallback? onClearAll;
  final VoidCallback? onClearConflict;

  bool get _hasContent =>
      categoryCreates.isNotEmpty ||
      productCreates.isNotEmpty ||
      productUpdates.isNotEmpty ||
      syncMessage != null;

  @override
  Widget build(BuildContext context) {
    if (!_hasContent) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    Widget actionRow(PendingOperationAction item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            Text(item.label),
            TextButton(
              onPressed: item.onRetry,
              child: const Text('Повторить'),
            ),
            TextButton(
              onPressed: item.onDiscard,
              child: const Text('Удалить'),
            ),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (categoryCreates.isNotEmpty ||
                productCreates.isNotEmpty ||
                productUpdates.isNotEmpty)
              Text(
                'Отложенные изменения товаров',
                style: theme.textTheme.titleMedium,
              ),
            if (categoryCreates.isNotEmpty ||
                productCreates.isNotEmpty ||
                productUpdates.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                hasConflict
                    ? 'Часть изменений не совпала с текущим состоянием сервера.'
                    : 'Эти изменения будут отправлены при следующей синхронизации.',
              ),
            ],
            if (categoryCreates.isNotEmpty ||
                productCreates.isNotEmpty ||
                productUpdates.isNotEmpty)
              const SizedBox(height: 12),
            if (!hasConflict &&
                (categoryCreates.isNotEmpty ||
                    productCreates.isNotEmpty ||
                    productUpdates.isNotEmpty) &&
                (onSyncAll != null || onClearAll != null)) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (onSyncAll != null)
                    TextButton.icon(
                      onPressed: onSyncAll,
                      icon: const Icon(Icons.sync_rounded),
                      label: const Text('Отправить все сейчас'),
                    ),
                  if (onClearAll != null)
                    TextButton.icon(
                      onPressed: onClearAll,
                      icon: const Icon(Icons.delete_sweep_rounded),
                      label: const Text('Очистить очередь'),
                    ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            ...categoryCreates.map(actionRow),
            ...productCreates.map(actionRow),
            ...productUpdates.map(actionRow),
            if (syncMessage != null) ...[
              if (categoryCreates.isNotEmpty ||
                  productCreates.isNotEmpty ||
                  productUpdates.isNotEmpty)
                const SizedBox(height: 8),
              Text(
                syncMessage!,
                style: TextStyle(
                  color: hasConflict ? const Color(0xFF9C2F1F) : null,
                  fontWeight: hasConflict ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
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

class TeamPendingOperationsCard extends StatelessWidget {
  const TeamPendingOperationsCard({
    super.key,
    required this.queueCount,
    required this.invites,
    required this.updates,
    this.syncMessage,
    this.hasConflict = false,
    this.onSyncAll,
    this.onClearAll,
    this.onClearInvites,
    this.onClearConflict,
  });

  final int queueCount;
  final List<PendingOperationAction> invites;
  final List<PendingOperationAction> updates;
  final String? syncMessage;
  final bool hasConflict;
  final VoidCallback? onSyncAll;
  final VoidCallback? onClearAll;
  final VoidCallback? onClearInvites;
  final VoidCallback? onClearConflict;

  bool get _hasContent => queueCount > 0 || syncMessage != null;

  @override
  Widget build(BuildContext context) {
    if (!_hasContent) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    Widget actionRow(PendingOperationAction item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            Text(item.label),
            TextButton(
              onPressed: item.onRetry,
              child: const Text('Повторить'),
            ),
            TextButton(
              onPressed: item.onDiscard,
              child: const Text('Удалить'),
            ),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (queueCount > 0)
              Text(
                'Отложенные изменения сотрудников',
                style: theme.textTheme.titleMedium,
              ),
            if (queueCount > 0) ...[
              const SizedBox(height: 6),
              Text(
                hasConflict
                    ? 'Часть изменений по команде конфликтует с серверным состоянием.'
                    : 'Приглашения и обновления будут отправлены при следующей синхронизации.',
              ),
            ],
            if (queueCount > 0) const SizedBox(height: 12),
            if (queueCount > 0)
              Chip(
                avatar: const Icon(Icons.cloud_upload_outlined, size: 18),
                label: Text('Очередь сотрудников: $queueCount'),
              ),
            if (queueCount > 0 &&
                !hasConflict &&
                (onSyncAll != null || onClearAll != null)) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (onSyncAll != null)
                    TextButton.icon(
                      onPressed: onSyncAll,
                      icon: const Icon(Icons.sync_rounded),
                      label: const Text('Отправить все сейчас'),
                    ),
                  if (onClearAll != null)
                    TextButton.icon(
                      onPressed: onClearAll,
                      icon: const Icon(Icons.delete_sweep_rounded),
                      label: const Text('Очистить очередь'),
                    ),
                ],
              ),
            ],
            if (invites.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Отложенные приглашения',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ...invites.map(actionRow),
              if (hasConflict && onClearInvites != null)
                TextButton.icon(
                  onPressed: onClearInvites,
                  icon: const Icon(Icons.delete_sweep_rounded),
                  label: const Text('Очистить приглашения'),
                ),
            ],
            if (updates.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...updates.map(actionRow),
            ],
            if (syncMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                syncMessage!,
                style: const TextStyle(
                  color: Color(0xFF9C2F1F),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
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
