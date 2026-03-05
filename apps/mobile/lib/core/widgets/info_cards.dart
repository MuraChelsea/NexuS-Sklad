import 'package:flutter/material.dart';

class InfoMessageCard extends StatelessWidget {
  const InfoMessageCard({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class AuthNoticeCard extends StatelessWidget {
  const AuthNoticeCard({
    super.key,
    required this.message,
    this.onDismiss,
  });

  final String message;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF3F8EE),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.info_outline_rounded, color: Color(0xFF2A6A53)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (onDismiss != null)
              IconButton(
                onPressed: onDismiss,
                tooltip: 'Скрыть notice',
                icon: const Icon(Icons.close_rounded),
              ),
          ],
        ),
      ),
    );
  }
}

class PendingActionCard extends StatelessWidget {
  const PendingActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.secondaryLabel,
    this.onPrimary,
    this.onSecondary,
  });

  final String title;
  final String subtitle;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                TextButton(
                  onPressed: onPrimary,
                  child: Text(primaryLabel),
                ),
                TextButton(
                  onPressed: onSecondary,
                  child: Text(secondaryLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
