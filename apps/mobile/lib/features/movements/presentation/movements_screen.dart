import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/domain_state_cards.dart';
import '../../../core/widgets/info_cards.dart';
import '../../../core/widgets/state_cards.dart';
import '../../auth/application/auth_controller.dart';
import '../../products/data/product_repository.dart';
import '../data/movement_queue_store.dart';
import '../data/movement_repository.dart';

class MovementsScreen extends StatefulWidget {
  const MovementsScreen({
    super.key,
    required this.config,
    required this.authController,
    this.movementRepository,
    this.productRepository,
    this.movementPayloadBuilder,
    this.requestedAction,
    this.actionRequestId = 0,
  });

  final AppConfig config;
  final AuthController authController;
  final MovementRepository? movementRepository;
  final ProductRepository? productRepository;
  final Future<MovementDialogPayload?> Function(
    MovementDialogAction action,
    List<MobileProduct> products,
  )? movementPayloadBuilder;
  final MovementDialogAction? requestedAction;
  final int actionRequestId;

  @override
  State<MovementsScreen> createState() => _MovementsScreenState();
}

class _MovementsScreenState extends State<MovementsScreen> {
  late Future<List<MobileMovement>> _movementsFuture;
  int _pendingCount = 0;
  bool _submitting = false;
  String? _syncMessage;
  bool _hasSyncConflict = false;
  int _lastHandledActionRequestId = 0;
  _MovementViewFilter _activeFilter = _MovementViewFilter.all;

  MovementRepository get _movementRepository =>
      widget.movementRepository ??
      MovementRepository(
        ApiClient(baseUrl: widget.config.apiBaseUrl),
      );

  ProductRepository get _productRepository =>
      widget.productRepository ??
      ProductRepository(
        ApiClient(baseUrl: widget.config.apiBaseUrl),
      );

  bool get _canAdjust {
    final role = widget.authController.currentUser?.role;
    return role == 'OWNER' || role == 'MANAGER';
  }

  @override
  void initState() {
    super.initState();
    _movementsFuture = _refreshMovements();
    _consumeRequestedAction();
  }

  @override
  void didUpdateWidget(covariant MovementsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _consumeRequestedAction();
  }

  void _consumeRequestedAction() {
    final action = widget.requestedAction;
    if (action == null) {
      return;
    }
    if (widget.actionRequestId == 0 ||
        widget.actionRequestId == _lastHandledActionRequestId) {
      return;
    }

    _lastHandledActionRequestId = widget.actionRequestId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      await _openMovementDialog(action);
    });
  }

  Future<List<MobileMovement>> _loadMovements() {
    final session = widget.authController.session!;
    return _movementRepository.fetchMovements(
      accessToken: session.accessToken,
      limit: 20,
    );
  }

  Future<List<MobileMovement>> _refreshMovements() async {
    final session = widget.authController.session!;
    final sync = await _movementRepository.flushPendingWrites(
      accessToken: session.accessToken,
    );
    final movements = await _loadMovements();
    if (mounted) {
      setState(() {
        _pendingCount = sync.pendingCount;
        _syncMessage = sync.blockingMessage;
        _hasSyncConflict = sync.hasConflict;
      });
    }

    if (sync.appliedCount > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Синхронизировано движений: ${sync.appliedCount}')),
      );
    }
    return movements;
  }

  Future<void> _openMovementDialog(
    MovementDialogAction action, {
    MovementDialogPayload? initialPayload,
    bool allowRetry = true,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    MovementDialogPayload? payload;

    setState(() {
      _submitting = true;
    });

    try {
      payload = initialPayload ??
          await (() async {
            final products = await _productRepository.fetchProducts(
              accessToken: widget.authController.session!.accessToken,
            );

            if (!mounted) {
              return null;
            }

            setState(() {
              _submitting = false;
            });

            if (products.isEmpty) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Сначала добавь хотя бы один товар в каталог')),
              );
              return null;
            }

            if (widget.movementPayloadBuilder case final builder?) {
              return builder(action, products);
            }

            return showDialog<MovementDialogPayload>(
              context: context,
              builder: (context) => _MovementDialog(
                action: action,
                products: products,
              ),
            );
          })();

      if (payload == null) {
        return;
      }

      setState(() {
        _submitting = true;
      });

      late final MovementWriteResult result;
      if (action == MovementDialogAction.income) {
        result = await _movementRepository.createIncome(
          accessToken: widget.authController.session!.accessToken,
          productId: payload.productId,
          quantity: payload.quantity,
          comment: payload.comment,
        );
      } else if (action == MovementDialogAction.expense) {
        result = await _movementRepository.createExpense(
          accessToken: widget.authController.session!.accessToken,
          productId: payload.productId,
          quantity: payload.quantity,
          comment: payload.comment,
        );
      } else {
        result = await _movementRepository.createAdjustment(
          accessToken: widget.authController.session!.accessToken,
          productId: payload.productId,
          targetQty: payload.quantity,
          comment: payload.comment,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _movementsFuture = _refreshMovements();
      });

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            result.queued
                ? '${action.label} сохранен в очередь на отправку'
                : '${action.label} проведен',
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      if (allowRetry && await widget.authController.recoverSession(error)) {
        await _openMovementDialog(
          action,
          initialPayload: payload,
          allowRetry: false,
        );
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  Future<void> _clearPendingQueue() async {
    await _movementRepository.clearPendingWrites();
    if (!mounted) {
      return;
    }

    setState(() {
      _syncMessage = null;
      _hasSyncConflict = false;
      _movementsFuture = _refreshMovements();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отложенные движения очищены')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Движения',
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              if (_pendingCount > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    avatar: const Icon(Icons.cloud_upload_outlined, size: 18),
                    label: Text('Очередь: $_pendingCount'),
                  ),
                ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _movementsFuture = _refreshMovements();
                  });
                },
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Фиксируй приход, расход и корректировку. Журнал покажет, кто и когда изменил остатки.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF5D655E),
            ),
          ),
          const SizedBox(height: 12),
          if (_syncMessage != null) ...[
            SyncIssueCard(
              message: _syncMessage!,
              hasConflict: _hasSyncConflict,
              onClearConflict: _hasSyncConflict ? _clearPendingQueue : null,
            ),
            const SizedBox(height: 12),
          ] else if (_pendingCount > 0) ...[
            PendingActionCard(
              title: 'Есть движения в очереди',
              subtitle:
                  'Часть операций сохранена локально и будет отправлена при следующей синхронизации.',
              primaryLabel: 'Отправить сейчас',
              secondaryLabel: 'Очистить очередь',
              onPrimary: () {
                setState(() {
                  _movementsFuture = _refreshMovements();
                });
              },
              onSecondary: _clearPendingQueue,
            ),
            const SizedBox(height: 12),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: _submitting
                    ? null
                    : () => _openMovementDialog(MovementDialogAction.income),
                icon: const Icon(Icons.south_west_rounded),
                label: const Text('Приход'),
              ),
              FilledButton.tonalIcon(
                onPressed: _submitting
                    ? null
                    : () => _openMovementDialog(MovementDialogAction.expense),
                icon: const Icon(Icons.north_east_rounded),
                label: const Text('Расход'),
              ),
              if (_canAdjust)
                OutlinedButton.icon(
                  onPressed: _submitting
                      ? null
                      : () => _openMovementDialog(MovementDialogAction.adjustment),
                  icon: const Icon(Icons.tune_rounded),
                  label: const Text('Корректировка'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<MobileMovement>>(
              future: _movementsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  if (snapshot.error is ApiException &&
                      widget.authController.isSessionExpiredError(
                        snapshot.error as ApiException,
                      )) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      final recovered = await widget.authController.recoverSession(
                        snapshot.error as ApiException,
                      );
                      if (recovered && mounted) {
                        setState(() {
                          _movementsFuture = _refreshMovements();
                        });
                      }
                    });
                  }
                  final message = snapshot.error is ApiException
                      ? (snapshot.error as ApiException).message
                      : 'Не удалось загрузить движения';
                  return ErrorStateCard(
                    message: message,
                    onRetry: () {
                      setState(() {
                        _movementsFuture = _refreshMovements();
                      });
                    },
                  );
                }

                final items = snapshot.data ?? const [];
                final incomeCount = items.where((item) => item.type == 'INCOME').length;
                final expenseCount = items.where((item) => item.type == 'EXPENSE').length;
                final adjustmentCount =
                    items.where((item) => item.type == 'ADJUSTMENT').length;
                final inventoryDiffCount =
                    items.where((item) => item.type == 'INVENTORY_DIFF').length;
                final filteredItems = _applyFilter(items);
                if (items.isEmpty) {
                  return EmptyMovementsCard(
                    onCreateIncome: _submitting
                        ? null
                        : () => _openMovementDialog(MovementDialogAction.income),
                  );
                }
                if (filteredItems.isEmpty) {
                  return ListView(
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(label: Text('Записей: ${items.length}')),
                          Chip(label: Text('Приход: $incomeCount')),
                          Chip(label: Text('Расход: $expenseCount')),
                          if (_canAdjust) Chip(label: Text('Корректировка: $adjustmentCount')),
                          Chip(label: Text('Сверки: $inventoryDiffCount')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _MovementFilterChips(
                        activeFilter: _activeFilter,
                        incomeCount: incomeCount,
                        expenseCount: expenseCount,
                        adjustmentCount: adjustmentCount,
                        inventoryDiffCount: inventoryDiffCount,
                        onSelected: (filter) {
                          setState(() {
                            _activeFilter = filter;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      EmptyStateCard(
                        title: 'По выбранному фильтру движений нет',
                        subtitle:
                            'Сбрось фильтр или открой другой тип операции, чтобы увидеть нужные записи.',
                        actionLabel: 'Сбросить фильтр',
                        onAction: () {
                          setState(() {
                            _activeFilter = _MovementViewFilter.all;
                          });
                        },
                      ),
                    ],
                  );
                }

                return ListView.separated(
                  itemCount: filteredItems.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(label: Text('Записей: ${items.length}')),
                              Chip(label: Text('Приход: $incomeCount')),
                              Chip(label: Text('Расход: $expenseCount')),
                              if (_canAdjust) Chip(label: Text('Корректировка: $adjustmentCount')),
                              Chip(label: Text('Сверки: $inventoryDiffCount')),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _MovementFilterChips(
                            activeFilter: _activeFilter,
                            incomeCount: incomeCount,
                            expenseCount: expenseCount,
                            adjustmentCount: adjustmentCount,
                            inventoryDiffCount: inventoryDiffCount,
                            onSelected: (filter) {
                              setState(() {
                                _activeFilter = filter;
                              });
                            },
                          ),
                        ],
                      );
                    }
                    final item = filteredItems[index - 1];
                    final accent = _colorForMovement(item.type);
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(18),
                        leading: CircleAvatar(
                          backgroundColor: accent.withValues(alpha: 0.12),
                          child: Icon(Icons.swap_vert_rounded, color: accent),
                        ),
                        title: Text(item.typeLabel),
                        subtitle: Text(
                          '${item.productName} · ${item.actorName}\n${_formatDate(item.createdAt)}',
                        ),
                        trailing: Text(
                          item.signedQuantity,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: accent,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForMovement(String type) {
    switch (type) {
      case 'INCOME':
        return const Color(0xFF2A6A53);
      case 'EXPENSE':
        return const Color(0xFFA04432);
      case 'ADJUSTMENT':
        return const Color(0xFF295C9B);
      case 'INVENTORY_DIFF':
        return const Color(0xFF9B6A1B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatDate(DateTime value) {
    String two(int number) => number.toString().padLeft(2, '0');
    return '${two(value.day)}.${two(value.month)} ${two(value.hour)}:${two(value.minute)}';
  }

  List<MobileMovement> _applyFilter(List<MobileMovement> items) {
    switch (_activeFilter) {
      case _MovementViewFilter.all:
        return items;
      case _MovementViewFilter.income:
        return items.where((item) => item.type == 'INCOME').toList(growable: false);
      case _MovementViewFilter.expense:
        return items.where((item) => item.type == 'EXPENSE').toList(growable: false);
      case _MovementViewFilter.adjustment:
        return items.where((item) => item.type == 'ADJUSTMENT').toList(growable: false);
      case _MovementViewFilter.inventoryDiff:
        return items.where((item) => item.type == 'INVENTORY_DIFF').toList(growable: false);
    }
  }
}

enum _MovementViewFilter { all, income, expense, adjustment, inventoryDiff }

class _MovementFilterChips extends StatelessWidget {
  const _MovementFilterChips({
    required this.activeFilter,
    required this.incomeCount,
    required this.expenseCount,
    required this.adjustmentCount,
    required this.inventoryDiffCount,
    required this.onSelected,
  });

  final _MovementViewFilter activeFilter;
  final int incomeCount;
  final int expenseCount;
  final int adjustmentCount;
  final int inventoryDiffCount;
  final ValueChanged<_MovementViewFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Все'),
          selected: activeFilter == _MovementViewFilter.all,
          onSelected: (_) => onSelected(_MovementViewFilter.all),
        ),
        ChoiceChip(
          label: Text('Приход ($incomeCount)'),
          selected: activeFilter == _MovementViewFilter.income,
          onSelected: (_) => onSelected(_MovementViewFilter.income),
        ),
        ChoiceChip(
          label: Text('Расход ($expenseCount)'),
          selected: activeFilter == _MovementViewFilter.expense,
          onSelected: (_) => onSelected(_MovementViewFilter.expense),
        ),
        ChoiceChip(
          label: Text('Корректировка ($adjustmentCount)'),
          selected: activeFilter == _MovementViewFilter.adjustment,
          onSelected: (_) => onSelected(_MovementViewFilter.adjustment),
        ),
        ChoiceChip(
          label: Text('Сверка ($inventoryDiffCount)'),
          selected: activeFilter == _MovementViewFilter.inventoryDiff,
          onSelected: (_) => onSelected(_MovementViewFilter.inventoryDiff),
        ),
      ],
    );
  }
}

enum MovementDialogAction {
  income('Приход'),
  expense('Расход'),
  adjustment('Корректировка');

  const MovementDialogAction(this.label);

  final String label;
}

class MovementDialogPayload {
  const MovementDialogPayload({
    required this.productId,
    required this.quantity,
    required this.comment,
  });

  final String productId;
  final double quantity;
  final String? comment;
}

class _MovementDialog extends StatefulWidget {
  const _MovementDialog({
    required this.action,
    required this.products,
  });

  final MovementDialogAction action;
  final List<MobileProduct> products;

  @override
  State<_MovementDialog> createState() => _MovementDialogState();
}

class _MovementDialogState extends State<_MovementDialog> {
  late String _selectedProductId;
  late final TextEditingController _quantityController;
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _selectedProductId = widget.products.first.id;
    _quantityController = TextEditingController();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quantityLabel = widget.action == MovementDialogAction.adjustment
        ? 'Целевой остаток'
        : 'Количество';

    return AlertDialog(
      title: Text(widget.action.label),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.action == MovementDialogAction.adjustment
                  ? 'Укажи новый целевой остаток для товара.'
                  : 'Выбери товар и зафиксируй изменение остатков.',
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedProductId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Товар',
                helperText: 'Выбери позицию, по которой меняется остаток',
              ),
              items: widget.products
                  .map(
                    (product) => DropdownMenuItem(
                      value: product.id,
                      child: Text(product.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedProductId = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _quantityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: quantityLabel,
                helperText: widget.action == MovementDialogAction.adjustment
                    ? 'После сохранения остаток станет равен этому значению'
                    : 'Укажи количество товара для операции',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Комментарий',
                helperText: 'Необязательно. Например: поставка, возврат, пересчет',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () {
            final quantity = double.tryParse(_quantityController.text.trim());
            if (quantity == null || quantity < 0) {
              return;
            }

            if (widget.action != MovementDialogAction.adjustment && quantity == 0) {
              return;
            }

            Navigator.of(context).pop(
              MovementDialogPayload(
                productId: _selectedProductId,
                quantity: quantity,
                comment: _commentController.text.trim().isEmpty
                    ? null
                    : _commentController.text.trim(),
              ),
            );
          },
          child: Text(
            widget.action == MovementDialogAction.income
                ? 'Провести приход'
                : widget.action == MovementDialogAction.expense
                    ? 'Провести расход'
                    : 'Применить корректировку',
          ),
        ),
      ],
    );
  }
}
