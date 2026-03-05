import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nexussklad_mobile/core/config/app_config.dart';
import 'package:nexussklad_mobile/core/network/api_client.dart';
import 'package:nexussklad_mobile/core/network/api_exception.dart';
import 'package:nexussklad_mobile/core/widgets/info_cards.dart';
import 'package:nexussklad_mobile/features/auth/application/auth_controller.dart';
import 'package:nexussklad_mobile/features/auth/data/auth_gateway.dart';
import 'package:nexussklad_mobile/features/auth/data/auth_session.dart';
import 'package:nexussklad_mobile/features/inventory/data/inventory_repository.dart';
import 'package:nexussklad_mobile/features/inventory/presentation/inventory_screen.dart';
import 'package:nexussklad_mobile/features/movements/data/movement_queue_store.dart';
import 'package:nexussklad_mobile/features/movements/data/movement_repository.dart';
import 'package:nexussklad_mobile/features/movements/presentation/movements_screen.dart';
import 'package:nexussklad_mobile/features/products/data/category_repository.dart';
import 'package:nexussklad_mobile/features/products/data/product_repository.dart';
import 'package:nexussklad_mobile/features/products/presentation/products_screen.dart';
import 'package:nexussklad_mobile/features/team/data/company_repository.dart';
import 'package:nexussklad_mobile/features/team/data/user_repository.dart';
import 'package:nexussklad_mobile/features/team/presentation/team_screen.dart';
import 'package:nexussklad_mobile/features/dashboard/data/dashboard_repository.dart';
import 'package:nexussklad_mobile/features/dashboard/presentation/dashboard_screen.dart';

void main() {
  testWidgets(
    'ProductsScreen shows create category dialog copy',
    (tester) async {
      final authController = AuthController.seeded(
        _FakeAuthGateway(),
        session: _demoSession(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              productRepository: _FakeProductRepository(),
              categoryRepository: _FakeCategoryRepository(),
            ),
          ),
        ),
      );
      for (var index = 0; index < 8; index += 1) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      await tester.tap(find.byTooltip('Создать категорию'));
      for (var index = 0; index < 8; index += 1) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      expect(find.text('Создать категорию'), findsNWidgets(2));
      expect(find.text('Например: Напитки, Бакалея или Хозтовары'), findsOneWidget);
    },
  );

  testWidgets(
    'ProductsScreen shows create product dialog copy',
    (tester) async {
      final authController = AuthController.seeded(
        _FakeAuthGateway(),
        session: _demoSession(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              productRepository: _FakeProductRepository(),
              categoryRepository: _FakeCategoryRepository(
                categories: const <MobileCategory>[
                  MobileCategory(id: 'category-1', name: 'Напитки'),
                ],
              ),
            ),
          ),
        ),
      );
      for (var index = 0; index < 8; index += 1) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      await tester.tap(find.byTooltip('Создать товар'));
      await tester.pumpAndSettle();

      expect(find.text('Заполни ключевые поля, чтобы товар появился в рабочем каталоге.'), findsOneWidget);
      expect(find.text('Например: шт, кг, л, уп'), findsOneWidget);
      expect(find.text('Создать товар'), findsWidgets);
    },
  );

  testWidgets(
    'MovementsScreen shows movement dialog copy',
    (tester) async {
      final authController = AuthController.seeded(
        _FakeAuthGateway(),
        session: _demoSession(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovementsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              movementRepository: _FakeMovementRepository(),
              productRepository: _FakeProductRepository(
                products: const <MobileProduct>[
                  MobileProduct(
                    id: 'product-1',
                    categoryId: 'category-1',
                    name: 'Cola Zero',
                    sku: 'SKU-001',
                    barcode: '4600000000000',
                    unit: 'шт',
                    currentStock: '2',
                    minStock: '3',
                    description: null,
                    categoryName: 'Напитки',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Приход'));
      await tester.pumpAndSettle();

      expect(find.text('Выбери товар и зафиксируй изменение остатков.'), findsOneWidget);
      expect(find.text('Выбери позицию, по которой меняется остаток'), findsOneWidget);
      expect(find.text('Укажи количество товара для операции'), findsOneWidget);
      expect(find.text('Провести приход'), findsOneWidget);
    },
  );

  testWidgets(
    'MovementsScreen filters movement types',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final authController = AuthController.seeded(
        _FakeAuthGateway(),
        session: _demoSession(
          accessToken: 'seed-access',
          refreshToken: 'seed-refresh',
          user: _demoUser(),
        ),
      );
      final movementRepository = _FakeMovementRepository(
        movements: [
          MobileMovement(
            id: 'm-1',
            type: 'INCOME',
            quantity: '12',
            productName: 'Сахар',
            actorName: 'Owner',
            createdAt: DateTime(2026, 3, 4, 10, 0),
          ),
          MobileMovement(
            id: 'm-2',
            type: 'EXPENSE',
            quantity: '3',
            productName: 'Соль',
            actorName: 'Owner',
            createdAt: DateTime(2026, 3, 4, 10, 10),
          ),
          MobileMovement(
            id: 'm-3',
            type: 'INVENTORY_DIFF',
            quantity: '1',
            productName: 'Мука',
            actorName: 'Owner',
            createdAt: DateTime(2026, 3, 4, 10, 20),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovementsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              movementRepository: movementRepository,
              productRepository: _FakeProductRepository(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Сахар'), findsOneWidget);
      expect(find.textContaining('Соль'), findsOneWidget);
      expect(find.textContaining('Мука'), findsOneWidget);

      await tester.tap(find.text('Приход (1)'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Сахар'), findsOneWidget);
      expect(find.textContaining('Соль'), findsNothing);
      expect(find.textContaining('Мука'), findsNothing);

      await tester.tap(find.text('Сверка (1)'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Мука'), findsOneWidget);
      expect(find.textContaining('Сахар'), findsNothing);
      expect(find.textContaining('Соль'), findsNothing);

      await tester.tap(find.text('Все'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Сахар'), findsOneWidget);
      expect(find.textContaining('Соль'), findsOneWidget);
      expect(find.textContaining('Мука'), findsOneWidget);
    },
  );

  testWidgets(
    'MovementsScreen shows pending queue action card',
    (tester) async {
      final authController = AuthController.seeded(
        _FakeAuthGateway(),
        session: _demoSession(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovementsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              movementRepository: _FakeMovementRepository(
                pendingCount: 2,
                movements: <MobileMovement>[
                  MobileMovement(
                    id: 'm-1',
                    type: 'INCOME',
                    quantity: '12',
                    productName: 'Сахар',
                    actorName: 'Owner',
                    createdAt: DateTime(2026, 3, 4, 10, 0),
                  ),
                ],
              ),
              productRepository: _FakeProductRepository(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Есть движения в очереди'), findsOneWidget);
      expect(
        find.text('Часть операций сохранена локально и будет отправлена при следующей синхронизации.'),
        findsOneWidget,
      );
      expect(find.text('Отправить сейчас'), findsOneWidget);
      expect(find.text('Очистить очередь'), findsOneWidget);
    },
  );

  testWidgets(
    'InventoryScreen shows actual quantity dialog copy',
    (tester) async {
      final authController = AuthController.seeded(
        _FakeAuthGateway(),
        session: _demoSession(),
      );
      final repository = _FakeInventoryRepository(
        session: const MobileInventorySession(
          id: 'inventory-1',
          status: 'DRAFT',
          comment: null,
          items: <MobileInventoryItem>[
            MobileInventoryItem(
              id: 'item-1',
              productId: 'product-1',
              productName: 'Cola Zero',
              unit: 'шт',
              expectedQty: '5',
              actualQty: '5',
              difference: '0',
            ),
          ],
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              repository: repository,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Открыть сессию'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Изменить').first);
      await tester.pumpAndSettle();

      expect(find.text('Фактический остаток · Cola Zero'), findsOneWidget);
      expect(find.text('Ожидалось: 5 шт'), findsOneWidget);
      expect(find.text('Введи реальное количество, которое видишь на складе'), findsOneWidget);
      expect(find.text('Зафиксировать'), findsOneWidget);
    },
  );

  testWidgets(
    'InventoryScreen filters differences and matched items',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final authController = AuthController.seeded(
        _FakeAuthGateway(),
        session: _demoSession(
          accessToken: 'seed-access',
          refreshToken: 'seed-refresh',
          user: _demoUser(),
        ),
      );
      final repository = _FakeInventoryRepository(
        session: const MobileInventorySession(
          id: 'inventory-1',
          status: 'DRAFT',
          comment: null,
          items: [
            MobileInventoryItem(
              id: 'item-1',
              productId: 'product-1',
              productName: 'Мука',
              unit: 'шт',
              expectedQty: '10',
              actualQty: '8',
              difference: '-2',
            ),
            MobileInventoryItem(
              id: 'item-2',
              productId: 'product-2',
              productName: 'Сахар',
              unit: 'шт',
              expectedQty: '5',
              actualQty: '5',
              difference: '0',
            ),
          ],
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              repository: repository,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Открыть сессию'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Мука'), findsOneWidget);
      expect(find.textContaining('Сахар'), findsOneWidget);

      await tester.tap(find.text('Расхождения (1)'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Мука'), findsOneWidget);
      expect(find.textContaining('Сахар'), findsNothing);

      await tester.tap(find.text('Совпадает (1)'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Сахар'), findsOneWidget);
      expect(find.textContaining('Мука'), findsNothing);

      await tester.tap(find.text('Все'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Мука'), findsOneWidget);
      expect(find.textContaining('Сахар'), findsOneWidget);
    },
  );

  testWidgets(
    'InventoryScreen shows pending queue action card',
    (tester) async {
      final authController = AuthController.seeded(
        _FakeAuthGateway(),
        session: _demoSession(),
      );
      final repository = _FakeInventoryRepository(
        pendingCount: 2,
        session: const MobileInventorySession(
          id: 'inventory-1',
          status: 'DRAFT',
          comment: null,
          items: <MobileInventoryItem>[
            MobileInventoryItem(
              id: 'item-1',
              productId: 'product-1',
              productName: 'Cola Zero',
              unit: 'шт',
              expectedQty: '5',
              actualQty: '5',
              difference: '0',
            ),
          ],
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              repository: repository,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Открыть сессию'));
      await tester.pumpAndSettle();

      expect(find.text('Есть позиции в очереди'), findsOneWidget);
      expect(
        find.text(
          'Часть изменений по инвентаризации сохранена локально и ждет синхронизации с сервером.',
        ),
        findsOneWidget,
      );
      expect(find.text('Отправить сейчас'), findsOneWidget);
      expect(find.text('Очистить очередь'), findsOneWidget);
    },
  );

  testWidgets(
    'TeamScreen shows invite dialog copy',
    (tester) async {
      final authController = AuthController.seeded(
        _FakeAuthGateway(),
        session: _demoSession(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TeamScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              companyRepository: _FakeCompanyRepository(
                company: MobileCompany(
                  id: 'company-1',
                  name: 'NexusSklad Demo Company',
                  city: 'Derbent',
                  phone: '+7 900 000 00 00',
                  createdAt: DateTime(2026, 3, 3, 10, 0),
                ),
              ),
              userRepository: _FakeUserRepository(),
            ),
          ),
        ),
      );
      for (var index = 0; index < 8; index += 1) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      await tester.tap(find.byTooltip('Пригласить'));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Создай приглашение для нового сотрудника. Токен можно будет передать вручную.'), findsOneWidget);
      expect(find.text('На этот адрес будет создано приглашение'), findsOneWidget);
      expect(
        find.text('Менеджер управляет операциями, сотрудник работает по складу'),
        findsOneWidget,
      );
      expect(find.widgetWithText(FilledButton, 'Создать приглашение'), findsOneWidget);
    },
  );

  testWidgets(
    'DashboardScreen quick actions open target workflows',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final authController = AuthController.seeded(
        _FakeAuthGateway(),
        session: _demoSession(),
      );

      var openedIncome = false;
      var openedExpense = false;
      var openedProducts = false;
      var openedInventory = false;
      var openedTeam = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              repository: _StaticDashboardRepository(
                const DashboardSummary(
                  date: '2026-03-03',
                  lowStockCount: 2,
                  totalMovementCount: 5,
                  inventorySessionsCount: 1,
                  incomeCount: 2,
                  expenseCount: 2,
                  adjustmentCount: 1,
                  inventoryDiffCount: 0,
                ),
              ),
              onOpenIncome: () {
                openedIncome = true;
              },
              onOpenExpense: () {
                openedExpense = true;
              },
              onOpenProducts: () {
                openedProducts = true;
              },
              onOpenInventory: () {
                openedInventory = true;
              },
              onOpenTeam: () {
                openedTeam = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Быстрые действия'), findsOneWidget);

      final scrollable = find.byType(Scrollable);

      await tester.scrollUntilVisible(find.text('Приход товара'), 120, scrollable: scrollable);
      await tester.tap(
        find.ancestor(
          of: find.text('Приход товара'),
          matching: find.byType(InkWell),
        ),
      );
      await tester.pump();
      expect(openedIncome, isTrue);

      await tester.scrollUntilVisible(find.text('Расход товара'), 120, scrollable: scrollable);
      await tester.tap(
        find.ancestor(
          of: find.text('Расход товара'),
          matching: find.byType(InkWell),
        ),
      );
      await tester.pump();
      expect(openedExpense, isTrue);

      await tester.scrollUntilVisible(find.text('Инвентаризация'), 120, scrollable: scrollable);
      await tester.tap(
        find.ancestor(
          of: find.text('Инвентаризация'),
          matching: find.byType(InkWell),
        ),
      );
      await tester.pump();
      expect(openedInventory, isTrue);

      await tester.scrollUntilVisible(find.text('Каталог и остатки'), 120, scrollable: scrollable);
      await tester.tap(
        find.ancestor(
          of: find.text('Каталог и остатки'),
          matching: find.byType(InkWell),
        ),
      );
      await tester.pump();
      expect(openedProducts, isTrue);

      await tester.scrollUntilVisible(find.text('Команда и доступ'), 120, scrollable: scrollable);
      await tester.tap(
        find.ancestor(
          of: find.text('Команда и доступ'),
          matching: find.byType(InkWell),
        ),
      );
      await tester.pump();
      expect(openedTeam, isTrue);
    },
  );

  testWidgets(
    'DashboardScreen refreshes session after 401 and reloads summary',
    (tester) async {
      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
        meResult: _demoUser(name: 'Recovered Owner'),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final repository = _FakeDashboardRepository(
        firstError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
        success: const DashboardSummary(
          date: '2026-03-03',
          lowStockCount: 2,
          totalMovementCount: 5,
          inventorySessionsCount: 1,
          incomeCount: 2,
          expenseCount: 2,
          adjustmentCount: 1,
          inventoryDiffCount: 0,
        ),
      );

      await tester.pumpWidget(
        _wrap(
          authController: authController,
          repository: repository,
        ),
      );
      for (var index = 0; index < 10; index += 1) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      expect(repository.fetchCalls, 2);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.currentUser?.name, 'Recovered Owner');
      expect(authGateway.persistedSessions, hasLength(1));

      expect(find.text('Сессия восстановлена. Продолжаем работу.'), findsOneWidget);
      expect(find.text('Низкий остаток'), findsOneWidget);
      expect(find.text('02'), findsOneWidget);
      expect(find.text('Позиции под контролем на 2026-03-03'), findsOneWidget);
      expect(find.text('Ошибка загрузки'), findsNothing);
    },
  );

  testWidgets(
    'ProductsScreen filters low stock and offline drafts',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final authController = AuthController.seeded(
        _FakeAuthGateway(),
        session: _demoSession(
          accessToken: 'seed-access',
          refreshToken: 'seed-refresh',
          user: const MobileUser(
            id: 'owner-1',
            companyId: 'company-1',
            companyName: 'NexusSklad Demo',
            email: 'owner@nexussklad.local',
            phone: '+7 900 000-00-00',
            name: 'Owner',
            role: 'OWNER',
          ),
        ),
      );

      final productRepository = _FakeProductRepository(
        products: [
          const MobileProduct(
            id: 'product-low',
            categoryId: 'cat-1',
            name: 'Мука',
            sku: 'FLOUR-1',
            barcode: null,
            unit: 'шт',
            currentStock: '2',
            minStock: '5',
            description: null,
            categoryName: 'Бакалея',
          ),
          const MobileProduct(
            id: 'product-plain',
            categoryId: null,
            name: 'Соль',
            sku: 'SALT-1',
            barcode: null,
            unit: 'шт',
            currentStock: '10',
            minStock: '2',
            description: null,
            categoryName: null,
          ),
          MobileProduct.pendingCreate(
            localId: 'local:new-1',
            categoryId: null,
            name: 'Новый офлайн товар',
            sku: null,
            barcode: null,
            unit: 'шт',
            currentStock: 5,
            minStock: 0,
            description: null,
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              productRepository: productRepository,
              categoryRepository: _FakeCategoryRepository(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Мука'), findsOneWidget);
      expect(find.text('Соль'), findsOneWidget);
      expect(find.text('Офлайн-черновики (1)'), findsOneWidget);

      await tester.tap(find.text('Низкий остаток (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Мука'), findsOneWidget);
      expect(find.text('Соль'), findsNothing);
      expect(find.text('Новый офлайн товар'), findsNothing);

      await tester.tap(find.text('Офлайн-черновики (1)'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Новый офлайн товар'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Новый офлайн товар'), findsOneWidget);
      expect(find.text('Мука'), findsNothing);
      expect(find.text('Соль'), findsNothing);

      await tester.tap(find.text('Все'));
      await tester.pumpAndSettle();

      expect(find.text('Мука'), findsOneWidget);
      expect(find.text('Соль'), findsOneWidget);
      expect(find.text('Новый офлайн товар'), findsOneWidget);
    },
  );

  testWidgets(
    'ProductsScreen refreshes session after 401 and reloads product list',
    (tester) async {
      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
        meResult: _demoUser(name: 'Recovered Owner'),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final productRepository = _FakeProductRepository(
        firstError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
        products: const <MobileProduct>[
          MobileProduct(
            id: 'product-1',
            categoryId: 'category-1',
            name: 'Cola Zero',
            sku: 'SKU-001',
            barcode: '4600000000000',
            unit: 'шт',
            currentStock: '2',
            minStock: '3',
            description: null,
            categoryName: 'Напитки',
          ),
        ],
      );
      final categoryRepository = _FakeCategoryRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              productRepository: productRepository,
              categoryRepository: categoryRepository,
            ),
          ),
        ),
      );
      for (var index = 0; index < 10; index += 1) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      expect(productRepository.fetchCalls, 2);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
      expect(find.text('Cola Zero'), findsOneWidget);
      expect(find.text('SKU SKU-001 · EAN 4600000000000 · Напитки'), findsOneWidget);
    },
  );

  testWidgets(
    'ProductsScreen refreshes session after 401 and retries create category',
    (tester) async {
      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
        meResult: _demoUser(name: 'Recovered Owner'),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final productRepository = _FakeProductRepository();
      final categoryRepository = _FakeCategoryRepository(
        firstCreateError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              productRepository: productRepository,
              categoryRepository: categoryRepository,
              createCategoryNameBuilder: () async => 'Напитки',
            ),
          ),
        ),
      );
      for (var index = 0; index < 10; index += 1) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      await tester.tap(find.byTooltip('Создать категорию'));
      await tester.pumpAndSettle();

      expect(categoryRepository.createCategoryCalls, 2);
      expect(categoryRepository.capturedNames, ['Напитки', 'Напитки']);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
      expect(find.text('Категория создана'), findsOneWidget);
    },
  );

  testWidgets(
    'ProductsScreen refreshes session after 401 and retries create product',
    (tester) async {
      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
        meResult: _demoUser(name: 'Recovered Owner'),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final productRepository = _FakeProductRepository(
        firstCreateError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
        products: const <MobileProduct>[
          MobileProduct(
            id: 'product-2',
            categoryId: 'category-1',
            name: 'Fanta',
            sku: 'SKU-002',
            barcode: '4600000000002',
            unit: 'шт',
            currentStock: '7',
            minStock: '2',
            description: 'Апельсин',
            categoryName: 'Напитки',
          ),
        ],
      );
      final categoryRepository = _FakeCategoryRepository(
        categories: const <MobileCategory>[
          MobileCategory(
            id: 'category-1',
            name: 'Напитки',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              productRepository: productRepository,
              categoryRepository: categoryRepository,
              createProductPayloadBuilder: (_) async => const ProductFormPayload(
                name: 'Fanta',
                unit: 'шт',
                categoryId: 'category-1',
                sku: 'SKU-002',
                barcode: '4600000000002',
                description: 'Апельсин',
                minStock: 2,
                currentStock: 7,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Создать товар'));
      await tester.pumpAndSettle();

      expect(productRepository.createProductCalls, 2);
      expect(productRepository.capturedCreateNames, ['Fanta', 'Fanta']);
      expect(productRepository.capturedCreateUnits, ['шт', 'шт']);
      expect(productRepository.capturedCreateCategoryIds, ['category-1', 'category-1']);
      expect(productRepository.capturedCreateSkus, ['SKU-002', 'SKU-002']);
      expect(productRepository.capturedCreateBarcodes, ['4600000000002', '4600000000002']);
      expect(productRepository.capturedCreateDescriptions, ['Апельсин', 'Апельсин']);
      expect(productRepository.capturedCreateMinStocks, [2.0, 2.0]);
      expect(productRepository.capturedCreateCurrentStocks, [7.0, 7.0]);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
      expect(find.text('Товар создан'), findsOneWidget);
    },
  );

  testWidgets(
    'ProductsScreen refreshes session after 401 and retries update product',
    (tester) async {
      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final productRepository = _FakeProductRepository(
        firstUpdateError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
        products: const <MobileProduct>[
          MobileProduct(
            id: 'product-1',
            categoryId: 'category-1',
            name: 'Cola Zero',
            sku: 'SKU-001',
            barcode: '4600000000000',
            unit: 'шт',
            currentStock: '5',
            minStock: '2',
            description: 'Classic item',
            categoryName: 'Напитки',
          ),
        ],
      );
      final categoryRepository = _FakeCategoryRepository(
        categories: const <MobileCategory>[
          MobileCategory(
            id: 'category-1',
            name: 'Напитки',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              productRepository: productRepository,
              categoryRepository: categoryRepository,
              editProductPayloadBuilder: (_, __) async => const ProductFormPayload(
                name: 'Cola Zero Updated',
                unit: 'кор',
                categoryId: 'category-1',
                sku: 'SKU-002',
                barcode: '4600000001111',
                description: 'Updated item',
                minStock: 4,
                currentStock: 5,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cola Zero'));
      await tester.pumpAndSettle();

      expect(productRepository.updateProductCalls, 2);
      expect(productRepository.capturedUpdateProductIds, ['product-1', 'product-1']);
      expect(productRepository.capturedUpdateNames, ['Cola Zero Updated', 'Cola Zero Updated']);
      expect(productRepository.capturedUpdateUnits, ['кор', 'кор']);
      expect(productRepository.capturedUpdateCategoryIds, ['category-1', 'category-1']);
      expect(productRepository.capturedUpdateSkus, ['SKU-002', 'SKU-002']);
      expect(productRepository.capturedUpdateBarcodes, ['4600000001111', '4600000001111']);
      expect(productRepository.capturedUpdateDescriptions, ['Updated item', 'Updated item']);
      expect(productRepository.capturedUpdateMinStocks, [4.0, 4.0]);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
    },
  );

  testWidgets(
    'MovementsScreen refreshes session after 401 and reloads movement list',
    (tester) async {
      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
        meResult: _demoUser(name: 'Recovered Owner'),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final movementRepository = _FakeMovementRepository(
        firstError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
        movements: <MobileMovement>[
          MobileMovement(
            id: 'movement-1',
            type: 'INCOME',
            quantity: '4',
            productName: 'Cola Zero',
            actorName: 'Recovered Owner',
            createdAt: DateTime(2026, 3, 3, 10, 15),
          ),
        ],
      );
      final productRepository = _FakeProductRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovementsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              movementRepository: movementRepository,
              productRepository: productRepository,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(movementRepository.fetchCalls, 2);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
      expect(find.text('Приход'), findsAtLeastNWidgets(1));
      expect(find.text('Cola Zero · Recovered Owner\n03.03 10:15'), findsOneWidget);
      expect(find.text('+4'), findsOneWidget);
    },
  );

  testWidgets(
    'MovementsScreen refreshes session after 401 and retries create income',
    (tester) async {
      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
        meResult: _demoUser(name: 'Recovered Owner'),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final movementRepository = _FakeMovementRepository(
        movements: <MobileMovement>[
          MobileMovement(
            id: 'movement-new',
            type: 'INCOME',
            quantity: '3',
            productName: 'Cola Zero',
            actorName: 'Recovered Owner',
            createdAt: DateTime(2026, 3, 3, 10, 20),
          ),
        ],
        firstIncomeError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
      );
      final productRepository = _FakeProductRepository(
        products: const <MobileProduct>[
          MobileProduct(
            id: 'product-1',
            categoryId: 'category-1',
            name: 'Cola Zero',
            sku: 'SKU-001',
            barcode: '4600000000000',
            unit: 'шт',
            currentStock: '5',
            minStock: '2',
            description: null,
            categoryName: 'Напитки',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovementsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              movementRepository: movementRepository,
              productRepository: productRepository,
              movementPayloadBuilder: (_, __) async => const MovementDialogPayload(
                productId: 'product-1',
                quantity: 3,
                comment: 'Поставка',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Приход').first);
      await tester.pumpAndSettle();

      expect(movementRepository.createIncomeCalls, 2);
      expect(movementRepository.capturedIncomeProductIds, ['product-1', 'product-1']);
      expect(movementRepository.capturedIncomeQuantities, [3.0, 3.0]);
      expect(movementRepository.capturedIncomeComments, ['Поставка', 'Поставка']);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
      expect(find.text('Cola Zero · Recovered Owner\n03.03 10:20'), findsOneWidget);
      expect(find.text('+3'), findsOneWidget);
    },
  );

  testWidgets(
    'MovementsScreen refreshes session after 401 and retries create expense',
    (tester) async {
      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final movementRepository = _FakeMovementRepository(
        movements: <MobileMovement>[
          MobileMovement(
            id: 'movement-expense',
            type: 'EXPENSE',
            quantity: '2',
            productName: 'Cola Zero',
            actorName: 'Recovered Owner',
            createdAt: DateTime(2026, 3, 3, 10, 23),
          ),
        ],
        firstExpenseError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
      );
      final productRepository = _FakeProductRepository(
        products: const <MobileProduct>[
          MobileProduct(
            id: 'product-1',
            categoryId: 'category-1',
            name: 'Cola Zero',
            sku: 'SKU-001',
            barcode: '4600000000000',
            unit: 'шт',
            currentStock: '5',
            minStock: '2',
            description: null,
            categoryName: 'Напитки',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovementsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              movementRepository: movementRepository,
              productRepository: productRepository,
              movementPayloadBuilder: (_, __) async => const MovementDialogPayload(
                productId: 'product-1',
                quantity: 2,
                comment: 'Shipment',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Расход').first);
      await tester.pumpAndSettle();

      expect(movementRepository.createExpenseCalls, 2);
      expect(movementRepository.capturedExpenseProductIds, ['product-1', 'product-1']);
      expect(movementRepository.capturedExpenseQuantities, [2.0, 2.0]);
      expect(movementRepository.capturedExpenseComments, ['Shipment', 'Shipment']);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
      expect(find.text('Cola Zero · Recovered Owner\n03.03 10:23'), findsOneWidget);
      expect(find.text('-2'), findsOneWidget);
    },
  );

  testWidgets(
    'MovementsScreen refreshes session after 401 and retries create adjustment',
    (tester) async {
      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final movementRepository = _FakeMovementRepository(
        movements: <MobileMovement>[
          MobileMovement(
            id: 'movement-adjustment',
            type: 'ADJUSTMENT',
            quantity: '12',
            productName: 'Cola Zero',
            actorName: 'Recovered Owner',
            createdAt: DateTime(2026, 3, 3, 10, 25),
          ),
        ],
        firstAdjustmentError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
      );
      final productRepository = _FakeProductRepository(
        products: const <MobileProduct>[
          MobileProduct(
            id: 'product-1',
            categoryId: 'category-1',
            name: 'Cola Zero',
            sku: 'SKU-001',
            barcode: '4600000000000',
            unit: 'шт',
            currentStock: '5',
            minStock: '2',
            description: null,
            categoryName: 'Напитки',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovementsScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              movementRepository: movementRepository,
              productRepository: productRepository,
              movementPayloadBuilder: (_, __) async => const MovementDialogPayload(
                productId: 'product-1',
                quantity: 12,
                comment: 'Set to counted stock',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Корректировка').first);
      await tester.pumpAndSettle();

      expect(movementRepository.createAdjustmentCalls, 2);
      expect(
        movementRepository.capturedAdjustmentProductIds,
        ['product-1', 'product-1'],
      );
      expect(movementRepository.capturedAdjustmentTargetQty, [12.0, 12.0]);
      expect(
        movementRepository.capturedAdjustmentComments,
        ['Set to counted stock', 'Set to counted stock'],
      );
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
      expect(find.text('Cola Zero · Recovered Owner\n03.03 10:25'), findsOneWidget);
      expect(find.text('+12'), findsOneWidget);
    },
  );

  testWidgets(
    'InventoryScreen refreshes session after 401 and retries start inventory',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
        meResult: _demoUser(name: 'Recovered Owner'),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final repository = _FakeInventoryRepository(
        firstStartError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
        session: const MobileInventorySession(
          id: 'inventory-1',
          status: 'COMPLETED',
          comment: null,
          items: <MobileInventoryItem>[
            MobileInventoryItem(
              id: 'item-1',
              productId: 'product-1',
              productName: 'Cola Zero',
              unit: 'шт',
              expectedQty: '5',
              actualQty: '5',
              difference: '0',
            ),
          ],
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              repository: repository,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Открыть сессию'), findsOneWidget);

      await tester.tap(find.text('Открыть сессию'));
      await tester.pumpAndSettle();

      expect(repository.startCalls, 2);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
      expect(find.text('Позиций: 1'), findsWidgets);
      expect(find.text('Cola Zero'), findsOneWidget);
      expect(find.text('Ожидалось: 5 шт\nФакт: 5 шт'), findsOneWidget);
    },
  );

  testWidgets(
    'InventoryScreen refreshes session after 401 and retries patch item',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
        meResult: _demoUser(name: 'Recovered Owner'),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final repository = _FakeInventoryRepository(
        session: const MobileInventorySession(
          id: 'inventory-1',
          status: 'DRAFT',
          comment: null,
          items: <MobileInventoryItem>[
            MobileInventoryItem(
              id: 'item-1',
              productId: 'product-1',
              productName: 'Cola Zero',
              unit: 'шт',
              expectedQty: '5',
              actualQty: '5',
              difference: '0',
            ),
          ],
        ),
        firstPatchError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              repository: repository,
              actualQtyBuilder: (_) async => 7,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Открыть сессию'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Изменить').first);
      await tester.pumpAndSettle();

      expect(repository.startCalls, 1);
      expect(repository.patchCalls, 2);
      expect(repository.capturedPatchInventoryIds, ['inventory-1', 'inventory-1']);
      expect(repository.capturedPatchItemIds, ['item-1', 'item-1']);
      expect(repository.capturedPatchActualQty, [7.0, 7.0]);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
      expect(find.text('Cola Zero'), findsOneWidget);
    },
  );

  testWidgets(
    'InventoryScreen refreshes session after 401 and retries finish inventory',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
        meResult: _demoUser(name: 'Recovered Owner'),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final repository = _FakeInventoryRepository(
        session: const MobileInventorySession(
          id: 'inventory-1',
          status: 'DRAFT',
          comment: null,
          items: <MobileInventoryItem>[
            MobileInventoryItem(
              id: 'item-1',
              productId: 'product-1',
              productName: 'Cola Zero',
              unit: 'шт',
              expectedQty: '5',
              actualQty: '5',
              difference: '0',
            ),
          ],
        ),
        firstFinishError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              repository: repository,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Открыть сессию'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Завершить'));
      await tester.pumpAndSettle();

      expect(repository.startCalls, 1);
      expect(repository.finishCalls, 2);
      expect(repository.capturedFinishInventoryIds, ['inventory-1', 'inventory-1']);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
      expect(find.text('Сессия завершена.'), findsOneWidget);
    },
  );

  testWidgets(
    'InventoryScreen refreshes session after 401 and retries sync queue',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
        meResult: _demoUser(name: 'Recovered Owner'),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final repository = _FakeInventoryRepository(
        session: const MobileInventorySession(
          id: 'inventory-1',
          status: 'DRAFT',
          comment: null,
          items: <MobileInventoryItem>[
            MobileInventoryItem(
              id: 'item-1',
              productId: 'product-1',
              productName: 'Cola Zero',
              unit: 'шт',
              expectedQty: '5',
              actualQty: '7',
              difference: '2',
            ),
          ],
        ),
        pendingCount: 1,
        firstSyncError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              repository: repository,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Открыть сессию'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Синхронизировать'));
      await tester.pumpAndSettle();

      expect(repository.startCalls, 1);
      expect(repository.flushCalls, 2);
      expect(repository.capturedFlushInventoryIds, ['inventory-1', 'inventory-1']);
      expect(repository.getByIdCalls, 1);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
      expect(find.text('Ожидалось: 5 шт\nФакт: 7 шт'), findsOneWidget);
    },
  );

  testWidgets(
    'TeamScreen refreshes session after 401 and reloads company data',
    (tester) async {
      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
        meResult: _demoUser(name: 'Recovered Owner'),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final companyRepository = _FakeCompanyRepository(
        firstError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
        company: MobileCompany(
          id: 'company-1',
          name: 'Recovered Company',
          city: 'Дербент',
          phone: '+7 900 000-00-00',
          createdAt: DateTime(2026, 3, 3, 10, 15),
        ),
      );
      final userRepository = _FakeUserRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TeamScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              companyRepository: companyRepository,
              userRepository: userRepository,
            ),
          ),
        ),
      );
      await tester.pump();
      for (var index = 0; index < 8; index += 1) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      expect(companyRepository.fetchCalls, 2);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
      expect(authController.currentUser?.companyName, 'Recovered Company');
      expect(
        find.text('Recovered Owner · Владелец · Recovered Company'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'TeamScreen refreshes session after 401 and retries invite user',
    (tester) async {
      final authGateway = _FakeAuthGateway(
        refreshResult: _demoSession(
          accessToken: 'next-access',
          refreshToken: 'next-refresh',
        ),
        meResult: _demoUser(name: 'Recovered Owner'),
      );
      final authController = AuthController.seeded(
        authGateway,
        session: _demoSession(),
      );
      final companyRepository = _FakeCompanyRepository(
        company: MobileCompany(
          id: 'company-1',
          name: 'Recovered Company',
          city: 'Дербент',
          phone: '+7 900 000-00-00',
          createdAt: DateTime(2026, 3, 3, 10, 15),
        ),
      );
      final userRepository = _FakeUserRepository(
        firstInviteError: const ApiException(
          'Сессия истекла. Войди снова.',
          statusCode: 401,
          code: 'AUTH_TOKEN_EXPIRED',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TeamScreen(
              config: const AppConfig(
                apiBaseUrl: 'http://localhost:4000',
                appName: 'NexusSklad',
              ),
              authController: authController,
              companyRepository: companyRepository,
              userRepository: userRepository,
              invitePayloadBuilder: () async => const InvitePayload(
                email: 'staff@nexussklad.local',
                role: 'STAFF',
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      for (var index = 0; index < 8; index += 1) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      await tester.tap(find.byTooltip('Пригласить'));
      await tester.pump(const Duration(milliseconds: 500));

      expect(userRepository.inviteCalls, 2);
      expect(userRepository.capturedInviteEmails, ['staff@nexussklad.local', 'staff@nexussklad.local']);
      expect(userRepository.capturedInviteRoles, ['STAFF', 'STAFF']);
      expect(authController.status, AuthStatus.signedIn);
      expect(authController.session?.accessToken, 'next-access');
      expect(authController.noticeMessage, 'Сессия восстановлена. Продолжаем работу.');
      expect(find.text('Приглашение готово'), findsOneWidget);
      expect(find.text('staff@nexussklad.local'), findsOneWidget);
    },
  );


}

Widget _wrap({
  required AuthController authController,
  required DashboardRepository repository,
}) {
  return MaterialApp(
    home: AnimatedBuilder(
      animation: authController,
      builder: (context, _) {
        return Scaffold(
          body: Column(
            children: [
              if (authController.noticeMessage != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: AuthNoticeCard(
                    message: authController.noticeMessage!,
                  ),
                ),
              Expanded(
                child: DashboardScreen(
                  config: const AppConfig(
                    apiBaseUrl: 'http://localhost:4000',
                    appName: 'NexusSklad',
                  ),
                  authController: authController,
                  repository: repository,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class _FakeDashboardRepository extends DashboardRepository {
  _FakeDashboardRepository({
    required this.firstError,
    required this.success,
  }) : super(ApiClient(baseUrl: 'http://localhost:4000'));

  final ApiException firstError;
  final DashboardSummary success;

  int fetchCalls = 0;

  @override
  Future<DashboardSummary> fetchDaily({
    required String accessToken,
  }) async {
    fetchCalls += 1;
    if (fetchCalls == 1) {
      throw firstError;
    }
    return success;
  }
}

class _StaticDashboardRepository extends DashboardRepository {
  _StaticDashboardRepository(this.summary)
      : super(ApiClient(baseUrl: 'http://localhost:4000'));

  final DashboardSummary summary;

  @override
  Future<DashboardSummary> fetchDaily({
    required String accessToken,
  }) async {
    return summary;
  }
}

class _FakeProductRepository extends ProductRepository {
  _FakeProductRepository({
    this.firstError,
    this.firstCreateError,
    this.firstUpdateError,
    this.products = const <MobileProduct>[],
  }) : super(ApiClient(baseUrl: 'http://localhost:4000'));

  final ApiException? firstError;
  final ApiException? firstCreateError;
  final ApiException? firstUpdateError;
  final List<MobileProduct> products;
  int fetchCalls = 0;
  int createProductCalls = 0;
  int updateProductCalls = 0;
  final List<String> capturedCreateNames = <String>[];
  final List<String> capturedCreateUnits = <String>[];
  final List<String?> capturedCreateCategoryIds = <String?>[];
  final List<String?> capturedCreateSkus = <String?>[];
  final List<String?> capturedCreateBarcodes = <String?>[];
  final List<String?> capturedCreateDescriptions = <String?>[];
  final List<double?> capturedCreateMinStocks = <double?>[];
  final List<double?> capturedCreateCurrentStocks = <double?>[];
  final List<String> capturedUpdateProductIds = <String>[];
  final List<String?> capturedUpdateNames = <String?>[];
  final List<String?> capturedUpdateUnits = <String?>[];
  final List<String?> capturedUpdateCategoryIds = <String?>[];
  final List<String?> capturedUpdateSkus = <String?>[];
  final List<String?> capturedUpdateBarcodes = <String?>[];
  final List<String?> capturedUpdateDescriptions = <String?>[];
  final List<double?> capturedUpdateMinStocks = <double?>[];

  @override
  Future<List<MobileProduct>> fetchProducts({
    required String accessToken,
    String? search,
  }) async {
    fetchCalls += 1;
    if (fetchCalls == 1 && firstError != null) {
      throw firstError!;
    }
    return products;
  }

  @override
  Future<ProductSyncResult> flushPendingUpdates({
    required String accessToken,
  }) async {
    return const ProductSyncResult(
      appliedCount: 0,
      pendingCount: 0,
    );
  }

  @override
  Future<List<PendingProductUpdateView>> getPendingUpdates() async => const [];

  @override
  Future<List<PendingProductCreateView>> getPendingCreates() async => const [];

  @override
  Future<ProductCreateResult> createProduct({
    required String accessToken,
    required String name,
    required String unit,
    String? categoryId,
    String? sku,
    String? barcode,
    String? description,
    double? minStock,
    double? currentStock,
  }) async {
    createProductCalls += 1;
    capturedCreateNames.add(name);
    capturedCreateUnits.add(unit);
    capturedCreateCategoryIds.add(categoryId);
    capturedCreateSkus.add(sku);
    capturedCreateBarcodes.add(barcode);
    capturedCreateDescriptions.add(description);
    capturedCreateMinStocks.add(minStock);
    capturedCreateCurrentStocks.add(currentStock);

    if (createProductCalls == 1 && firstCreateError != null) {
      throw firstCreateError!;
    }

    return ProductCreateResult(
      queued: false,
      product: products.first,
    );
  }

  @override
  Future<ProductWriteResult> updateProduct({
    required String accessToken,
    required MobileProduct fallbackProduct,
    required String productId,
    bool includeCategoryId = false,
    String? categoryId,
    String? name,
    String? sku,
    String? barcode,
    String? description,
    String? unit,
    double? minStock,
  }) async {
    updateProductCalls += 1;
    capturedUpdateProductIds.add(productId);
    capturedUpdateNames.add(name);
    capturedUpdateUnits.add(unit);
    capturedUpdateCategoryIds.add(categoryId);
    capturedUpdateSkus.add(sku);
    capturedUpdateBarcodes.add(barcode);
    capturedUpdateDescriptions.add(description);
    capturedUpdateMinStocks.add(minStock);

    if (updateProductCalls == 1 && firstUpdateError != null) {
      throw firstUpdateError!;
    }

    return ProductWriteResult(
      queued: false,
      product: fallbackProduct.copyWith(
        name: name,
        unit: unit,
        categoryId: categoryId,
        sku: sku,
        barcode: barcode,
        description: description,
        minStock: minStock,
      ),
    );
  }
}

class _FakeCategoryRepository extends CategoryRepository {
  _FakeCategoryRepository({
    this.firstCreateError,
    this.categories = const <MobileCategory>[],
  }) : super(ApiClient(baseUrl: 'http://localhost:4000'));

  final ApiException? firstCreateError;
  final List<MobileCategory> categories;
  int createCategoryCalls = 0;
  final List<String> capturedNames = <String>[];

  @override
  Future<CategoryCreateResult> createCategory({
    required String accessToken,
    required String name,
  }) async {
    createCategoryCalls += 1;
    capturedNames.add(name);

    if (createCategoryCalls == 1 && firstCreateError != null) {
      throw firstCreateError!;
    }

    return CategoryCreateResult(
      queued: false,
      category: MobileCategory(
        id: 'category-1',
        name: name,
      ),
    );
  }

  @override
  Future<CategorySyncResult> flushPendingCreates({
    required String accessToken,
  }) async {
    return const CategorySyncResult(
      appliedCount: 0,
      pendingCount: 0,
    );
  }

  @override
  Future<List<PendingCategoryCreateView>> getPendingCreates() async => const [];

  @override
  Future<List<MobileCategory>> fetchCategories({
    required String accessToken,
  }) async =>
      categories;
}

class _FakeMovementRepository extends MovementRepository {
  _FakeMovementRepository({
    this.firstError,
    this.firstIncomeError,
    this.firstExpenseError,
    this.firstAdjustmentError,
    this.movements = const <MobileMovement>[],
    this.pendingCount = 0,
  }) : super(ApiClient(baseUrl: 'http://localhost:4000'));

  final ApiException? firstError;
  final ApiException? firstIncomeError;
  final ApiException? firstExpenseError;
  final ApiException? firstAdjustmentError;
  final List<MobileMovement> movements;
  final int pendingCount;
  int fetchCalls = 0;
  int createIncomeCalls = 0;
  int createExpenseCalls = 0;
  int createAdjustmentCalls = 0;
  final List<String> capturedIncomeProductIds = <String>[];
  final List<double> capturedIncomeQuantities = <double>[];
  final List<String?> capturedIncomeComments = <String?>[];
  final List<String> capturedExpenseProductIds = <String>[];
  final List<double> capturedExpenseQuantities = <double>[];
  final List<String?> capturedExpenseComments = <String?>[];
  final List<String> capturedAdjustmentProductIds = <String>[];
  final List<double> capturedAdjustmentTargetQty = <double>[];
  final List<String?> capturedAdjustmentComments = <String?>[];

  @override
  Future<List<MobileMovement>> fetchMovements({
    required String accessToken,
    int limit = 20,
  }) async {
    fetchCalls += 1;
    if (fetchCalls == 1 && firstError != null) {
      throw firstError!;
    }
    return movements;
  }

  @override
  Future<MovementSyncResult> flushPendingWrites({
    required String accessToken,
  }) async {
    return MovementSyncResult(
      appliedCount: 0,
      pendingCount: pendingCount,
    );
  }

  @override
  Future<MovementWriteResult> createIncome({
    required String accessToken,
    required String productId,
    required double quantity,
    String? comment,
  }) async {
    createIncomeCalls += 1;
    capturedIncomeProductIds.add(productId);
    capturedIncomeQuantities.add(quantity);
    capturedIncomeComments.add(comment);

    if (createIncomeCalls == 1 && firstIncomeError != null) {
      throw firstIncomeError!;
    }

    return const MovementWriteResult(queued: false);
  }

  @override
  Future<MovementWriteResult> createExpense({
    required String accessToken,
    required String productId,
    required double quantity,
    String? comment,
  }) async {
    createExpenseCalls += 1;
    capturedExpenseProductIds.add(productId);
    capturedExpenseQuantities.add(quantity);
    capturedExpenseComments.add(comment);

    if (createExpenseCalls == 1 && firstExpenseError != null) {
      throw firstExpenseError!;
    }

    return const MovementWriteResult(queued: false);
  }

  @override
  Future<MovementWriteResult> createAdjustment({
    required String accessToken,
    required String productId,
    required double targetQty,
    String? comment,
  }) async {
    createAdjustmentCalls += 1;
    capturedAdjustmentProductIds.add(productId);
    capturedAdjustmentTargetQty.add(targetQty);
    capturedAdjustmentComments.add(comment);

    if (createAdjustmentCalls == 1 && firstAdjustmentError != null) {
      throw firstAdjustmentError!;
    }

    return const MovementWriteResult(queued: false);
  }
}

class _FakeInventoryRepository extends InventoryRepository {
  _FakeInventoryRepository({
    this.firstStartError,
    this.firstPatchError,
    this.firstFinishError,
    this.firstSyncError,
    this.pendingCount = 0,
    required this.session,
  }) : super(ApiClient(baseUrl: 'http://localhost:4000'));

  final ApiException? firstStartError;
  final ApiException? firstPatchError;
  final ApiException? firstFinishError;
  final ApiException? firstSyncError;
  final int pendingCount;
  final MobileInventorySession session;
  int startCalls = 0;
  int patchCalls = 0;
  int finishCalls = 0;
  int flushCalls = 0;
  int getByIdCalls = 0;
  final List<String> capturedPatchInventoryIds = <String>[];
  final List<String> capturedPatchItemIds = <String>[];
  final List<double> capturedPatchActualQty = <double>[];
  final List<String> capturedFinishInventoryIds = <String>[];
  final List<String> capturedFlushInventoryIds = <String>[];

  @override
  Future<PendingInventoryStartView?> getPendingStart() async => null;

  @override
  Future<int> getPendingCount({
    required String inventoryId,
  }) async =>
      pendingCount;

  @override
  Future<InventoryStartResult> start({
    required String accessToken,
  }) async {
    startCalls += 1;
    if (startCalls == 1 && firstStartError != null) {
      throw firstStartError!;
    }

    return InventoryStartResult(
      queued: false,
      session: session,
    );
  }

  @override
  Future<InventoryWriteResult> patchItem({
    required String accessToken,
    required String inventoryId,
    required String itemId,
    required double actualQty,
    required MobileInventoryItem fallbackItem,
  }) async {
    patchCalls += 1;
    capturedPatchInventoryIds.add(inventoryId);
    capturedPatchItemIds.add(itemId);
    capturedPatchActualQty.add(actualQty);

    if (patchCalls == 1 && firstPatchError != null) {
      throw firstPatchError!;
    }

    return InventoryWriteResult(
      queued: false,
      item: fallbackItem.copyWithActualQty(actualQty),
    );
  }

  @override
  Future<InventorySyncResult> flushPendingItemUpdates({
    required String accessToken,
    required String inventoryId,
  }) async {
    flushCalls += 1;
    capturedFlushInventoryIds.add(inventoryId);

    if (flushCalls == 1 && firstSyncError != null) {
      throw firstSyncError!;
    }

    return const InventorySyncResult(
      appliedCount: 1,
      pendingCount: 0,
    );
  }

  @override
  Future<MobileInventorySession> finish({
    required String accessToken,
    required String inventoryId,
  }) async {
    finishCalls += 1;
    capturedFinishInventoryIds.add(inventoryId);

    if (finishCalls == 1 && firstFinishError != null) {
      throw firstFinishError!;
    }

    return session.copyWith(status: 'COMPLETED');
  }

  @override
  Future<MobileInventorySession> getById({
    required String accessToken,
    required String inventoryId,
  }) async {
    getByIdCalls += 1;
    return session;
  }
}

class _FakeCompanyRepository extends CompanyRepository {
  _FakeCompanyRepository({
    this.firstError,
    required this.company,
  }) : super(ApiClient(baseUrl: 'http://localhost:4000'));

  final ApiException? firstError;
  final MobileCompany company;
  int fetchCalls = 0;

  @override
  Future<CompanySyncResult> flushPendingUpdate({
    required String accessToken,
  }) async {
    return const CompanySyncResult(
      applied: false,
      hasPending: false,
    );
  }

  @override
  Future<MobileCompany> fetchCompany({
    required String accessToken,
  }) async {
    fetchCalls += 1;
    if (fetchCalls == 1 && firstError != null) {
      throw firstError!;
    }
    return company;
  }
}

class _FakeUserRepository extends UserRepository {
  _FakeUserRepository({
    this.firstInviteError,
  }) : super(ApiClient(baseUrl: 'http://localhost:4000'));

  final ApiException? firstInviteError;
  int inviteCalls = 0;
  final List<String> capturedInviteEmails = <String>[];
  final List<String> capturedInviteRoles = <String>[];

  @override
  Future<UserSyncResult> flushPendingUpdates({
    required String accessToken,
  }) async {
    return const UserSyncResult(
      appliedCount: 0,
      pendingCount: 0,
    );
  }

  @override
  Future<List<PendingUserUpdateView>> getPendingUpdates() async => const [];

  @override
  Future<List<PendingUserInviteView>> getPendingInvites() async => const [];

  @override
  Future<int> getPendingInviteCount() async => 0;

  @override
  Future<List<MobileTeamUser>> fetchUsers({
    required String accessToken,
  }) async =>
      const [];

  @override
  Future<InviteUserResult> inviteUser({
    required String accessToken,
    required String email,
    required String role,
  }) async {
    inviteCalls += 1;
    capturedInviteEmails.add(email);
    capturedInviteRoles.add(role);

    if (inviteCalls == 1 && firstInviteError != null) {
      throw firstInviteError!;
    }

    return InviteUserResult(
      inviteToken: 'invite-token-123',
      user: MobileTeamUser(
        id: 'user-2',
        name: 'Pending User',
        email: email,
        phone: null,
        role: role,
        isActive: false,
        createdAt: DateTime(2026, 3, 3, 10, 0),
        inviteExpiresAt: DateTime(2026, 3, 10, 10, 0),
      ),
    );
  }

}

class _FakeAuthGateway implements AuthGateway {
  _FakeAuthGateway({
    this.refreshResult,
    this.meResult,
  });

  final AuthSession? refreshResult;
  final MobileUser? meResult;

  final List<AuthSession> persistedSessions = <AuthSession>[];

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSession> refresh(String refreshToken) async {
    return refreshResult ?? _demoSession();
  }

  @override
  Future<MobileUser> me(String accessToken) async {
    return meResult ?? _demoUser();
  }

  @override
  Future<void> persistSession(AuthSession session) async {
    persistedSessions.add(session);
  }

  @override
  Future<void> clearCachedSession() async {}

  @override
  Future<AuthSession?> readCachedSession() async => null;

  @override
  Future<void> logout(String refreshToken) async {}
}

AuthSession _demoSession({
  String accessToken = 'demo-access',
  String refreshToken = 'demo-refresh',
  MobileUser? user,
}) {
  return AuthSession(
    accessToken: accessToken,
    refreshToken: refreshToken,
    user: user ?? _demoUser(),
  );
}

MobileUser _demoUser({
  String name = 'Owner',
}) {
  return MobileUser(
    id: 'user-1',
    companyId: 'company-1',
    name: name,
    email: 'owner@nexussklad.local',
    phone: '+7 900 000-00-00',
    role: 'OWNER',
    companyName: 'NexusSklad Demo Company',
  );
}
