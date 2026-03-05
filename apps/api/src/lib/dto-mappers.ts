import type { Prisma } from '@prisma/client';
import type {
  AuditLogDto,
  CategoryDto,
  CompanyDto,
  CompanyUserDto,
  DailyReportDto,
  InventoryItemDto,
  InventorySessionDto,
  ProductDto,
  StockMovementDto,
  StockReportDto,
} from '@nexussklad/shared';

type DecimalLike = Prisma.Decimal | number | string;
type DateLike = Date | string | null;

export function toCompanyDto(company: {
  id: string;
  name: string;
  city: string | null;
  phone: string | null;
  createdAt: Date;
}): CompanyDto {
  return {
    id: company.id,
    name: company.name,
    city: company.city,
    phone: company.phone,
    createdAt: toIso(company.createdAt)!,
  };
}

export function toCategoryDto(category: {
  id: string;
  companyId: string;
  parentId: string | null;
  name: string;
  createdAt: Date;
}): CategoryDto {
  return {
    id: category.id,
    companyId: category.companyId,
    parentId: category.parentId,
    name: category.name,
    createdAt: toIso(category.createdAt)!,
  };
}

export function toProductDto(product: {
  id: string;
  companyId: string;
  categoryId: string | null;
  name: string;
  sku: string | null;
  barcode: string | null;
  unit: string;
  description: string | null;
  minStock: DecimalLike;
  currentStock: DecimalLike;
  createdAt: Date;
  updatedAt: Date;
  category?: { id: string; name: string } | null;
}): ProductDto {
  return {
    id: product.id,
    companyId: product.companyId,
    categoryId: product.categoryId,
    name: product.name,
    sku: product.sku,
    barcode: product.barcode,
    unit: product.unit,
    description: product.description,
    minStock: toDecimalString(product.minStock),
    currentStock: toDecimalString(product.currentStock),
    createdAt: toIso(product.createdAt)!,
    updatedAt: toIso(product.updatedAt)!,
    category: product.category
      ? {
          id: product.category.id,
          name: product.category.name,
        }
      : null,
  };
}

export function toCompanyUserDto(user: {
  id: string;
  companyId: string;
  name: string;
  email: string | null;
  phone: string | null;
  role: 'OWNER' | 'MANAGER' | 'STAFF';
  isActive: boolean;
  createdAt: Date;
  inviteExpiresAt: Date | null;
}): CompanyUserDto {
  return {
    id: user.id,
    companyId: user.companyId,
    name: user.name,
    email: user.email,
    phone: user.phone,
    role: user.role,
    isActive: user.isActive,
    createdAt: toIso(user.createdAt)!,
    inviteExpiresAt: toIso(user.inviteExpiresAt),
  };
}

export function toAuditLogDto(log: {
  id: string;
  companyId: string;
  userId: string;
  action: string;
  entityType: string;
  entityId: string | null;
  payload: Prisma.JsonValue | null;
  createdAt: Date;
  user: {
    id: string;
    name: string;
    role: 'OWNER' | 'MANAGER' | 'STAFF';
  };
}): AuditLogDto {
  return {
    id: log.id,
    companyId: log.companyId,
    userId: log.userId,
    action: log.action,
    entityType: log.entityType,
    entityId: log.entityId,
    payload: isJsonObject(log.payload) ? log.payload : null,
    createdAt: toIso(log.createdAt)!,
    user: {
      id: log.user.id,
      name: log.user.name,
      role: log.user.role,
    },
  };
}

export function toStockMovementDto(movement: {
  id: string;
  companyId: string;
  productId: string;
  createdById: string;
  movementType: 'INCOME' | 'EXPENSE' | 'ADJUSTMENT' | 'INVENTORY_DIFF';
  quantity: DecimalLike;
  beforeQty: DecimalLike;
  afterQty: DecimalLike;
  comment: string | null;
  createdAt: Date;
  product: {
    id: string;
    name: string;
    sku: string | null;
    unit: string;
  };
  createdBy: {
    id: string;
    name: string;
    role: 'OWNER' | 'MANAGER' | 'STAFF';
  };
}): StockMovementDto {
  return {
    id: movement.id,
    companyId: movement.companyId,
    productId: movement.productId,
    createdById: movement.createdById,
    movementType: movement.movementType,
    quantity: toDecimalString(movement.quantity),
    beforeQty: toDecimalString(movement.beforeQty),
    afterQty: toDecimalString(movement.afterQty),
    comment: movement.comment,
    createdAt: toIso(movement.createdAt)!,
    product: {
      id: movement.product.id,
      name: movement.product.name,
      sku: movement.product.sku,
      unit: movement.product.unit,
    },
    createdBy: {
      id: movement.createdBy.id,
      name: movement.createdBy.name,
      role: movement.createdBy.role,
    },
  };
}

export function toInventoryItemDto(item: {
  id: string;
  sessionId: string;
  productId: string;
  expectedQty: DecimalLike;
  actualQty: DecimalLike;
  difference: DecimalLike;
  comment: string | null;
  product: {
    id: string;
    name: string;
    sku: string | null;
    unit: string;
  };
}): InventoryItemDto {
  return {
    id: item.id,
    sessionId: item.sessionId,
    productId: item.productId,
    expectedQty: toDecimalString(item.expectedQty),
    actualQty: toDecimalString(item.actualQty),
    difference: toDecimalString(item.difference),
    comment: item.comment,
    product: {
      id: item.product.id,
      name: item.product.name,
      sku: item.product.sku,
      unit: item.product.unit,
    },
  };
}

export function toInventorySessionDto(session: {
  id: string;
  companyId: string;
  startedById: string;
  status: 'DRAFT' | 'IN_PROGRESS' | 'COMPLETED';
  comment: string | null;
  startedAt: Date;
  finishedAt: Date | null;
  startedBy: {
    id: string;
    name: string;
    role: 'OWNER' | 'MANAGER' | 'STAFF';
  };
  items: Array<Parameters<typeof toInventoryItemDto>[0]>;
}): InventorySessionDto {
  return {
    id: session.id,
    companyId: session.companyId,
    startedById: session.startedById,
    startedBy: {
      id: session.startedBy.id,
      name: session.startedBy.name,
      role: session.startedBy.role,
    },
    status: session.status,
    comment: session.comment,
    startedAt: toIso(session.startedAt)!,
    finishedAt: toIso(session.finishedAt),
    items: session.items.map(toInventoryItemDto),
  };
}

export function toDailyReportDto(report: {
  date: string;
  movementSummary: Record<string, { count: number; quantity: DecimalLike }>;
  inventory: {
    sessionsCount: number;
    sessions: Array<{
      id: string;
      status: string;
      startedAt: Date;
      finishedAt: Date | null;
      comment: string | null;
      startedBy: {
        id: string;
        name: string;
      };
      _count: {
        items: number;
      };
    }>;
  };
  stock: {
    totalProducts: number;
    lowStockCount: number;
  };
}): DailyReportDto {
  return {
    date: report.date,
    movementSummary: Object.fromEntries(
      Object.entries(report.movementSummary).map(([key, value]) => [
        key,
        {
          count: value.count,
          quantity: toDecimalString(value.quantity),
        },
      ]),
    ),
    inventory: {
      sessionsCount: report.inventory.sessionsCount,
      sessions: report.inventory.sessions.map((session) => ({
        id: session.id,
        status: session.status,
        startedAt: toIso(session.startedAt)!,
        finishedAt: toIso(session.finishedAt),
        comment: session.comment,
        startedBy: {
          id: session.startedBy.id,
          name: session.startedBy.name,
        },
        _count: {
          items: session._count.items,
        },
      })),
    },
    stock: {
      totalProducts: report.stock.totalProducts,
      lowStockCount: report.stock.lowStockCount,
    },
  };
}

export function toStockReportDto(report: {
  summary: {
    totalItems: number;
    lowStockItems: number;
  };
  items: Array<{
    id: string;
    name: string;
    sku: string | null;
    unit: string;
    currentStock: DecimalLike;
    minStock: DecimalLike;
    isLowStock: boolean;
    category: { id: string; name: string } | null;
  }>;
}): StockReportDto {
  return {
    summary: {
      totalItems: report.summary.totalItems,
      lowStockItems: report.summary.lowStockItems,
    },
    items: report.items.map((item) => ({
      id: item.id,
      name: item.name,
      sku: item.sku,
      unit: item.unit,
      currentStock: toDecimalString(item.currentStock),
      minStock: toDecimalString(item.minStock),
      isLowStock: item.isLowStock,
      category: item.category
        ? {
            id: item.category.id,
            name: item.category.name,
          }
        : null,
    })),
  };
}

export function toDecimalString(value: DecimalLike): string {
  return value.toString();
}

export function toIso(value: DateLike): string | null {
  if (value == null) {
    return null;
  }

  return value instanceof Date ? value.toISOString() : value;
}

function isJsonObject(value: Prisma.JsonValue | null): value is Prisma.JsonObject {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}
