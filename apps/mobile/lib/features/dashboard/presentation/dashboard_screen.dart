import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/domain_state_cards.dart';
import '../../../core/widgets/summary_card.dart';
import '../../auth/application/auth_controller.dart';
import '../data/dashboard_repository.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.config,
    required this.authController,
    this.repository,
    this.onOpenIncome,
    this.onOpenExpense,
    this.onOpenProducts,
    this.onOpenInventory,
    this.onOpenTeam,
  });

  final AppConfig config;
  final AuthController authController;
  final DashboardRepository? repository;
  final VoidCallback? onOpenIncome;
  final VoidCallback? onOpenExpense;
  final VoidCallback? onOpenProducts;
  final VoidCallback? onOpenInventory;
  final VoidCallback? onOpenTeam;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardSummary> _summaryFuture;

  @override
  void initState() {
    super.initState();
    _summaryFuture = _loadSummary();
  }

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

  Future<DashboardSummary> _loadSummary() {
    final session = widget.authController.session!;
    return (widget.repository ??
            DashboardRepository(
              ApiClient(baseUrl: widget.config.apiBaseUrl),
            ))
        .fetchDaily(
      accessToken: session.accessToken,
    );
  }

  Future<void> _refreshSummary() async {
    setState(() {
      _summaryFuture = _loadSummary();
    });
    await _summaryFuture;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = widget.authController.session!;

    return RefreshIndicator(
      onRefresh: _refreshSummary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF193F31), Color(0xFF2A6A53)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0x1FFFFFFF),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'Рабочая смена',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.warehouse_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Text(
                          '${session.user.companyName}\n${session.user.name}',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${_roleLabel(session.user.role)} · Подключено к ${widget.config.apiBaseUrl}',
                          style: const TextStyle(
                            color: Color(0xDEFFFFFF),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<DashboardSummary>(
                    future: _summaryFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasError) {
                        if (snapshot.error is ApiException &&
                            widget.authController.isSessionExpiredError(
                              snapshot.error as ApiException,
                            )) {
                          WidgetsBinding.instance.addPostFrameCallback((_) async {
                            final recovered =
                                await widget.authController.recoverSession(
                              snapshot.error as ApiException,
                            );
                            if (recovered && mounted) {
                              setState(() {
                                _summaryFuture = _loadSummary();
                              });
                            }
                          });
                        }
                        final message = snapshot.error is ApiException
                            ? (snapshot.error as ApiException).message
                            : 'Не удалось загрузить обзор смены';
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ошибка загрузки',
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 6),
                                Text(message),
                                const SizedBox(height: 12),
                                FilledButton(
                                  onPressed: _refreshSummary,
                                  child: const Text('Повторить'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final summary = snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SummaryCard(
                                  title: 'Низкий остаток',
                                  value: summary.lowStockCount
                                      .toString()
                                      .padLeft(2, '0'),
                                  caption:
                                      'Позиции под контролем на ${summary.date}',
                                  color: const Color(0xFFB55D2A),
                                  icon: Icons.warning_amber_rounded,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SummaryCard(
                                  title: 'Движения',
                                  value: summary.totalMovementCount.toString(),
                                  caption: 'Операции и сверки за день',
                                  color: const Color(0xFF295C9B),
                                  icon: Icons.sync_alt_rounded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(label: Text('Приходов: ${summary.incomeCount}')),
                              Chip(label: Text('Расходов: ${summary.expenseCount}')),
                              Chip(
                                label: Text(
                                  'Корректировок: ${summary.adjustmentCount}',
                                ),
                              ),
                              Chip(
                                label: Text(
                                  'Сверок: ${summary.inventoryDiffCount}',
                                ),
                              ),
                              Chip(
                                label: Text(
                                  'Сессий: ${summary.inventorySessionsCount}',
                                ),
                              ),
                            ],
                          ),
                          if (summary.totalMovementCount == 0 &&
                              summary.lowStockCount == 0) ...[
                            const SizedBox(height: 12),
                            const DashboardNoActivityCard(),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Быстрые действия', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _DashboardTile(
                    title: 'Приход товара',
                    subtitle: 'Открыть журнал движений и зафиксировать поставку',
                    icon: Icons.south_west_rounded,
                    accent: const Color(0xFF2A6A53),
                    onTap: widget.onOpenIncome,
                  ),
                  const SizedBox(height: 12),
                  _DashboardTile(
                    title: 'Расход товара',
                    subtitle: 'Списать или отгрузить позиции со склада',
                    icon: Icons.north_east_rounded,
                    accent: const Color(0xFF8F3A2A),
                    onTap: widget.onOpenExpense,
                  ),
                  const SizedBox(height: 12),
                  _DashboardTile(
                    title: 'Инвентаризация',
                    subtitle: 'Перейти к сессии и пройтись по фактическим остаткам',
                    icon: Icons.fact_check_outlined,
                    accent: const Color(0xFF9B6A1B),
                    onTap: widget.onOpenInventory,
                  ),
                  const SizedBox(height: 12),
                  _DashboardTile(
                    title: 'Каталог и остатки',
                    subtitle: 'Проверить low-stock и открыть карточки товаров',
                    icon: Icons.inventory_2_rounded,
                    accent: const Color(0xFF6B3FA0),
                    onTap: widget.onOpenProducts,
                  ),
                  const SizedBox(height: 12),
                  _DashboardTile(
                    title: 'Команда и доступ',
                    subtitle: 'Посмотреть состав команды и роли доступа',
                    icon: Icons.group_rounded,
                    accent: const Color(0xFF5E4B8B),
                    onTap: widget.onOpenTeam,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  const _DashboardTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: accent.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
