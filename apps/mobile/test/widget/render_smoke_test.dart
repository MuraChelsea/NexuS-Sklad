import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nexussklad_mobile/core/widgets/domain_state_cards.dart';
import 'package:nexussklad_mobile/core/widgets/entity_cards.dart';
import 'package:nexussklad_mobile/core/widgets/info_cards.dart';
import 'package:nexussklad_mobile/core/widgets/state_cards.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  testWidgets('EmptyStateCard renders title, subtitle and action', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      wrap(
        EmptyStateCard(
          title: 'Товары не найдены',
          subtitle: 'Создай первую позицию прямо в приложении.',
          actionLabel: 'Создать товар',
          onAction: () {
            tapped = true;
          },
        ),
      ),
    );

    expect(find.text('Товары не найдены'), findsOneWidget);
    expect(find.text('Создай первую позицию прямо в приложении.'), findsOneWidget);
    expect(find.text('Создать товар'), findsOneWidget);

    await tester.tap(find.text('Создать товар'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('ErrorStateCard renders retry action', (tester) async {
    var retried = false;

    await tester.pumpWidget(
      wrap(
        ErrorStateCard(
          message: 'Не удалось загрузить движения',
          onRetry: () {
            retried = true;
          },
        ),
      ),
    );

    expect(find.text('Не удалось загрузить движения'), findsOneWidget);
    expect(find.text('Повторить'), findsOneWidget);

    await tester.tap(find.text('Повторить'));
    await tester.pump();

    expect(retried, isTrue);
  });

  testWidgets('SyncIssueCard renders conflict clear action', (tester) async {
    var cleared = false;

    await tester.pumpWidget(
      wrap(
        SyncIssueCard(
          message: 'Есть конфликт синхронизации',
          hasConflict: true,
          onClearConflict: () {
            cleared = true;
          },
        ),
      ),
    );

    expect(find.text('Нужна ручная проверка'), findsOneWidget);
    expect(find.text('Есть конфликт синхронизации'), findsOneWidget);
    expect(find.text('Очистить и принять серверное состояние'), findsOneWidget);

    await tester.tap(find.text('Очистить и принять серверное состояние'));
    await tester.pump();

    expect(cleared, isTrue);
  });

  testWidgets('SyncIssueCard hides clear action for non-conflict state', (tester) async {
    await tester.pumpWidget(
      wrap(
        const SyncIssueCard(
          message: 'Синхронизация ожидает сеть',
          hasConflict: false,
        ),
      ),
    );

    expect(find.text('Синхронизация ожидает повторной отправки'), findsOneWidget);
    expect(find.text('Синхронизация ожидает сеть'), findsOneWidget);
    expect(find.text('Очистить и принять серверное состояние'), findsNothing);
  });

  testWidgets('InfoMessageCard renders informational text', (tester) async {
    await tester.pumpWidget(
      wrap(
        const InfoMessageCard(
          message: 'В компании пока нет сотрудников кроме владельца.',
        ),
      ),
    );

    expect(find.text('В компании пока нет сотрудников кроме владельца.'), findsOneWidget);
  });

  testWidgets('AuthNoticeCard renders message and dismiss action', (tester) async {
    var dismissed = false;

    await tester.pumpWidget(
      wrap(
        AuthNoticeCard(
          message: 'Сессия восстановлена. Продолжаем работу.',
          onDismiss: () {
            dismissed = true;
          },
        ),
      ),
    );

    expect(find.text('Сессия восстановлена. Продолжаем работу.'), findsOneWidget);
    expect(find.byTooltip('Скрыть notice'), findsOneWidget);

    await tester.tap(find.byTooltip('Скрыть notice'));
    await tester.pump();
    expect(dismissed, isTrue);
  });

  testWidgets('PendingActionCard renders retry and delete actions', (tester) async {
    var retried = false;
    var deleted = false;

    await tester.pumpWidget(
      wrap(
        PendingActionCard(
          title: 'Отложенный старт инвентаризации',
          subtitle: 'Создано: 03.03 10:15',
          primaryLabel: 'Повторить',
          secondaryLabel: 'Удалить',
          onPrimary: () {
            retried = true;
          },
          onSecondary: () {
            deleted = true;
          },
        ),
      ),
    );

    expect(find.text('Отложенный старт инвентаризации'), findsOneWidget);
    expect(find.text('Создано: 03.03 10:15'), findsOneWidget);
    expect(find.text('Повторить'), findsOneWidget);
    expect(find.text('Удалить'), findsOneWidget);

    await tester.tap(find.text('Повторить'));
    await tester.pump();
    expect(retried, isTrue);

    await tester.tap(find.text('Удалить'));
    await tester.pump();
    expect(deleted, isTrue);
  });

  testWidgets('DashboardNoActivityCard renders dashboard helper text', (tester) async {
    await tester.pumpWidget(
      wrap(
        const DashboardNoActivityCard(),
      ),
    );

    expect(
      find.text(
        'За сегодня еще нет движений и критичных остатков. Начни с прихода, расхода или короткой сверки остатков.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('EmptyMovementsCard renders movement CTA', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      wrap(
        EmptyMovementsCard(
          onCreateIncome: () {
            tapped = true;
          },
        ),
      ),
    );

    expect(find.text('Движений пока нет'), findsOneWidget);
    expect(find.text('Зафиксировать приход'), findsOneWidget);

    await tester.tap(find.text('Зафиксировать приход'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('PendingInventoryStartCard renders pending inventory actions', (tester) async {
    await tester.pumpWidget(
      wrap(
        const PendingInventoryStartCard(
          createdAtLabel: '03.03 10:15',
        ),
      ),
    );

    expect(find.text('Отложенный старт инвентаризации'), findsOneWidget);
    expect(
      find.text('Запрос на открытие сессии сохранен локально. Создано: 03.03 10:15'),
      findsOneWidget,
    );
    expect(find.text('Отправить сейчас'), findsOneWidget);
    expect(find.text('Убрать из очереди'), findsOneWidget);
  });

  testWidgets('ProductPendingOperationsCard renders queued product operations', (tester) async {
    var cleared = false;
    var synced = false;

    await tester.pumpWidget(
      wrap(
        ProductPendingOperationsCard(
          categoryCreates: const [
            PendingOperationAction(
              id: 'cat-1',
              label: 'Категория: Напитки · 03.03 10:15',
            ),
          ],
          productCreates: const [
            PendingOperationAction(
              id: 'prod-create-1',
              label: 'Создание: Cola · 03.03 10:20',
            ),
          ],
          productUpdates: const [
            PendingOperationAction(
              id: 'prod-update-1',
              label: 'Cola Zero · 03.03 10:25',
            ),
          ],
          onSyncAll: () {
            synced = true;
          },
          onClearAll: () {
            cleared = true;
          },
        ),
      ),
    );

    expect(find.text('Отложенные изменения товаров'), findsOneWidget);
    expect(find.text('Эти изменения будут отправлены при следующей синхронизации.'), findsOneWidget);
    expect(find.text('Отправить все сейчас'), findsOneWidget);
    expect(find.text('Очистить очередь'), findsOneWidget);
    expect(find.text('Категория: Напитки · 03.03 10:15'), findsOneWidget);
    expect(find.text('Создание: Cola · 03.03 10:20'), findsOneWidget);
    expect(find.text('Cola Zero · 03.03 10:25'), findsOneWidget);

    await tester.tap(find.text('Отправить все сейчас'));
    await tester.pump();
    expect(synced, isTrue);

    await tester.tap(find.text('Очистить очередь'));
    await tester.pump();
    expect(cleared, isTrue);
  });

  testWidgets('ProductPendingOperationsCard renders conflict controls', (tester) async {
    var cleared = false;

    await tester.pumpWidget(
      wrap(
        ProductPendingOperationsCard(
          categoryCreates: const [
            PendingOperationAction(
              id: 'cat-1',
              label: 'Категория: Напитки · 03.03 10:15',
            ),
          ],
          productCreates: const [
            PendingOperationAction(
              id: 'prod-create-1',
              label: 'Создание: Cola · 03.03 10:20',
            ),
          ],
          productUpdates: const [
            PendingOperationAction(
              id: 'prod-update-1',
              label: 'Cola Zero · 03.03 10:25',
            ),
          ],
          syncMessage: 'Есть конфликт синхронизации товаров',
          hasConflict: true,
          onClearConflict: () {
            cleared = true;
          },
        ),
      ),
    );

    expect(find.text('Отложенные изменения товаров'), findsOneWidget);
    expect(find.text('Часть изменений не совпала с текущим состоянием сервера.'), findsOneWidget);
    expect(find.text('Есть конфликт синхронизации товаров'), findsOneWidget);
    expect(find.text('Очистить и принять серверное состояние'), findsOneWidget);

    await tester.tap(find.text('Очистить и принять серверное состояние'));
    await tester.pump();
    expect(cleared, isTrue);
  });

  testWidgets('TeamPendingOperationsCard renders queued invites and updates', (tester) async {
    var invitesCleared = false;
    var updatesCleared = false;

    await tester.pumpWidget(
      wrap(
        TeamPendingOperationsCard(
          queueCount: 3,
          invites: const [
            PendingOperationAction(
              id: 'invite-1',
              label: 'staff@nexussklad.local · Сотрудник · 03.03 10:15',
            ),
          ],
          updates: const [
            PendingOperationAction(
              id: 'user-1',
              label: 'Ali · Менеджер · 03.03 10:20',
            ),
          ],
          syncMessage: 'Есть конфликт синхронизации сотрудников',
          hasConflict: true,
          onClearInvites: () {
            invitesCleared = true;
          },
          onClearConflict: () {
            updatesCleared = true;
          },
        ),
      ),
    );

    expect(find.text('Отложенные изменения сотрудников'), findsOneWidget);
    expect(find.text('Часть изменений по команде конфликтует с серверным состоянием.'), findsOneWidget);
    expect(find.text('Очередь сотрудников: 3'), findsOneWidget);
    expect(find.text('Отложенные приглашения'), findsOneWidget);
    expect(find.text('staff@nexussklad.local · Сотрудник · 03.03 10:15'), findsOneWidget);
    expect(find.text('Ali · Менеджер · 03.03 10:20'), findsOneWidget);
    expect(find.text('Есть конфликт синхронизации сотрудников'), findsOneWidget);
    expect(find.text('Очистить приглашения'), findsOneWidget);
    expect(find.text('Очистить и принять серверное состояние'), findsOneWidget);

    await tester.tap(find.text('Очистить приглашения'));
    await tester.pump();
    expect(invitesCleared, isTrue);

    await tester.tap(find.text('Очистить и принять серверное состояние'));
    await tester.pump();
    expect(updatesCleared, isTrue);
  });

  testWidgets('TeamPendingOperationsCard renders batch actions without conflict', (tester) async {
    var synced = false;
    var cleared = false;

    await tester.pumpWidget(
      wrap(
        TeamPendingOperationsCard(
          queueCount: 2,
          invites: const [
            PendingOperationAction(
              id: 'invite-1',
              label: 'staff@nexussklad.local · Сотрудник · 03.03 10:15',
            ),
          ],
          updates: const [
            PendingOperationAction(
              id: 'user-1',
              label: 'Ali · Менеджер · 03.03 10:20',
            ),
          ],
          onSyncAll: () {
            synced = true;
          },
          onClearAll: () {
            cleared = true;
          },
        ),
      ),
    );

    expect(find.text('Отправить все сейчас'), findsOneWidget);
    expect(find.text('Очистить очередь'), findsOneWidget);

    await tester.tap(find.text('Отправить все сейчас'));
    await tester.pump();
    expect(synced, isTrue);

    await tester.tap(find.text('Очистить очередь'));
    await tester.pump();
    expect(cleared, isTrue);
  });

  testWidgets('CompanyStatusCard renders pending company state', (tester) async {
    var synced = false;
    var edited = false;
    var cleared = false;

    await tester.pumpWidget(
      wrap(
        CompanyStatusCard(
          name: 'Test Company',
          details: 'Derbent · +7 900 000 00 00',
          canEdit: true,
          hasPendingSync: true,
          hasConflict: true,
          syncMessage: 'Компания требует синхронизации',
          onEdit: () {
            edited = true;
          },
          onSync: () {
            synced = true;
          },
          onClearConflict: () {
            cleared = true;
          },
        ),
      ),
    );

    expect(find.text('Test Company'), findsOneWidget);
    expect(find.text('Derbent · +7 900 000 00 00'), findsOneWidget);
    expect(find.text('В очереди'), findsOneWidget);
    expect(find.text('Есть изменения в очереди'), findsOneWidget);
    expect(find.text('Нужна сверка с сервером'), findsOneWidget);
    expect(find.text('Компания требует синхронизации'), findsOneWidget);

    await tester.tap(find.byTooltip('Синхронизировать компанию'));
    await tester.pump();
    expect(synced, isTrue);

    await tester.tap(find.byTooltip('Редактировать компанию'));
    await tester.pump();
    expect(edited, isTrue);

    await tester.tap(find.text('Очистить конфликтную очередь'));
    await tester.pump();
    expect(cleared, isTrue);
  });

  testWidgets('TeamMemberInfoCard renders queued badge and tap action', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      wrap(
        TeamMemberInfoCard(
          name: 'Ali',
          subtitle: 'ali@nexussklad.local · +7 900 000 00 00',
          role: 'MANAGER',
          accent: const Color(0xFF295C9B),
          canEdit: true,
          hasPendingSync: true,
          onTap: () {
            tapped = true;
          },
        ),
      ),
    );

    expect(find.text('Ali'), findsOneWidget);
    expect(find.text('ali@nexussklad.local · +7 900 000 00 00'), findsOneWidget);
    expect(find.text('Менеджер'), findsOneWidget);
    expect(find.text('в очереди'), findsOneWidget);

    await tester.tap(find.text('Ali'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('ProductStockCard renders stock badges', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ProductStockCard(
          name: 'Cola Zero',
          subtitle: 'SKU 123 · EAN 4600000000000 · Напитки',
          stockLabel: '2 шт',
          canEdit: true,
          isLowStock: true,
          isPendingCreate: true,
        ),
      ),
    );

    expect(find.text('Cola Zero'), findsOneWidget);
    expect(find.text('SKU 123 · EAN 4600000000000 · Напитки'), findsOneWidget);
    expect(find.text('2 шт'), findsOneWidget);
    expect(find.text('низкий остаток'), findsOneWidget);
    expect(find.text('создается офлайн'), findsOneWidget);
  });
}
