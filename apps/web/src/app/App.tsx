import { useEffect, useMemo, useState, type ReactNode } from 'react';
import type {
  OpenApiComponents,
} from '@nexussklad/shared';

import { ApiError, isSessionExpiredApiError } from '../core/api';
import { appConfig } from '../core/config';
import { executeConfirmedSessionAction, executeSessionAction } from '../core/session-actions';
import { fetchAllAuditLogs } from '../features/audit/audit';
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
  fetchAllMovements,
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
  dailyMovements: StockMovementDto[];
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

type MovementFilter = 'ALL' | 'INCOME' | 'EXPENSE' | 'ADJUSTMENT' | 'INVENTORY_DIFF';
type MovementSort = 'NEWEST' | 'OLDEST';
type TeamFilter = 'ALL' | 'ACTIVE' | 'MANAGER' | 'STAFF' | 'INVITED';
type TeamSort = 'ACTIVE_FIRST' | 'NAME_ASC';
type InventorySessionFilter = 'ALL' | 'DRAFT' | 'COMPLETED';
type InventorySessionSort = 'NEWEST' | 'OLDEST';
type ProductFilter = 'ALL' | 'LOW_STOCK' | 'UNCATEGORIZED';
type ProductSort = 'LOW_FIRST' | 'NAME_ASC';
type CategorySort = 'ROOT_FIRST' | 'NAME_ASC';
type StockReportSort = 'LOW_FIRST' | 'NAME_ASC';
type StockStatusFilter = 'ALL' | 'LOW' | 'OK';

const DEMO_EMAIL = 'owner@nexussklad.local';
const DEMO_PASSWORD = 'demo-owner-123';

function normalizeAuditToken(value: string) {
  return value.toLowerCase().replaceAll(/[^a-z0-9а-яё]+/gi, '');
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

function formatMovementTypeLabel(movementType: StockMovementDto['movementType']) {
  switch (movementType) {
    case 'INCOME':
      return 'Приход';
    case 'EXPENSE':
      return 'Расход';
    case 'ADJUSTMENT':
      return 'Корректировка';
    case 'INVENTORY_DIFF':
      return 'Сверка';
    default:
      return 'Операция';
  }
}

function resolveUtcDayRange(date: string) {
  const dayStart = new Date(`${date}T00:00:00.000Z`);
  const dayEnd = new Date(dayStart);
  dayEnd.setUTCDate(dayEnd.getUTCDate() + 1);
  dayEnd.setUTCMilliseconds(dayEnd.getUTCMilliseconds() - 1);

  return {
    dateFrom: dayStart.toISOString(),
    dateTo: dayEnd.toISOString(),
  };
}

function sortMovementsByCreatedAt(movements: StockMovementDto[], sortMode: MovementSort = 'NEWEST') {
  return [...movements].sort((a, b) => (
    sortMode === 'OLDEST'
      ? Date.parse(a.createdAt) - Date.parse(b.createdAt)
      : Date.parse(b.createdAt) - Date.parse(a.createdAt)
  ));
}

function buildMovementSearchText(movement: StockMovementDto) {
  const compactMovementId = movement.id.replaceAll(/[^a-z0-9а-яё]+/gi, '');
  const compactProductId = movement.product.id.replaceAll(/[^a-z0-9а-яё]+/gi, '');
  const compactProductSku = (movement.product.sku ?? '').replaceAll(/[^a-z0-9а-яё]+/gi, '');
  const compactCreatedById = movement.createdBy.id.replaceAll(/[^a-z0-9а-яё]+/gi, '');
  const compactCreatedAt = movement.createdAt.replaceAll(/\D+/g, '');
  return [
    movement.id,
    compactMovementId,
    movement.createdAt,
    compactCreatedAt,
    new Date(movement.createdAt).toLocaleString('ru-RU'),
    movement.product.name,
    movement.product.id,
    compactProductId,
    movement.product.sku ?? '',
    compactProductSku,
    movement.product.unit,
    movement.createdBy.id,
    compactCreatedById,
    movement.createdBy.name,
    formatRoleLabel(movement.createdBy.role),
    formatMovementTypeLabel(movement.movementType),
    movement.comment ?? '',
    movement.movementType.replaceAll('_', ''),
    movement.quantity,
    movement.beforeQty,
    movement.afterQty,
  ]
    .map((value) => String(value ?? ''))
    .join(' ')
    .toLowerCase();
}

function sortInventorySessionsByStartedAt<T extends { startedAt: string }>(
  sessions: T[],
  sortMode: InventorySessionSort = 'NEWEST',
) {
  return [...sessions].sort((a, b) => (
    sortMode === 'OLDEST'
      ? Date.parse(a.startedAt) - Date.parse(b.startedAt)
      : Date.parse(b.startedAt) - Date.parse(a.startedAt)
  ));
}

function sortStockReportItems(items: StockReportDto['items'], sortMode: StockReportSort) {
  const getDeficit = (item: StockReportDto['items'][number]) => Math.max(0, Number(item.minStock) - Number(item.currentStock));
  if (sortMode === 'NAME_ASC') {
    return [...items].sort((left, right) => left.name.localeCompare(right.name, 'ru-RU'));
  }
  return [...items].sort((left, right) => {
    if (left.isLowStock !== right.isLowStock) {
      return left.isLowStock ? -1 : 1;
    }
    const deficitDiff = getDeficit(right) - getDeficit(left);
    if (deficitDiff !== 0) {
      return deficitDiff;
    }
    return left.name.localeCompare(right.name, 'ru-RU');
  });
}

function buildInventorySessionSearchText(session: DailyReportDto['inventory']['sessions'][number]) {
  const compactStartedAt = session.startedAt.replaceAll(/\D+/g, '');
  const compactFinishedAt = (session.finishedAt ?? '').replaceAll(/\D+/g, '');
  const compactSessionId = session.id.replaceAll(/[^a-z0-9а-яё]+/gi, '');
  const compactStartedById = session.startedBy.id.replaceAll(/[^a-z0-9а-яё]+/gi, '');
  const finishedAtLabel = session.finishedAt ? new Date(session.finishedAt).toLocaleString('ru-RU') : '';
  return [
    session.id,
    compactSessionId,
    session.id.slice(0, 8),
    session.startedBy.id,
    compactStartedById,
    session.startedBy.name,
    session.status,
    formatInventoryStatusLabel(session.status),
    session.startedAt,
    compactStartedAt,
    new Date(session.startedAt).toLocaleString('ru-RU'),
    session.finishedAt ?? '',
    compactFinishedAt,
    finishedAtLabel,
    session.comment ?? '',
    `Позиции: ${session._count.items}`,
    String(session._count.items),
  ]
    .join(' ')
    .toLowerCase();
}

function buildTeamUserSearchText(user: CompanyUserDto) {
  const hasInvite = Boolean(user.inviteExpiresAt);
  const compactUserId = user.id.replaceAll(/[^a-z0-9а-яё]+/gi, '');
  const compactEmail = (user.email ?? '').replaceAll(/[^a-z0-9а-яё]+/gi, '');
  const phoneDigits = (user.phone ?? '').replaceAll(/\D+/g, '');
  const statusLabel = user.isActive
    ? 'Активен'
    : hasInvite
      ? 'Ожидает активации'
      : 'Неактивен';
  const inviteLabel = hasInvite
    ? `Приглашение до ${new Date(user.inviteExpiresAt as string).toLocaleDateString('ru-RU')}`
    : '';
  const inviteDateRaw = hasInvite ? String(user.inviteExpiresAt) : '';
  const inviteDateDigits = hasInvite ? String(user.inviteExpiresAt).replaceAll(/\D+/g, '') : '';
  return [
    user.id,
    compactUserId,
    user.name,
    user.email ?? '',
    compactEmail,
    user.phone ?? '',
    phoneDigits,
    user.role,
    formatRoleLabel(user.role),
    statusLabel,
    inviteLabel,
    inviteDateRaw,
    inviteDateDigits,
  ]
    .join(' ')
    .toLowerCase();
}

function sortTeamUsers(users: CompanyUserDto[], sortMode: TeamSort) {
  if (sortMode === 'NAME_ASC') {
    return [...users].sort((left, right) => left.name.localeCompare(right.name, 'ru-RU'));
  }
  const statusRank = (user: CompanyUserDto) => (
    user.isActive
      ? 0
      : user.inviteExpiresAt
        ? 1
        : 2
  );
  return [...users].sort((left, right) => {
    const rankDiff = statusRank(left) - statusRank(right);
    if (rankDiff !== 0) {
      return rankDiff;
    }
    return left.name.localeCompare(right.name, 'ru-RU');
  });
}

function sortCatalogProducts(products: ProductDto[], sortMode: ProductSort) {
  const isLowStock = (product: ProductDto) => Number(product.currentStock) <= Number(product.minStock);
  const getDeficit = (product: ProductDto) => Math.max(0, Number(product.minStock) - Number(product.currentStock));
  if (sortMode === 'NAME_ASC') {
    return [...products].sort((left, right) => left.name.localeCompare(right.name, 'ru-RU'));
  }
  return [...products].sort((left, right) => {
    const leftLow = isLowStock(left);
    const rightLow = isLowStock(right);
    if (leftLow !== rightLow) {
      return leftLow ? -1 : 1;
    }
    const deficitDiff = getDeficit(right) - getDeficit(left);
    if (deficitDiff !== 0) {
      return deficitDiff;
    }
    return left.name.localeCompare(right.name, 'ru-RU');
  });
}

function sortCategories(categories: CategoryDto[], allCategories: CategoryDto[], sortMode: CategorySort) {
  const getParentName = (category: CategoryDto) => allCategories.find((item) => item.id === category.parentId)?.name ?? '';
  if (sortMode === 'NAME_ASC') {
    return [...categories].sort((left, right) => left.name.localeCompare(right.name, 'ru-RU'));
  }
  return [...categories].sort((left, right) => {
    const leftIsRoot = !left.parentId;
    const rightIsRoot = !right.parentId;
    if (leftIsRoot !== rightIsRoot) {
      return leftIsRoot ? -1 : 1;
    }
    const parentDiff = getParentName(left).localeCompare(getParentName(right), 'ru-RU');
    if (parentDiff !== 0) {
      return parentDiff;
    }
    return left.name.localeCompare(right.name, 'ru-RU');
  });
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
    const movementDayRange = resolveUtcDayRange(reportFilters.date);
    const [report, stockReport, company, products, categories, movements, dailyMovements, users, auditLogs] = await Promise.all([
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
      fetchAllMovements(activeSession.accessToken),
      fetchAllMovements(activeSession.accessToken, movementDayRange),
      activeSession.user.role === 'OWNER' ? fetchUsers(activeSession.accessToken) : Promise.resolve([]),
      activeSession.user.role === 'OWNER'
        ? fetchAllAuditLogs(activeSession.accessToken, {
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
      dailyMovements,
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
                  movements={data.dailyMovements}
                  selectedDate={reportFilters.date}
                  onDateChange={(date) => setReportFilters((current) => ({ ...current, date }))}
                  lowStockCount={lowStockCount}
                  movementCount={data.dailyMovements.length}
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
                      buildExportFileName('movements-journal', []),
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
      <label className="field-block">
        <span className="field-label">Email сотрудника</span>
        <input className="input" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="Email" />
      </label>
      <label className="field-block">
        <span className="field-label">Пароль</span>
        <input
          className="input"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          placeholder="Пароль"
        />
      </label>
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

export function DashboardView({
  report,
  movements,
  selectedDate,
  onDateChange,
  lowStockCount,
  movementCount,
  productCount,
  defaultSessionFilter = 'ALL',
  defaultSessionSearch = '',
  defaultSessionSort = 'NEWEST',
  defaultMovementFilter = 'ALL',
  defaultMovementSearch = '',
  defaultMovementSort = 'NEWEST',
}: {
  report: DailyReportDto;
  movements: StockMovementDto[];
  selectedDate: string;
  onDateChange: (date: string) => void;
  lowStockCount: number;
  movementCount: number;
  productCount: number;
  defaultSessionFilter?: InventorySessionFilter;
  defaultSessionSearch?: string;
  defaultSessionSort?: InventorySessionSort;
  defaultMovementFilter?: MovementFilter;
  defaultMovementSearch?: string;
  defaultMovementSort?: MovementSort;
}) {
  const [sessionFilter, setSessionFilter] = useState<InventorySessionFilter>(defaultSessionFilter);
  const [sessionSearch, setSessionSearch] = useState(defaultSessionSearch);
  const [sessionSort, setSessionSort] = useState<InventorySessionSort>(defaultSessionSort);
  const [movementFilter, setMovementFilter] = useState<MovementFilter>(defaultMovementFilter);
  const [movementSearch, setMovementSearch] = useState(defaultMovementSearch);
  const [movementSort, setMovementSort] = useState<MovementSort>(defaultMovementSort);
  const draftSessions = report.inventory.sessions.filter((session) => session.status !== 'COMPLETED').length;
  const completedSessions = report.inventory.sessions.filter((session) => session.status === 'COMPLETED').length;
  const filteredSessions = sessionFilter === 'ALL'
    ? report.inventory.sessions
    : report.inventory.sessions.filter((session) => session.status === sessionFilter);
  const normalizedSessionSearch = sessionSearch.trim().toLowerCase();
  const compactSessionSearch = normalizeAuditToken(normalizedSessionSearch);
  const visibleSessions = normalizedSessionSearch
    ? filteredSessions.filter((session) => {
      const searchText = buildInventorySessionSearchText(session);
      if (searchText.includes(normalizedSessionSearch)) {
        return true;
      }
      if (!compactSessionSearch) {
        return false;
      }
      return normalizeAuditToken(searchText).includes(compactSessionSearch);
    })
    : filteredSessions;
  const orderedSessions = sortInventorySessionsByStartedAt(visibleSessions, sessionSort);
  const sessionFilterOptions: Array<{ value: InventorySessionFilter; label: string }> = [
    { value: 'ALL', label: 'Все' },
    { value: 'DRAFT', label: 'Черновики' },
    { value: 'COMPLETED', label: 'Завершенные' },
  ];
  const movementTypeCounts = movements.reduce<Record<string, number>>((acc, movement) => {
    acc[movement.movementType] = (acc[movement.movementType] ?? 0) + 1;
    return acc;
  }, {});
  const filteredMovements = movementFilter === 'ALL'
    ? movements
    : movements.filter((movement) => movement.movementType === movementFilter);
  const normalizedMovementSearch = movementSearch.trim().toLowerCase();
  const compactMovementSearch = normalizeAuditToken(normalizedMovementSearch);
  const visibleMovements = normalizedMovementSearch
    ? filteredMovements.filter((movement) => {
      const searchText = buildMovementSearchText(movement);
      if (searchText.includes(normalizedMovementSearch)) {
        return true;
      }
      if (!compactMovementSearch) {
        return false;
      }
      return normalizeAuditToken(searchText).includes(compactMovementSearch);
    })
    : filteredMovements;
  const orderedMovements = sortMovementsByCreatedAt(visibleMovements, movementSort);
  const movementFilterOptions: Array<{ value: MovementFilter; label: string }> = [
    { value: 'ALL', label: 'Все' },
    { value: 'INCOME', label: 'Приход' },
    { value: 'EXPENSE', label: 'Расход' },
    { value: 'ADJUSTMENT', label: 'Корректировка' },
    { value: 'INVENTORY_DIFF', label: 'Сверка' },
  ];
  const hasActiveSessionControls = sessionFilter !== 'ALL' || sessionSearch.length > 0;
  const hasActiveMovementControls = movementFilter !== 'ALL' || movementSearch.length > 0;

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
        {report.inventory.sessions.length > 0 ? (
          <>
            <div className="toolbar audit-insights">
              <div className="badge">Сессий: {report.inventory.sessions.length}</div>
              <div className="badge">Черновики: {draftSessions}</div>
              <div className="badge">Завершено: {completedSessions}</div>
            </div>
            <div className="filter-panel inventory-filter-panel">
              <div className="toolbar-actions toolbar-filters">
                {sessionFilterOptions.map((option) => (
                  <button
                    key={option.value}
                    className={`button-ghost quick-filter-button${sessionFilter === option.value ? ' active' : ''}`}
                    onClick={() => setSessionFilter(option.value)}
                  >
                    {option.label}
                  </button>
                ))}
              </div>
              <div className="toolbar-actions toolbar-filters">
                <input
                  className="input input-compact"
                  value={sessionSearch}
                  onChange={(event) => setSessionSearch(event.target.value)}
                  placeholder="Поиск по ID, сотруднику, статусу, дате, комментарию или позициям"
                />
                {sessionSearch ? (
                  <button className="button-ghost" onClick={() => setSessionSearch('')}>Очистить поиск</button>
                ) : null}
                {hasActiveSessionControls ? (
                  <button
                    className="button-ghost"
                    onClick={() => {
                      setSessionFilter('ALL');
                      setSessionSearch('');
                    }}
                  >
                    Сбросить всё
                  </button>
                ) : null}
                <button
                  className={`button-ghost quick-filter-button${sessionSort === 'NEWEST' ? ' active' : ''}`}
                  onClick={() => setSessionSort('NEWEST')}
                >
                  Сначала новые
                </button>
                <button
                  className={`button-ghost quick-filter-button${sessionSort === 'OLDEST' ? ' active' : ''}`}
                  onClick={() => setSessionSort('OLDEST')}
                >
                  Сначала старые
                </button>
              </div>
            </div>
          </>
        ) : null}
        {report.inventory.sessions.length === 0 ? (
          <InlineState
            title="За выбранный день операций нет"
            message="Проведи приход, расход или инвентаризацию, чтобы сводка за день начала заполняться."
          />
        ) : visibleSessions.length === 0 ? (
          normalizedSessionSearch ? (
            <InlineState
              title="Поиск не дал сессий в сводке дня"
              message="Очисти поиск или выбери другой статус сессий."
              actionLabel="Очистить поиск"
              onAction={() => setSessionSearch('')}
            />
          ) : (
            <InlineState
              title="По выбранному фильтру сессий нет"
              message="В сводке есть сессии, но не в выбранном статусе."
              actionLabel="Сбросить фильтр"
              onAction={() => setSessionFilter('ALL')}
            />
          )
        ) : (
          <table>
            <thead>
              <tr>
                <th>Когда</th>
                <th>Сессия</th>
                <th>Статус</th>
                <th>Сотрудник</th>
                <th>Позиций</th>
              </tr>
            </thead>
            <tbody>
              {orderedSessions.map((session) => (
                <tr key={session.id}>
                  <td>{new Date(session.startedAt).toLocaleString('ru-RU')}</td>
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
      <section className="table-card">
        <div className="toolbar">
          <div className="toolbar-title">
            <div className="section-label">Операции за день</div>
            <h3 style={{ margin: 0 }}>Движения по складу</h3>
          </div>
          <div className="toolbar-actions">
            <div className="badge">Дата: {report.date}</div>
          </div>
        </div>
        {movements.length > 0 ? (
          <>
            <div className="toolbar audit-insights">
              <div className="badge">Записей: {movements.length}</div>
              <div className="badge">Приходов: {movementTypeCounts.INCOME ?? 0}</div>
              <div className="badge">Расходов: {movementTypeCounts.EXPENSE ?? 0}</div>
              <div className="badge">Корректировок: {movementTypeCounts.ADJUSTMENT ?? 0}</div>
              <div className="badge">Сверок: {movementTypeCounts.INVENTORY_DIFF ?? 0}</div>
            </div>
            <div className="filter-panel movement-filter-panel">
              <div className="toolbar-actions toolbar-filters">
                {movementFilterOptions.map((option) => (
                  <button
                    key={option.value}
                    className={`button-ghost quick-filter-button${movementFilter === option.value ? ' active' : ''}`}
                    onClick={() => setMovementFilter(option.value)}
                  >
                    {option.label}
                  </button>
                ))}
              </div>
              <div className="toolbar-actions toolbar-filters">
                <input
                  className="input input-compact"
                  value={movementSearch}
                  onChange={(event) => setMovementSearch(event.target.value)}
                  placeholder="Поиск по товару, SKU, единице, ID, сотруднику, роли, типу, количеству, дате или комментарию"
                />
                {movementSearch ? (
                  <button className="button-ghost" onClick={() => setMovementSearch('')}>Очистить поиск</button>
                ) : null}
                {hasActiveMovementControls ? (
                  <button
                    className="button-ghost"
                    onClick={() => {
                      setMovementFilter('ALL');
                      setMovementSearch('');
                    }}
                  >
                    Сбросить всё
                  </button>
                ) : null}
                <button
                  className={`button-ghost quick-filter-button${movementSort === 'NEWEST' ? ' active' : ''}`}
                  onClick={() => setMovementSort('NEWEST')}
                >
                  Сначала новые
                </button>
                <button
                  className={`button-ghost quick-filter-button${movementSort === 'OLDEST' ? ' active' : ''}`}
                  onClick={() => setMovementSort('OLDEST')}
                >
                  Сначала старые
                </button>
              </div>
            </div>
          </>
        ) : null}
        {movements.length === 0 ? (
          <InlineState
            title="За выбранный день движений нет"
            message="Проведи приход, расход или корректировку, чтобы увидеть операции в сводке дня."
          />
        ) : visibleMovements.length === 0 ? (
          normalizedMovementSearch ? (
            <InlineState
              title="Поиск не дал движений в сводке дня"
              message="Очисти поиск или выбери другой тип операций."
              actionLabel="Очистить поиск"
              onAction={() => setMovementSearch('')}
            />
          ) : (
            <InlineState
              title="По выбранному фильтру движений нет"
              message="В сводке есть движения, но не выбранного типа."
              actionLabel="Сбросить фильтр"
              onAction={() => setMovementFilter('ALL')}
            />
          )
        ) : (
          <table>
            <thead>
              <tr>
                <th>Когда</th>
                <th>Тип</th>
                <th>Товар</th>
                <th>Сотрудник</th>
                <th>Кол-во</th>
              </tr>
            </thead>
            <tbody>
              {orderedMovements.map((movement) => (
                <MovementTableRow key={movement.id} movement={movement} />
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
  defaultFilter = 'ALL',
  defaultSearch = '',
  defaultCategorySearch = '',
  defaultSort = 'LOW_FIRST',
  defaultCategorySort = 'ROOT_FIRST',
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
  defaultFilter?: ProductFilter;
  defaultSearch?: string;
  defaultCategorySearch?: string;
  defaultSort?: ProductSort;
  defaultCategorySort?: CategorySort;
}) {
  const [productFilter, setProductFilter] = useState<ProductFilter>(defaultFilter);
  const [productSearch, setProductSearch] = useState(defaultSearch);
  const [categorySearch, setCategorySearch] = useState(defaultCategorySearch);
  const [productSort, setProductSort] = useState<ProductSort>(defaultSort);
  const [categorySort, setCategorySort] = useState<CategorySort>(defaultCategorySort);
  const lowStockProducts = products.filter((product) => Number(product.currentStock) <= Number(product.minStock)).length;
  const uncategorizedProducts = products.filter((product) => !product.categoryId).length;
  const rootCategories = categories.filter((category) => !category.parentId).length;
  const filteredProducts = products.filter((product) => {
    switch (productFilter) {
      case 'LOW_STOCK':
        return Number(product.currentStock) <= Number(product.minStock);
      case 'UNCATEGORIZED':
        return !product.categoryId;
      case 'ALL':
      default:
        return true;
    }
  });
  const normalizedSearch = productSearch.trim().toLowerCase();
  const compactProductSearch = normalizeAuditToken(normalizedSearch);
  const visibleProducts = normalizedSearch
    ? filteredProducts.filter((product) => {
      const compactProductId = product.id.replaceAll(/[^a-z0-9а-яё]+/gi, '');
      const compactSku = (product.sku ?? '').replaceAll(/[^a-z0-9а-яё]+/gi, '');
      const barcodeDigits = (product.barcode ?? '').replaceAll(/\D+/g, '');
      const searchValues = [
        product.id,
        compactProductId,
        product.name,
        product.sku ?? '',
        compactSku,
        product.barcode ?? '',
        barcodeDigits,
        product.category?.name ?? '',
        product.unit,
      ]
        .join(' ')
        .toLowerCase();
      if (searchValues.includes(normalizedSearch)) {
        return true;
      }
      if (!compactProductSearch) {
        return false;
      }
      return normalizeAuditToken(searchValues).includes(compactProductSearch);
    })
    : filteredProducts;
  const orderedProducts = sortCatalogProducts(visibleProducts, productSort);
  const productFilterOptions: Array<{ value: ProductFilter; label: string }> = [
    { value: 'ALL', label: 'Все' },
    { value: 'LOW_STOCK', label: 'Низкий остаток' },
    { value: 'UNCATEGORIZED', label: 'Без категории' },
  ];
  const normalizedCategorySearch = categorySearch.trim().toLowerCase();
  const compactCategorySearch = normalizeAuditToken(normalizedCategorySearch);
  const visibleCategories = normalizedCategorySearch
    ? categories.filter((category) => {
      const parentName = categories.find((item) => item.id === category.parentId)?.name ?? '';
      const compactCategoryId = category.id.replaceAll(/[^a-z0-9а-яё]+/gi, '');
      const compactParentId = (category.parentId ?? '').replaceAll(/[^a-z0-9а-яё]+/gi, '');
      const compactCategoryName = category.name.replaceAll(/[^a-z0-9а-яё]+/gi, '');
      const compactParentName = parentName.replaceAll(/[^a-z0-9а-яё]+/gi, '');
      const searchValues = [
        category.id,
        compactCategoryId,
        category.parentId ?? '',
        compactParentId,
        category.name,
        compactCategoryName,
        parentName,
        compactParentName,
      ]
        .join(' ')
        .toLowerCase();
      if (searchValues.includes(normalizedCategorySearch)) {
        return true;
      }
      if (!compactCategorySearch) {
        return false;
      }
      return normalizeAuditToken(searchValues).includes(compactCategorySearch);
    })
    : categories;
  const orderedCategories = sortCategories(visibleCategories, categories, categorySort);

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
        {products.length > 0 ? (
          <div className="filter-panel product-filter-panel">
            <div className="toolbar-actions toolbar-filters">
              {productFilterOptions.map((option) => (
                <button
                  key={option.value}
                  className={`button-ghost quick-filter-button${productFilter === option.value ? ' active' : ''}`}
                  onClick={() => setProductFilter(option.value)}
                >
                  {option.label}
                </button>
              ))}
            </div>
            <div className="toolbar-actions toolbar-filters">
              <input
                className="input input-compact"
                value={productSearch}
                onChange={(event) => setProductSearch(event.target.value)}
                placeholder="Поиск по ID, названию, SKU, штрихкоду, категории или единице"
              />
              {productSearch ? (
                <button className="button-ghost" onClick={() => setProductSearch('')}>Очистить поиск</button>
              ) : null}
              {(productFilter !== 'ALL' || productSearch) ? (
                <button
                  className="button-ghost"
                  onClick={() => {
                    setProductFilter('ALL');
                    setProductSearch('');
                  }}
                >
                  Сбросить всё
                </button>
              ) : null}
              <button
                className={`button-ghost quick-filter-button${productSort === 'LOW_FIRST' ? ' active' : ''}`}
                onClick={() => setProductSort('LOW_FIRST')}
              >
                Риск сначала
              </button>
              <button
                className={`button-ghost quick-filter-button${productSort === 'NAME_ASC' ? ' active' : ''}`}
                onClick={() => setProductSort('NAME_ASC')}
              >
                По названию
              </button>
            </div>
          </div>
        ) : null}
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
        ) : visibleProducts.length === 0 ? (
          normalizedSearch ? (
            <InlineState
              title="Поиск не дал товаров по текущему фильтру."
              message="Очисти поиск или выбери другой фильтр каталога."
              actionLabel="Очистить поиск"
              onAction={() => setProductSearch('')}
            />
          ) : (
            <InlineState
              title="По выбранному фильтру товаров нет"
              message="В каталоге есть позиции, но в этом срезе пока пусто."
              actionLabel="Сбросить фильтр"
              onAction={() => setProductFilter('ALL')}
            />
          )
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
              {orderedProducts.map((product) => {
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
        ) : visibleCategories.length === 0 ? (
          <>
            <div className="filter-panel category-filter-panel">
              <div className="toolbar-actions toolbar-filters">
                <input
                  className="input input-compact"
                  value={categorySearch}
                  onChange={(event) => setCategorySearch(event.target.value)}
                  placeholder="Поиск по ID, категории или родителю"
                />
                {categorySearch ? (
                  <button className="button-ghost" onClick={() => setCategorySearch('')}>Очистить поиск</button>
                ) : null}
                <button
                  className={`button-ghost quick-filter-button${categorySort === 'ROOT_FIRST' ? ' active' : ''}`}
                  onClick={() => setCategorySort('ROOT_FIRST')}
                >
                  Корневые сначала
                </button>
                <button
                  className={`button-ghost quick-filter-button${categorySort === 'NAME_ASC' ? ' active' : ''}`}
                  onClick={() => setCategorySort('NAME_ASC')}
                >
                  По названию
                </button>
              </div>
            </div>
            <InlineState
              title="Поиск не дал категорий"
              message="Измени запрос или очисти поиск, чтобы увидеть все категории."
              actionLabel="Очистить поиск"
              onAction={() => setCategorySearch('')}
            />
          </>
        ) : (
          <>
            <div className="filter-panel category-filter-panel">
              <div className="toolbar-actions toolbar-filters">
                <input
                  className="input input-compact"
                  value={categorySearch}
                  onChange={(event) => setCategorySearch(event.target.value)}
                  placeholder="Поиск по ID, категории или родителю"
                />
                {categorySearch ? (
                  <button className="button-ghost" onClick={() => setCategorySearch('')}>Очистить поиск</button>
                ) : null}
                <button
                  className={`button-ghost quick-filter-button${categorySort === 'ROOT_FIRST' ? ' active' : ''}`}
                  onClick={() => setCategorySort('ROOT_FIRST')}
                >
                  Корневые сначала
                </button>
                <button
                  className={`button-ghost quick-filter-button${categorySort === 'NAME_ASC' ? ' active' : ''}`}
                  onClick={() => setCategorySort('NAME_ASC')}
                >
                  По названию
                </button>
              </div>
            </div>
            <table>
              <thead>
                <tr>
                  <th>Название</th>
                  <th>Родительская категория</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {orderedCategories.map((category) => (
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
          </>
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
  defaultFilter = 'ALL',
  defaultSearch = '',
  defaultSort = 'NEWEST',
}: {
  products: ProductDto[];
  movements: StockMovementDto[];
  canAdjust: boolean;
  onCreate: (kind: 'income' | 'expense' | 'adjustment') => void;
  onExport: () => void;
  defaultFilter?: MovementFilter;
  defaultSearch?: string;
  defaultSort?: MovementSort;
}) {
  const [movementFilter, setMovementFilter] = useState<MovementFilter>(defaultFilter);
  const [movementSearch, setMovementSearch] = useState(defaultSearch);
  const [movementSort, setMovementSort] = useState<MovementSort>(defaultSort);
  const movementTypeCounts = movements.reduce<Record<string, number>>((acc, movement) => {
    acc[movement.movementType] = (acc[movement.movementType] ?? 0) + 1;
    return acc;
  }, {});
  const filteredMovements = movementFilter === 'ALL'
    ? movements
    : movements.filter((movement) => movement.movementType === movementFilter);
  const normalizedSearch = movementSearch.trim().toLowerCase();
  const compactMovementSearch = normalizeAuditToken(normalizedSearch);
  const visibleMovements = normalizedSearch
    ? filteredMovements.filter((movement) => {
      const searchText = buildMovementSearchText(movement);
      if (searchText.includes(normalizedSearch)) {
        return true;
      }
      if (!compactMovementSearch) {
        return false;
      }
      return normalizeAuditToken(searchText).includes(compactMovementSearch);
    })
    : filteredMovements;
  const orderedMovements = sortMovementsByCreatedAt(visibleMovements, movementSort);
  const movementFilterOptions: Array<{ value: MovementFilter; label: string }> = [
    { value: 'ALL', label: 'Все' },
    { value: 'INCOME', label: 'Приход' },
    { value: 'EXPENSE', label: 'Расход' },
    { value: 'ADJUSTMENT', label: 'Корректировка' },
    { value: 'INVENTORY_DIFF', label: 'Сверка' },
  ];

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
        <div className="badge">Корректировок: {movementTypeCounts.ADJUSTMENT ?? 0}</div>
        <div className="badge">Сверок: {movementTypeCounts.INVENTORY_DIFF ?? 0}</div>
      </div>
      <div className="filter-panel movement-filter-panel">
        <div className="toolbar-actions toolbar-filters">
          {movementFilterOptions.map((option) => (
            <button
              key={option.value}
              className={`button-ghost quick-filter-button${movementFilter === option.value ? ' active' : ''}`}
              onClick={() => setMovementFilter(option.value)}
            >
              {option.label}
            </button>
          ))}
        </div>
        <div className="toolbar-actions toolbar-filters">
          <input
            className="input input-compact"
            value={movementSearch}
            onChange={(event) => setMovementSearch(event.target.value)}
            placeholder="Поиск по товару, SKU, единице, ID, сотруднику, роли, типу, количеству, дате или комментарию"
          />
          {movementSearch ? (
            <button className="button-ghost" onClick={() => setMovementSearch('')}>Очистить поиск</button>
          ) : null}
          {(movementFilter !== 'ALL' || movementSearch) ? (
            <button
              className="button-ghost"
              onClick={() => {
                setMovementFilter('ALL');
                setMovementSearch('');
              }}
            >
              Сбросить всё
            </button>
          ) : null}
          <button
            className={`button-ghost quick-filter-button${movementSort === 'NEWEST' ? ' active' : ''}`}
            onClick={() => setMovementSort('NEWEST')}
          >
            Сначала новые
          </button>
          <button
            className={`button-ghost quick-filter-button${movementSort === 'OLDEST' ? ' active' : ''}`}
            onClick={() => setMovementSort('OLDEST')}
          >
            Сначала старые
          </button>
        </div>
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
      ) : visibleMovements.length === 0 ? (
        normalizedSearch ? (
          <InlineState
            title="Поиск не дал движений по текущему фильтру."
            message="Очисти поиск или выбери другой тип операций."
            actionLabel="Очистить поиск"
            onAction={() => setMovementSearch('')}
          />
        ) : (
          <InlineState
            title="По выбранному фильтру движений нет"
            message="В журнале есть операции, но для этого типа записей пока нет."
            actionLabel="Сбросить фильтр"
            onAction={() => setMovementFilter('ALL')}
          />
        )
      ) : (
        <table>
          <thead>
            <tr>
              <th>Когда</th>
              <th>Тип</th>
              <th>Товар</th>
              <th>Сотрудник</th>
              <th>Кол-во</th>
            </tr>
          </thead>
          <tbody>
            {orderedMovements.map((movement) => (
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
  defaultSessionFilter = 'ALL',
  defaultSessionSearch = '',
  defaultSessionSort = 'NEWEST',
  defaultStockSort = 'LOW_FIRST',
  defaultStockStatusFilter = 'ALL',
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
  defaultSessionFilter?: InventorySessionFilter;
  defaultSessionSearch?: string;
  defaultSessionSort?: InventorySessionSort;
  defaultStockSort?: StockReportSort;
  defaultStockStatusFilter?: StockStatusFilter;
}) {
  const [sessionFilter, setSessionFilter] = useState<InventorySessionFilter>(defaultSessionFilter);
  const [sessionSearch, setSessionSearch] = useState(defaultSessionSearch);
  const [sessionSort, setSessionSort] = useState<InventorySessionSort>(defaultSessionSort);
  const [stockSort, setStockSort] = useState<StockReportSort>(defaultStockSort);
  const [stockStatusFilter, setStockStatusFilter] = useState<StockStatusFilter>(defaultStockStatusFilter);
  const reportFilterBadges = collectReportFilterBadges(filters, categories);
  const draftSessions = report.inventory.sessions.filter((session) => session.status !== 'COMPLETED').length;
  const completedSessions = report.inventory.sessions.filter((session) => session.status === 'COMPLETED').length;
  const filteredSessions = sessionFilter === 'ALL'
    ? report.inventory.sessions
    : report.inventory.sessions.filter((session) => session.status === sessionFilter);
  const normalizedSessionSearch = sessionSearch.trim().toLowerCase();
  const compactSessionSearch = normalizeAuditToken(normalizedSessionSearch);
  const visibleSessions = normalizedSessionSearch
    ? filteredSessions.filter((session) => {
      const searchText = buildInventorySessionSearchText(session);
      if (searchText.includes(normalizedSessionSearch)) {
        return true;
      }
      if (!compactSessionSearch) {
        return false;
      }
      return normalizeAuditToken(searchText).includes(compactSessionSearch);
    })
    : filteredSessions;
  const orderedSessions = sortInventorySessionsByStartedAt(visibleSessions, sessionSort);
  const hasActiveStockFilters = Boolean(filters.stockSearch || filters.stockCategoryId || filters.lowOnly);
  const filteredStockItems = stockStatusFilter === 'ALL'
    ? stockReport.items
    : stockReport.items.filter((item) => (stockStatusFilter === 'LOW' ? item.isLowStock : !item.isLowStock));
  const orderedStockItems = sortStockReportItems(filteredStockItems, stockSort);
  const sessionFilterOptions: Array<{ value: InventorySessionFilter; label: string }> = [
    { value: 'ALL', label: 'Все' },
    { value: 'DRAFT', label: 'Черновики' },
    { value: 'COMPLETED', label: 'Завершенные' },
  ];
  const stockStatusFilterOptions: Array<{ value: StockStatusFilter; label: string }> = [
    { value: 'ALL', label: 'Все позиции' },
    { value: 'LOW', label: 'Низкий остаток' },
    { value: 'OK', label: 'В норме' },
  ];
  const hasActiveSessionControls = sessionFilter !== 'ALL' || sessionSearch.length > 0;
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
        ) : visibleSessions.length === 0 ? (
          <>
            <div className="filter-panel inventory-filter-panel">
              <div className="toolbar-actions toolbar-filters">
                {sessionFilterOptions.map((option) => (
                  <button
                    key={option.value}
                    className={`button-ghost quick-filter-button${sessionFilter === option.value ? ' active' : ''}`}
                    onClick={() => setSessionFilter(option.value)}
                  >
                    {option.label}
                  </button>
                ))}
              </div>
              <div className="toolbar-actions toolbar-filters">
                <input
                  className="input input-compact"
                  value={sessionSearch}
                  onChange={(event) => setSessionSearch(event.target.value)}
                  placeholder="Поиск по ID, сотруднику, статусу, дате, комментарию или позициям"
                />
                {sessionSearch ? (
                  <button className="button-ghost" onClick={() => setSessionSearch('')}>Очистить поиск</button>
                ) : null}
                {hasActiveSessionControls ? (
                  <button
                    className="button-ghost"
                    onClick={() => {
                      setSessionFilter('ALL');
                      setSessionSearch('');
                    }}
                  >
                    Сбросить всё
                  </button>
                ) : null}
                <button
                  className={`button-ghost quick-filter-button${sessionSort === 'NEWEST' ? ' active' : ''}`}
                  onClick={() => setSessionSort('NEWEST')}
                >
                  Сначала новые
                </button>
                <button
                  className={`button-ghost quick-filter-button${sessionSort === 'OLDEST' ? ' active' : ''}`}
                  onClick={() => setSessionSort('OLDEST')}
                >
                  Сначала старые
                </button>
              </div>
            </div>
            {normalizedSessionSearch ? (
              <InlineState
                title="Поиск не дал сессий по текущему фильтру."
                message="Очисти поиск или выбери другой статус сессий."
                actionLabel="Очистить поиск"
                onAction={() => setSessionSearch('')}
              />
            ) : (
              <InlineState
                title="По выбранному фильтру сессий нет"
                message="В списке есть другие сессии инвентаризации, но не в этом статусе."
                actionLabel="Сбросить фильтр"
                onAction={() => setSessionFilter('ALL')}
              />
            )}
          </>
        ) : (
          <>
            <div className="filter-panel inventory-filter-panel">
              <div className="toolbar-actions toolbar-filters">
                {sessionFilterOptions.map((option) => (
                  <button
                    key={option.value}
                    className={`button-ghost quick-filter-button${sessionFilter === option.value ? ' active' : ''}`}
                    onClick={() => setSessionFilter(option.value)}
                  >
                    {option.label}
                  </button>
                ))}
              </div>
              <div className="toolbar-actions toolbar-filters">
                <input
                  className="input input-compact"
                  value={sessionSearch}
                  onChange={(event) => setSessionSearch(event.target.value)}
                  placeholder="Поиск по ID, сотруднику, статусу, дате, комментарию или позициям"
                />
                {sessionSearch ? (
                  <button className="button-ghost" onClick={() => setSessionSearch('')}>Очистить поиск</button>
                ) : null}
                {hasActiveSessionControls ? (
                  <button
                    className="button-ghost"
                    onClick={() => {
                      setSessionFilter('ALL');
                      setSessionSearch('');
                    }}
                  >
                    Сбросить всё
                  </button>
                ) : null}
                <button
                  className={`button-ghost quick-filter-button${sessionSort === 'NEWEST' ? ' active' : ''}`}
                  onClick={() => setSessionSort('NEWEST')}
                >
                  Сначала новые
                </button>
                <button
                  className={`button-ghost quick-filter-button${sessionSort === 'OLDEST' ? ' active' : ''}`}
                  onClick={() => setSessionSort('OLDEST')}
                >
                  Сначала старые
                </button>
              </div>
            </div>
            <table>
              <thead>
                <tr>
                  <th>Когда</th>
                  <th>ID</th>
                  <th>Статус</th>
                  <th>Сотрудник</th>
                  <th>Позиций</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {orderedSessions.map((session) => (
                  <InventorySessionRow
                    key={session.id}
                    session={session}
                    onOpen={() => onOpenSession(session.id)}
                  />
                ))}
              </tbody>
            </table>
          </>
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
              placeholder="Поиск по товару / SKU / штрихкоду"
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
            {stockStatusFilterOptions.map((option) => (
              <button
                key={option.value}
                className={`button-ghost quick-filter-button${stockStatusFilter === option.value ? ' active' : ''}`}
                onClick={() => setStockStatusFilter(option.value)}
              >
                {option.label}
              </button>
            ))}
            <button
              className={`button-ghost quick-filter-button${stockSort === 'LOW_FIRST' ? ' active' : ''}`}
              onClick={() => setStockSort('LOW_FIRST')}
            >
              Риск сначала
            </button>
            <button
              className={`button-ghost quick-filter-button${stockSort === 'NAME_ASC' ? ' active' : ''}`}
              onClick={() => setStockSort('NAME_ASC')}
            >
              По названию
            </button>
          </div>
        </div>
        {stockReport.items.length === 0 ? (
          <InlineState
            title="По текущим фильтрам позиций нет"
            message="Сними фильтры или добавь товары, чтобы увидеть отчет по остаткам."
          />
        ) : orderedStockItems.length === 0 ? (
          <InlineState
            title="По выбранному статусу позиций нет"
            message="В отчете есть позиции, но не в выбранном статусе."
            actionLabel="Сбросить статус"
            onAction={() => setStockStatusFilter('ALL')}
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
              {orderedStockItems.map((item) => (
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
  defaultFilter = 'ALL',
  defaultSearch = '',
  defaultSort = 'ACTIVE_FIRST',
}: {
  company: CompanyDto;
  users: CompanyUserDto[];
  isOwner: boolean;
  onEditCompany: () => void;
  onInvite: () => void;
  onEditUser: (user: CompanyUserDto) => void;
  defaultFilter?: TeamFilter;
  defaultSearch?: string;
  defaultSort?: TeamSort;
}) {
  const [teamFilter, setTeamFilter] = useState<TeamFilter>(defaultFilter);
  const [teamSearch, setTeamSearch] = useState(defaultSearch);
  const [teamSort, setTeamSort] = useState<TeamSort>(defaultSort);
  const activeUsers = users.filter((user) => user.isActive).length;
  const inactiveUsers = users.length - activeUsers;
  const managers = users.filter((user) => user.role === 'MANAGER').length;
  const staff = users.filter((user) => user.role === 'STAFF').length;
  const hasInvites = users.some((user) => Boolean(user.inviteExpiresAt));
  const teamFilterOptions: Array<{ value: TeamFilter; label: string }> = [
    { value: 'ALL', label: 'Все' },
    { value: 'ACTIVE', label: 'Активные' },
    { value: 'MANAGER', label: 'Менеджеры' },
    { value: 'STAFF', label: 'Сотрудники' },
    { value: 'INVITED', label: 'Приглашения' },
  ];
  const normalizedSearch = teamSearch.trim().toLowerCase();
  const filteredUsers = users.filter((user) => {
    switch (teamFilter) {
      case 'ACTIVE':
        return user.isActive;
      case 'MANAGER':
        return user.role === 'MANAGER';
      case 'STAFF':
        return user.role === 'STAFF';
      case 'INVITED':
        return Boolean(user.inviteExpiresAt);
      case 'ALL':
      default:
        return true;
    }
  });
  const visibleUsers = normalizedSearch
    ? filteredUsers.filter((user) => buildTeamUserSearchText(user).includes(normalizedSearch))
    : filteredUsers;
  const orderedUsers = sortTeamUsers(visibleUsers, teamSort);

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
            {hasInvites ? <div className="badge">Приглашений: {users.filter((user) => Boolean(user.inviteExpiresAt)).length}</div> : null}
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
            <>
              <div className="filter-panel team-filter-panel">
                <div className="toolbar-actions toolbar-filters">
                  {teamFilterOptions.map((option) => (
                    <button
                      key={option.value}
                      className={`button-ghost quick-filter-button${teamFilter === option.value ? ' active' : ''}`}
                      onClick={() => setTeamFilter(option.value)}
                    >
                      {option.label}
                    </button>
                  ))}
                </div>
                <div className="toolbar-actions toolbar-filters">
                  <input
                    className="input input-compact"
                    value={teamSearch}
                    onChange={(event) => setTeamSearch(event.target.value)}
                    placeholder="Поиск по имени, email, телефону, роли, статусу, ID или дате приглашения"
                  />
                  {teamSearch ? (
                    <button className="button-ghost" onClick={() => setTeamSearch('')}>Очистить поиск</button>
                  ) : null}
                  {(teamFilter !== 'ALL' || teamSearch) ? (
                    <button
                      className="button-ghost"
                      onClick={() => {
                        setTeamFilter('ALL');
                        setTeamSearch('');
                      }}
                    >
                      Сбросить всё
                    </button>
                  ) : null}
                  <button
                    className={`button-ghost quick-filter-button${teamSort === 'ACTIVE_FIRST' ? ' active' : ''}`}
                    onClick={() => setTeamSort('ACTIVE_FIRST')}
                  >
                    Активные сначала
                  </button>
                  <button
                    className={`button-ghost quick-filter-button${teamSort === 'NAME_ASC' ? ' active' : ''}`}
                    onClick={() => setTeamSort('NAME_ASC')}
                  >
                    По имени
                  </button>
                </div>
              </div>
              {visibleUsers.length === 0 ? (
                normalizedSearch ? (
                  <InlineState
                    title="Поиск не дал сотрудников по текущему фильтру."
                    message="Очисти поиск или выбери другой фильтр команды."
                    actionLabel="Очистить поиск"
                    onAction={() => setTeamSearch('')}
                  />
                ) : (
                  <InlineState
                    title="По выбранному фильтру сотрудников нет"
                    message="В команде есть сотрудники, но в этом срезе список сейчас пуст."
                    actionLabel="Сбросить фильтр"
                    onAction={() => setTeamFilter('ALL')}
                  />
                )
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
                    {orderedUsers.map((user) => (
                      <TeamUserRow
                        key={user.id}
                        user={user}
                        onEdit={() => onEditUser(user)}
                      />
                    ))}
                  </tbody>
                </table>
              )}
            </>
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
  const hasInvite = Boolean(user.inviteExpiresAt);
  const statusLabel = user.isActive
    ? 'Активен'
    : hasInvite
      ? 'Ожидает активации'
      : 'Неактивен';
  return (
    <tr>
      <td>{user.name}</td>
      <td>{user.email ?? '—'}</td>
      <td>{formatRoleLabel(user.role)}</td>
      <td>
        <div className="user-status-stack">
          <span className={`badge ${!user.isActive ? 'warn' : ''}`}>
            {statusLabel}
          </span>
          {hasInvite ? (
            <span className="badge warn">
              Приглашение до {new Date(user.inviteExpiresAt as string).toLocaleDateString('ru-RU')}
            </span>
          ) : null}
        </div>
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
            detail={buildExportFileName('movements-journal', [])}
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
      <td>{new Date(session.startedAt).toLocaleString('ru-RU')}</td>
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
  defaultSearch = '',
  defaultSort = 'NEWEST',
}: {
  logs: AuditLogDto[];
  filters: AuditFiltersState;
  users: CompanyUserDto[];
  onChangeFilters: (next: Partial<AuditFiltersState>) => void;
  onClearFilters: () => void;
  onExport: () => void;
  defaultSearch?: string;
  defaultSort?: 'NEWEST' | 'OLDEST';
}) {
  const [auditSearch, setAuditSearch] = useState(defaultSearch);
  const [auditSort, setAuditSort] = useState<'NEWEST' | 'OLDEST'>(defaultSort);
  const entityFilterPresets: Array<{ label: string; value: string }> = [
    { label: 'Все сущности', value: '' },
    { label: 'Товары', value: 'product' },
    { label: 'Категории', value: 'category' },
    { label: 'Движения', value: 'stock_movement' },
    { label: 'Сессии инвентаризации', value: 'inventory_session' },
    { label: 'Сотрудники', value: 'user' },
  ];
  const actionFilterPresets: Array<{ label: string; value: string }> = [
    { label: 'Все действия', value: '' },
    { label: 'Приглашения', value: 'user.invited' },
    { label: 'Завершение инвентаризации', value: 'inventory.finished' },
    { label: 'Обновление позиции инвентаризации', value: 'inventory.item.updated' },
    { label: 'Обновление товара', value: 'product.updated' },
    { label: 'Обновление сотрудника', value: 'user.updated' },
  ];
  const normalizedAuditSearch = auditSearch.trim().toLowerCase();
  const compactAuditSearch = normalizeAuditToken(normalizedAuditSearch);
  const filteredLogs = normalizedAuditSearch
    ? logs.filter((log) => {
      const payloadSearchText = buildAuditPayloadSummary(log.payload).join(' ');
      const searchValues = [
        formatAuditActionLabel(log.action),
        formatEntityTypeLabel(log.entityType),
        log.id,
        log.action,
        log.entityType,
        log.createdAt,
        new Date(log.createdAt).toLocaleString('ru-RU'),
        log.user.id,
        log.user.name,
        formatRoleLabel(log.user.role),
        log.user.role,
        log.entityId ?? '',
        payloadSearchText,
      ].join(' ').toLowerCase();
      if (searchValues.includes(normalizedAuditSearch)) {
        return true;
      }
      if (!compactAuditSearch) {
        return false;
      }
      return normalizeAuditToken(searchValues).includes(compactAuditSearch);
    })
    : logs;
  const visibleLogs = filteredLogs
    .slice()
    .sort((left, right) => (
      auditSort === 'OLDEST'
        ? new Date(left.createdAt).getTime() - new Date(right.createdAt).getTime()
        : new Date(right.createdAt).getTime() - new Date(left.createdAt).getTime()
    ));
  const insights = buildAuditInsights(visibleLogs);
  const filterBadges = collectAuditFilterBadges(filters, users);
  const hasActiveFilters = filterBadges.length > 0;
  const hasActiveControls = hasActiveFilters || normalizedAuditSearch.length > 0;
  return (
    <section className="table-card">
      <div className="toolbar">
        <div className="toolbar-title">
          <div className="section-label">Журнал действий</div>
          <h3 style={{ margin: 0 }}>Журнал изменений</h3>
        </div>
        <div className="toolbar-actions">
          <button className="button-ghost" onClick={onExport}>Экспорт CSV</button>
          <button
            className={`button-ghost quick-filter-button${auditSort === 'NEWEST' ? ' active' : ''}`}
            onClick={() => setAuditSort('NEWEST')}
          >
            Сначала новые
          </button>
          <button
            className={`button-ghost quick-filter-button${auditSort === 'OLDEST' ? ' active' : ''}`}
            onClick={() => setAuditSort('OLDEST')}
          >
            Сначала старые
          </button>
          <div className="badge">Записей: {visibleLogs.length}</div>
          {normalizedAuditSearch ? <div className="badge">Всего в выборке: {logs.length}</div> : null}
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
        <input
          className="input"
          value={auditSearch}
          onChange={(event) => setAuditSearch(event.target.value)}
          placeholder="Поиск по действию, сущности, ID, сотруднику, роли, дате или деталям"
        />
        {hasActiveFilters ? (
          <button className="button-ghost audit-filter-reset" onClick={onClearFilters}>Сбросить фильтры</button>
        ) : null}
        {normalizedAuditSearch ? (
          <button className="button-ghost audit-filter-reset" onClick={() => setAuditSearch('')}>Очистить поиск</button>
        ) : null}
        {hasActiveControls ? (
          <button
            className="button-ghost audit-filter-reset"
            onClick={() => {
              onClearFilters();
              setAuditSearch('');
            }}
          >
            Сбросить всё
          </button>
        ) : null}
      </div>
      <div className="filter-panel audit-preset-panel">
        <div className="toolbar-actions toolbar-filters">
          {entityFilterPresets.map((preset) => (
            <button
              key={preset.label}
              className={`button-ghost quick-filter-button${filters.entityType === preset.value ? ' active' : ''}`}
              onClick={() => onChangeFilters({ entityType: preset.value })}
            >
              {preset.label}
            </button>
          ))}
        </div>
        <div className="toolbar-actions toolbar-filters">
          {actionFilterPresets.map((preset) => (
            <button
              key={preset.label}
              className={`button-ghost quick-filter-button${filters.action === preset.value ? ' active' : ''}`}
              onClick={() => onChangeFilters({ action: preset.value })}
            >
              {preset.label}
            </button>
          ))}
        </div>
      </div>
      <ActiveFilterChips
        title="Активные фильтры"
        badges={filterBadges}
        emptyLabel="Фильтры не заданы"
        compact
      />
      {visibleLogs.length > 0 ? (
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
      ) : visibleLogs.length === 0 ? (
        <InlineState
          title="Поиск не дал записей по текущим фильтрам"
          message="Очисти поиск или измени фильтры журнала."
          actionLabel="Очистить поиск"
          onAction={() => setAuditSearch('')}
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
            {visibleLogs.map((item) => (
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
  return (
    <tr>
      <td>{new Date(movement.createdAt).toLocaleString('ru-RU')}</td>
      <td>{formatMovementTypeLabel(movement.movementType)}</td>
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
        {!log.payload && !log.entityId ? (
          '—'
        ) : (
          <div className="audit-payload-stack">
            {log.entityId ? <span className="badge">ID: {log.entityId}</span> : null}
            {payloadSummary.map((item) => (
              <span key={item} className="badge">{item}</span>
            ))}
            {payloadSummary.length === 0 && !log.entityId ? <span className="badge">Есть изменения</span> : null}
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
        <label className="field-block">
          <span className="field-label">Товар</span>
          <select className="select" value={productId} onChange={(e) => setProductId(e.target.value)}>
            {products.map((product) => <option key={product.id} value={product.id}>{product.name}</option>)}
          </select>
        </label>
        <label className="field-block">
          <span className="field-label">{kind === 'adjustment' ? 'Целевой остаток' : 'Количество'}</span>
          <input className="input" type="number" inputMode="numeric" value={quantity} onChange={(e) => setQuantity(e.target.value)} placeholder={kind === 'adjustment' ? 'Целевой остаток' : 'Количество'} />
        </label>
        <label className="field-block">
          <span className="field-label">Комментарий</span>
          <textarea className="textarea" value={comment} onChange={(e) => setComment(e.target.value)} placeholder="Комментарий" />
        </label>
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
        <label className="field-block"><span className="field-label">Телефон</span><input className="input" value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="Телефон" /></label>
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
        <label className="field-block">
          <span className="field-label">Роль сотрудника</span>
          <select className="select" value={role} onChange={(e) => setRole(e.target.value as 'MANAGER' | 'STAFF')}>
            <option value="STAFF">Сотрудник</option>
            <option value="MANAGER">Менеджер</option>
          </select>
        </label>
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
          <label className="field-block">
            <span className="field-label">Роль сотрудника</span>
            <select className="select" value={role} onChange={(e) => setRole(e.target.value as 'MANAGER' | 'STAFF')}>
              <option value="STAFF">Сотрудник</option>
              <option value="MANAGER">Менеджер</option>
            </select>
          </label>
        </div>
        <label className="field-block">
          <span className="field-label">Новый пароль</span>
          <input className="input" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Новый пароль" />
        </label>
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
