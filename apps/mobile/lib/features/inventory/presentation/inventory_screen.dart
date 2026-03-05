import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/domain_state_cards.dart';
import '../../../core/widgets/info_cards.dart';
import '../../../core/widgets/state_cards.dart';
import '../../auth/application/auth_controller.dart';
import '../data/inventory_repository.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({
    super.key,
    required this.config,
    required this.authController,
    this.repository,
    this.actualQtyBuilder,
    this.startRequestId = 0,
  });

  final AppConfig config;
  final AuthController authController;
  final InventoryRepository? repository;
  final Future<double?> Function(MobileInventoryItem item)? actualQtyBuilder;
  final int startRequestId;

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  MobileInventorySession? _session;
  PendingInventoryStartView? _pendingStart;
  int _pendingCount = 0;
  bool _loading = false;
  String? _errorMessage;
  String? _syncMessage;
  bool _hasSyncConflict = false;
  int _lastHandledStartRequestId = 0;
  _InventoryItemFilter _activeFilter = _InventoryItemFilter.all;

  InventoryRepository get _repository =>
      widget.repository ??
      InventoryRepository(
        ApiClient(baseUrl: widget.config.apiBaseUrl),
      );

  @override
  void initState() {
    super.initState();
    _loadPendingStartState();
    _consumeStartRequest();
  }

  @override
  void didUpdateWidget(covariant InventoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _consumeStartRequest();
  }

  void _consumeStartRequest() {
    if (widget.startRequestId == 0 ||
        widget.startRequestId == _lastHandledStartRequestId) {
      return;
    }

    _lastHandledStartRequestId = widget.startRequestId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      await _startInventory();
    });
  }

  Future<void> _loadPendingStartState() async {
    final pending = await _repository.getPendingStart();
    if (!mounted) {
      return;
    }

    setState(() {
      _pendingStart = pending;
    });
  }

  Future<void> _refreshPendingCount() async {
    final session = _session;
    if (session == null) {
      if (mounted) {
        setState(() {
          _pendingCount = 0;
        });
      }
      return;
    }

    final count = await _repository.getPendingCount(inventoryId: session.id);
    if (mounted) {
      setState(() {
        _pendingCount = count;
      });
    }
  }

  Future<void> _flushPendingUpdates({
    bool allowRetry = true,
  }) async {
    final session = _session;
    if (session == null) {
      return;
    }

    try {
      final sync = await _repository.flushPendingItemUpdates(
        accessToken: widget.authController.session!.accessToken,
        inventoryId: session.id,
      );

      await _refreshPendingCount();
      if (mounted) {
        setState(() {
          _syncMessage = sync.blockingMessage;
          _hasSyncConflict = sync.hasConflict;
        });
      }

      if (sync.appliedCount > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Синхронизировано позиций инвентаризации: ${sync.appliedCount}')),
        );
        final refreshed = await _repository.getById(
          accessToken: widget.authController.session!.accessToken,
          inventoryId: session.id,
        );
        if (mounted) {
          setState(() {
            _session = refreshed;
          });
        }
      }
    } on ApiException catch (error) {
      if (allowRetry && await widget.authController.recoverSession(error)) {
        await _flushPendingUpdates(allowRetry: false);
        return;
      }
      if (mounted) {
        setState(() {
          _errorMessage = error.message;
        });
      }
    }
  }

  Future<void> _clearPendingQueue() async {
    final session = _session;
    if (session == null) {
      return;
    }

    await _repository.clearPendingItemUpdates(inventoryId: session.id);
    await _refreshPendingCount();

    if (!mounted) {
      return;
    }

    setState(() {
      _syncMessage = null;
      _hasSyncConflict = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отложенные изменения инвентаризации очищены')),
    );
  }

  Future<void> _clearPendingStart() async {
    await _repository.clearPendingStart();
    if (!mounted) {
      return;
    }

    setState(() {
      _pendingStart = null;
      _syncMessage = null;
      _hasSyncConflict = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отложенный запуск инвентаризации удален')),
    );
  }

  Future<void> _retryPendingStart() async {
    final result = await _repository.flushPendingStart(
      accessToken: widget.authController.session!.accessToken,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _pendingStart = result.hasPending ? _pendingStart : null;
      _syncMessage = result.blockingMessage;
      _hasSyncConflict = result.hasConflict;
      if (result.session != null) {
        _session = result.session;
      }
    });

    if (result.session != null) {
      await _refreshPendingCount();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Запуск инвентаризации синхронизирован')),
      );
      return;
    }

    if (result.blockingMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.blockingMessage!)),
      );
    }
  }

  Future<void> _startInventory({
    bool allowRetry = true,
  }) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result = await _repository.start(
        accessToken: widget.authController.session!.accessToken,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _session = result.session;
        _pendingStart = result.queued ? PendingInventoryStartView(createdAt: DateTime.now()) : null;
      });

      if (result.session != null) {
        await _refreshPendingCount();
      }

      if (result.queued) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Запуск инвентаризации сохранен в очередь на отправку')),
        );
      }
    } on ApiException catch (error) {
      if (allowRetry && await widget.authController.recoverSession(error)) {
        await _startInventory(allowRetry: false);
        return;
      }
      setState(() {
        _errorMessage = error.message;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _refreshScreen() async {
    if (_session == null) {
      await _retryPendingStart();
      return;
    }

    await _flushPendingUpdates();
  }

  Future<void> _changeActualQty(
    MobileInventoryItem item, {
    double? initialValue,
    bool allowRetry = true,
  }) async {
    final value = initialValue ??
        await (() async {
          if (widget.actualQtyBuilder case final builder?) {
            return builder(item);
          }
          return _showActualQtyDialog(item);
        })();

    if (value == null || _session == null) {
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final updated = await _repository.patchItem(
        accessToken: widget.authController.session!.accessToken,
        inventoryId: _session!.id,
        itemId: item.id,
        actualQty: value,
        fallbackItem: item,
      );

      final nextItems = _session!.items
          .map((entry) => entry.id == updated.item.id ? updated.item : entry)
          .toList();

      setState(() {
        _session = _session!.copyWith(items: nextItems);
      });
      await _refreshPendingCount();

      if (!updated.queued && mounted) {
        await _flushPendingUpdates();
      }

      if (updated.queued && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Изменение сохранено в очередь на отправку')),
        );
      }
    } on ApiException catch (error) {
      if (allowRetry && await widget.authController.recoverSession(error)) {
        await _changeActualQty(
          item,
          initialValue: value,
          allowRetry: false,
        );
        return;
      }
      setState(() {
        _errorMessage = error.message;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _finishInventory({
    bool allowRetry = true,
  }) async {
    final session = _session;
    if (session == null) {
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      await _flushPendingUpdates();
      if (_pendingCount > 0) {
        setState(() {
          _errorMessage = 'Сначала синхронизируй все офлайн-изменения';
        });
        return;
      }

      final finished = await _repository.finish(
        accessToken: widget.authController.session!.accessToken,
        inventoryId: session.id,
      );
      setState(() {
        _session = finished;
      });
    } on ApiException catch (error) {
      if (allowRetry && await widget.authController.recoverSession(error)) {
        await _finishInventory(allowRetry: false);
        return;
      }
      setState(() {
        _errorMessage = error.message;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<double?> _showActualQtyDialog(MobileInventoryItem item) async {
    final controller = TextEditingController(text: item.actualQty);
    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Фактический остаток · ${item.productName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Ожидалось: ${item.expectedQty} ${item.unit}'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Фактический остаток',
                  helperText: 'Введи реальное количество, которое видишь на складе',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(double.tryParse(controller.text));
              },
              child: const Text('Зафиксировать'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return value;
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
                child: Text('Инвентаризация', style: theme.textTheme.headlineMedium),
              ),
              IconButton(
                onPressed: _loading ? null : _refreshScreen,
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Обновить',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _session == null
                ? 'Открой сессию и зафиксируй фактические остатки по позициям.'
                : _session!.isCompleted
                    ? 'Сессия завершена.'
                    : 'Проверь позиции, синхронизируй очередь и зафиксируй расхождения.',
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(
                color: Color(0xFF9C2F1F),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (_syncMessage != null) ...[
            SyncIssueCard(
              message: _syncMessage!,
              hasConflict: _hasSyncConflict,
              onClearConflict:
                  _hasSyncConflict && !_loading ? _clearPendingQueue : null,
            ),
            const SizedBox(height: 12),
          ] else if (_session != null && _pendingCount > 0) ...[
            PendingActionCard(
              title: 'Есть позиции в очереди',
              subtitle:
                  'Часть изменений по инвентаризации сохранена локально и ждет синхронизации с сервером.',
              primaryLabel: 'Отправить сейчас',
              secondaryLabel: 'Очистить очередь',
              onPrimary: _loading ? null : _flushPendingUpdates,
              onSecondary: _loading ? null : _clearPendingQueue,
            ),
            const SizedBox(height: 12),
          ],
          if (_pendingStart != null && _session == null) ...[
            PendingInventoryStartCard(
              createdAtLabel: _formatPendingDate(_pendingStart!.createdAt),
              onRetry: _loading ? null : _retryPendingStart,
              onDiscard: _loading ? null : _clearPendingStart,
            ),
            const SizedBox(height: 12),
          ],
          if (_session == null)
            FilledButton.icon(
              onPressed: _loading ? null : _startInventory,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.playlist_add_check_circle_outlined),
              label: const Text('Открыть сессию'),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Позиций: ${_session!.items.length}',
                    style: theme.textTheme.titleMedium,
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
                if (!_session!.isCompleted) ...[
                  OutlinedButton(
                    onPressed: _loading ? null : _flushPendingUpdates,
                    child: const Text('Синхронизировать'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _loading ? null : _finishInventory,
                    child: const Text('Завершить'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('Позиций: ${_session!.items.length}')),
                Chip(
                  label: Text(
                    'Расхождений: ${_session!.items.where((item) => item.difference != '0').length}',
                  ),
                ),
                if (_pendingCount > 0) Chip(label: Text('В очереди: $_pendingCount')),
              ],
            ),
            const SizedBox(height: 12),
            _InventoryFilterChips(
              activeFilter: _activeFilter,
              differenceCount: _session!.items.where((item) => item.difference != '0').length,
              matchedCount: _session!.items.where((item) => item.difference == '0').length,
              onSelected: (filter) {
                setState(() {
                  _activeFilter = filter;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Builder(
                builder: (context) {
                  final filteredItems = _applyFilter(_session!.items);
                  if (filteredItems.isEmpty) {
                    return EmptyStateCard(
                      title: 'По выбранному фильтру позиций нет',
                      subtitle:
                          'Сбрось фильтр или продолжи сверку, чтобы увидеть остальные позиции сессии.',
                      actionLabel: 'Сбросить фильтр',
                      onAction: () {
                        setState(() {
                          _activeFilter = _InventoryItemFilter.all;
                        });
                      },
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final diff = double.tryParse(item.difference) ?? 0;
                      final diffColor = diff == 0
                          ? const Color(0xFF2A6A53)
                          : diff > 0
                              ? const Color(0xFF295C9B)
                              : const Color(0xFFA04432);

                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(18),
                          title: Text(
                            item.productName,
                            style: theme.textTheme.titleMedium,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              'Ожидалось: ${item.expectedQty} ${item.unit}\n'
                              'Факт: ${item.actualQty} ${item.unit}',
                            ),
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                item.difference,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: diffColor,
                                ),
                              ),
                              if (!_session!.isCompleted)
                                TextButton(
                                  onPressed: _loading ? null : () => _changeActualQty(item),
                                  style: TextButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text('Изменить'),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatPendingDate(DateTime value) {
    String two(int number) => number.toString().padLeft(2, '0');
    return '${two(value.day)}.${two(value.month)} ${two(value.hour)}:${two(value.minute)}';
  }

  List<MobileInventoryItem> _applyFilter(List<MobileInventoryItem> items) {
    switch (_activeFilter) {
      case _InventoryItemFilter.all:
        return items;
      case _InventoryItemFilter.differences:
        return items.where((item) => item.difference != '0').toList(growable: false);
      case _InventoryItemFilter.matched:
        return items.where((item) => item.difference == '0').toList(growable: false);
    }
  }
}

enum _InventoryItemFilter { all, differences, matched }

class _InventoryFilterChips extends StatelessWidget {
  const _InventoryFilterChips({
    required this.activeFilter,
    required this.differenceCount,
    required this.matchedCount,
    required this.onSelected,
  });

  final _InventoryItemFilter activeFilter;
  final int differenceCount;
  final int matchedCount;
  final ValueChanged<_InventoryItemFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Все'),
          selected: activeFilter == _InventoryItemFilter.all,
          onSelected: (_) => onSelected(_InventoryItemFilter.all),
        ),
        ChoiceChip(
          label: Text('Расхождения ($differenceCount)'),
          selected: activeFilter == _InventoryItemFilter.differences,
          onSelected: (_) => onSelected(_InventoryItemFilter.differences),
        ),
        ChoiceChip(
          label: Text('Совпадает ($matchedCount)'),
          selected: activeFilter == _InventoryItemFilter.matched,
          onSelected: (_) => onSelected(_InventoryItemFilter.matched),
        ),
      ],
    );
  }
}
