import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/domain_state_cards.dart';
import '../../../core/widgets/entity_cards.dart';
import '../../../core/widgets/state_cards.dart';
import '../../auth/application/auth_controller.dart';
import '../data/category_repository.dart';
import '../data/product_repository.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({
    super.key,
    required this.config,
    required this.authController,
    this.productRepository,
    this.categoryRepository,
    this.createCategoryNameBuilder,
    this.createProductPayloadBuilder,
    this.editProductPayloadBuilder,
  });

  final AppConfig config;
  final AuthController authController;
  final ProductRepository? productRepository;
  final CategoryRepository? categoryRepository;
  final Future<String?> Function()? createCategoryNameBuilder;
  final Future<ProductFormPayload?> Function(List<MobileCategory> categories)?
      createProductPayloadBuilder;
  final Future<ProductFormPayload?> Function(
    MobileProduct product,
    List<MobileCategory> categories,
  )? editProductPayloadBuilder;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late final TextEditingController _searchController;
  late Future<List<MobileProduct>> _productsFuture;
  int _pendingOperationCount = 0;
  bool _submitting = false;
  String? _syncMessage;
  bool _hasSyncConflict = false;
  List<PendingProductUpdateView> _pendingUpdates = const [];
  List<PendingProductCreateView> _pendingCreates = const [];
  List<PendingCategoryCreateView> _pendingCategoryCreates = const [];
  _ProductViewFilter _activeFilter = _ProductViewFilter.all;

  ProductRepository get _productRepository =>
      widget.productRepository ??
      ProductRepository(
        ApiClient(baseUrl: widget.config.apiBaseUrl),
      );

  CategoryRepository get _categoryRepository =>
      widget.categoryRepository ??
      CategoryRepository(
        ApiClient(baseUrl: widget.config.apiBaseUrl),
      );

  bool get _canManage {
    final role = widget.authController.currentUser?.role;
    return role == 'OWNER' || role == 'MANAGER';
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _productsFuture = _refreshProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<MobileProduct>> _loadProducts() {
    final session = widget.authController.session!;
    return _productRepository.fetchProducts(
      accessToken: session.accessToken,
      search: _searchController.text,
    );
  }

  Future<List<MobileProduct>> _refreshProducts() async {
    final session = widget.authController.session!;
    final categorySync = await _categoryRepository.flushPendingCreates(
      accessToken: session.accessToken,
    );
    final sync = await _productRepository.flushPendingUpdates(
      accessToken: session.accessToken,
    );
    final products = await _loadProducts();
    if (mounted) {
      setState(() {
        _pendingOperationCount = sync.pendingCount + categorySync.pendingCount;
        _syncMessage = _mergeMessages(categorySync.blockingMessage, sync.blockingMessage);
        _hasSyncConflict = categorySync.hasConflict || sync.hasConflict;
        _pendingUpdates = const [];
        _pendingCreates = const [];
        _pendingCategoryCreates = const [];
      });
    }

    if (sync.pendingCount > 0 || categorySync.pendingCount > 0) {
      final pending = await _productRepository.getPendingUpdates();
      final pendingCreates = await _productRepository.getPendingCreates();
      final pendingCategories = await _categoryRepository.getPendingCreates();
      if (mounted) {
        setState(() {
          _pendingUpdates = pending;
          _pendingCreates = pendingCreates;
          _pendingCategoryCreates = pendingCategories;
        });
      }
    }

    if (categorySync.appliedCount > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Синхронизировано категорий: ${categorySync.appliedCount}')),
      );
    }
    if (sync.appliedCount > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Синхронизировано товаров: ${sync.appliedCount}')),
      );
    }
    return products;
  }

  Future<void> _openCreateCategoryDialog({
    String? initialName,
    bool allowRetry = true,
  }) async {
    final name = initialName ??
        await (() async {
          if (widget.createCategoryNameBuilder case final builder?) {
            return builder();
          }

          final controller = TextEditingController();
          final value = await showDialog<String>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Создать категорию'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Название категории',
                    helperText: 'Например: Напитки, Бакалея или Хозтовары',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Отмена'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(controller.text.trim()),
                    child: const Text('Создать категорию'),
                  ),
                ],
              );
            },
          );
          controller.dispose();
          return value;
        })();

    if (name == null || name.isEmpty) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    try {
      final result = await _categoryRepository.createCategory(
        accessToken: widget.authController.session!.accessToken,
        name: name,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _productsFuture = _refreshProducts();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.queued ? 'Категория сохранена в очередь на отправку' : 'Категория создана',
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      if (allowRetry && await widget.authController.recoverSession(error)) {
        await _openCreateCategoryDialog(
          initialName: name,
          allowRetry: false,
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
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

  Future<void> _openCreateDialog({
    ProductFormPayload? initialPayload,
    bool allowRetry = true,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    ProductFormPayload? payload;

    setState(() {
      _submitting = true;
    });

    try {
      payload = initialPayload ??
          await (() async {
            final categories = await _categoryRepository.fetchCategories(
              accessToken: widget.authController.session!.accessToken,
            );

            if (!mounted) {
              return null;
            }

            setState(() {
              _submitting = false;
            });

            if (widget.createProductPayloadBuilder case final builder?) {
              return builder(categories);
            }

            return showDialog<ProductFormPayload>(
              context: context,
              builder: (context) => _ProductDialog(
                title: 'Новый товар',
                categories: categories,
              ),
            );
          })();

      if (payload == null) {
        return;
      }

      setState(() {
        _submitting = true;
      });

      final result = await _productRepository.createProduct(
        accessToken: widget.authController.session!.accessToken,
        name: payload.name,
        unit: payload.unit,
        categoryId: payload.categoryId,
        sku: payload.sku,
        barcode: payload.barcode,
        description: payload.description,
        minStock: payload.minStock,
        currentStock: payload.currentStock,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _productsFuture = _refreshProducts();
      });

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            result.queued ? 'Товар сохранен в очередь на создание' : 'Товар создан',
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      if (allowRetry && await widget.authController.recoverSession(error)) {
        await _openCreateDialog(
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

  Future<void> _openEditDialog(
    MobileProduct product, {
    ProductFormPayload? initialPayload,
    bool allowRetry = true,
  }) async {
    if (!_canManage) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    ProductFormPayload? payload;

    setState(() {
      _submitting = true;
    });

    try {
      payload = initialPayload ??
          await (() async {
            final categories = await _categoryRepository.fetchCategories(
              accessToken: widget.authController.session!.accessToken,
            );

            if (!mounted) {
              return null;
            }

            setState(() {
              _submitting = false;
            });

            if (widget.editProductPayloadBuilder case final builder?) {
              return builder(product, categories);
            }

            return showDialog<ProductFormPayload>(
              context: context,
              builder: (context) => _ProductDialog(
                title: 'Редактировать товар',
                categories: categories,
                initialProduct: product,
              ),
            );
          })();

      if (payload == null) {
        return;
      }

      setState(() {
        _submitting = true;
      });

      final result = await _productRepository.updateProduct(
        accessToken: widget.authController.session!.accessToken,
        fallbackProduct: product,
        productId: product.id,
        includeCategoryId: true,
        categoryId: payload.categoryId,
        name: payload.name,
        sku: payload.sku,
        barcode: payload.barcode,
        description: payload.description,
        unit: payload.unit,
        minStock: payload.minStock,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _productsFuture = _refreshProducts();
      });

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            result.queued
                ? 'Изменения по товару сохранены в очередь на отправку'
                : 'Товар обновлен',
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }
      if (allowRetry && await widget.authController.recoverSession(error)) {
        await _openEditDialog(
          product,
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
    await _productRepository.clearPendingUpdates();
    await _productRepository.clearPendingCreates();
    await _categoryRepository.clearPendingCreates();
    if (!mounted) {
      return;
    }

    setState(() {
      _syncMessage = null;
      _hasSyncConflict = false;
      _pendingUpdates = const [];
      _pendingCreates = const [];
      _pendingCategoryCreates = const [];
      _productsFuture = _refreshProducts();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отложенные изменения по товарам очищены')),
    );
  }

  Future<void> _retryPendingUpdate(String productId) async {
    final message = await _productRepository.retryPendingUpdate(
      accessToken: widget.authController.session!.accessToken,
      productId: productId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _productsFuture = _refreshProducts();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message ?? 'Изменения по товару повторно отправлены',
        ),
      ),
    );
  }

  Future<void> _retryPendingCreate(String localId) async {
    final message = await _productRepository.retryPendingCreate(
      accessToken: widget.authController.session!.accessToken,
      localId: localId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _productsFuture = _refreshProducts();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message ?? 'Создание товара повторно отправлено',
        ),
      ),
    );
  }

  Future<void> _discardPendingUpdate(String productId) async {
    await _productRepository.discardPendingUpdate(productId);
    if (!mounted) {
      return;
    }

    setState(() {
      _productsFuture = _refreshProducts();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отложенное изменение по товару удалено')),
    );
  }

  Future<void> _discardPendingCreate(String localId) async {
    await _productRepository.discardPendingCreate(localId);
    if (!mounted) {
      return;
    }

    setState(() {
      _productsFuture = _refreshProducts();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отложенное создание товара удалено')),
    );
  }

  Future<void> _retryPendingCategoryCreate(String localId) async {
    final message = await _categoryRepository.retryPendingCreate(
      accessToken: widget.authController.session!.accessToken,
      localId: localId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _productsFuture = _refreshProducts();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Создание категории повторно отправлено')),
    );
  }

  Future<void> _discardPendingCategoryCreate(String localId) async {
    await _categoryRepository.discardPendingCreate(localId);
    if (!mounted) {
      return;
    }

    setState(() {
      _productsFuture = _refreshProducts();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отложенное создание категории удалено')),
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
                child: Text('Товары', style: theme.textTheme.headlineMedium),
              ),
              if (_pendingOperationCount > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    avatar: const Icon(Icons.cloud_upload_outlined, size: 18),
                    label: Text('Очередь: $_pendingOperationCount'),
                  ),
                ),
              if (_canManage)
                IconButton(
                  onPressed: _submitting ? null : _openCreateCategoryDialog,
                  icon: const Icon(Icons.create_new_folder_outlined),
                  tooltip: 'Создать категорию',
                ),
              if (_canManage)
                IconButton(
                  onPressed: _submitting ? null : _openCreateDialog,
                  icon: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_box_outlined),
                  tooltip: 'Создать товар',
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск по названию, SKU или штрихкоду',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _productsFuture = _refreshProducts();
                  });
                },
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
            ),
            onSubmitted: (_) {
              setState(() {
                _productsFuture = _refreshProducts();
              });
            },
          ),
          const SizedBox(height: 16),
          if (_pendingCategoryCreates.isNotEmpty ||
              _pendingCreates.isNotEmpty ||
              _pendingUpdates.isNotEmpty ||
              _syncMessage != null) ...[
            ProductPendingOperationsCard(
              categoryCreates: _pendingCategoryCreates
                  .map(
                    (item) => PendingOperationAction(
                      id: item.localId,
                      label:
                          'Категория: ${item.name} · ${_formatPendingDate(item.createdAt)}',
                      onRetry: () => _retryPendingCategoryCreate(item.localId),
                      onDiscard: () => _discardPendingCategoryCreate(item.localId),
                    ),
                  )
                  .toList(growable: false),
              productCreates: _pendingCreates
                  .map(
                    (item) => PendingOperationAction(
                      id: item.localId,
                      label:
                          'Создание: ${item.name} · ${_formatPendingDate(item.createdAt)}',
                      onRetry: () => _retryPendingCreate(item.localId),
                      onDiscard: () => _discardPendingCreate(item.localId),
                    ),
                  )
                  .toList(growable: false),
              productUpdates: _pendingUpdates
                  .map(
                    (item) => PendingOperationAction(
                      id: item.productId,
                      label: '${item.name} · ${_formatPendingDate(item.createdAt)}',
                      onRetry: () => _retryPendingUpdate(item.productId),
                      onDiscard: () => _discardPendingUpdate(item.productId),
                    ),
                  )
                  .toList(growable: false),
              syncMessage: _syncMessage,
              hasConflict: _hasSyncConflict,
              onSyncAll: _hasSyncConflict
                  ? null
                  : () {
                      setState(() {
                        _productsFuture = _refreshProducts();
                      });
                    },
              onClearAll: _hasSyncConflict ? null : _clearPendingQueue,
              onClearConflict: _hasSyncConflict ? _clearPendingQueue : null,
            ),
            const SizedBox(height: 12),
          ],
          Expanded(
            child: FutureBuilder<List<MobileProduct>>(
              future: _productsFuture,
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
                          _productsFuture = _refreshProducts();
                        });
                      }
                    });
                  }
                  final message = snapshot.error is ApiException
                      ? (snapshot.error as ApiException).message
                      : 'Не удалось загрузить товары';
                  return ErrorStateCard(
                    message: message,
                    onRetry: () {
                      setState(() {
                        _productsFuture = _refreshProducts();
                      });
                    },
                  );
                }

                final items = snapshot.data ?? const [];
                final lowStockCount = items.where((item) => item.isLowStock).length;
                final uncategorizedCount =
                    items.where((item) => item.categoryName == null).length;
                final pendingCreateCount = items.where((item) => item.isPendingCreate).length;
                final filteredItems = _applyFilter(items);
                if (items.isEmpty) {
                  return EmptyStateCard(
                    title: 'Каталог пока пуст',
                    subtitle: _canManage
                        ? 'Создай первую категорию или товар, чтобы склад начал наполняться.'
                        : 'Владелец или менеджер еще не добавили товары. Обнови экран позже.',
                    actionLabel: _canManage ? 'Создать товар' : null,
                    onAction: _canManage ? _openCreateDialog : null,
                  );
                }
                if (filteredItems.isEmpty) {
                  return ListView(
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(label: Text('Товаров: ${items.length}')),
                          Chip(label: Text('Низкий остаток: $lowStockCount')),
                          Chip(label: Text('Без категории: $uncategorizedCount')),
                          Chip(label: Text('Офлайн-черновики: $pendingCreateCount')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _ProductFilterChips(
                        activeFilter: _activeFilter,
                        lowStockCount: lowStockCount,
                        uncategorizedCount: uncategorizedCount,
                        pendingCreateCount: pendingCreateCount,
                        onSelected: (filter) {
                          setState(() {
                            _activeFilter = filter;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      EmptyStateCard(
                        title: 'По выбранному фильтру товаров нет',
                        subtitle:
                            'Сбрось фильтр или обнови каталог, чтобы увидеть остальные позиции.',
                        actionLabel: 'Сбросить фильтр',
                        onAction: () {
                          setState(() {
                            _activeFilter = _ProductViewFilter.all;
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
                              Chip(label: Text('Товаров: ${items.length}')),
                              Chip(label: Text('Низкий остаток: $lowStockCount')),
                              Chip(label: Text('Без категории: $uncategorizedCount')),
                              Chip(label: Text('Офлайн-черновики: $pendingCreateCount')),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _ProductFilterChips(
                            activeFilter: _activeFilter,
                            lowStockCount: lowStockCount,
                            uncategorizedCount: uncategorizedCount,
                            pendingCreateCount: pendingCreateCount,
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
                    return ProductStockCard(
                      name: item.name,
                      subtitle: [
                        if (item.sku != null && item.sku!.isNotEmpty) 'SKU ${item.sku}',
                        if (item.barcode != null && item.barcode!.isNotEmpty)
                          'EAN ${item.barcode}',
                        if (item.categoryName != null) item.categoryName!,
                      ].join(' · '),
                      stockLabel: '${item.currentStock} ${item.unit}',
                      canEdit: _canManage,
                      isLowStock: item.isLowStock,
                      isPendingCreate: item.isPendingCreate,
                      onTap:
                          _canManage && !item.isPendingCreate ? () => _openEditDialog(item) : null,
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

  String _formatPendingDate(DateTime value) {
    String two(int number) => number.toString().padLeft(2, '0');
    return '${two(value.day)}.${two(value.month)} ${two(value.hour)}:${two(value.minute)}';
  }

  String? _mergeMessages(String? first, String? second) {
    if (first == null || first.isEmpty) {
      return second;
    }
    if (second == null || second.isEmpty) {
      return first;
    }
    return '$first\n$second';
  }

  List<MobileProduct> _applyFilter(List<MobileProduct> items) {
    switch (_activeFilter) {
      case _ProductViewFilter.all:
        return items;
      case _ProductViewFilter.lowStock:
        return items.where((item) => item.isLowStock).toList(growable: false);
      case _ProductViewFilter.uncategorized:
        return items.where((item) => item.categoryName == null).toList(growable: false);
      case _ProductViewFilter.pendingCreate:
        return items.where((item) => item.isPendingCreate).toList(growable: false);
    }
  }
}

enum _ProductViewFilter { all, lowStock, uncategorized, pendingCreate }

class _ProductFilterChips extends StatelessWidget {
  const _ProductFilterChips({
    required this.activeFilter,
    required this.lowStockCount,
    required this.uncategorizedCount,
    required this.pendingCreateCount,
    required this.onSelected,
  });

  final _ProductViewFilter activeFilter;
  final int lowStockCount;
  final int uncategorizedCount;
  final int pendingCreateCount;
  final ValueChanged<_ProductViewFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Все'),
          selected: activeFilter == _ProductViewFilter.all,
          onSelected: (_) => onSelected(_ProductViewFilter.all),
        ),
        ChoiceChip(
          label: Text('Низкий остаток ($lowStockCount)'),
          selected: activeFilter == _ProductViewFilter.lowStock,
          onSelected: (_) => onSelected(_ProductViewFilter.lowStock),
        ),
        ChoiceChip(
          label: Text('Без категории ($uncategorizedCount)'),
          selected: activeFilter == _ProductViewFilter.uncategorized,
          onSelected: (_) => onSelected(_ProductViewFilter.uncategorized),
        ),
        ChoiceChip(
          label: Text('Офлайн-черновики ($pendingCreateCount)'),
          selected: activeFilter == _ProductViewFilter.pendingCreate,
          onSelected: (_) => onSelected(_ProductViewFilter.pendingCreate),
        ),
      ],
    );
  }
}

class ProductFormPayload {
  const ProductFormPayload({
    required this.name,
    required this.unit,
    required this.categoryId,
    required this.sku,
    required this.barcode,
    required this.description,
    required this.minStock,
    required this.currentStock,
  });

  final String name;
  final String unit;
  final String? categoryId;
  final String? sku;
  final String? barcode;
  final String? description;
  final double? minStock;
  final double? currentStock;
}

class _ProductDialog extends StatefulWidget {
  const _ProductDialog({
    required this.title,
    required this.categories,
    this.initialProduct,
  });

  final String title;
  final List<MobileCategory> categories;
  final MobileProduct? initialProduct;

  @override
  State<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<_ProductDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _unitController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _minStockController;
  late final TextEditingController _currentStockController;
  String? _selectedCategoryId;

  bool get _isEdit => widget.initialProduct != null;

  @override
  void initState() {
    super.initState();
    final product = widget.initialProduct;
    _nameController = TextEditingController(text: product?.name ?? '');
    _skuController = TextEditingController(text: product?.sku ?? '');
    _barcodeController = TextEditingController(text: product?.barcode ?? '');
    _unitController = TextEditingController(text: product?.unit ?? '');
    _descriptionController = TextEditingController(text: product?.description ?? '');
    _minStockController = TextEditingController(text: product?.minStock ?? '');
    _currentStockController = TextEditingController(text: product?.currentStock ?? '');
    _selectedCategoryId = product?.categoryId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _unitController.dispose();
    _descriptionController.dispose();
    _minStockController.dispose();
    _currentStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isEdit
                  ? 'Обнови карточку товара и сохрани изменения в каталоге.'
                  : 'Заполни ключевые поля, чтобы товар появился в рабочем каталоге.',
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              initialValue: _selectedCategoryId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Категория',
                helperText: 'Можно оставить пустой, если товар пока без категории',
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Без категории'),
                ),
                ...widget.categories.map(
                  (category) => DropdownMenuItem<String?>(
                    value: category.id,
                    child: Text(category.name),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Название',
                helperText: 'Понятное имя, по которому товар будут искать на складе',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _unitController,
              decoration: const InputDecoration(
                labelText: 'Единица',
                helperText: 'Например: шт, кг, л, уп',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _skuController,
              decoration: const InputDecoration(
                labelText: 'SKU',
                helperText: 'Внутренний код товара, если он уже используется',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _barcodeController,
              decoration: const InputDecoration(
                labelText: 'Штрихкод',
                helperText: 'EAN или другой код для быстрого поиска',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _minStockController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Минимальный остаток',
                helperText: 'Когда остаток опустится ниже, товар попадет в low stock',
              ),
            ),
            if (!_isEdit) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _currentStockController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Стартовый остаток',
                  helperText: 'Можно оставить пустым и добавить остаток позже через движение',
                ),
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Описание',
                helperText: 'Короткая заметка для команды: объем, бренд или особенности',
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
            final name = _nameController.text.trim();
            final unit = _unitController.text.trim();
            final minStock = _parseOptionalDouble(_minStockController.text);
            final currentStock = _parseOptionalDouble(_currentStockController.text);

            if (name.isEmpty || unit.isEmpty) {
              return;
            }

            Navigator.of(context).pop(
              ProductFormPayload(
                name: name,
                unit: unit,
                categoryId: _selectedCategoryId,
                sku: _nullIfEmpty(_skuController.text),
                barcode: _nullIfEmpty(_barcodeController.text),
                description: _nullIfEmpty(_descriptionController.text),
                minStock: minStock,
                currentStock: _isEdit ? null : currentStock,
              ),
            );
          },
          child: Text(_isEdit ? 'Сохранить товар' : 'Создать товар'),
        ),
      ],
    );
  }

  double? _parseOptionalDouble(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return double.tryParse(trimmed);
  }

  String? _nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
