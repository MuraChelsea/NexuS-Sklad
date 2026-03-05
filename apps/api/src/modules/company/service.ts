import type { PrismaClient } from '@prisma/client';

import { AppError } from '../../lib/app-error.js';

type UpdateCompanyInput = {
  companyId: string;
  userId: string;
  name?: string;
  city?: string | null;
  phone?: string | null;
};

export class CompanyService {
  constructor(private readonly prisma: PrismaClient) {}

  async getById(companyId: string) {
    const company = await this.prisma.company.findUnique({
      where: { id: companyId },
    });

    if (!company) {
      throw new AppError(404, 'COMPANY_NOT_FOUND', 'Company not found');
    }

    return company;
  }

  async update(input: UpdateCompanyInput) {
    const existing = await this.getById(input.companyId);

    const name = input.name?.trim();
    if (input.name !== undefined && !name) {
      throw new AppError(400, 'COMPANY_NAME_EMPTY', 'Company name must not be empty');
    }

    return this.prisma.$transaction(async (tx) => {
      const company = await tx.company.update({
        where: { id: input.companyId },
        data: {
          name,
          city: this.normalizeOptionalString(input.city),
          phone: this.normalizeOptionalString(input.phone),
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: input.companyId,
          userId: input.userId,
          action: 'company.updated',
          entityType: 'company',
          entityId: company.id,
          payload: {
            before: {
              name: existing.name,
              city: existing.city,
              phone: existing.phone,
            },
            after: {
              name: company.name,
              city: company.city,
              phone: company.phone,
            },
          },
        },
      });

      return company;
    });
  }

  private normalizeOptionalString(value?: string | null) {
    if (value === undefined) {
      return undefined;
    }

    const trimmed = value?.trim();
    return trimmed ? trimmed : null;
  }
}
