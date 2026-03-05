import { useEffect, useMemo, useState, type ReactNode } from 'react';
import type {
  OpenApiComponents,
} from '@nexussklad/shared';

import { ApiError, isSessionExpiredApiError } from '../core/api';
import { appConfig } from '../core/config';
import { executeConfirmedSessionAction, executeSessionAction } from '../core/session-actions';
import { fetchAuditLogs } from '../features/audit/audit';
import { login, me, refresh } from '../features/auth/auth';
import { fetchDailyReport, fetchStockReport } from '../features/dashboard/dashboard';
import {
  fetchInventorySession,
  finishInventory,
  startInventory,
  updateInventoryItem,
} from '../features/inventory/inventory';
import {
  canAdjust,
  createAdjustment,
  createExpense,
  createIncome,
  fetchMovements,
  sortProducts,
} from '../features/movements/movements';
import {
  createCategory,
  createProduct,
  deleteCategory,
  deleteProduct,
  fetchCategories,
  fetchProducts,
  updateCategory,
  updateProduct,
} from '../features/products/products';
import {
  fetchCompany,
  fetchUsers,
  inviteUser,
  updateCompany,
  updateUser,
} from '../features/team/team';

type SessionState = {
  accessToken: string;
  refreshToken: string;
  user: Awaited<ReturnType<typeof me>>;
};

const WEB_SESSION_STORAGE_KEY = 'nexussklad.web.session';

type CategoryDto = OpenApiComponents['schemas']['Category'];
type CompanyDto = OpenApiComponents['schemas']['Company'];
type CompanyUserDto = OpenApiComponents['schemas']['CompanyUser'];
type CreateCategoryRequestDto = OpenApiComponents['schemas']['CreateCategoryRequest'];
type CreateProductRequestDto = OpenApiComponents['schemas']['CreateProductRequest'];
type DailyReportDto = OpenApiComponents['schemas']['DailyReport'];
type AuditLogDto = OpenApiComponents['schemas']['AuditLog'];
type InviteUserRequestDto = OpenApiComponents['schemas']['InviteUserRequest'];
type InventoryItemDto = OpenApiComponents['schemas']['InventoryItem'];
type InventorySessionDto = OpenApiComponents['schemas']['InventorySession'];
type ProductDto = OpenApiComponents['schemas']['Product'];
type StockReportDto = OpenApiComponents['schemas']['StockReport'];
type StockMovementDto = OpenApiComponents['schemas']['StockMovement'];
type UpdateInventoryItemRequestDto = OpenApiComponents['schemas']['UpdateInventoryItemRequest'];
type UpdateCategoryRequestDto = OpenApiComponents['schemas']['UpdateCategoryRequest'];
type UpdateCompanyRequestDto = OpenApiComponents['schemas']['UpdateCompanyRequest'];
type UpdateProductRequestDto = OpenApiComponents['schemas']['UpdateProductRequest'];
type UpdateUserRequestDto = OpenApiComponents['schemas']['UpdateUserRequest'];

type ViewKey = 'dashboard' | 'products' | 'movements' | 'inventory' | 'team' | 'reports' | 'audit';

type AdminData = {
  report: DailyReportDto;
  stockReport: StockReportDto;
  company: CompanyDto;
  users: CompanyUserDto[];
  products: ProductDto[];
  categories: Awaited<ReturnType<typeof fetchCategories>>;
  movements: StockMovementDto[];
  auditLogs: AuditLogDto[];
};

type AuditFiltersState = {
  userId: string;
  entityType: string;
  action: string;
};

type ReportFiltersState = {
  date: string;
  stockSearch: string;
  stockCategoryId: string;
  lowOnly: boolean;
};

const DEMO_EMAIL = 'owner@nexussklad.local';
const DEMO_PASSWORD = 'demo-owner-123';

function normalizeAuditToken(value: string) {
  return value.toLowerCase().replaceAll(/[_-]+/g, '');
}

function formatRoleLabel(role: 'OWNER' | 'MANAGER' | 'STAFF') {
  switch (role) {
    case 'OWNER':
      return 'Владелец';
    case 'MANAGER':
      return 'Менеджер';
    case 'STAFF':
      return 'Сотрудник';
  }
}

function formatInventoryStatusLabel(status: string) {
  switch (status) {
    case 'DRAFT':
      return 'Черновик';
    case 'COMPLETED':
      return 'Завершена';
    default:
      return status;
  }
}

function formatEntityTypeLabel(entityType: string) {
  switch (normalizeAuditToken(entityType)) {
    case 'category':
      return 'категория';
    case 'product':
      return 'товар';
    case 'company':
      return 'компания';
    case 'user':
      return 'сотрудник';
    case 'stockmovement':
    case 'movement':
      return 'движение склада';
    case 'inventorysession':
    case 'inventory':
      return 'сессия инвентаризации';
    case 'inventoryitem':
    case 'inventoryitemupdated':
      return 'позиция инвентаризации';
    case 'inventorydiff':
      return 'расхождение инвентаризации';
    case 'auth':
      return 'доступ';
    default:
      return entityType;
  }
}

function formatAuditActionLabel(action: string) {
  const normalizedAction = action.toLowerCase();
  switch (normalizedAction) {
    case 'movement.income.created':
      return 'Проведен приход';
    case 'movement.expense.created':
      return 'Проведен расход';
    case 'movement.adjustment.created':
      return 'Проведена корректировка';
    case 'movement.inventory_diff.created':
      return 'Зафиксировано расхождение инвентаризации';
    case 'inventory.started':
      return 'Запущена сессия инвентаризации';
    case 'inventory.finished':
      return 'Завершена сессия инвентаризации';
    case 'inventory.item.updated':
      return 'Обновлена позиция инвентаризации';
    case 'user.invited':
      return 'Создано приглашение сотрудника';
    case 'auth.invite.accepted':
      return 'Приглашение принято';
    case 'auth.register':
      return 'Создана компания и владелец';
    case 'auth.logout':
      return 'Завершена сессия доступа';
  }

  const parts = normalizedAction.split('.');
  const verb = parts.at(-1);
  const entityLabel = formatEntityTypeLabel(parts.slice(0, -1).join('_') || normalizedAction);

  switch (verb) {
    case 'created':
      return `Создание: ${entityLabel}`;
    case 'updated':
      return `Обновление: ${entityLabel}`;
    case 'deleted':
      return `Удаление: ${entityLabel}`;
    case 'started':
      return `Запуск: ${entityLabel}`;
    case 'finished':
      return `Завершение: ${entityLabel}`;
    case 'invited':
      return `Приглашение: ${entityLabel}`;
    default:
      return action;
  }
}

function formatAuditPayloadKey(key: string) {
  switch (key) {
    case 'name':
      return 'Название';
    case 'email':
      return 'Email';
    case 'phone':
      return 'Телефон';
    case 'role':
      return 'Роль';
    case 'comment':
      return 'Комментарий';
    case 'before':
      return 'До';
    case 'after':
      return 'После';
    case 'quantity':
      return 'Количество';
    case 'beforeQty':
      return 'Остаток до';
    case 'afterQty':
      return 'Остаток после';
    case 'itemCount':
    case 'totalItemsCount':
      return 'Позиции';
    case 'changedItemsCount':
      return 'Изменено';
    case 'categoryId':
      return 'Категория';
    case 'parentId':
      return 'Родительская категория';
    case 'productIds':
      return 'Товары';
    default:
      return key;
  }
}

function buildAuditPayloadSummary(payload: AuditLogDto['payload']) {
  if (!payload) {
    return [];
  }

  return Object.entries(payload)
    .flatMap(([key, value]) => {
      if (value === null || value === '') {
        return [];
      }

      if (Array.isArray(value)) {
        if (value.length === 0) {
          return [];
        }
        return [`${formatAuditPayloadKey(key)}: ${value.length}`];
      }

      if (typeof value === 'object') {
        const nestedEntries = Object.entries(value).filter(([, nestedValue]) => nestedValue !== null && nestedValue !== '');
        if (nestedEntries.length === 0) {
          return [];
        }
        const nestedLabels = nestedEntries
          .slice(0, 2)
          .map(([nestedKey]) => formatAuditPayloadKey(nestedKey));
        const extraFields = nestedEntries.length - nestedLabels.length;
        return [
          `${formatAuditPayloadKey(key)}: ${nestedLabels.join(', ')}${extraFields > 0 ? ` +${extraFields}` : ''}`,
        ];
      }

      return [`${formatAuditPayloadKey(key)}: ${String(value)}`];
    })
    .slice(0, 3);
}

function readStoredSession(): SessionState | null {
  if (typeof window === 'undefined') {
    return null;
  }

  try {
    const rawValue = window.localStorage.getItem(WEB_SESSION_STORAGE_KEY);
    if (!rawValue) {
      return null;
    }

    const parsed = JSON.parse(rawValue);
    if (
      typeof parsed?.accessToken === 'string' &&
      typeof parsed?.refreshToken === 'string' &&
      typeof parsed?.user === 'object' &&
      parsed.user !== null
    ) {
      return parsed as SessionState;
    }
  } catch {
    window.localStorage.removeItem(WEB_SESSION_STORAGE_KEY);
  }

  return null;
}

function persistStoredSession(session: SessionState | null): void {
  if (typeof window === 'undefined') {
    return;
  }

  if (!session) {
    window.localStorage.removeItem(WEB_SESSION_STORAGE_KEY);
    return;
  }

  window.localStorage.setItem(WEB_SESSION_STORAGE_KEY, JSON.stringify(session));
}

export function App() {
  const [session, setSession] = useState<SessionState | null>(() => readStoredSession());
  const [view, setView] = useState<ViewKey>('dashboard');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [authNotice, setAuthNotice] = useState<string | null>(null);
  const [data, setData] = useState<AdminData | null>(null);
  const [productModal, setProductModal] = useState<ProductDto | null | false>(false);
  const [categoryModal, setCategoryModal] = useState<CategoryDto | null | false>(false);
  const [movementModal, setMovementModal] = useState<'income' | 'expense' | 'adjustment' | null>(null);
  const [companyModalOpen, setCompanyModalOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<CompanyUserDto | null>(null);
  const [inviteOpen, setInviteOpen] = useState(false);
  const [inviteToken, setInviteToken] = useState<string | null>(null);
  const [selectedInventory, setSelectedInventory] = useState<InventorySessionDto | null>(null);
  const [auditFilters, setAuditFilters] = useState<AuditFiltersState>({
    userId: '',
    entityType: '',
    action: '',
  });
  const [reportFilters, setReportFilters] = useState<ReportFiltersState>({
    date: new Date().toISOString().slice(0, 10),
    stockSearch: '',
    stockCategoryId: '',
    lowOnly: false,
  });

  const isOwner = session?.user.role === 'OWNER';
  const isManager = session?.user.role === 'MANAGER';
  const canManageProducts = isOwner || isManager;
  const canManageInventory = isOwner || isManager;

  async function handleLogin(email: string, password: string) {
    setLoading(true);
    setError(null);
    setAuthNotice(null);

    try {
      const auth = await login(email, password);
      const currentUser = await me(auth.accessToken);
      setSession({
        accessToken: auth.accessToken,
        refreshToken: auth.refreshToken,
        user: currentUser,
      });
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Не удалось выполнить вход');
    } finally {
      setLoading(false);
    }
  }

  function resetTransientUi() {
    setProductModal(false);
    setCategoryModal(false);
    setMovementModal(null);
    setCompanyModalOpen(false);
    setEditingUser(null);
    setInviteOpen(false);
    setInviteToken(null);
    setSelectedInventory(null);
    setView('dashboard');
  }

  function expireSession(error: ApiError) {
    resetTransientUi();
    setSession(null);
    setData(null);
    setLoading(false);
    setError(null);
    setAuthNotice(error.message);
  }

  async function tryRefreshSession(activeSession: SessionState): Promise<SessionState | null> {
    try {
      const refreshed = await refresh(activeSession.refreshToken);
      const currentUser = await me(refreshed.accessToken);
      const nextSession = {
        accessToken: refreshed.accessToken,
        refreshToken: refreshed.refreshToken,
        user: currentUser,
      };
      setSession(nextSession);
      setAuthNotice('Сессия восстановлена. Действие повторено автоматически.');
      return nextSession;
    } catch (refreshError) {
      expireSession(
        refreshError instanceof ApiError
          ? refreshError
          : new ApiError('Сессия истекла. Войди снова.', 401, 'AUTH_REFRESH_REVOKED'),
      );
      return null;
    }
  }

  async function runSessionAction<T>(
    operation: (activeSession: SessionState) => Promise<T>,
    fallbackMessage: string,
    activeSession: SessionState | null = session,
  ): Promise<T | undefined> {
    setError(null);
    if (!activeSession) {
      return undefined;
    }

    let result: T | undefined;
    const completed = await executeSessionAction({
      session: activeSession,
      operation: async (usableSession) => {
        result = await operation(usableSession);
      },
      refreshSession: tryRefreshSession,
      onError: (message) => {
        setError(message);
      },
      fallbackMessage,
    });

    return completed ? result : undefined;
  }

  async function loadAdminData(activeSession: SessionState) {
    const [report, stockReport, company, products, categories, movements, users, auditLogs] = await Promise.all([
      fetchDailyReport(activeSession.accessToken, {
        date: reportFilters.date,
      }),
      fetchStockReport(activeSession.accessToken, {
        search: reportFilters.stockSearch || undefined,
        categoryId: reportFilters.stockCategoryId || undefined,
        lowOnly: reportFilters.lowOnly,
      }),
      fetchCompany(activeSession.accessToken),
      fetchProducts(activeSession.accessToken),
      fetchCategories(activeSession.accessToken),
      fetchMovements(activeSession.accessToken),
      activeSession.user.role === 'OWNER' ? fetchUsers(activeSession.accessToken) : Promise.resolve([]),
      activeSession.user.role === 'OWNER'
        ? fetchAuditLogs(activeSession.accessToken, {
            userId: auditFilters.userId || undefined,
            entityType: auditFilters.entityType || undefined,
            action: auditFilters.action || undefined,
          })
        : Promise.resolve([]),
    ]);

    setData({
      report,
      stockReport,
      company,
      users,
      products: sortProducts(products),
      categories,
      movements,
      auditLogs,
    });
  }

  async function refreshAdminData(activeSession: SessionState = session as SessionState) {
    setLoading(true);
    setError(null);

    try {
      const loaded = await runSessionAction(
        (usableSession) => loadAdminData(usableSession),
        'Не удалось загрузить admin данные',
        activeSession,
      );
      if (loaded === undefined && !session) {
        return;
      }
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Не удалось загрузить admin данные');
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    persistStoredSession(session);
  }, [session]);

  useEffect(() => {
    if (!session) {
      setData(null);
      return;
    }

    void refreshAdminData(session);
  }, [session, reportFilters, auditFilters]);

  const lowStockCount = useMemo(
    () => data?.products.filter((item) => Number(item.currentStock) <= Number(item.minStock)).length ?? 0,
    [data],
  );

  if (!session) {
    return (
      <div className="app-shell">
        <div className="auth-layout">
          <section className="hero-card">
            <div className="section-label">NexusSklad</div>
            <h1>Панель владельца и менеджера</h1>
            <p>
              Здесь собраны управление компанией, командой, отчетами и важными изменениями.
              Мобильное приложение остается рабочим инструментом, а веб-панель — контуром контроля.
            </p>
            <div className="stack" style={{ maxWidth: 420 }}>
              <div className="badge">Тестовый доступ: {DEMO_EMAIL}</div>
              <div className="badge">Вход по email и паролю</div>
            </div>
          </section>
          <section className="auth-card">
            <div className="section-label">Вход</div>
            <h2 style={{ marginTop: 0 }}>Открыть панель управления</h2>
            <LoginForm onSubmit={handleLogin} loading={loading} error={error} notice={authNotice} />
            <div className="notice" style={{ marginTop: 16 }}>
              Тестовый вход: `owner@nexussklad.local / demo-owner-123`.
            </div>
          </section>
        </div>
      </div>
    );
  }

  return (
    <div className="app-shell">
      <div className="topbar">
        <aside className="sidebar">
          <div>
            <div className="section-label" style={{ color: 'rgba(255,249,235,0.72)' }}>NexusSklad</div>
            <h1 className="brand-title">Панель<br />контроля</h1>
            <p className="brand-subtitle">{session.user.company.name}</p>
          </div>
          <div className="nav-list">
            <NavButton active={view === 'dashboard'} onClick={() => setView('dashboard')} label="Обзор" />
            <NavButton active={view === 'products'} onClick={() => setView('products')} label="Товары" />
            <NavButton active={view === 'movements'} onClick={() => setView('movements')} label="Движения" />
            <NavButton active={view === 'inventory'} onClick={() => setView('inventory')} label="Инвентаризация" />
            <NavButton active={view === 'team'} onClick={() => setView('team')} label="Компания и команда" />
            <NavButton active={view === 'reports'} onClick={() => setView('reports')} label="Экспорт и отчеты" />
            {isOwner ? <NavButton active={view === 'audit'} onClick={() => setView('audit')} label="Аудит" /> : null}
          </div>
          <div className="surface" style={{ background: 'rgba(255,249,235,0.08)', color: '#fff9eb' }}>
            <div className="section-label" style={{ color: 'rgba(255,249,235,0.68)' }}>Профиль</div>
            <strong>{session.user.name}</strong>
            <div className="muted" style={{ color: 'rgba(255,249,235,0.72)' }}>{formatRoleLabel(session.user.role)}</div>
            <button className="button-secondary" style={{ marginTop: 14 }} onClick={() => setSession(null)}>
              Выйти
            </button>
          </div>
        </aside>
        <main className="main-column">
          <section className="header-card">
            <div className="toolbar-title">
              <div className="section-label">Контроль</div>
              <h2 style={{ margin: 0 }}>{session.user.company.name}</h2>
              <p className="muted" style={{ marginBottom: 0 }}>
                Панель владельца и менеджера. Здесь удобнее редактировать компанию, команду и справочники.
              </p>
            </div>
            <div className="toolbar-actions">
              <div className="badge">Веб-панель</div>
              <button className="button-ghost" disabled={loading} onClick={() => void refreshAdminData()}>
                {loading ? 'Обновление...' : 'Обновить данные'}
              </button>
            </div>
          </section>

          {error ? (
            <InlineState
              tone="error"
              title="Ошибка загрузки панели"
              message={error}
              actionLabel="Повторить"
              onAction={() => void refreshAdminData()}
            />
          ) : null}
          {authNotice && !error ? (
            <InlineSessionNotice
              message={authNotice}
              onDismiss={() => setAuthNotice(null)}
            />
          ) : null}
          {loading && !data ? <div className="notice">Загрузка данных...</div> : null}

          {data ? (
            <>
              {view === 'dashboard' ? (
                <DashboardView
                  report={data.report}
                  selectedDate={reportFilters.date}
                  onDateChange={(date) => setReportFilters((current) => ({ ...current, date }))}
                  lowStockCount={lowStockCount}
                  movementCount={data.movements.length}
                  productCount={data.products.length}
                />
              ) : null}

              {view === 'products' ? (
                <ProductsView
                  isOwner={Boolean(isOwner)}
                  canManage={canManageProducts}
                  products={data.products}
                  categories={data.categories}
                  onCreateCategory={() => setCategoryModal(null)}
                  onEditCategory={(category) => setCategoryModal(category)}
                  onCreate={() => setProductModal(null)}
                  onEdit={(product) => setProductModal(product)}
                  onDeleteProduct={async (product) => {
                    if (!session || !isOwner) return;
                    const deleted = await executeConfirmedSessionAction({
                      confirm: window.confirm,
                      confirmMessage: `Удалить товар "${product.name}"?\n\nЭто действие необратимо. Если товар уже используется в работе, лучше сначала проверь связанные движения и остатки.`,
                      session,
                      operation: async (usableSession) => {
                        await deleteProduct(usableSession.accessToken, product.id);
                        await refreshAdminData(usableSession);
                      },
                      refreshSession: tryRefreshSession,
                      onError: (message) => setError(message),
                      fallbackMessage: 'Не удалось удалить товар',
                    });
                    if (!deleted) return;
                  }}
                  onDeleteCategory={async (category) => {
                    if (!session || !isOwner) return;
                    const deleted = await executeConfirmedSessionAction({
                      confirm: window.confirm,
                      confirmMessage: `Удалить категорию "${category.name}"?\n\nЭто действие необратимо. Перед удалением проверь, что в категории не осталось нужных товаров.`,
                      session,
                      operation: async (usableSession) => {
                        await deleteCategory(usableSession.accessToken, category.id);
                        await refreshAdminData(usableSession);
                      },
                      refreshSession: tryRefreshSession,
                      onError: (message) => setError(message),
                      fallbackMessage: 'Не удалось удалить категорию',
                    });
                    if (!deleted) return;
                  }}
                  onExportProducts={() => {
                    if (!data) return;
                    downloadCsv(
                      'nexussklad-products.csv',
                      [
                        ['name', 'sku', 'barcode', 'category', 'unit', 'currentStock', 'minStock'],
                        ...data.products.map((item) => [
                          item.name,
                          item.sku ?? '',
                          item.barcode ?? '',
                          item.category?.name ?? '',
                          item.unit,
                          item.currentStock,
                          item.minStock,
                        ]),
                      ],
                    );
                  }}
                />
              ) : null}

              {view === 'movements' ? (
                <MovementsView
                  products={data.products}
                  movements={data.movements}
                  canAdjust={canAdjust(session.user.role)}
                  onCreate={(kind) => setMovementModal(kind)}
                  onExport={() => {
                    downloadCsv(
                      'nexussklad-movements.csv',
                      [
                        ['type', 'product', 'actor', 'quantity', 'beforeQty', 'afterQty', 'createdAt'],
                        ...data.movements.map((item) => [
                          item.movementType,
                          item.product.name,
                          item.createdBy.name,
                          item.quantity,
                          item.beforeQty,
                          item.afterQty,
                          item.createdAt,
                        ]),
                      ],
                    );
                  }}
                />
              ) : null}

              {view === 'inventory' ? (
                <InventoryView
                  report={data.report}
                  stockReport={data.stockReport}
                  categories={data.categories}
                  filters={reportFilters}
                  canManage={Boolean(canManageInventory)}
                  onChangeFilters={(next) => setReportFilters((current) => ({ ...current, ...next }))}
                  onStart={async () => {
                    if (!session || !canManageInventory) return;
                    const inventory = await runSessionAction(
                      async (usableSession) => {
                        const nextInventory = await startInventory(usableSession.accessToken);
                        await refreshAdminData(usableSession);
                        return nextInventory;
                      },
                      'Не удалось запустить инвентаризацию',
                      session,
                    );
                    if (!inventory) return;
                    setSelectedInventory(inventory);
                  }}
                  onOpenSession={async (inventoryId) => {
                    if (!session) return;
                    const inventory = await runSessionAction(
                      (usableSession) => fetchInventorySession(usableSession.accessToken, inventoryId),
                      'Не удалось открыть инвентаризацию',
                      session,
                    );
                    if (!inventory) return;
                    setSelectedInventory(inventory);
                  }}
                  onExportStock={() => {
                    downloadCsv(
                      'nexussklad-stock-report.csv',
                      [
                        ['name', 'sku', 'category', 'unit', 'currentStock', 'minStock', 'isLowStock'],
                        ...data.stockReport.items.map((item) => [
                          item.name,
                          item.sku ?? '',
                          item.category?.name ?? '',
                          item.unit,
                          item.currentStock,
                          item.minStock,
                          item.isLowStock ? 'yes' : 'no',
                        ]),
                      ],
                    );
                  }}
                />
              ) : null}

              {view === 'team' ? (
                <TeamView
                  company={data.company}
                  users={data.users}
                  isOwner={Boolean(isOwner)}
                  onEditCompany={() => setCompanyModalOpen(true)}
                  onInvite={() => setInviteOpen(true)}
                  onEditUser={(user) => setEditingUser(user)}
                />
              ) : null}

              {view === 'reports' ? (
                <ReportingView
                  report={data.report}
                  stockReport={data.stockReport}
                  categories={data.categories}
                  movements={data.movements}
                  products={data.products}
                  auditLogs={data.auditLogs}
                  canSeeAudit={Boolean(isOwner)}
                  reportFilters={reportFilters}
                  auditFilters={auditFilters}
                  onExportProducts={() => {
                    downloadCsv(
                      buildExportFileName('products-catalog', []),
                      [
                        ['name', 'sku', 'barcode', 'category', 'unit', 'currentStock', 'minStock'],
                        ...data.products.map((item) => [
                          item.name,
                          item.sku ?? '',
                          item.barcode ?? '',
                          item.category?.name ?? '',
                          item.unit,
                          item.currentStock,
                          item.minStock,
                        ]),
                      ],
                    );
                  }}
                  onExportMovements={() => {
                    downloadCsv(
                      buildExportFileName('movements-journal', reportFilters.date ? [reportFilters.date] : []),
                      [
                        ['type', 'product', 'actor', 'quantity', 'beforeQty', 'afterQty', 'createdAt'],
                        ...data.movements.map((item) => [
                          item.movementType,
                          item.product.name,
                          item.createdBy.name,
                          item.quantity,
                          item.beforeQty,
                          item.afterQty,
                          item.createdAt,
                        ]),
                      ],
                    );
                  }}
                  onExportStock={() => {
                    downloadCsv(
                      buildExportFileName('stock-report', collectReportFilterTokens(reportFilters, data.categories)),
                      [
                        ['name', 'sku', 'category', 'unit', 'currentStock', 'minStock', 'isLowStock'],
                        ...data.stockReport.items.map((item) => [
                          item.name,
                          item.sku ?? '',
                          item.category?.name ?? '',
                          item.unit,
                          item.currentStock,
                          item.minStock,
                          item.isLowStock ? 'yes' : 'no',
                        ]),
                      ],
                    );
                  }}
                  onExportAudit={() => {
                    downloadCsv(
                      buildExportFileName('audit-trail', collectAuditFilterTokens(auditFilters, data.users)),
                      [
                        ['createdAt', 'action', 'entityType', 'entityId', 'user', 'role', 'payload'],
                        ...data.auditLogs.map((item) => [
                          item.createdAt,
                          item.action,
                          item.entityType,
                          item.entityId ?? '',
                          item.user.name,
                          item.user.role,
                          item.payload ? JSON.stringify(item.payload) : '',
                        ]),
                      ],
                    );
                  }}
                />
              ) : null}

              {view === 'audit' ? (
                <AuditView
                  logs={data.auditLogs}
                  filters={auditFilters}
                  users={data.users}
                  onChangeFilters={(next) => setAuditFilters((current) => ({ ...current, ...next }))}
                  onClearFilters={() => setAuditFilters({ userId: '', entityType: '', action: '' })}
                  onExport={() => {
                    downloadCsv(
                      buildExportFileName('audit-trail', collectAuditFilterTokens(auditFilters, data.users)),
                      [
                        ['createdAt', 'action', 'entityType', 'entityId', 'user', 'role', 'payload'],
                        ...data.auditLogs.map((item) => [
                          item.createdAt,
                          item.action,
                          item.entityType,
                          item.entityId ?? '',
                          item.user.name,
                          item.user.role,
                          item.payload ? JSON.stringify(item.payload) : '',
                        ]),
                      ],
                    );
                  }}
                />
              ) : null}
            </>
          ) : null}
        </main>
      </div>

      {data && productModal !== false ? (
        <ProductModal
          product={productModal || undefined}
          categories={data.categories}
          onClose={() => setProductModal(false)}
          onSubmit={async (payload) => {
            if (!session) return;
            const saved = await runSessionAction(
              async (usableSession) => {
                if (productModal) {
                  await updateProduct(usableSession.accessToken, productModal.id, payload as UpdateProductRequestDto);
                } else {
                  await createProduct(usableSession.accessToken, payload as CreateProductRequestDto);
                }
                await refreshAdminData(usableSession);
                return true;
              },
              'Не удалось сохранить товар',
              session,
            );
            if (!saved) return;
            setProductModal(false);
          }}
        />
      ) : null}

      {data && categoryModal !== false ? (
        <CategoryModal
          category={categoryModal || undefined}
          categories={data.categories}
          onClose={() => setCategoryModal(false)}
          onSubmit={async (payload) => {
            if (!session) return;
            const saved = await runSessionAction(
              async (usableSession) => {
                if (categoryModal) {
                  await updateCategory(usableSession.accessToken, categoryModal.id, payload as UpdateCategoryRequestDto & { parentId?: string | null });
                } else {
                  await createCategory(usableSession.accessToken, payload as CreateCategoryRequestDto & { parentId?: string | null });
                }
                await refreshAdminData(usableSession);
                return true;
              },
              'Не удалось сохранить категорию',
              session,
            );
            if (!saved) return;
            setCategoryModal(false);
          }}
        />
      ) : null}

      {data && movementModal ? (
        <MovementModal
          kind={movementModal}
          products={data.products}
          onClose={() => setMovementModal(null)}
          onSubmit={async (payload) => {
            if (!session) return;
            const saved = await runSessionAction(
              async (usableSession) => {
                if (movementModal === 'income') {
                  await createIncome(usableSession.accessToken, payload as { productId: string; quantity: number; comment?: string | null });
                } else if (movementModal === 'expense') {
                  await createExpense(usableSession.accessToken, payload as { productId: string; quantity: number; comment?: string | null });
                } else {
                  await createAdjustment(usableSession.accessToken, payload as { productId: string; targetQty: number; comment?: string | null });
                }
                await refreshAdminData(usableSession);
                return true;
              },
              'Не удалось сохранить движение',
              session,
            );
            if (!saved) return;
            setMovementModal(null);
          }}
        />
      ) : null}

      {data && companyModalOpen ? (
        <CompanyModal
          company={data.company}
          onClose={() => setCompanyModalOpen(false)}
          onSubmit={async (payload) => {
            if (!session) return;
            const nextSession = await runSessionAction(
              async (usableSession) => {
                await updateCompany(usableSession.accessToken, payload);
                const currentUser = await me(usableSession.accessToken);
                const updatedSession = { ...usableSession, user: currentUser };
                setSession(updatedSession);
                await refreshAdminData(updatedSession);
                return updatedSession;
              },
              'Не удалось обновить компанию',
              session,
            );
            if (!nextSession) return;
            setCompanyModalOpen(false);
          }}
        />
      ) : null}

      {inviteOpen && session ? (
        <InviteModal
          inviteToken={inviteToken}
          onClose={() => {
            setInviteOpen(false);
            setInviteToken(null);
          }}
          onSubmit={async (payload) => {
            const response = await runSessionAction(
              (usableSession) => inviteUser(usableSession.accessToken, payload as InviteUserRequestDto),
              'Не удалось создать приглашение',
              session,
            );
            if (!response) return;
            setInviteToken(response.inviteToken);
            await refreshAdminData(session);
          }}
        />
      ) : null}

      {editingUser && session ? (
        <UserModal
          user={editingUser}
          onClose={() => setEditingUser(null)}
          onSubmit={async (payload) => {
            const updated = await runSessionAction(
              async (usableSession) => {
                await updateUser(usableSession.accessToken, editingUser.id, payload);
                await refreshAdminData(usableSession);
                return true;
              },
              'Не удалось обновить сотрудника',
              session,
            );
            if (!updated) return;
            setEditingUser(null);
          }}
        />
      ) : null}

      {selectedInventory && session ? (
        <InventorySessionModal
          inventory={selectedInventory}
          canManage={Boolean(canManageInventory)}
          onClose={() => setSelectedInventory(null)}
          onUpdateItem={async (itemId, payload) => {
            const updatedItem = await runSessionAction(
              async (usableSession) => updateInventoryItem(usableSession.accessToken, selectedInventory.id, itemId, payload),
              'Не удалось обновить позицию инвентаризации',
              session,
            );
            if (!updatedItem) return;
            setSelectedInventory((current) => current ? {
              ...current,
              items: current.items.map((item) => (item.id === itemId ? updatedItem : item)),
            } : current);
            await refreshAdminData(session);
          }}
          onFinish={async () => {
            const finished = await runSessionAction(
              async (usableSession) => finishInventory(usableSession.accessToken, selectedInventory.id),
              'Не удалось завершить инвентаризацию',
              session,
            );
            if (!finished) return;
            setSelectedInventory(finished);
            await refreshAdminData(session);
          }}
        />
      ) : null}
    </div>
  );
}

export function LoginForm({
  onSubmit,
  loading,
  error,
  notice,
}: {
  onSubmit: (email: string, password: string) => Promise<void>;
  loading: boolean;
  error: string | null;
  notice: string | null;
}) {
  const [email, setEmail] = useState(DEMO_EMAIL);
  const [password, setPassword] = useState(DEMO_PASSWORD);

  return (
    <form
      className="form-stack"
      onSubmit={(event) => {
        event.preventDefault();
        void onSubmit(email, password);
      }}
    >
      <label className="field-block"><span className="field-label">Email сотрудника</span><label className="field-block"><span className="field-label">Email</span><input className="input" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="Email" /></label></label>
      <input
        className="input"
        type="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        placeholder="Пароль"
      />
      {notice ? <div className="notice">{notice}</div> : null}
      {error ? <div className="error">{error}</div> : null}
      <button className="button" disabled={loading} type="submit">
        {loading ? 'Вход...' : 'Войти'}
      </button>
    </form>
  );
}

function NavButton({ active, onClick, label }: { active: boolean; onClick: () => void; label: string }) {
  return (
    <button className={`nav-button ${active ? 'active' : ''}`} onClick={onClick}>
      {label}
    </button>
  );
}

function DashboardView({
  report,
  selectedDate,
  onDateChange,
  lowStockCount,
  movementCount,
  productCount,
}: {
  report: DailyReportDto;
  selectedDate: string;
  onDateChange: (date: string) => void;
  lowStockCount: number;
  movementCount: number;
  productCount: number;
}) {
  return (
    <>
      <section className="metrics-grid">
        <MetricCard title="Низкий остаток" value={String(lowStockCount)} tone="var(--accent-2)" />
        <MetricCard title="Движения" value={String(movementCount)} tone="var(--sky)" />
        <MetricCard title="Товары" value={String(productCount)} tone="var(--success)" />
      </section>
      <section className="table-card">
        <div className="toolbar">
          <div className="toolbar-title">
            <div className="section-label">Сводка за день</div>
            <h3 style={{ margin: 0 }}>Сессии инвентаризации и сводка по дню</h3>
          </div>
          <div className="toolbar-actions">
            <input
              className="input input-compact"
              type="date"
              value={selectedDate}
              onChange={(event) => onDateChange(event.target.value)}
            />
            <div className="badge">Дата: {report.date}</div>
          </div>
        </div>
        {report.inventory.sessions.length === 0 ? (
          <InlineState
            title="За выбранный день операций нет"
            message="Проведи приход, расход или инвентаризацию, чтобы сводка за день начала заполняться."
          />
        ) : (
          <table>
            <thead>
              <tr>
                <th>Сессия</th>
                <th>Статус</th>
                <th>Сотрудник</th>
                <th>Позиций</th>
              </tr>
            </thead>
            <tbody>
              {report.inventory.sessions.map((session) => (
                <tr key={session.id}>
                  <td>{session.id.slice(0, 8)}</td>
                  <td>{formatInventoryStatusLabel(session.status)}</td>
                  <td>{session.startedBy.name}</td>
                  <td>{session._count.items}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </>
  );
}

function MetricCard({ title, value, tone }: { title: string; value: string; tone: string }) {
  return (
    <article className="metric-card">
      <div className="section-label">{title}</div>
      <strong style={{ color: tone }}>{value}</strong>
    </article>
  );
}

export function InlineState({
  title,
  message,
  actionLabel,
  onAction,
  tone = 'notice',
}: {
  title: string;
  message: string;
  actionLabel?: string;
  onAction?: () => void;
  tone?: 'notice' | 'error';
}) {
  return (
    <section className={tone === 'error' ? 'error state-block' : 'notice state-block'}>
      <div>
        <strong>{title}</strong>
        <div style={{ marginTop: 6 }}>{message}</div>
      </div>
      {actionLabel && onAction ? (
        <button className="button-ghost" onClick={onAction}>
          {actionLabel}
        </button>
      ) : null}
    </section>
  );
}

export function InlineSessionNotice({
  message,
  onDismiss,
}: {
  message: string;
  onDismiss: () => void;
}) {
  return (
    <section className="session-notice">
      <div>
        <strong>Сессия восстановлена</strong>
        <div style={{ marginTop: 6 }}>{message}</div>
      </div>
      <button className="button-ghost" onClick={onDismiss}>
        Скрыть
      </button>
    </section>
  );
}

export function ProductsView({
  isOwner,
  products,
  categories,
  canManage,
  onCreate,
  onEdit,
  onCreateCategory,
  onEditCategory,
  onDeleteProduct,
  onDeleteCategory,
  onExportProducts,
}: {
  isOwner: boolean;
  products: ProductDto[];
  categories: CategoryDto[];
  canManage: boolean;
  onCreate: () => void;
  onEdit: (product: ProductDto) => void;
  onCreateCategory: () => void;
  onEditCategory: (category: CategoryDto) => void;
  onDeleteProduct: (product: ProductDto) => void;
  onDeleteCategory: (category: CategoryDto) => void;
  onExportProducts: () => void;
}) {
  const lowStockProducts = products.filter((product) => Number(product.currentStock) <= Number(product.minStock)).length;
  const uncategorizedProducts = products.filter((product) => !product.categoryId).length;
  const rootCategories = categories.filter((category) => !category.parentId).length;

  return (
    <>
      <section className="table-card">
        <div className="toolbar">
          <div className="toolbar-title">
            <div className="section-label">Справочник</div>
            <h3 style={{ margin: 0 }}>Товары</h3>
          </div>
          <div className="toolbar-actions">
            <button className="button-ghost" onClick={onExportProducts}>Экспорт CSV</button>
            {canManage ? <button className="button" onClick={onCreate}>Новый товар</button> : null}
          </div>
        </div>
        <div className="toolbar audit-insights">
          <div className="badge">Товаров: {products.length}</div>
          <div className={`badge ${lowStockProducts > 0 ? 'warn' : ''}`}>Низкий остаток: {lowStockProducts}</div>
          <div className={`badge ${uncategorizedProducts > 0 ? 'warn' : ''}`}>Без категории: {uncategorizedProducts}</div>
        </div>
        {products.length === 0 ? (
          <InlineState
            title="Товаров пока нет"
            message={
              canManage
                ? 'Создай первый товар, чтобы открыть движения, инвентаризацию и отчеты.'
                : 'Владелец или менеджер должны сначала завести товары.'
            }
            actionLabel={canManage ? 'Создать товар' : undefined}
            onAction={canManage ? onCreate : undefined}
          />
        ) : (
          <table>
            <thead>
              <tr>
                <th>Название</th>
                <th>Категория</th>
                <th>Остаток</th>
                <th>Мин. остаток</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {products.map((product) => {
                const low = Number(product.currentStock) <= Number(product.minStock);
                return (
                  <ProductTableRow
                    key={product.id}
                    product={product}
                    low={low}
                    canManage={canManage}
                    isOwner={isOwner}
                    onEdit={() => onEdit(product)}
                    onDelete={() => onDeleteProduct(product)}
                  />
                );
              })}
            </tbody>
          </table>
        )}
      </section>
      <section className="table-card">
        <div className="toolbar">
          <div>
            <div className="section-label">Структура</div>
            <h3 style={{ margin: 0 }}>Категории</h3>
          </div>
          <div className="toolbar-actions">
            {canManage ? <button className="button" onClick={onCreateCategory}>Новая категория</button> : null}
          </div>
        </div>
        <div className="toolbar audit-insights">
          <div className="badge">Категорий: {categories.length}</div>
          <div className="badge">Корневых: {rootCategories}</div>
        </div>
        {categories.length === 0 ? (
          <InlineState
            title="Категории пока не созданы"
            message="Можно работать и без категорий, но структура каталога и фильтры будут слабее."
            actionLabel={canManage ? 'Создать категорию' : undefined}
            onAction={canManage ? onCreateCategory : undefined}
          />
        ) : (
          <table>
            <thead>
              <tr>
                <th>Название</th>
                <th>Родительская категория</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {categories.map((category) => (
                <tr key={category.id}>
                  <td>{category.name}</td>
                  <td>{categories.find((item) => item.id === category.parentId)?.name ?? '—'}</td>
                  <td>
                    <div className="actions-row">
                      {canManage ? <button className="button-ghost" onClick={() => onEditCategory(category)}>Редактировать</button> : null}
                      {isOwner ? <button className="button-danger" onClick={() => onDeleteCategory(category)}>Удалить</button> : null}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </>
  );
}

export function MovementsView({
  products,
  movements,
  canAdjust,
  onCreate,
  onExport,
}: {
  products: ProductDto[];
  movements: StockMovementDto[];
  canAdjust: boolean;
  onCreate: (kind: 'income' | 'expense' | 'adjustment') => void;
  onExport: () => void;
}) {
  const movementTypeCounts = movements.reduce<Record<string, number>>((acc, movement) => {
    acc[movement.movementType] = (acc[movement.movementType] ?? 0) + 1;
    return acc;
  }, {});

  return (
    <section className="table-card">
      <div className="toolbar">
        <div className="toolbar-title">
          <div className="section-label">Операции</div>
          <h3 style={{ margin: 0 }}>Движения склада</h3>
        </div>
        <div className="toolbar-actions">
          <button className="button" onClick={() => onCreate('income')}>Приход</button>
          <button className="button-secondary" onClick={() => onCreate('expense')}>Расход</button>
          {canAdjust ? <button className="button-ghost" onClick={() => onCreate('adjustment')}>Корректировка</button> : null}
          <button className="button-ghost" onClick={onExport}>Экспорт CSV</button>
        </div>
      </div>
        <div className="toolbar audit-insights">
          <div className="badge">Записей: {movements.length}</div>
          <div className="badge">Приходов: {movementTypeCounts.INCOME ?? 0}</div>
          <div className="badge">Расходов: {movementTypeCounts.EXPENSE ?? 0}</div>
          {canAdjust ? <div className="badge">Корректировок: {movementTypeCounts.ADJUSTMENT ?? 0}</div> : null}
        </div>
      {movements.length === 0 ? (
        <InlineState
          title="Движений пока нет"
          message={
            products.length === 0
              ? 'Сначала заведи товар, затем приходы и расходы начнут формировать журнал.'
              : 'Сделай первый приход или расход, чтобы журнал начал наполняться.'
          }
          actionLabel={products.length > 0 ? 'Создать приход' : undefined}
          onAction={products.length > 0 ? () => onCreate('income') : undefined}
        />
      ) : (
        <table>
          <thead>
            <tr>
              <th>Тип</th>
              <th>Товар</th>
              <th>Сотрудник</th>
              <th>Кол-во</th>
            </tr>
          </thead>
          <tbody>
            {movements.map((movement) => (
              <MovementTableRow key={movement.id} movement={movement} />
            ))}
          </tbody>
        </table>
      )}
    </section>
  );
}

export function InventoryView({
  report,
  stockReport,
  categories,
  filters,
  canManage,
  onChangeFilters,
  onStart,
  onOpenSession,
  onExportStock,
}: {
  report: DailyReportDto;
  stockReport: StockReportDto;
  categories: CategoryDto[];
  filters: ReportFiltersState;
  canManage: boolean;
  onChangeFilters: (next: Partial<ReportFiltersState>) => void;
  onStart: () => void;
  onOpenSession: (inventoryId: string) => void;
  onExportStock: () => void;
}) {
  const reportFilterBadges = collectReportFilterBadges(filters, categories);
  const draftSessions = report.inventory.sessions.filter((session) => session.status !== 'COMPLETED').length;
  const completedSessions = report.inventory.sessions.filter((session) => session.status === 'COMPLETED').length;
  const hasActiveStockFilters = Boolean(filters.stockSearch || filters.stockCategoryId || filters.lowOnly);
  return (
    <>
      <section className="metrics-grid">
        <MetricCard title="Сессии сегодня" value={String(report.inventory.sessionsCount)} tone="var(--accent)" />
        <MetricCard title="Низкий остаток" value={String(stockReport.summary.lowStockItems)} tone="var(--accent-2)" />
        <MetricCard title="Позиции в отчете" value={String(stockReport.summary.totalItems)} tone="var(--sky)" />
      </section>

      <section className="table-card">
        <div className="toolbar">
          <div className="toolbar-title">
            <div className="section-label">Инвентаризация</div>
            <h3 style={{ margin: 0 }}>Сессии за день</h3>
          </div>
          <div className="toolbar-actions">
            {canManage ? <button className="button" onClick={onStart}>Запустить сессию</button> : null}
            <div className="badge">Сегодня: {report.date}</div>
          </div>
        </div>
        <div className="toolbar audit-insights">
          <div className="badge">Черновики: {draftSessions}</div>
          <div className="badge">Завершено: {completedSessions}</div>
        </div>
        {report.inventory.sessions.length === 0 ? (
          <InlineState
            title="За сегодня сессий инвентаризации нет"
            message="Запусти первую сессию, чтобы зафиксировать фактические остатки и сверить расхождения."
            actionLabel={canManage ? 'Запустить сессию' : undefined}
            onAction={canManage ? onStart : undefined}
          />
        ) : (
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Статус</th>
                <th>Сотрудник</th>
                <th>Позиций</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {report.inventory.sessions.map((session) => (
                <InventorySessionRow
                  key={session.id}
                  session={session}
                  onOpen={() => onOpenSession(session.id)}
                />
              ))}
            </tbody>
          </table>
        )}
      </section>

      <section className="table-card">
        <div className="toolbar">
          <div className="toolbar-title">
            <div className="section-label">Отчет</div>
            <h3 style={{ margin: 0 }}>Отчет по остаткам</h3>
          </div>
          <div className="toolbar-actions">
            <button className="button-ghost" onClick={onExportStock}>Экспорт CSV</button>
          </div>
        </div>
        <div className="reporting-context-grid stock-report-context-grid">
          <ContextBadgeRow
            title="Контекст отчета"
            badges={reportFilterBadges.filter((badge) => badge !== `Дата: ${filters.date}`)}
            emptyLabel="Без дополнительных фильтров"
          />
          <ContextBadgeRow
            title="Сводка отчета"
            badges={[
              `Низкий остаток: ${stockReport.summary.lowStockItems}`,
              `Позиции в отчете: ${stockReport.summary.totalItems}`,
            ]}
            emptyLabel="Сводка отчета пока не собрана"
          />
        </div>
        <div className="filter-panel stock-filter-panel">
          <div className="toolbar-actions toolbar-filters">
            <input
              className="input input-compact"
              value={filters.stockSearch}
              onChange={(event) => onChangeFilters({ stockSearch: event.target.value })}
              placeholder="Поиск по товару / SKU"
            />
            <select
              className="select input-compact"
              value={filters.stockCategoryId}
              onChange={(event) => onChangeFilters({ stockCategoryId: event.target.value })}
            >
              <option value="">Все категории</option>
              {categories.map((category) => (
                <option key={category.id} value={category.id}>{category.name}</option>
              ))}
            </select>
            <label className="badge">
              <input
                type="checkbox"
                checked={filters.lowOnly}
                onChange={(event) => onChangeFilters({ lowOnly: event.target.checked })}
              />
              Только низкий остаток
            </label>
            {hasActiveStockFilters ? (
              <button
                className="button-ghost"
                onClick={() => onChangeFilters({ stockSearch: '', stockCategoryId: '', lowOnly: false })}
              >
                Сбросить фильтры
              </button>
            ) : null}
          </div>
        </div>
        {stockReport.items.length === 0 ? (
          <InlineState
            title="По текущим фильтрам позиций нет"
            message="Сними фильтры или добавь товары, чтобы увидеть отчет по остаткам."
          />
        ) : (
          <table>
            <thead>
              <tr>
                <th>Товар</th>
                <th>Категория</th>
                <th>Остаток</th>
                <th>Мин. остаток</th>
              </tr>
            </thead>
            <tbody>
              {stockReport.items.map((item) => (
                <StockReportRow key={item.id} item={item} />
              ))}
            </tbody>
          </table>
        )}
      </section>
    </>
  );
}

export function TeamView({
  company,
  users,
  isOwner,
  onEditCompany,
  onInvite,
  onEditUser,
}: {
  company: CompanyDto;
  users: CompanyUserDto[];
  isOwner: boolean;
  onEditCompany: () => void;
  onInvite: () => void;
  onEditUser: (user: CompanyUserDto) => void;
}) {
  const activeUsers = users.filter((user) => user.isActive).length;
  const inactiveUsers = users.length - activeUsers;
  const managers = users.filter((user) => user.role === 'MANAGER').length;
  const staff = users.filter((user) => user.role === 'STAFF').length;

  return (
    <>
      <CompanyPanel company={company} isOwner={isOwner} onEditCompany={onEditCompany} />
      <section className="table-card">
        <div className="toolbar">
          <div className="toolbar-title">
            <div className="section-label">Команда</div>
            <h3 style={{ margin: 0 }}>Команда и приглашения</h3>
          </div>
          {isOwner ? <button className="button" onClick={onInvite}>Пригласить</button> : null}
        </div>
        {isOwner ? (
          <div className="toolbar audit-insights">
            <div className="badge">Сотрудников: {users.length}</div>
            <div className="badge">Активных: {activeUsers}</div>
            <div className="badge">Менеджеров: {managers}</div>
            <div className="badge">Сотрудников склада: {staff}</div>
            {inactiveUsers > 0 ? <div className="badge warn">Неактивных: {inactiveUsers}</div> : null}
          </div>
        ) : null}
        {isOwner ? (
          users.length === 0 ? (
            <InlineState
              title="Команда пока не заполнена"
              message="В компании пока нет сотрудников кроме владельца."
              actionLabel="Пригласить сотрудника"
              onAction={onInvite}
            />
          ) : (
            <table>
              <thead>
                <tr>
                  <th>Имя</th>
                  <th>Email</th>
                  <th>Роль</th>
                  <th>Статус</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {users.map((user) => (
                  <TeamUserRow
                    key={user.id}
                    user={user}
                    onEdit={() => onEditUser(user)}
                  />
                ))}
              </tbody>
            </table>
          )
        ) : (
          <InlineState
            title="Раздел владельца"
            message="Управление компанией, ролями и сотрудниками доступно только владельцу. Менеджер и сотрудник работают без этих административных действий."
          />
        )}
      </section>
    </>
  );
}

export function CompanyPanel({
  company,
  isOwner,
  onEditCompany,
}: {
  company: CompanyDto;
  isOwner: boolean;
  onEditCompany: () => void;
}) {
  const completenessBadges = [
    company.city ? `Город: ${company.city}` : 'Город не заполнен',
    company.phone ? `Телефон: ${company.phone}` : 'Телефон не заполнен',
    `Создана: ${new Date(company.createdAt).toLocaleDateString('ru-RU')}`,
  ];

  return (
    <section className="surface">
      <div className="toolbar">
        <div className="toolbar-title">
          <div className="section-label">Компания</div>
          <h3 style={{ margin: 0 }}>{company.name}</h3>
          <p className="muted">
            {[company.city, company.phone].filter(Boolean).join(' · ') || 'Данные еще не заполнены'}
          </p>
        </div>
        {isOwner ? (
          <button className="button-ghost" onClick={onEditCompany}>
            Редактировать компанию
          </button>
        ) : null}
      </div>
      <div className="toolbar audit-insights">
        {completenessBadges.map((badge) => (
          <div key={badge} className={`badge ${badge.includes('не заполнен') ? 'warn' : ''}`}>{badge}</div>
        ))}
      </div>
    </section>
  );
}

export function ProductTableRow({
  product,
  low,
  canManage,
  isOwner,
  onEdit,
  onDelete,
}: {
  product: ProductDto;
  low: boolean;
  canManage: boolean;
  isOwner: boolean;
  onEdit: () => void;
  onDelete: () => void;
}) {
  return (
    <tr>
      <td>
        <strong>{product.name}</strong>
        <div className="muted">{product.sku ?? 'без SKU'}</div>
      </td>
      <td>{product.category?.name ?? 'Без категории'}</td>
      <td>
        <span className={`badge ${low ? 'low' : ''}`}>
          {product.currentStock} {product.unit}
        </span>
      </td>
      <td>{product.minStock}</td>
      <td>
        <div className="actions-row">
          {canManage ? (
            <button className="button-ghost" onClick={onEdit}>
              Редактировать
            </button>
          ) : null}
          {isOwner ? (
            <button className="button-danger" onClick={onDelete}>
              Удалить
            </button>
          ) : null}
        </div>
      </td>
    </tr>
  );
}

export function TeamUserRow({
  user,
  onEdit,
}: {
  user: CompanyUserDto;
  onEdit: () => void;
}) {
  return (
    <tr>
      <td>{user.name}</td>
      <td>{user.email ?? '—'}</td>
      <td>{formatRoleLabel(user.role)}</td>
      <td>
        <span className={`badge ${!user.isActive ? 'warn' : ''}`}>
          {user.isActive ? 'Активен' : 'Неактивен'}
        </span>
      </td>
      <td>
        <button className="button-ghost" onClick={onEdit}>
          Редактировать
        </button>
      </td>
    </tr>
  );
}

export function ReportingView({
  report,
  stockReport,
  categories,
  movements,
  products,
  auditLogs,
  canSeeAudit,
  reportFilters,
  auditFilters,
  onExportProducts,
  onExportMovements,
  onExportStock,
  onExportAudit,
}: {
  report: DailyReportDto;
  stockReport: StockReportDto;
  categories: CategoryDto[];
  movements: StockMovementDto[];
  products: ProductDto[];
  auditLogs: AuditLogDto[];
  canSeeAudit: boolean;
  reportFilters: ReportFiltersState;
  auditFilters: AuditFiltersState;
  onExportProducts: () => void;
  onExportMovements: () => void;
  onExportStock: () => void;
  onExportAudit: () => void;
}) {
  const reportFilterBadges = collectReportFilterBadges(reportFilters, categories);
  const auditFilterBadges = collectAuditFilterBadges(auditFilters);
  const dailyInsightBadges = [
    `Приход: ${report.movementSummary.INCOME?.count ?? 0}`,
    `Расход: ${report.movementSummary.EXPENSE?.count ?? 0}`,
    `Корр.: ${report.movementSummary.ADJUSTMENT?.count ?? 0}`,
    `Расхождения: ${report.movementSummary.INVENTORY_DIFF?.count ?? 0}`,
    `Сессии: ${report.inventory.sessionsCount}`,
    `Низкий остаток: ${report.stock.lowStockCount}`,
  ];
  return (
    <>
      <section className="metrics-grid">
        <MetricCard title="Экспорт товаров" value={String(products.length)} tone="var(--sky)" />
        <MetricCard title="Экспорт движений" value={String(movements.length)} tone="var(--success)" />
        <MetricCard title="Низкий остаток" value={String(stockReport.summary.lowStockItems)} tone="var(--accent-2)" />
      </section>

      <section className="table-card">
        <div className="toolbar">
          <div className="toolbar-title">
            <div className="section-label">Отчеты и экспорт</div>
            <h3 style={{ margin: 0 }}>Центр выгрузок</h3>
          </div>
          <div className="badge">Дата сводки: {report.date}</div>
        </div>
        <div className="context-stack reporting-context-stack">
          <div className="reporting-context-grid">
            <ContextBadgeRow
              title="Контекст отчета"
              badges={reportFilterBadges}
              emptyLabel="Без дополнительных фильтров"
            />
            {canSeeAudit ? (
              <ContextBadgeRow
                title="Контекст журнала"
                badges={auditFilterBadges}
                emptyLabel="Выгрузка журнала без фильтров"
              />
            ) : null}
          </div>
          <ContextBadgeRow
            title="Сводка дня"
            badges={dailyInsightBadges}
            emptyLabel="За день операций нет"
          />
        </div>
        <div className="reporting-grid">
          <ExportCard
            title="Товары"
            description={`Текущий каталог и остатки. Позиции: ${products.length}.`}
            detail={buildExportFileName('products-catalog', [])}
            actionLabel="Экспорт каталога"
            onClick={onExportProducts}
          />
          <ExportCard
            title="Движения"
            description={`История движений по складу. Записей: ${movements.length}.`}
            detail={buildExportFileName('movements-journal', reportFilters.date ? [report.date] : [])}
            actionLabel="Экспорт журнала"
            onClick={onExportMovements}
          />
          <ExportCard
            title="Отчет по остаткам"
            description={`Срез по остаткам и зонам риска. Позиции: ${stockReport.summary.totalItems}.`}
            detail={buildExportFileName('stock-report', collectReportFilterTokens(reportFilters, categories))}
            actionLabel="Экспорт отчета"
            onClick={onExportStock}
          />
          {canSeeAudit ? (
            <ExportCard
              title="Журнал изменений"
              description={`Журнал важных действий владельца и команды. Записей: ${auditLogs.length}.`}
              detail={buildExportFileName('audit-trail', collectAuditFilterTokens(auditFilters, []))}
              actionLabel="Экспорт журнала"
              onClick={onExportAudit}
            />
          ) : null}
        </div>
        {products.length === 0 && movements.length === 0 && stockReport.items.length === 0 ? (
          <div style={{ marginTop: 16 }}>
            <InlineState
              title="Экспортировать пока нечего"
              message="Сначала заведи товары и проведи первые операции, тогда центр выгрузок станет полезным."
            />
          </div>
        ) : null}
      </section>
    </>
  );
}

export function ExportCard({
  title,
  description,
  detail,
  actionLabel,
  onClick,
}: {
  title: string;
  description: string;
  detail?: string;
  actionLabel: string;
  onClick: () => void;
}) {
  return (
    <article className="surface export-card">
      <div className="section-label">CSV</div>
      <strong>{title}</strong>
      <p className="muted" style={{ marginTop: 8 }}>{description}</p>
      {detail ? (
        <div className="export-detail">
          <span className="export-detail-label">Имя файла</span>
          <code>{detail}</code>
        </div>
      ) : null}
      <button className="button" onClick={onClick}>{actionLabel}</button>
    </article>
  );
}

export function InventorySessionRow({
  session,
  onOpen,
}: {
  session: DailyReportDto['inventory']['sessions'][number];
  onOpen: () => void;
}) {
  return (
    <tr>
      <td>{session.id.slice(0, 8)}</td>
      <td>{formatInventoryStatusLabel(session.status)}</td>
      <td>{session.startedBy.name}</td>
      <td>{session._count.items}</td>
      <td>
        <button className="button-ghost" onClick={onOpen}>
          Открыть
        </button>
      </td>
    </tr>
  );
}

export function StockReportRow({
  item,
}: {
  item: StockReportDto['items'][number];
}) {
  return (
    <tr>
      <td>
        <strong>{item.name}</strong>
        <div className="muted">{item.sku ?? 'без SKU'}</div>
      </td>
      <td>{item.category?.name ?? 'Без категории'}</td>
      <td>
        <span className={`badge ${item.isLowStock ? 'low' : ''}`}>
          {item.currentStock} {item.unit}
        </span>
      </td>
      <td>{item.minStock}</td>
    </tr>
  );
}

function InventorySessionModal({
  inventory,
  canManage,
  onClose,
  onUpdateItem,
  onFinish,
}: {
  inventory: InventorySessionDto;
  canManage: boolean;
  onClose: () => void;
  onUpdateItem: (itemId: string, payload: UpdateInventoryItemRequestDto) => Promise<void>;
  onFinish: () => Promise<void>;
}) {
  return (
    <ModalFrame title={`Инвентаризация ${inventory.id.slice(0, 8)}`} onClose={onClose}>
      <div className="stack">
        <div className="toolbar">
          <div>
            <div className="section-label">Статус</div>
            <strong>{formatInventoryStatusLabel(inventory.status)}</strong>
            <div className="muted">
              {new Date(inventory.startedAt).toLocaleString('ru-RU')}
              {inventory.finishedAt ? ` · завершена ${new Date(inventory.finishedAt).toLocaleString('ru-RU')}` : ''}
            </div>
          </div>
          {canManage && inventory.status !== 'COMPLETED' ? (
            <button className="button" onClick={() => void onFinish()}>
              Завершить сессию
            </button>
          ) : null}
        </div>

        <div className="inventory-grid">
          {inventory.items.map((item) => (
            <InventoryItemEditor
              key={item.id}
              item={item}
              disabled={inventory.status === 'COMPLETED'}
              onSave={(payload) => onUpdateItem(item.id, payload)}
            />
          ))}
        </div>
      </div>
    </ModalFrame>
  );
}

function InventoryItemEditor({
  item,
  disabled,
  onSave,
}: {
  item: InventoryItemDto;
  disabled: boolean;
  onSave: (payload: UpdateInventoryItemRequestDto) => Promise<void>;
}) {
  const [actualQty, setActualQty] = useState(item.actualQty);

  useEffect(() => {
    setActualQty(item.actualQty);
  }, [item.actualQty]);

  return (
    <article className="surface inventory-item-card">
      <div className="section-label">Позиция</div>
      <strong>{item.product.name}</strong>
      <div className="muted">{item.product.sku ?? 'без SKU'}</div>
      <div className="inventory-stats">
        <span className="badge">Ожидалось: {item.expectedQty}</span>
        <span className={`badge ${Number(item.difference) !== 0 ? 'warn' : ''}`}>Разница: {item.difference}</span>
      </div>
      <div className="grid-2">
        <input
          className="input"
          value={actualQty}
          disabled={disabled}
          onChange={(event) => setActualQty(event.target.value)}
          placeholder="Факт"
        />
        <button
          className="button"
          disabled={disabled}
          onClick={() => void onSave({ actualQty: Number(actualQty) })}
        >
          Сохранить
        </button>
      </div>
    </article>
  );
}

export function AuditView({
  logs,
  filters,
  users,
  onChangeFilters,
  onClearFilters,
  onExport,
}: {
  logs: AuditLogDto[];
  filters: AuditFiltersState;
  users: CompanyUserDto[];
  onChangeFilters: (next: Partial<AuditFiltersState>) => void;
  onClearFilters: () => void;
  onExport: () => void;
}) {
  const insights = buildAuditInsights(logs);
  const filterBadges = collectAuditFilterBadges(filters, users);
  const hasActiveFilters = filterBadges.length > 0;
  return (
    <section className="table-card">
      <div className="toolbar">
        <div className="toolbar-title">
          <div className="section-label">Журнал действий</div>
          <h3 style={{ margin: 0 }}>Журнал изменений</h3>
        </div>
        <div className="toolbar-actions">
          <button className="button-ghost" onClick={onExport}>Экспорт CSV</button>
          <div className="badge">Записей: {logs.length}</div>
        </div>
      </div>
      <div className="filter-panel audit-filter-panel">
        <select
          className="select"
          value={filters.userId}
          onChange={(event) => onChangeFilters({ userId: event.target.value })}
        >
          <option value="">Все пользователи</option>
          {users.map((user) => (
            <option key={user.id} value={user.id}>{user.name}</option>
          ))}
        </select>
        <input
          className="input"
          value={filters.entityType}
          onChange={(event) => onChangeFilters({ entityType: event.target.value })}
          placeholder="Тип сущности"
        />
        <input
          className="input"
          value={filters.action}
          onChange={(event) => onChangeFilters({ action: event.target.value })}
          placeholder="Действие"
        />
        {hasActiveFilters ? (
          <button className="button-ghost audit-filter-reset" onClick={onClearFilters}>Сбросить фильтры</button>
        ) : null}
      </div>
      <ActiveFilterChips
        title="Активные фильтры"
        badges={filterBadges}
        emptyLabel="Фильтры не заданы"
        compact
      />
      {logs.length > 0 ? (
        <CompactBadgeGroup
          title="Сводка журнала"
          badges={[
            `Пользователей в выборке: ${insights.uniqueUsers}`,
            `Сущностей в выборке: ${insights.uniqueEntities}`,
            ...(insights.topAction ? [`Чаще всего: ${formatAuditActionLabel(insights.topAction)}`] : []),
            ...(insights.topEntityType ? [`По сущности: ${formatEntityTypeLabel(insights.topEntityType)}`] : []),
          ]}
          emptyLabel="Сводка журнала пока не собрана"
        />
      ) : null}
      {logs.length === 0 ? (
        <InlineState
          title="По текущим фильтрам журнал пуст"
          message="Измени фильтры или выполни действия в панели, чтобы увидеть журнал."
        />
      ) : (
        <table>
          <thead>
            <tr>
              <th>Когда</th>
              <th>Действие</th>
              <th>Сущность</th>
              <th>Пользователь</th>
              <th>Детали</th>
            </tr>
          </thead>
          <tbody>
            {logs.map((item) => (
              <AuditLogRow key={item.id} log={item} />
            ))}
          </tbody>
        </table>
      )}
    </section>
  );
}


export function ContextBadgeRow({
  title,
  badges,
  emptyLabel,
}: {
  title: string;
  badges: string[];
  emptyLabel: string;
}) {
  return (
    <div className="context-badge-row">
      <div className="section-label">{title}</div>
      <div className="compact-badge-grid">
        {(badges.length > 0 ? badges : [emptyLabel]).map((badge) => (
          <div key={badge} className="badge badge-compact">{badge}</div>
        ))}
      </div>
    </div>
  );
}

export function ActiveFilterChips({
  title,
  badges,
  emptyLabel,
  compact = false,
}: {
  title: string;
  badges: string[];
  emptyLabel: string;
  compact?: boolean;
}) {
  return (
    <div className={`active-filter-block${compact ? ' active-filter-block-compact' : ''}`}>
      <div className="section-label">{title}</div>
      <div className={`chip-list${compact ? ' chip-list-compact' : ''}`}>
        {badges.length > 0
          ? badges.map((badge) => (
            <span key={badge} className={`badge active-filter-chip${compact ? ' badge-compact' : ''}`}>{badge}</span>
          ))
          : <span className="badge">{emptyLabel}</span>}
      </div>
    </div>
  );
}

function CompactBadgeGroup({ title, badges, emptyLabel }: { title: string; badges: string[]; emptyLabel: string }) {
  return (
    <div className="active-filter-block active-filter-block-compact">
      <div className="section-label">{title}</div>
      <div className="compact-badge-grid">
        {(badges.length > 0 ? badges : [emptyLabel]).map((badge) => (
          <span key={badge} className="badge badge-compact active-filter-chip">{badge}</span>
        ))}
      </div>
    </div>
  );
}

export function MovementTableRow({
  movement,
}: {
  movement: StockMovementDto;
}) {
  const movementLabel = movement.movementType === 'INCOME'
    ? 'Приход'
    : movement.movementType === 'EXPENSE'
      ? 'Расход'
      : movement.movementType === 'ADJUSTMENT'
        ? 'Корректировка'
        : 'Сверка';
  return (
    <tr>
      <td>{movementLabel}</td>
      <td>{movement.product.name}</td>
      <td>{movement.createdBy.name}</td>
      <td>{movement.quantity}</td>
    </tr>
  );
}

export function AuditLogRow({
  log,
}: {
  log: AuditLogDto;
}) {
  const payloadSummary = buildAuditPayloadSummary(log.payload);
  return (
    <tr>
      <td>{new Date(log.createdAt).toLocaleString('ru-RU')}</td>
      <td>{formatAuditActionLabel(log.action)}</td>
      <td>{formatEntityTypeLabel(log.entityType)}</td>
      <td>{log.user.name}</td>
      <td style={{ maxWidth: 420 }}>
        {!log.payload ? (
          '—'
        ) : (
          <div className="audit-payload-stack">
            {payloadSummary.map((item) => (
              <span key={item} className="badge">{item}</span>
            ))}
            {payloadSummary.length === 0 ? <span className="badge">Есть изменения</span> : null}
          </div>
        )}
      </td>
    </tr>
  );
}

export function ModalFrame({ title, children, onClose }: { title: string; children: ReactNode; onClose: () => void }) {
  return (
    <div className="modal-backdrop" onClick={onClose}>
      <div className="modal-card" onClick={(event) => event.stopPropagation()}>
        <div className="toolbar">
          <h3 style={{ margin: 0 }}>{title}</h3>
          <button className="button-ghost" onClick={onClose}>Закрыть</button>
        </div>
        <div style={{ marginTop: 18 }}>{children}</div>
      </div>
    </div>
  );
}

export function ProductModal({
  product,
  categories,
  onClose,
  onSubmit,
}: {
  product?: ProductDto;
  categories: { id: string; name: string }[];
  onClose: () => void;
  onSubmit: (payload: CreateProductRequestDto | UpdateProductRequestDto) => Promise<void>;
}) {
  const [name, setName] = useState(product?.name ?? '');
  const [unit, setUnit] = useState(product?.unit ?? 'шт');
  const [sku, setSku] = useState(product?.sku ?? '');
  const [barcode, setBarcode] = useState(product?.barcode ?? '');
  const [description, setDescription] = useState(product?.description ?? '');
  const [minStock, setMinStock] = useState(product?.minStock ?? '0');
  const [currentStock, setCurrentStock] = useState(product?.currentStock ?? '0');
  const [categoryId, setCategoryId] = useState(product?.categoryId ?? '');

  return (
    <ModalFrame title={product ? 'Редактировать товар' : 'Новый товар'} onClose={onClose}>
      <form className="stack" onSubmit={(event) => {
        event.preventDefault();
        void onSubmit({
          categoryId: categoryId || null,
          name,
          sku: sku || null,
          barcode: barcode || null,
          unit,
          description: description || null,
          minStock: Number(minStock),
          ...(product ? {} : { currentStock: Number(currentStock) }),
        }).then(onClose);
      }}>
        <p className="muted" style={{ margin: 0 }}>
          Заполни минимум название, единицу и минимальный остаток. SKU и штрихкод можно добавить позже.
        </p>
        <div className="grid-2">
          <label className="field-block">
            <span className="field-label">Название товара</span>
            <input className="input" value={name} onChange={(e) => setName(e.target.value)} placeholder="Например: Вода 0.5 л" />
          </label>
          <label className="field-block">
            <span className="field-label">Единица измерения</span>
            <input className="input" value={unit} onChange={(e) => setUnit(e.target.value)} placeholder="шт, кг, канистра" />
          </label>
        </div>
        <div className="grid-2">
          <label className="field-block">
            <span className="field-label">SKU</span>
            <input className="input" value={sku} onChange={(e) => setSku(e.target.value)} placeholder="Внутренний артикул" />
          </label>
          <label className="field-block">
            <span className="field-label">Штрихкод</span>
            <input className="input" value={barcode} onChange={(e) => setBarcode(e.target.value)} placeholder="Если уже есть" />
          </label>
        </div>
        <div className="grid-2">
          <label className="field-block">
            <span className="field-label">Категория</span>
            <select className="select" value={categoryId} onChange={(e) => setCategoryId(e.target.value)}>
              <option value="">Без категории</option>
              {categories.map((category) => <option key={category.id} value={category.id}>{category.name}</option>)}
            </select>
          </label>
          <label className="field-block">
            <span className="field-label">Минимальный остаток</span>
            <input className="input" type="number" inputMode="numeric" value={minStock} onChange={(e) => setMinStock(e.target.value)} placeholder="Порог предупреждения" />
          </label>
        </div>
        {!product ? (
          <label className="field-block">
            <span className="field-label">Стартовый остаток</span>
            <input className="input" type="number" inputMode="numeric" value={currentStock} onChange={(e) => setCurrentStock(e.target.value)} placeholder="Сколько сейчас на складе" />
          </label>
        ) : null}
        <label className="field-block">
          <span className="field-label">Описание</span>
          <textarea className="textarea" value={description} onChange={(e) => setDescription(e.target.value)} placeholder="Кратко опиши товар или упаковку" />
        </label>
        <div className="actions-row">
          <button className="button" type="submit">{product ? 'Обновить товар' : 'Создать товар'}</button>
        </div>
      </form>
    </ModalFrame>
  );
}

export function MovementModal({
  kind,
  products,
  onClose,
  onSubmit,
}: {
  kind: 'income' | 'expense' | 'adjustment';
  products: ProductDto[];
  onClose: () => void;
  onSubmit: (payload: unknown) => Promise<void>;
}) {
  const [productId, setProductId] = useState(products[0]?.id ?? '');
  const [quantity, setQuantity] = useState('0');
  const [comment, setComment] = useState('');
  const movementLabel = kind === 'income' ? 'Приход' : kind === 'expense' ? 'Расход' : 'Корректировка';

  return (
    <ModalFrame title={`Операция по складу: ${movementLabel}`} onClose={onClose}>
      <form className="stack" onSubmit={(event) => {
        event.preventDefault();
        const numeric = Number(quantity);
        if (kind === 'adjustment') {
          void onSubmit({ productId, targetQty: numeric, comment: comment || null }).then(onClose);
        } else {
          void onSubmit({ productId, quantity: numeric, comment: comment || null }).then(onClose);
        }
      }}>
        <p className="muted" style={{ margin: 0 }}>
          {kind === 'adjustment'
            ? 'Корректировка меняет целевой остаток сразу. Используй ее только для выравнивания факта после проверки.'
            : 'Выбери товар и зафиксируй операцию. Комментарий полезен для разбора спорных движений.'}
        </p>
        <select className="select" value={productId} onChange={(e) => setProductId(e.target.value)}>
          {products.map((product) => <option key={product.id} value={product.id}>{product.name}</option>)}
        </select>
        <input className="input" type="number" inputMode="numeric" value={quantity} onChange={(e) => setQuantity(e.target.value)} placeholder={kind === 'adjustment' ? 'Целевой остаток' : 'Количество'} />
        <textarea className="textarea" value={comment} onChange={(e) => setComment(e.target.value)} placeholder="Комментарий" />
        <button className="button" type="submit">
          {kind === 'income' ? 'Провести приход' : kind === 'expense' ? 'Провести расход' : 'Применить корректировку'}
        </button>
      </form>
    </ModalFrame>
  );
}

export function CompanyModal({ company, onClose, onSubmit }: { company: CompanyDto; onClose: () => void; onSubmit: (payload: UpdateCompanyRequestDto) => Promise<void> }) {
  const [name, setName] = useState(company.name);
  const [city, setCity] = useState(company.city ?? '');
  const [phone, setPhone] = useState(company.phone ?? '');

  return (
    <ModalFrame title="Редактировать компанию" onClose={onClose}>
      <form className="stack" onSubmit={(event) => {
        event.preventDefault();
        void onSubmit({ name, city: city || null, phone: phone || null }).then(onClose);
      }}>
        <p className="muted" style={{ margin: 0 }}>
          Эти данные используются в панели контроля и помогают быстрее разбирать отчеты и работу команды.
        </p>
        <label className="field-block"><span className="field-label">Название компании</span><input className="input" value={name} onChange={(e) => setName(e.target.value)} placeholder="Название" /></label>
        <label className="field-block"><span className="field-label">Город</span><input className="input" value={city} onChange={(e) => setCity(e.target.value)} placeholder="Город" /></label>
        <label className="field-block"><span className="field-label">Телефон</span><label className="field-block"><span className="field-label">Телефон</span><input className="input" value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="Телефон" /></label></label>
        <button className="button" type="submit">Сохранить данные компании</button>
      </form>
    </ModalFrame>
  );
}

export function InviteModal({ inviteToken, onClose, onSubmit }: { inviteToken: string | null; onClose: () => void; onSubmit: (payload: InviteUserRequestDto) => Promise<void> }) {
  const [email, setEmail] = useState('');
  const [role, setRole] = useState<'MANAGER' | 'STAFF'>('STAFF');

  return (
    <ModalFrame title="Пригласить сотрудника" onClose={onClose}>
      <form className="stack" onSubmit={(event) => {
        event.preventDefault();
        void onSubmit({ email, role });
      }}>
        <p className="muted" style={{ margin: 0 }}>
          После создания приглашения передай сотруднику токен. Он активирует доступ и сам задаст пароль.
        </p>
        <label className="field-block"><span className="field-label">Email</span><input className="input" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="Email" /></label>
        <select className="select" value={role} onChange={(e) => setRole(e.target.value as 'MANAGER' | 'STAFF')}>
          <option value="STAFF">Сотрудник</option>
          <option value="MANAGER">Менеджер</option>
        </select>
        <button className="button" type="submit">Создать приглашение</button>
        {inviteToken ? (
          <InlineState
            title="Приглашение готово"
            message={`Передай сотруднику этот токен для активации доступа: ${inviteToken}`}
          />
        ) : null}
      </form>
    </ModalFrame>
  );
}

export function UserModal({ user, onClose, onSubmit }: { user: CompanyUserDto; onClose: () => void; onSubmit: (payload: UpdateUserRequestDto) => Promise<void> }) {
  const [name, setName] = useState(user.name);
  const [email, setEmail] = useState(user.email ?? '');
  const [phone, setPhone] = useState(user.phone ?? '');
  const [role, setRole] = useState<'MANAGER' | 'STAFF'>(user.role === 'MANAGER' ? 'MANAGER' : 'STAFF');
  const [isActive, setIsActive] = useState(user.isActive);
  const [password, setPassword] = useState('');

  return (
    <ModalFrame title="Редактировать сотрудника" onClose={onClose}>
      <form className="stack" onSubmit={(event) => {
        event.preventDefault();
        void onSubmit({
          name,
          email,
          phone: phone || null,
          role,
          isActive,
          ...(password ? { password } : {}),
        }).then(onClose);
      }}>
        <p className="muted" style={{ margin: 0 }}>
          Здесь меняются роль, доступ и пароль сотрудника. Оставь пароль пустым, если его не нужно обновлять.
        </p>
        <div className="grid-2">
          <label className="field-block"><span className="field-label">Имя сотрудника</span><input className="input" value={name} onChange={(e) => setName(e.target.value)} placeholder="Имя" /></label>
          <label className="field-block"><span className="field-label">Email</span><input className="input" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="Email" /></label>
        </div>
        <div className="grid-2">
          <label className="field-block"><span className="field-label">Телефон</span><input className="input" value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="Телефон" /></label>
          <select className="select" value={role} onChange={(e) => setRole(e.target.value as 'MANAGER' | 'STAFF')}>
            <option value="STAFF">Сотрудник</option>
            <option value="MANAGER">Менеджер</option>
          </select>
        </div>
        <input className="input" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Новый пароль" />
        <label className="badge" style={{ width: 'fit-content' }}>
          <input type="checkbox" checked={isActive} onChange={(e) => setIsActive(e.target.checked)} />
          Активен
        </label>
        <button className="button" type="submit">Сохранить сотрудника</button>
      </form>
    </ModalFrame>
  );
}

export function CategoryModal({
  category,
  categories,
  onClose,
  onSubmit,
}: {
  category?: CategoryDto;
  categories: CategoryDto[];
  onClose: () => void;
  onSubmit: (payload: CreateCategoryRequestDto & { parentId?: string | null } | UpdateCategoryRequestDto & { parentId?: string | null }) => Promise<void>;
}) {
  const [name, setName] = useState(category?.name ?? '');
  const [parentId, setParentId] = useState(category?.parentId ?? '');

  return (
    <ModalFrame title={category ? 'Редактировать категорию' : 'Новая категория'} onClose={onClose}>
      <form className="stack" onSubmit={(event) => {
        event.preventDefault();
        void onSubmit({ name, parentId: parentId || null }).then(onClose);
      }}>
        <p className="muted" style={{ margin: 0 }}>
          Категория нужна для структуры каталога и фильтров. Родительскую категорию указывай только если действительно нужна вложенность.
        </p>
        <input className="input" value={name} onChange={(e) => setName(e.target.value)} placeholder="Название категории" />
        <select className="select" value={parentId} onChange={(e) => setParentId(e.target.value)}>
          <option value="">Без родительской категории</option>
          {categories
            .filter((item) => item.id !== category?.id)
            .map((item) => <option key={item.id} value={item.id}>{item.name}</option>)}
        </select>
        <button className="button" type="submit">{category ? 'Сохранить категорию' : 'Создать категорию'}</button>
      </form>
    </ModalFrame>
  );
}

function downloadCsv(filename: string, rows: string[][]) {
  const csv = rows
    .map((row) =>
      row
        .map((cell) => `"${String(cell ?? '').replaceAll('"', '""')}"`)
        .join(','),
    )
    .join('\n');

  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement('a');
  anchor.href = url;
  anchor.download = filename;
  document.body.appendChild(anchor);
  anchor.click();
  anchor.remove();
  URL.revokeObjectURL(url);
}

function buildExportFileName(base: string, tags: string[]) {
  const normalizedTags = tags
    .map((tag) => sanitizeFileToken(tag))
    .filter(Boolean)
    .slice(0, 4);
  const suffix = normalizedTags.length > 0 ? `-${normalizedTags.join('-')}` : '';
  return `nexussklad-${base}${suffix}.csv`;
}

function sanitizeFileToken(value: string) {
  return value
    .toLowerCase()
    .replaceAll(/[^a-z0-9а-яё]+/gi, '-')
    .replaceAll(/^-+|-+$/g, '')
    .slice(0, 24);
}

function collectReportFilterTokens(filters: ReportFiltersState, categories: CategoryDto[]) {
  const categoryName = categories.find((item) => item.id === filters.stockCategoryId)?.name;
  return [
    filters.date,
    filters.stockSearch || '',
    categoryName || '',
    filters.lowOnly ? 'low-only' : '',
  ].filter(Boolean);
}

function collectReportFilterBadges(filters: ReportFiltersState, categories: CategoryDto[]) {
  const categoryName = categories.find((item) => item.id === filters.stockCategoryId)?.name;
  return [
    `Дата: ${filters.date}`,
    filters.stockSearch ? `Поиск: ${filters.stockSearch}` : '',
    categoryName ? `Категория: ${categoryName}` : '',
    filters.lowOnly ? 'Только низкий остаток' : '',
  ].filter(Boolean);
}

function collectAuditFilterTokens(filters: AuditFiltersState, users: CompanyUserDto[]) {
  const userName = users.find((item) => item.id === filters.userId)?.name;
  return [
    userName || filters.userId,
    filters.entityType,
    filters.action,
  ].filter(Boolean);
}

function collectAuditFilterBadges(filters: AuditFiltersState, users: CompanyUserDto[] = []) {
  const userName = users.find((item) => item.id === filters.userId)?.name;
  return [
    userName ? `Пользователь: ${userName}` : filters.userId ? 'Пользователь: выбран вручную' : '',
    filters.entityType ? `Сущность: ${formatEntityTypeLabel(filters.entityType)}` : '',
    filters.action ? `Действие: ${formatAuditActionLabel(filters.action)}` : '',
  ].filter(Boolean);
}

function buildAuditInsights(logs: AuditLogDto[]) {
  const actionCounts = new Map<string, number>();
  const entityCounts = new Map<string, number>();
  const users = new Set<string>();
  const entities = new Set<string>();

  for (const log of logs) {
    users.add(log.user.id);
    if (log.entityId) entities.add(log.entityId);
    actionCounts.set(log.action, (actionCounts.get(log.action) ?? 0) + 1);
    entityCounts.set(log.entityType, (entityCounts.get(log.entityType) ?? 0) + 1);
  }

  const topAction = [...actionCounts.entries()].sort((left, right) => right[1] - left[1])[0]?.[0] ?? null;
  const topEntityType = [...entityCounts.entries()].sort((left, right) => right[1] - left[1])[0]?.[0] ?? null;

  return {
    uniqueUsers: users.size,
    uniqueEntities: entities.size,
    topAction,
    topEntityType,
  };
}
