import test from 'node:test';
import assert from 'node:assert/strict';

import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';

import {
  App,
  ActiveFilterChips,
  AuditView,
  AuditLogRow,
  CategoryModal,
  CompanyPanel,
  CompanyModal,
  ExportCard,
  InlineSessionNotice,
  InventoryView,
  InventorySessionRow,
  InviteModal,
  LoginForm,
  MovementTableRow,
  MovementModal,
  MovementsView,
  ProductTableRow,
  ProductModal,
  ProductsView,
  ReportingView,
  StockReportRow,
  TeamUserRow,
  TeamView,
  UserModal,
} from '../app/App.tsx';

test('App restores persisted web session from localStorage', () => {
  const originalWindow = global.window;
  global.window = {
    localStorage: {
      getItem(key) {
        if (key !== 'nexussklad.web.session') {
          return null;
        }

        return JSON.stringify({
          accessToken: 'access-token',
          refreshToken: 'refresh-token',
          user: demoCurrentUser(),
        });
      },
      setItem() {},
      removeItem() {},
    },
  };

  try {
    const html = renderToStaticMarkup(React.createElement(App));
    assert.match(html, /Оптовый склад Дербент/);
    assert.doesNotMatch(html, /Открыть панель управления/);
  } finally {
    global.window = originalWindow;
  }
});

test('ProductsView renders explicit empty states', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [],
      categories: [],
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.match(html, /Товаров пока нет/);
  assert.match(html, /Категории пока не созданы/);
});

test('ProductsView renders catalog summary badges', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct(), { ...demoProduct(), id: 'prod-2', name: 'No Category Product', categoryId: null, category: null, currentStock: '0', minStock: '1' }],
      categories: [demoCategory()],
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.match(html, /Товаров: 2/);
  assert.match(html, /Низкий остаток: 1/);
  assert.match(html, /Без категории: 2/);
  assert.match(html, /Корневых: 1/);
});

test('MovementsView renders empty state CTA', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [],
      canAdjust: true,
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.match(html, /Движений пока нет/);
  assert.match(html, /Создать приход/);
});

test('MovementsView renders movement summary badges', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [
        demoMovement(),
        { ...demoMovement(), id: 'movement-2', movementType: 'EXPENSE' },
        { ...demoMovement(), id: 'movement-3', movementType: 'ADJUSTMENT' },
      ],
      canAdjust: true,
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.match(html, /Записей: 3/);
  assert.match(html, /Приходов: 1/);
  assert.match(html, /Расходов: 1/);
  assert.match(html, /Корректировок: 1/);
});

test('TeamView renders owner empty team state', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [],
      isOwner: true,
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.match(html, /Команда пока не заполнена/);
  assert.match(html, /Пригласить сотрудника/);
});

test('TeamView renders owner team summary badges', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [demoUser(), { ...demoUser(), id: 'staff-2', role: 'STAFF', isActive: false, name: 'Murad', email: 'murad@nexussklad.local' }],
      isOwner: true,
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.match(html, /Сотрудников: 2/);
  assert.match(html, /Активных: 1/);
  assert.match(html, /Менеджеров: 1/);
  assert.match(html, /Сотрудников склада: 1/);
  assert.match(html, /Неактивных: 1/);
});

test('TeamView renders owner-only notice for non-owner users', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [demoUser()],
      isOwner: false,
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.match(html, /Раздел владельца/);
  assert.match(html, /доступно только владельцу/);
});

test('AuditView renders empty filtered state', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [],
      users: [],
      filters: { userId: '', entityType: '', action: '' },
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.match(html, /журнал пуст/);
  assert.match(html, /Фильтры не заданы/);
});

test('AuditView renders insight badges and clear-filters action', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [demoAuditLog(), { ...demoAuditLog(), id: 'audit-2', action: 'inventory.finished' }],
      users: [demoUser()],
      filters: { userId: demoUser().id, entityType: 'inventory_session', action: 'inventory.finished' },
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.match(html, /Сбросить фильтры/);
  assert.match(html, /Пользователей в выборке: 1/);
  assert.match(html, /Чаще всего: Завершена сессия инвентаризации/);
  assert.match(html, /По сущности: сессия инвентаризации/);
});

test('ReportingView renders export empty state', () => {
  const html = renderToStaticMarkup(
    React.createElement(ReportingView, {
      report: demoDailyReport(),
      stockReport: demoStockReport([]),
      categories: [demoCategory()],
      movements: [],
      products: [],
      auditLogs: [],
      canSeeAudit: true,
      reportFilters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      auditFilters: { userId: '', entityType: '', action: '' },
      onExportProducts: () => undefined,
      onExportMovements: () => undefined,
      onExportStock: () => undefined,
      onExportAudit: () => undefined,
    }),
  );

  assert.match(html, /Экспортировать пока нечего/);
  assert.match(html, /nexussklad-products-catalog\.csv/);
});

test('ReportingView renders active export context', () => {
  const html = renderToStaticMarkup(
    React.createElement(ReportingView, {
      report: demoDailyReport(),
      stockReport: demoStockReport([demoStockItem()]),
      categories: [demoCategory()],
      movements: [demoMovement()],
      products: [demoProduct()],
      auditLogs: [demoAuditLog()],
      canSeeAudit: true,
      reportFilters: { date: '2026-03-03', stockSearch: 'cola', stockCategoryId: 'cat-1', lowOnly: true },
      auditFilters: { userId: demoUser().id, entityType: 'PRODUCT', action: 'PRODUCT_UPDATED' },
      onExportProducts: () => undefined,
      onExportMovements: () => undefined,
      onExportStock: () => undefined,
      onExportAudit: () => undefined,
    }),
  );

  assert.match(html, /Контекст отчета/);
  assert.match(html, /Поиск: cola/);
  assert.match(html, /Категория: Напитки/);
  assert.match(html, /Только низкий остаток/);
  assert.match(html, /Сводка дня/);
  assert.match(html, /Приход: 0/);
  assert.match(html, /Сессии: 0/);
  assert.match(html, /nexussklad-stock-report-2026-03-03-cola/i);
});

test('InventoryView renders empty session CTA and stock filters context', () => {
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report: demoDailyReport(),
      stockReport: demoStockReport([]),
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: 'cola', stockCategoryId: 'cat-1', lowOnly: true },
      canManage: true,
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.match(html, /За сегодня сессий инвентаризации нет/);
  assert.match(html, /Запустить сессию/);
  assert.match(html, /Контекст отчета/);
  assert.match(html, /Поиск: cola/);
  assert.match(html, /Категория: Напитки/);
  assert.match(html, /Сбросить фильтры/);
});

test('CompanyPanel renders company summary and owner action', () => {
  const html = renderToStaticMarkup(
    React.createElement(CompanyPanel, {
      company: demoCompany(),
      isOwner: true,
      onEditCompany: () => undefined,
    }),
  );

  assert.match(html, /Оптовый склад Дербент/);
  assert.match(html, /Дербент/);
  assert.match(html, /Редактировать компанию/);
  assert.match(html, /Создана:/);
  assert.match(html, /Город: Дербент/);
});

test('ProductTableRow renders stock badge and actions', () => {
  const html = renderToStaticMarkup(
    React.createElement(
      'table',
      null,
      React.createElement(
        'tbody',
        null,
        React.createElement(ProductTableRow, {
          product: demoProduct(),
          low: true,
          canManage: true,
          isOwner: true,
          onEdit: () => undefined,
          onDelete: () => undefined,
        }),
      ),
    ),
  );

  assert.match(html, /Demo Product/);
  assert.match(html, /SKU-1/);
  assert.match(html, /5 шт/);
  assert.match(html, /Редактировать/);
  assert.match(html, /Удалить/);
});

test('TeamUserRow renders user status and action', () => {
  const html = renderToStaticMarkup(
    React.createElement(
      'table',
      null,
      React.createElement(
        'tbody',
        null,
        React.createElement(TeamUserRow, {
          user: demoUser(),
          onEdit: () => undefined,
        }),
      ),
    ),
  );

  assert.match(html, /Мурад И\./);
  assert.match(html, /ali@nexussklad.local/);
  assert.match(html, /Менеджер/);
  assert.match(html, /Активен/);
  assert.match(html, /Редактировать/);
});

test('InventorySessionRow renders session summary and action', () => {
  const html = renderToStaticMarkup(
    React.createElement(
      'table',
      null,
      React.createElement(
        'tbody',
        null,
        React.createElement(InventorySessionRow, {
          session: demoInventorySession(),
          onOpen: () => undefined,
        }),
      ),
    ),
  );

  assert.match(html, /inv-2026/);
  assert.match(html, /Черновик/);
  assert.match(html, /Мурад И\./);
  assert.match(html, /Черновик/);
  assert.match(html, /12/);
  assert.match(html, /Открыть/);
});

test('StockReportRow renders low-stock badge', () => {
  const html = renderToStaticMarkup(
    React.createElement(
      'table',
      null,
      React.createElement(
        'tbody',
        null,
        React.createElement(StockReportRow, {
          item: demoStockItem(),
        }),
      ),
    ),
  );

  assert.match(html, /Cola Zero/);
  assert.match(html, /Напитки/);
  assert.match(html, /2 шт/);
  assert.match(html, /3/);
});

test('ExportCard renders export action', () => {
  const html = renderToStaticMarkup(
    React.createElement(ExportCard, {
      title: 'Журнал изменений',
      description: 'Журнал важных действий владельца и команды.',
      detail: 'nexussklad-audit-trail.csv',
      actionLabel: 'Экспорт журнала',
      onClick: () => undefined,
    }),
  );

  assert.match(html, /Журнал изменений/);
  assert.match(html, /владельца и команды/);
  assert.match(html, /Имя файла/);
  assert.match(html, /nexussklad-audit-trail\.csv/);
  assert.match(html, /Экспорт журнала/);
});

test('ActiveFilterChips renders explicit badges', () => {
  const html = renderToStaticMarkup(
    React.createElement(ActiveFilterChips, {
      title: 'Контекст',
      badges: ['Дата: 2026-03-03', 'Только низкий остаток'],
      emptyLabel: 'Нет фильтров',
    }),
  );

  assert.match(html, /Контекст/);
  assert.match(html, /Дата: 2026-03-03/);
  assert.match(html, /Только низкий остаток/);
});

test('MovementTableRow renders movement row data', () => {
  const html = renderToStaticMarkup(
    React.createElement(
      'table',
      null,
      React.createElement(
        'tbody',
        null,
        React.createElement(MovementTableRow, {
          movement: demoMovement(),
        }),
      ),
    ),
  );

  assert.match(html, /Cola Zero/);
  assert.match(html, /Мурад И\./);
  assert.match(html, /Приход/);
  assert.match(html, /5/);
});

test('AuditLogRow renders audit payload row', () => {
  const html = renderToStaticMarkup(
    React.createElement(
      'table',
      null,
      React.createElement(
        'tbody',
        null,
        React.createElement(AuditLogRow, {
          log: demoAuditLog(),
        }),
      ),
    ),
  );

  assert.match(html, /Завершена сессия инвентаризации/);
  assert.match(html, /сессия инвентаризации/);
  assert.match(html, /Мурад И\./);
  assert.match(html, /Позиции: 2/);
  assert.doesNotMatch(html, /Показать JSON/);
});

test('ProductModal renders product form fields', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductModal, {
      categories: [demoCategory()],
      onClose: () => undefined,
      onSubmit: async () => undefined,
    }),
  );

  assert.match(html, /Новый товар/);
  assert.match(html, /SKU и штрихкод можно добавить позже/);
  assert.match(html, /Название товара/);
  assert.match(html, /Единица измерения/);
  assert.match(html, /Минимальный остаток/);
  assert.match(html, /Стартовый остаток/);
  assert.match(html, /Создать товар/);
});

test('CompanyModal renders company form fields', () => {
  const html = renderToStaticMarkup(
    React.createElement(CompanyModal, {
      company: demoCompany(),
      onClose: () => undefined,
      onSubmit: async () => undefined,
    }),
  );

  assert.match(html, /Редактировать компанию/);
  assert.match(html, /используются в панели контроля/i);
  assert.match(html, /Город/);
  assert.match(html, /Телефон/);
  assert.match(html, /Сохранить данные компании/);
});

test('InviteModal renders invite token state', () => {
  const html = renderToStaticMarkup(
    React.createElement(InviteModal, {
      inviteToken: 'invite-token-123',
      onClose: () => undefined,
      onSubmit: async () => undefined,
    }),
  );

  assert.match(html, /Пригласить сотрудника/);
  assert.match(html, /Он активирует доступ и сам задаст пароль/);
  assert.match(html, /Приглашение готово/);
  assert.match(html, /Передай сотруднику этот токен/);
  assert.match(html, /invite-token-123/);
});

test('UserModal renders user form state', () => {
  const html = renderToStaticMarkup(
    React.createElement(UserModal, {
      user: demoUser(),
      onClose: () => undefined,
      onSubmit: async () => undefined,
    }),
  );

  assert.match(html, /Редактировать сотрудника/);
  assert.match(html, /Оставь пароль пустым/);
  assert.match(html, /Новый пароль/);
  assert.match(html, /Активен/);
  assert.match(html, /Сохранить сотрудника/);
});

test('CategoryModal renders category form fields', () => {
  const html = renderToStaticMarkup(
    React.createElement(CategoryModal, {
      categories: [demoCategory()],
      onClose: () => undefined,
      onSubmit: async () => undefined,
    }),
  );

  assert.match(html, /Новая категория/);
  assert.match(html, /Родительскую категорию указывай только если действительно нужна вложенность/);
  assert.match(html, /Название категории/);
  assert.match(html, /Без родительской категории/);
  assert.match(html, /Создать категорию/);
});

test('MovementModal renders operation form', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementModal, {
      kind: 'income',
      products: [demoProduct()],
      onClose: () => undefined,
      onSubmit: async () => undefined,
    }),
  );

  assert.match(html, /Операция по складу: Приход/);
  assert.match(html, /Комментарий полезен для разбора спорных движений/);
  assert.match(html, /Количество/);
  assert.match(html, /Комментарий/);
  assert.match(html, /Провести приход/);
});

test('LoginForm renders auth notice and error states', () => {
  const html = renderToStaticMarkup(
    React.createElement(LoginForm, {
      loading: false,
      error: 'Сессия истекла. Войди снова.',
      notice: 'Сессия восстановлена. Действие повторено автоматически.',
      onSubmit: async () => undefined,
    }),
  );

  assert.match(html, /Сессия восстановлена\. Действие повторено автоматически\./);
  assert.match(html, /Сессия истекла\. Войди снова\./);
  assert.match(html, /Войти/);
});

test('InlineSessionNotice renders recovery message and dismiss action', () => {
  const html = renderToStaticMarkup(
    React.createElement(InlineSessionNotice, {
      message: 'Сессия восстановлена. Действие повторено автоматически.',
      onDismiss: () => undefined,
    }),
  );

  assert.match(html, /Сессия восстановлена/);
  assert.match(html, /Действие повторено автоматически/);
  assert.match(html, /Скрыть/);
});

function demoCompany() {
  return {
    id: '11111111-1111-1111-1111-111111111111',
    name: 'Оптовый склад Дербент',
    city: 'Дербент',
    phone: '+7 900 000-00-00',
    createdAt: '2026-03-03T00:00:00.000Z',
  };
}

function demoCategory() {
  return {
    id: 'cat-1',
    name: 'Напитки',
    parentId: null,
    createdAt: '2026-03-03T00:00:00.000Z',
  };
}

function demoProduct() {
  return {
    id: '55555555-5555-5555-5555-555555555555',
    companyId: '11111111-1111-1111-1111-111111111111',
    categoryId: null,
    name: 'Demo Product',
    sku: 'SKU-1',
    barcode: null,
    unit: 'шт',
    description: null,
    minStock: '1',
    currentStock: '5',
    createdAt: '2026-03-03T00:00:00.000Z',
    updatedAt: '2026-03-03T00:00:00.000Z',
    category: null,
  };
}

function demoDailyReport() {
  return {
    date: '2026-03-03',
    movementSummary: {
      INCOME: { count: 0, quantity: '0' },
      EXPENSE: { count: 0, quantity: '0' },
      ADJUSTMENT: { count: 0, quantity: '0' },
      INVENTORY_DIFF: { count: 0, quantity: '0' },
    },
    inventory: {
      sessionsCount: 0,
      sessions: [],
    },
    stock: {
      totalProducts: 0,
      lowStockCount: 0,
    },
  };
}

function demoStockReport(items) {
  return {
    summary: {
      totalItems: items.length,
      lowStockItems: 0,
    },
    items,
  };
}

function demoUser() {
  return {
    id: '77777777-7777-7777-7777-777777777777',
    companyId: '11111111-1111-1111-1111-111111111111',
    name: 'Мурад И.',
    email: 'ali@nexussklad.local',
    phone: '+7 900 111-11-11',
    role: 'MANAGER',
    isActive: true,
    inviteTokenHash: null,
    inviteExpiresAt: null,
    createdAt: '2026-03-03T00:00:00.000Z',
    updatedAt: '2026-03-03T00:00:00.000Z',
  };
}

function demoCurrentUser() {
  return {
    id: 'owner-1',
    companyId: '11111111-1111-1111-1111-111111111111',
    name: 'Мурад И.',
    email: 'owner@nexussklad.local',
    phone: '+7 900 000-00-00',
    role: 'OWNER',
    isActive: true,
    company: demoCompany(),
  };
}

function demoInventorySession() {
  return {
    id: 'inv-20260303-01',
    status: 'DRAFT',
    comment: null,
    startedAt: '2026-03-03T10:00:00.000Z',
    finishedAt: null,
    companyId: '11111111-1111-1111-1111-111111111111',
    startedBy: {
      id: 'owner-1',
      name: 'Мурад И.',
      role: 'OWNER',
    },
    _count: {
      items: 12,
    },
    items: [],
  };
}

function demoStockItem() {
  return {
    id: 'stock-1',
    name: 'Cola Zero',
    sku: 'SKU-2',
    unit: 'шт',
    currentStock: '2',
    minStock: '3',
    isLowStock: true,
    category: {
      id: 'cat-1',
      name: 'Напитки',
      parentId: null,
      createdAt: '2026-03-03T00:00:00.000Z',
    },
  };
}

function demoMovement() {
  return {
    id: 'movement-1',
    movementType: 'INCOME',
    quantity: '5',
    beforeQty: '0',
    afterQty: '5',
    comment: null,
    createdAt: '2026-03-03T10:00:00.000Z',
    product: {
      id: 'product-1',
      name: 'Cola Zero',
    },
    createdBy: {
      id: 'owner-1',
      name: 'Мурад И.',
      role: 'OWNER',
    },
  };
}

function demoAuditLog() {
  return {
    id: 'audit-1',
    action: 'inventory.finished',
    entityType: 'inventory_session',
    entityId: 'inventory-1',
    createdAt: '2026-03-03T10:00:00.000Z',
    user: {
      id: 'owner-1',
      name: 'Мурад И.',
      role: 'OWNER',
    },
    payload: {
      totalItemsCount: 2,
      changedItemsCount: 0,
    },
  };
}
