import 'package:flutter/material.dart';

String _roleLabel(String role) {
  switch (role) {
    case 'OWNER':
      return 'Владелец';
    case 'MANAGER':
      return 'Менеджер';
    case 'STAFF':
      return 'Сотрудник';
    default:
      return role;
  }
}

class CompanyStatusCard extends StatelessWidget {
  const CompanyStatusCard({
    super.key,
    required this.name,
    required this.details,
    required this.canEdit,
    required this.hasPendingSync,
    required this.hasConflict,
    this.syncMessage,
    this.onEdit,
    this.onSync,
    this.onClearConflict,
  });

  final String name;
  final String details;
  final bool canEdit;
  final bool hasPendingSync;
  final bool hasConflict;
  final String? syncMessage;
  final VoidCallback? onEdit;
  final VoidCallback? onSync;
  final VoidCallback? onClearConflict;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (hasPendingSync)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Chip(
                      avatar: const Icon(Icons.cloud_upload_outlined, size: 18),
                      label: const Text('В очереди'),
                    ),
                  ),
                if (hasPendingSync && onSync != null)
                  IconButton(
                    onPressed: onSync,
                    icon: const Icon(Icons.sync_rounded),
                    tooltip: 'Синхронизировать компанию',
                  ),
                if (canEdit)
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded),
                    tooltip: 'Редактировать компанию',
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(details),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (hasPendingSync) const Chip(label: Text('Есть изменения в очереди')),
                if (hasConflict) const Chip(label: Text('Нужна сверка с сервером')),
                if (!hasPendingSync && !hasConflict) const Chip(label: Text('Данные актуальны')),
              ],
            ),
            if (syncMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                syncMessage!,
                style: const TextStyle(
                  color: Color(0xFF9C2F1F),
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (hasConflict && onClearConflict != null) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: onClearConflict,
                  icon: const Icon(Icons.delete_sweep_rounded),
                  label: const Text('Очистить конфликтную очередь'),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class TeamMemberInfoCard extends StatelessWidget {
  const TeamMemberInfoCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.role,
    required this.accent,
    required this.canEdit,
    required this.hasPendingSync,
    this.onTap,
  });

  final String name;
  final String subtitle;
  final String role;
  final Color accent;
  final bool canEdit;
  final bool hasPendingSync;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: canEdit ? onTap : null,
        contentPadding: const EdgeInsets.all(18),
        leading: CircleAvatar(
          backgroundColor: accent.withValues(alpha: 0.12),
          child: Icon(Icons.person_rounded, color: accent),
        ),
        title: Text(name),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _roleLabel(role),
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (hasPendingSync) ...[
                const SizedBox(height: 2),
                Text(
                  'в очереди',
                  style: TextStyle(
                    color: accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ProductStockCard extends StatelessWidget {
  const ProductStockCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.stockLabel,
    required this.canEdit,
    required this.isLowStock,
    required this.isPendingCreate,
    this.onTap,
  });

  final String name;
  final String subtitle;
  final String stockLabel;
  final bool canEdit;
  final bool isLowStock;
  final bool isPendingCreate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        onTap: canEdit && !isPendingCreate ? onTap : null,
        contentPadding: const EdgeInsets.all(18),
        title: Text(
          name,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              stockLabel,
              style: theme.textTheme.titleMedium,
            ),
            if (isLowStock)
              const Text(
                'низкий остаток',
                style: TextStyle(
                  color: Color(0xFFB55D2A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            if (isPendingCreate)
              const Text(
                'создается офлайн',
                style: TextStyle(
                  color: Color(0xFF295C9B),
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
