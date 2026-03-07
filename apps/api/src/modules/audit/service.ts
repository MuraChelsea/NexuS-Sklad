import type { PrismaClient } from '@prisma/client';

type ListAuditLogsInput = {
  companyId: string;
  userId?: string;
  entityType?: string;
  action?: string;
  limit?: number;
  offset?: number;
};

export class AuditService {
  constructor(private readonly prisma: PrismaClient) {}

  async list(input: ListAuditLogsInput) {
    const action = input.action?.trim();
    const entityType = input.entityType?.trim();

    return this.prisma.auditLog.findMany({
      where: {
        companyId: input.companyId,
        ...(input.userId ? { userId: input.userId } : {}),
        ...(entityType ? { entityType } : {}),
        ...(action ? { action: { contains: action, mode: 'insensitive' } } : {}),
      },
      orderBy: [{ createdAt: 'desc' }],
      take: input.limit ?? 50,
      skip: input.offset ?? 0,
      include: {
        user: {
          select: {
            id: true,
            name: true,
            role: true,
          },
        },
      },
    });
  }
}
