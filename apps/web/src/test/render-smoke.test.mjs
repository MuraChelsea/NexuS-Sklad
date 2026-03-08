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
  DashboardView,
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
  selectVisibleAuditLogs,
  selectVisibleMovements,
  selectVisibleProducts,
  selectVisibleStockReportItems,
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

test('selectVisibleProducts applies current catalog filter, search and sort for export parity', () => {
  const items = selectVisibleProducts(
    [
      { ...demoProduct(), id: 'prod-ok', name: 'Арбуз', currentStock: '10', minStock: '2', sku: 'SKU-ARB' },
      { ...demoProduct(), id: 'prod-low', name: 'Банан', currentStock: '1', minStock: '3', sku: 'SKU-BAN' },
    ],
    'LOW_STOCK',
    'sku ban',
    'NAME_ASC',
  );

  assert.equal(items.length, 1);
  assert.equal(items[0].name, 'Банан');
});

test('selectVisibleMovements applies current journal search and sort for export parity', () => {
  const items = selectVisibleMovements(
    [
      demoMovement(),
      {
        ...demoMovement(),
        id: 'movement-old-1',
        createdAt: '2026-03-02T08:00:00.000Z',
        comment: 'inventory diff check',
        movementType: 'INVENTORY_DIFF',
      },
    ],
    'ALL',
    'inventory diff',
    'OLDEST',
  );

  assert.equal(items.length, 1);
  assert.equal(items[0].id, 'movement-old-1');
});

test('selectVisibleStockReportItems applies current stock status filter for export parity', () => {
  const items = selectVisibleStockReportItems(
    demoStockReport([
      { ...demoStockItem(), id: 'stock-ok', name: 'Арбуз', isLowStock: false, currentStock: '10', minStock: '2' },
      { ...demoStockItem(), id: 'stock-low', name: 'Банан', isLowStock: true, currentStock: '1', minStock: '3' },
    ]).items,
    'LOW',
    'NAME_ASC',
  );

  assert.equal(items.length, 1);
  assert.equal(items[0].name, 'Банан');
});

test('selectVisibleAuditLogs applies current search and sort for export parity', () => {
  const items = selectVisibleAuditLogs(
    [
      demoAuditLog(),
      {
        ...demoAuditLog(),
        id: 'audit-old-1',
        action: 'product.updated',
        createdAt: '2026-03-01T10:00:00.000Z',
        payload: {
          before: { name: 'Cola' },
          after: { name: 'Cola Zero' },
        },
      },
    ],
    'после',
    'OLDEST',
  );

  assert.equal(items.length, 1);
  assert.equal(items[0].id, 'audit-old-1');
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

test('ProductsView renders quick filter actions', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
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

  assert.match(html, />Все</);
  assert.match(html, />Низкий остаток</);
  assert.match(html, />Без категории</);
  assert.match(html, /Поиск по ID, названию, SKU, штрихкоду, категории или единице/);
  assert.match(html, /Риск сначала/);
  assert.match(html, /По названию/);
});

test('ProductsView renders filtered empty state when selected filter has no matches', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [{ ...demoProduct(), minStock: '1', currentStock: '5', categoryId: 'cat-1', category: demoCategory() }],
      categories: [demoCategory()],
      defaultFilter: 'LOW_STOCK',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.match(html, /По выбранному фильтру товаров нет/);
  assert.match(html, /Сбросить фильтр/);
});

test('ProductsView treats missing category relation as uncategorized', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [{ ...demoProduct(), categoryId: 'cat-1', category: null }],
      categories: [demoCategory()],
      defaultFilter: 'UNCATEGORIZED',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.match(html, /Без категории: 1/);
  assert.match(html, /Demo Product/);
  assert.doesNotMatch(html, /По выбранному фильтру товаров нет/);
});

test('ProductsView renders search empty state when query has no matches', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [demoCategory()],
      defaultSearch: 'not-found-product',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.match(html, /Поиск не дал товаров по текущему фильтру\./);
  assert.match(html, /Очистить поиск/);
});

test('ProductsView supports search by category label', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [{ ...demoProduct(), categoryId: 'cat-1', category: demoCategory() }],
      categories: [demoCategory()],
      defaultSearch: 'напитки',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал товаров по текущему фильтру\./);
  assert.match(html, /Demo Product/);
});

test('ProductsView supports search by unit label', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [{ ...demoProduct(), unit: 'кг' }],
      categories: [demoCategory()],
      defaultSearch: 'кг',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал товаров по текущему фильтру\./);
  assert.match(html, /Demo Product/);
});

test('ProductsView supports search by compact barcode digits', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [{ ...demoProduct(), barcode: '460-123-45' }],
      categories: [demoCategory()],
      defaultSearch: '46012345',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал товаров по текущему фильтру\./);
  assert.match(html, /Demo Product/);
});

test('ProductsView supports search by separator-free sku token', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [{ ...demoProduct(), sku: 'SKU-1' }],
      categories: [demoCategory()],
      defaultSearch: 'sku1',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал товаров по текущему фильтру\./);
  assert.match(html, /Demo Product/);
});

test('ProductsView supports search by separator-variant sku token', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [{ ...demoProduct(), sku: 'SKU-1' }],
      categories: [demoCategory()],
      defaultSearch: 'sku 1',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал товаров по текущему фильтру\./);
  assert.match(html, /Demo Product/);
});

test('ProductsView supports search by product id', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [demoCategory()],
      defaultSearch: '55555555-5555-5555-5555-555555555555',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал товаров по текущему фильтру\./);
  assert.match(html, /Demo Product/);
});

test('ProductsView supports search by separator-variant product id token', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [demoCategory()],
      defaultSearch: '55555555 5555 5555 5555 555555555555',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал товаров по текущему фильтру\./);
  assert.match(html, /Demo Product/);
});

test('ProductsView supports search by compact product id', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [demoCategory()],
      defaultSearch: '55555555555555555555555555555555',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал товаров по текущему фильтру\./);
  assert.match(html, /Demo Product/);
});

test('ProductsView supports product name sorting mode', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [
        { ...demoProduct(), id: 'prod-z', name: 'Яблоко' },
        { ...demoProduct(), id: 'prod-a', name: 'Арбуз' },
      ],
      categories: [demoCategory()],
      defaultSort: 'NAME_ASC',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.ok(html.indexOf('Арбуз') < html.indexOf('Яблоко'));
});

test('ProductsView renders category search controls', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
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

  assert.match(html, /Поиск по ID, категории или родителю/);
  assert.match(html, /Корневые сначала/);
  assert.match(html, /По названию/);
});

test('ProductsView renders category search empty state when query has no matches', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [demoCategory()],
      defaultCategorySearch: 'not-found-category',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.match(html, /Поиск не дал категорий/);
  assert.match(html, /Очистить поиск/);
});

test('ProductsView supports category search by category id', () => {
  const category = demoCategory();
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [category],
      defaultCategorySearch: category.id,
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал категорий/);
  assert.match(html, /Напитки/);
});

test('ProductsView supports category search by compact category id', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [demoCategory()],
      defaultCategorySearch: 'cat1',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал категорий/);
  assert.match(html, /Напитки/);
});

test('ProductsView supports category search by parent id', () => {
  const parentCategory = { ...demoCategory(), id: 'root-9', name: 'Основная группа', parentId: null };
  const childCategory = { ...demoCategory(), id: 'cat-9', name: 'Подкатегория', parentId: parentCategory.id };
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [parentCategory, childCategory],
      defaultCategorySearch: parentCategory.id,
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал категорий/);
  assert.match(html, /Подкатегория/);
});

test('ProductsView supports category search by compact parent id', () => {
  const parentCategory = { ...demoCategory(), id: 'root-9', name: 'Основная группа', parentId: null };
  const childCategory = { ...demoCategory(), id: 'cat-9', name: 'Подкатегория', parentId: parentCategory.id };
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [parentCategory, childCategory],
      defaultCategorySearch: 'root9',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал категорий/);
  assert.match(html, /Подкатегория/);
});

test('ProductsView supports category search by separator-free category name token', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [{ ...demoCategory(), name: 'Сухие смеси' }],
      defaultCategorySearch: 'сухиесмеси',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал категорий/);
  assert.match(html, /Сухие смеси/);
});

test('ProductsView supports category search by separator-variant category name token', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [{ ...demoCategory(), name: 'Сухие смеси' }],
      defaultCategorySearch: 'сухие-смеси',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал категорий/);
  assert.match(html, /Сухие смеси/);
});

test('ProductsView supports category search by separator-free parent name token', () => {
  const parentCategory = { ...demoCategory(), id: 'root-10', name: 'Молочная продукция', parentId: null };
  const childCategory = { ...demoCategory(), id: 'cat-10', name: 'Сметана', parentId: parentCategory.id };
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [parentCategory, childCategory],
      defaultCategorySearch: 'молочнаяпродукция',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал категорий/);
  assert.match(html, /Сметана/);
});

test('ProductsView supports category search by separator-variant parent name token', () => {
  const parentCategory = { ...demoCategory(), id: 'root-10', name: 'Молочная продукция', parentId: null };
  const childCategory = { ...demoCategory(), id: 'cat-10', name: 'Сметана', parentId: parentCategory.id };
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [parentCategory, childCategory],
      defaultCategorySearch: 'молочная-продукция',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал категорий/);
  assert.match(html, /Сметана/);
});

test('ProductsView supports category name sorting mode', () => {
  const html = renderToStaticMarkup(
    React.createElement(ProductsView, {
      isOwner: true,
      canManage: true,
      products: [demoProduct()],
      categories: [
        { ...demoCategory(), id: 'cat-z', name: 'Ягоды' },
        { ...demoCategory(), id: 'cat-a', name: 'Арбузы' },
      ],
      defaultCategorySort: 'NAME_ASC',
      onCreate: () => undefined,
      onEdit: () => undefined,
      onCreateCategory: () => undefined,
      onEditCategory: () => undefined,
      onDeleteProduct: () => undefined,
      onDeleteCategory: () => undefined,
      onExportProducts: () => undefined,
    }),
  );

  assert.ok(html.indexOf('Арбузы') < html.indexOf('Ягоды'));
});

test('DashboardView renders session filter controls and summary badges', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 2,
      sessions: [
        demoInventorySession(),
        { ...demoInventorySession(), id: 'inv-20260303-02', status: 'COMPLETED' },
      ],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 3,
      movementCount: 5,
      productCount: 8,
      onDateChange: () => undefined,
    }),
  );

  assert.match(html, /Текущий низкий остаток/);
  assert.match(html, /Движения за день/);
  assert.match(html, /Товаров в каталоге/);
  assert.match(html, /Сессий: 2/);
  assert.match(html, /Черновики: 1/);
  assert.match(html, /Завершено: 1/);
  assert.match(html, /Когда/);
  assert.match(html, /Поиск по ID, сотруднику, статусу, дате, комментарию или позициям/);
  assert.match(html, />Все</);
  assert.match(html, />Черновики</);
  assert.match(html, />Завершенные</);
  assert.match(html, /Сначала новые/);
  assert.match(html, /Сначала старые/);
});

test('DashboardView renders filtered empty state when selected status has no sessions', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultSessionFilter: 'COMPLETED',
      onDateChange: () => undefined,
    }),
  );

  assert.match(html, /По выбранному фильтру сессий нет/);
  assert.match(html, /Сбросить фильтр/);
});

test('DashboardView renders search empty state when query has no matches', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultSessionSearch: 'not-found-dashboard-session',
      onDateChange: () => undefined,
    }),
  );

  assert.match(html, /Поиск не дал сессий в сводке дня/);
  assert.match(html, /Очистить поиск/);
});

test('DashboardView supports session search by technical status token', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultSessionSearch: 'draft',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий в сводке дня/);
  assert.match(html, /inv-2026/);
});

test('DashboardView supports session search by comment', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [{ ...demoInventorySession(), comment: 'Ночная сверка' }],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultSessionSearch: 'сверка',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий в сводке дня/);
  assert.match(html, /inv-2026/);
});

test('DashboardView supports session search by ISO date value', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultSessionSearch: '2026-03-03',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий в сводке дня/);
  assert.match(html, /inv-2026/);
});

test('DashboardView supports session search by compact session id', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultSessionSearch: 'inv2026030301',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий в сводке дня/);
  assert.match(html, /inv-2026/);
});

test('DashboardView supports session search by separator-variant session id token', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultSessionSearch: 'inv 20260303 01',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий в сводке дня/);
  assert.match(html, /inv-2026/);
});

test('DashboardView supports session search by compact actor id', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultSessionSearch: 'owner1',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий в сводке дня/);
  assert.match(html, /inv-2026/);
});

test('DashboardView supports session search by finished date value', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [{ ...demoInventorySession(), status: 'COMPLETED', finishedAt: '2026-03-04T11:00:00.000Z' }],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultSessionSearch: '2026-03-04',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий в сводке дня/);
  assert.match(html, /inv-2026/);
});

test('DashboardView supports session search by compact finished date value', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [{ ...demoInventorySession(), status: 'COMPLETED', finishedAt: '2026-03-04T11:00:00.000Z' }],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultSessionSearch: '20260304',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий в сводке дня/);
  assert.match(html, /inv-2026/);
});

test('DashboardView supports oldest-first session sorting mode', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 2,
      sessions: [
        demoInventorySession(),
        {
          ...demoInventorySession(),
          id: 'inv-old-01',
          startedAt: '2026-03-03T08:00:00.000Z',
          startedBy: {
            ...demoInventorySession().startedBy,
            name: 'Старший смены',
          },
        },
      ],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultSessionSort: 'OLDEST',
      onDateChange: () => undefined,
    }),
  );

  assert.ok(html.indexOf('Старший смены') < html.indexOf('Мурад И.'));
});

test('DashboardView renders movement filter controls and summary badges', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [
        demoMovement(),
        { ...demoMovement(), id: 'movement-2', movementType: 'EXPENSE' },
      ],
      selectedDate: report.date,
      lowStockCount: 2,
      movementCount: 2,
      productCount: 4,
      onDateChange: () => undefined,
    }),
  );

  assert.match(html, /Движения по складу/);
  assert.match(html, /Когда/);
  assert.match(html, /Записей: 2/);
  assert.match(html, /Приходов: 1/);
  assert.match(html, /Расходов: 1/);
  assert.match(html, /Поиск по товару, SKU, единице, ID, сотруднику, роли, типу, количеству, дате или комментарию/);
  assert.match(html, /Сначала новые/);
  assert.match(html, /Сначала старые/);
});

test('DashboardView renders movement filtered empty state', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementFilter: 'EXPENSE',
      onDateChange: () => undefined,
    }),
  );

  assert.match(html, /По выбранному фильтру движений нет/);
  assert.match(html, /Сбросить фильтр/);
});

test('DashboardView renders movement search empty state', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: 'not-found-dashboard-movement',
      onDateChange: () => undefined,
    }),
  );

  assert.match(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Очистить поиск/);
});

test('DashboardView supports movement search by operation type label', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: 'приход',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Cola Zero/);
});

test('DashboardView supports movement search by separator-free operation token', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [{ ...demoMovement(), movementType: 'INVENTORY_DIFF' }],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: 'inventorydiff',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Cola Zero/);
});

test('DashboardView supports movement search by separator-variant operation token', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [{ ...demoMovement(), movementType: 'INVENTORY_DIFF' }],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: 'inventory diff',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Cola Zero/);
});

test('DashboardView supports movement search by role label', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: 'владелец',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Cola Zero/);
});

test('DashboardView supports movement search by quantity value', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: '5',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Cola Zero/);
});

test('DashboardView supports movement search by movement id', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: 'movement-1',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Cola Zero/);
});

test('DashboardView supports movement search by compact movement id', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: 'movement1',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Cola Zero/);
});

test('DashboardView supports movement search by compact actor id', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: 'owner1',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Cola Zero/);
});

test('DashboardView supports movement search by product sku', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: 'sku-1',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Cola Zero/);
});

test('DashboardView supports movement search by separator-free product sku token', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: 'sku1',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Cola Zero/);
});

test('DashboardView supports movement search by product unit', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: 'шт',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Cola Zero/);
});

test('DashboardView supports movement search by date value', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: '2026',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Cola Zero/);
});

test('DashboardView supports movement search by compact date value', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [demoMovement()],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 1,
      productCount: 1,
      defaultMovementSearch: '20260303',
      onDateChange: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений в сводке дня/);
  assert.match(html, /Cola Zero/);
});

test('DashboardView supports oldest-first movement sorting mode', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(DashboardView, {
      report,
      movements: [
        demoMovement(),
        {
          ...demoMovement(),
          id: 'movement-older',
          createdAt: '2026-03-03T08:00:00.000Z',
          product: { id: 'product-2', name: 'База' },
        },
      ],
      selectedDate: report.date,
      lowStockCount: 1,
      movementCount: 2,
      productCount: 2,
      defaultMovementSort: 'OLDEST',
      onDateChange: () => undefined,
    }),
  );

  assert.ok(html.indexOf('База') < html.indexOf('Cola Zero'));
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
  assert.match(html, /Сверок: 0/);
});

test('MovementsView renders quick filter actions', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [demoMovement()],
      canAdjust: true,
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.match(html, />Все</);
  assert.match(html, />Приход</);
  assert.match(html, />Расход</);
  assert.match(html, />Корректировка</);
  assert.match(html, />Сверка</);
  assert.match(html, /Когда/);
  assert.match(html, /Поиск по товару, SKU, единице, ID, сотруднику, роли, типу, количеству, дате или комментарию/);
  assert.match(html, /Сначала новые/);
  assert.match(html, /Сначала старые/);
});

test('MovementsView renders filtered empty state when selected type has no entries', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [demoMovement()],
      canAdjust: true,
      defaultFilter: 'EXPENSE',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.match(html, /По выбранному фильтру движений нет/);
  assert.match(html, /Сбросить фильтр/);
});

test('MovementsView renders search empty state when query has no matches', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [demoMovement()],
      canAdjust: true,
      defaultSearch: 'not-found-movement',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.match(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Очистить поиск/);
});

test('MovementsView supports search by movement comment', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [{ ...demoMovement(), comment: 'Ночная поставка' }],
      canAdjust: true,
      defaultSearch: 'поставка',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Cola Zero/);
});

test('MovementsView supports search by separator-free operation token', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [{ ...demoMovement(), movementType: 'INVENTORY_DIFF' }],
      canAdjust: true,
      defaultSearch: 'inventorydiff',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Cola Zero/);
});

test('MovementsView supports search by separator-variant operation token', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [{ ...demoMovement(), movementType: 'INVENTORY_DIFF' }],
      canAdjust: true,
      defaultSearch: 'inventory diff',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Cola Zero/);
});

test('MovementsView supports search by role label', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [demoMovement()],
      canAdjust: true,
      defaultSearch: 'владелец',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Cola Zero/);
});

test('MovementsView supports search by quantity value', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [demoMovement()],
      canAdjust: true,
      defaultSearch: '5',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Cola Zero/);
});

test('MovementsView supports search by movement id', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [demoMovement()],
      canAdjust: true,
      defaultSearch: 'movement-1',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Cola Zero/);
});

test('MovementsView supports search by compact movement id', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [demoMovement()],
      canAdjust: true,
      defaultSearch: 'movement1',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Cola Zero/);
});

test('MovementsView supports search by compact actor id', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [demoMovement()],
      canAdjust: true,
      defaultSearch: 'owner1',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Cola Zero/);
});

test('MovementsView supports search by product sku', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [demoMovement()],
      canAdjust: true,
      defaultSearch: 'sku-1',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Cola Zero/);
});

test('MovementsView supports search by separator-free product sku token', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [demoMovement()],
      canAdjust: true,
      defaultSearch: 'sku1',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Cola Zero/);
});

test('MovementsView supports search by product unit', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [demoMovement()],
      canAdjust: true,
      defaultSearch: 'шт',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Cola Zero/);
});

test('MovementsView supports search by date value', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [demoMovement()],
      canAdjust: true,
      defaultSearch: '2026',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Cola Zero/);
});

test('MovementsView supports search by compact date value', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [demoMovement()],
      canAdjust: true,
      defaultSearch: '20260303',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал движений по текущему фильтру\./);
  assert.match(html, /Cola Zero/);
});

test('MovementsView supports oldest-first sorting mode', () => {
  const html = renderToStaticMarkup(
    React.createElement(MovementsView, {
      products: [demoProduct()],
      movements: [
        demoMovement(),
        {
          ...demoMovement(),
          id: 'movement-older',
          createdAt: '2026-03-03T08:00:00.000Z',
          product: { id: 'product-2', name: 'База' },
        },
      ],
      canAdjust: true,
      defaultSort: 'OLDEST',
      onCreate: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.ok(html.indexOf('База') < html.indexOf('Cola Zero'));
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

test('TeamView renders owner-only company as empty team state', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [{ ...demoCurrentUser(), createdAt: '2026-03-03T00:00:00.000Z', inviteExpiresAt: null }],
      isOwner: true,
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.match(html, /Команда пока не заполнена/);
  assert.match(html, /В компании пока нет сотрудников кроме владельца\./);
  assert.match(html, /Сотрудников: 0/);
  assert.doesNotMatch(html, /owner@nexussklad\.local/);
});

test('TeamView renders owner team summary badges', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [
        demoUser(),
        {
          ...demoUser(),
          id: 'staff-2',
          role: 'STAFF',
          isActive: false,
          name: 'Murad',
          email: 'murad@nexussklad.local',
          inviteExpiresAt: '2026-03-09T00:00:00.000Z',
        },
      ],
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
  assert.match(html, /Приглашений: 1/);
  assert.match(html, /Неактивных: 1/);
});

test('TeamView renders team filters and search controls', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [demoUser()],
      isOwner: true,
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.match(html, />Все</);
  assert.match(html, />Активные</);
  assert.match(html, />Менеджеры</);
  assert.match(html, />Сотрудники</);
  assert.match(html, />Приглашения</);
  assert.match(html, /Поиск по имени, email, телефону, роли, статусу, ID или дате приглашения/);
  assert.match(html, /Активные сначала/);
  assert.match(html, /По имени/);
});

test('TeamView renders filtered empty state when selected filter has no users', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [demoUser()],
      isOwner: true,
      defaultFilter: 'INVITED',
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.match(html, /По выбранному фильтру сотрудников нет/);
  assert.match(html, /Сбросить фильтр/);
});

test('TeamView renders search empty state when query has no matches', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [demoUser()],
      isOwner: true,
      defaultSearch: 'not-found-user',
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.match(html, /Поиск не дал сотрудников по текущему фильтру\./);
  assert.match(html, /Очистить поиск/);
});

test('TeamView supports search by role label', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [demoUser()],
      isOwner: true,
      defaultSearch: 'менеджер',
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сотрудников по текущему фильтру\./);
  assert.match(html, /Мурад И\./);
});

test('TeamView supports search by compact phone digits', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [demoUser()],
      isOwner: true,
      defaultSearch: '79001111111',
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сотрудников по текущему фильтру\./);
  assert.match(html, /Мурад И\./);
});

test('TeamView supports search by compact user id', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [demoUser()],
      isOwner: true,
      defaultSearch: '77777777777777777777777777777777',
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сотрудников по текущему фильтру\./);
  assert.match(html, /Мурад И\./);
});

test('TeamView supports search by separator-variant user id token', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [demoUser()],
      isOwner: true,
      defaultSearch: '7777 7777 7777 7777 7777 7777 7777 7777',
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сотрудников по текущему фильтру\./);
  assert.match(html, /Мурад И\./);
});

test('TeamView supports search by compact email token', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [demoUser()],
      isOwner: true,
      defaultSearch: 'alinexusskladlocal',
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сотрудников по текущему фильтру\./);
  assert.match(html, /Мурад И\./);
});

test('TeamView supports search by separator-variant email token', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [demoUser()],
      isOwner: true,
      defaultSearch: 'ali nexussklad local',
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сотрудников по текущему фильтру\./);
  assert.match(html, /Мурад И\./);
});

test('TeamView supports search by invite status label', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [{ ...demoUser(), isActive: false, inviteExpiresAt: '2026-03-09T00:00:00.000Z' }],
      isOwner: true,
      defaultSearch: 'ожидает',
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сотрудников по текущему фильтру\./);
  assert.match(html, /Приглашение до/);
});

test('TeamView supports search by invite label text', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [{ ...demoUser(), isActive: false, inviteExpiresAt: '2026-03-09T00:00:00.000Z' }],
      isOwner: true,
      defaultSearch: 'приглашение до',
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сотрудников по текущему фильтру\./);
  assert.match(html, /Приглашение до/);
});

test('TeamView supports search by invite date value', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [{ ...demoUser(), isActive: false, inviteExpiresAt: '2026-03-09T00:00:00.000Z' }],
      isOwner: true,
      defaultSearch: '2026',
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сотрудников по текущему фильтру\./);
  assert.match(html, /Приглашение до/);
});

test('TeamView supports search by compact invite date value', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [{ ...demoUser(), isActive: false, inviteExpiresAt: '2026-03-09T00:00:00.000Z' }],
      isOwner: true,
      defaultSearch: '20260309',
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сотрудников по текущему фильтру\./);
  assert.match(html, /Приглашение до/);
});

test('TeamView supports name sorting mode', () => {
  const html = renderToStaticMarkup(
    React.createElement(TeamView, {
      company: demoCompany(),
      users: [
        { ...demoUser(), id: 'user-1', name: 'Яна', email: 'yana@nexussklad.local' },
        { ...demoUser(), id: 'user-2', name: 'Анна', email: 'anna@nexussklad.local' },
      ],
      isOwner: true,
      defaultSort: 'NAME_ASC',
      onEditCompany: () => undefined,
      onInvite: () => undefined,
      onEditUser: () => undefined,
    }),
  );

  assert.ok(html.indexOf('Анна') < html.indexOf('Яна'));
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

  assert.match(html, /Журнал пока пуст/);
  assert.match(html, /Фильтры не заданы/);
});

test('AuditView renders filtered empty state when server-side filters remove all logs', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [],
      users: [demoUser()],
      filters: { userId: demoUser().id, entityType: 'product', action: '' },
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.match(html, /По текущим фильтрам журнал пуст/);
  assert.match(html, /Пользователь: Мурад И\./);
  assert.match(html, /Сущность: товар/);
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

  assert.match(html, /Поиск по действию, сущности, ID, сотруднику, роли, дате или деталям/);
  assert.match(html, />Все сущности</);
  assert.match(html, />Сессии инвентаризации</);
  assert.match(html, />Все действия</);
  assert.match(html, />Завершение инвентаризации</);
  assert.match(html, /Сначала новые/);
  assert.match(html, /Сначала старые/);
  assert.match(html, /Сбросить фильтры/);
  assert.match(html, /Сбросить всё/);
  assert.match(html, /Пользователей в выборке: 1/);
  assert.match(html, /Чаще всего: Завершена сессия инвентаризации/);
  assert.match(html, /По сущности: сессия инвентаризации/);
});

test('AuditView renders search empty state when query has no matches', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [demoAuditLog()],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: 'not-found-audit',
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.match(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /Очистить поиск/);
});

test('AuditView supports search by technical action token', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [demoAuditLog()],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: 'inventory.finished',
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /ID: inventory-1/);
});

test('AuditView supports separator-free technical search token', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [demoAuditLog()],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: 'inventoryfinished',
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /ID: inventory-1/);
});

test('AuditView supports search by payload summary labels', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [demoAuditLog()],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: 'позиции',
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /Позиции: 2/);
});

test('AuditView supports search by role label', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [demoAuditLog()],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: 'владелец',
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /ID: inventory-1/);
});

test('AuditView supports search by user id', () => {
  const auditLog = demoAuditLog();
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [auditLog],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: auditLog.user.id,
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /ID: inventory-1/);
});

test('AuditView supports search by compact user id', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [demoAuditLog()],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: 'owner1',
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /ID: inventory-1/);
});

test('AuditView supports search by log id', () => {
  const auditLog = demoAuditLog();
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [auditLog],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: auditLog.id,
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /ID: inventory-1/);
});

test('AuditView supports search by compact log id', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [demoAuditLog()],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: 'audit1',
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /ID: inventory-1/);
});

test('AuditView supports search by entity id', () => {
  const auditLog = demoAuditLog();
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [auditLog],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: auditLog.entityId,
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /ID: inventory-1/);
});

test('AuditView supports search by compact entity id', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [demoAuditLog()],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: 'inventory1',
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /ID: inventory-1/);
});

test('AuditView supports search by compact entity type token', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [demoAuditLog()],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: 'inventorysession',
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /ID: inventory-1/);
});

test('AuditView supports search by date value', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [demoAuditLog()],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: '2026-03-03',
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /ID: inventory-1/);
});

test('AuditView supports search by compact date value', () => {
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [demoAuditLog()],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSearch: '20260303',
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал записей по текущим фильтрам/);
  assert.match(html, /ID: inventory-1/);
});

test('AuditView respects oldest-first sorting in timeline table', () => {
  const newer = demoAuditLog();
  const older = {
    ...demoAuditLog(),
    id: 'audit-2',
    entityId: 'inventory-2',
    createdAt: '2026-03-03T08:00:00.000Z',
  };
  const html = renderToStaticMarkup(
    React.createElement(AuditView, {
      logs: [newer, older],
      users: [demoUser()],
      filters: { userId: '', entityType: '', action: '' },
      defaultSort: 'OLDEST',
      onChangeFilters: () => undefined,
      onClearFilters: () => undefined,
      onExport: () => undefined,
    }),
  );

  assert.ok(html.indexOf('ID: inventory-2') < html.indexOf('ID: inventory-1'));
});

test('ReportingView renders export empty state', () => {
  const html = renderToStaticMarkup(
    React.createElement(ReportingView, {
      report: demoDailyReport(),
      stockReport: demoStockReport([]),
      categories: [demoCategory()],
      users: [],
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

test('ReportingView does not show empty state when only audit export has data', () => {
  const html = renderToStaticMarkup(
    React.createElement(ReportingView, {
      report: demoDailyReport(),
      stockReport: demoStockReport([]),
      categories: [demoCategory()],
      users: [demoUser()],
      movements: [],
      products: [],
      auditLogs: [demoAuditLog()],
      canSeeAudit: true,
      reportFilters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      auditFilters: { userId: demoUser().id, entityType: '', action: '' },
      onExportProducts: () => undefined,
      onExportMovements: () => undefined,
      onExportStock: () => undefined,
      onExportAudit: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Экспортировать пока нечего/);
  assert.match(html, /Журнал изменений/);
  assert.match(html, /Записей: 1\./);
  assert.match(html, /nexussklad-audit-trail-[^-<]*мурад-и/i);
});

test('ReportingView renders active export context', () => {
  const html = renderToStaticMarkup(
    React.createElement(ReportingView, {
      report: demoDailyReport(),
      stockReport: demoStockReport([demoStockItem()]),
      categories: [demoCategory()],
      users: [demoUser()],
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
  assert.match(html, /Дата сводки: 2026-03-03/);
  assert.match(html, /Низкий остаток в отчете/);
  assert.match(html, /Поиск: cola/);
  assert.match(html, /Категория: Напитки/);
  assert.match(html, /Только низкий остаток/);
  assert.match(html, /Сводка дня/);
  assert.match(html, /Приход: 0/);
  assert.match(html, /Сессии: 0/);
  assert.match(html, /Текущий низкий остаток: 0/);
  assert.match(html, /Пользователь: Мурад И\./);
  assert.match(html, /nexussklad-stock-report-cola-напитки-low-only\.csv/i);
  assert.doesNotMatch(html, /nexussklad-stock-report-2026-03-03/i);
  assert.match(html, /nexussklad-audit-trail-[^-<]*мурад-и/i);
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

  assert.match(html, /Сессии за день/);
  assert.match(html, /Дата: 2026-03-03/);
  assert.match(html, /Низкий остаток в отчете/);
  assert.match(html, /Низкий остаток в отчете: 0/);
  assert.match(html, /За выбранный день сессий инвентаризации нет/);
  assert.match(html, /Запустить сессию/);
  assert.match(html, /Контекст отчета/);
  assert.match(html, /Поиск: cola/);
  assert.match(html, /Категория: Напитки/);
  assert.match(html, /placeholder="Поиск по товару \/ SKU \/ штрихкоду"/);
  assert.match(html, /Сбросить фильтры/);
});

test('InventoryView renders session filter controls', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 2,
      sessions: [
        demoInventorySession(),
        { ...demoInventorySession(), id: 'inv-20260303-02', status: 'COMPLETED' },
      ],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport: demoStockReport([demoStockItem()]),
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.match(html, />Все</);
  assert.match(html, />Черновики</);
  assert.match(html, />Завершенные</);
  assert.match(html, /Когда/);
  assert.match(html, /Поиск по ID, сотруднику, статусу, дате, комментарию или позициям/);
  assert.match(html, /Сначала новые/);
  assert.match(html, /Сначала старые/);
  assert.match(html, /Черновики: 1/);
  assert.match(html, /Завершено: 1/);
  assert.match(html, /Все позиции/);
  assert.match(html, /Низкий остаток/);
  assert.match(html, /В норме/);
  assert.match(html, /Риск сначала/);
  assert.match(html, /По названию/);
});

test('InventoryView renders filtered empty state when selected status has no sessions', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport: demoStockReport([]),
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      defaultSessionFilter: 'COMPLETED',
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.match(html, /По выбранному фильтру сессий нет/);
  assert.match(html, /Сбросить фильтр/);
});

test('InventoryView renders search empty state when query has no matches', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport: demoStockReport([]),
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      defaultSessionSearch: 'not-found-session',
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.match(html, /Поиск не дал сессий по текущему фильтру\./);
  assert.match(html, /Очистить поиск/);
});

test('InventoryView supports session search by positions label', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport: demoStockReport([demoStockItem()]),
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      defaultSessionSearch: 'Позиции: 12',
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий по текущему фильтру\./);
  assert.match(html, /inv-2026/);
});

test('InventoryView supports session search by comment', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [{ ...demoInventorySession(), comment: 'Ночная сверка' }],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport: demoStockReport([demoStockItem()]),
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      defaultSessionSearch: 'сверка',
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий по текущему фильтру\./);
  assert.match(html, /inv-2026/);
});

test('InventoryView supports session search by ISO date value', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport: demoStockReport([demoStockItem()]),
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      defaultSessionSearch: '2026-03-03',
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий по текущему фильтру\./);
  assert.match(html, /inv-2026/);
});

test('InventoryView supports session search by compact session id', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport: demoStockReport([demoStockItem()]),
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      defaultSessionSearch: 'inv2026030301',
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий по текущему фильтру\./);
  assert.match(html, /inv-2026/);
});

test('InventoryView supports session search by separator-variant session id token', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport: demoStockReport([demoStockItem()]),
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      defaultSessionSearch: 'inv 20260303 01',
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий по текущему фильтру\./);
  assert.match(html, /inv-2026/);
});

test('InventoryView supports session search by compact actor id', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport: demoStockReport([demoStockItem()]),
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      defaultSessionSearch: 'owner1',
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий по текущему фильтру\./);
  assert.match(html, /inv-2026/);
});

test('InventoryView supports session search by finished date value', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [{ ...demoInventorySession(), status: 'COMPLETED', finishedAt: '2026-03-04T11:00:00.000Z' }],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport: demoStockReport([demoStockItem()]),
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      defaultSessionSearch: '2026-03-04',
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий по текущему фильтру\./);
  assert.match(html, /inv-2026/);
});

test('InventoryView supports session search by compact finished date value', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [{ ...demoInventorySession(), status: 'COMPLETED', finishedAt: '2026-03-04T11:00:00.000Z' }],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport: demoStockReport([demoStockItem()]),
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      defaultSessionSearch: '20260304',
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.doesNotMatch(html, /Поиск не дал сессий по текущему фильтру\./);
  assert.match(html, /inv-2026/);
});

test('InventoryView supports oldest-first session sorting mode', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 2,
      sessions: [
        demoInventorySession(),
        {
          ...demoInventorySession(),
          id: 'inv-old-01',
          startedAt: '2026-03-03T08:00:00.000Z',
          startedBy: {
            ...demoInventorySession().startedBy,
            name: 'Старший смены',
          },
        },
      ],
    },
  };
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport: demoStockReport([demoStockItem()]),
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      defaultSessionSort: 'OLDEST',
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.ok(html.indexOf('Старший смены') < html.indexOf('Мурад И.'));
});

test('InventoryView supports stock report name sorting mode', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const stockReport = demoStockReport([
    {
      ...demoStockItem(),
      id: 'stock-b',
      name: 'Банан',
      isLowStock: true,
      currentStock: '1',
      minStock: '3',
    },
    {
      ...demoStockItem(),
      id: 'stock-a',
      name: 'Арбуз',
      isLowStock: false,
      currentStock: '10',
      minStock: '2',
    },
  ]);
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport,
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      defaultStockSort: 'NAME_ASC',
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.ok(html.indexOf('Арбуз') < html.indexOf('Банан'));
});

test('InventoryView renders stock status filtered empty state', () => {
  const report = {
    ...demoDailyReport(),
    inventory: {
      sessionsCount: 1,
      sessions: [demoInventorySession()],
    },
  };
  const stockReport = demoStockReport([
    {
      ...demoStockItem(),
      id: 'stock-ok-1',
      name: 'Запас',
      isLowStock: false,
      currentStock: '10',
      minStock: '2',
    },
  ]);
  const html = renderToStaticMarkup(
    React.createElement(InventoryView, {
      report,
      stockReport,
      categories: [demoCategory()],
      filters: { date: '2026-03-03', stockSearch: '', stockCategoryId: '', lowOnly: false },
      canManage: true,
      defaultStockStatusFilter: 'LOW',
      onChangeFilters: () => undefined,
      onStart: () => undefined,
      onOpenSession: () => undefined,
      onExportStock: () => undefined,
    }),
  );

  assert.match(html, /По выбранному статусу позиций нет/);
  assert.match(html, /Сбросить статус/);
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
          user: { ...demoUser(), isActive: false, inviteExpiresAt: '2026-03-09T00:00:00.000Z' },
          onEdit: () => undefined,
        }),
      ),
    ),
  );

  assert.match(html, /Мурад И\./);
  assert.match(html, /ali@nexussklad.local/);
  assert.match(html, /Менеджер/);
  assert.match(html, /Ожидает активации/);
  assert.match(html, /Приглашение до/);
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

  assert.match(html, /2026/);
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
  assert.match(html, /2026/);
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
  assert.match(html, /ID: inventory-1/);
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
  assert.equal((html.match(/field-label\">Телефон/g) ?? []).length, 1);
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
  assert.match(html, /Роль сотрудника/);
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
  assert.match(html, /Роль сотрудника/);
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
  assert.match(html, /Товар/);
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

  assert.match(html, /Email сотрудника/);
  assert.match(html, /Пароль/);
  assert.equal((html.match(/field-label\">Email сотрудника/g) ?? []).length, 1);
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
      sku: 'SKU-1',
      unit: 'шт',
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
