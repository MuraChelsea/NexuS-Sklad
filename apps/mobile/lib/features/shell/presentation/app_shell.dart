import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/widgets/info_cards.dart';
import '../../auth/application/auth_controller.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../inventory/presentation/inventory_screen.dart';
import '../../movements/presentation/movements_screen.dart';
import '../../products/presentation/products_screen.dart';
import '../../team/presentation/team_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.config,
    required this.authController,
  });

  final AppConfig config;
  final AuthController authController;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  String? _lastSnackNotice;
  int _movementActionRequestId = 0;
  MovementDialogAction? _movementRequestedAction;
  int _inventoryStartRequestId = 0;

  void _openTab(int index, {String? notice}) {
    setState(() {
      _currentIndex = index;
    });

    if (notice == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(notice)),
      );
    });
  }

  void _openMovementAction(
    MovementDialogAction action, {
    required String notice,
  }) {
    setState(() {
      _currentIndex = 3;
      _movementRequestedAction = action;
      _movementActionRequestId += 1;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(notice)),
      );
    });
  }

  void _openInventoryStart({required String notice}) {
    setState(() {
      _currentIndex = 2;
      _inventoryStartRequestId += 1;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(notice)),
      );
    });
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    final notice = widget.authController.noticeMessage;
    if (notice == null || notice == _lastSnackNotice) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _lastSnackNotice = notice;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(notice)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(
        config: widget.config,
        authController: widget.authController,
        onOpenIncome: () => _openMovementAction(
          MovementDialogAction.income,
          notice: 'Открыл приход. Выбери товар и зафиксируй поставку.',
        ),
        onOpenExpense: () => _openMovementAction(
          MovementDialogAction.expense,
          notice: 'Открыл расход. Выбери товар и укажи количество.',
        ),
        onOpenProducts: () => _openTab(
          1,
          notice: 'Открыл каталог. Проверь карточки товаров и низкий остаток.',
        ),
        onOpenInventory: () => _openInventoryStart(
          notice: 'Открыл инвентаризацию и подготовил запуск новой сессии.',
        ),
        onOpenTeam: () => _openTab(
          4,
          notice: 'Открыл команду. Здесь доступны компания, сотрудники и роли.',
        ),
      ),
      ProductsScreen(
        config: widget.config,
        authController: widget.authController,
      ),
      InventoryScreen(
        config: widget.config,
        authController: widget.authController,
        startRequestId: _inventoryStartRequestId,
      ),
      MovementsScreen(
        config: widget.config,
        authController: widget.authController,
        requestedAction: _movementRequestedAction,
        actionRequestId: _movementActionRequestId,
      ),
      TeamScreen(
        config: widget.config,
        authController: widget.authController,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (widget.authController.noticeMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: AuthNoticeCard(
                  message: widget.authController.noticeMessage!,
                  onDismiss: () {
                    widget.authController.clearNotice();
                    setState(() {
                      _lastSnackNotice = null;
                    });
                  },
                ),
              ),
            Expanded(child: pages[_currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Обзор',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Товары',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_outlined),
            selectedIcon: Icon(Icons.fact_check_rounded),
            label: 'Инвент.',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz_rounded),
            label: 'Движения',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group_rounded),
            label: 'Команда',
          ),
        ],
      ),
    );
  }
}
