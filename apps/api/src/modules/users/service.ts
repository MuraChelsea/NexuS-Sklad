import { UserRole, type PrismaClient } from '@prisma/client';

import { AppError } from '../../lib/app-error.js';
import { generateInviteToken, hashInviteToken } from '../../lib/invite-token.js';
import { hashPassword } from '../../lib/password.js';

type CreateUserInput = {
  companyId: string;
  actorUserId: string;
  name: string;
  email: string;
  phone?: string | null;
  password: string;
  role: UserRole;
};

type UpdateUserInput = {
  companyId: string;
  actorUserId: string;
  userId: string;
  name?: string;
  email?: string;
  phone?: string | null;
  password?: string;
  role?: UserRole;
  isActive?: boolean;
};

type InviteUserInput = {
  companyId: string;
  actorUserId: string;
  email: string;
  role: UserRole;
};

export class UserService {
  constructor(private readonly prisma: PrismaClient) {}

  async list(companyId: string) {
    return this.prisma.user.findMany({
      where: { companyId },
      orderBy: [{ createdAt: 'asc' }],
      select: {
        id: true,
        companyId: true,
        name: true,
        email: true,
        phone: true,
        role: true,
        isActive: true,
        createdAt: true,
        inviteExpiresAt: true,
      },
    });
  }

  async create(input: CreateUserInput) {
    const name = input.name.trim();
    const email = input.email.trim().toLowerCase();

    if (!name) {
      throw new AppError(400, 'USER_NAME_EMPTY', 'User name must not be empty');
    }

    await this.ensureUniqueEmail(email);

    return this.prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: {
          companyId: input.companyId,
          name,
          email,
          phone: this.normalizeOptionalString(input.phone) ?? null,
          passwordHash: hashPassword(input.password),
          role: input.role,
          isActive: true,
        },
        select: {
          id: true,
          companyId: true,
          name: true,
          email: true,
          phone: true,
          role: true,
          isActive: true,
          createdAt: true,
          inviteExpiresAt: true,
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: input.companyId,
          userId: input.actorUserId,
          action: 'user.created',
          entityType: 'user',
          entityId: user.id,
          payload: {
            name: user.name,
            email: user.email,
            role: user.role,
            isActive: user.isActive,
          },
        },
      });

      return user;
    });
  }

  async invite(input: InviteUserInput) {
    const email = input.email.trim().toLowerCase();
    await this.ensureUniqueEmail(email);

    const inviteToken = generateInviteToken();
    const inviteTokenHash = hashInviteToken(inviteToken);
    const inviteExpiresAt = new Date(Date.now() + 1000 * 60 * 60 * 24 * 7);

    const user = await this.prisma.$transaction(async (tx) => {
      const createdUser = await tx.user.create({
        data: {
          companyId: input.companyId,
          name: 'Invited user',
          email,
          passwordHash: hashPassword(generateInviteToken()),
          role: input.role,
          isActive: false,
          inviteTokenHash,
          inviteExpiresAt,
        },
        select: {
          id: true,
          companyId: true,
          name: true,
          email: true,
          phone: true,
          role: true,
          isActive: true,
          createdAt: true,
          inviteExpiresAt: true,
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: input.companyId,
          userId: input.actorUserId,
          action: 'user.invited',
          entityType: 'user',
          entityId: createdUser.id,
          payload: {
            email: createdUser.email,
            role: createdUser.role,
            inviteExpiresAt: createdUser.inviteExpiresAt?.toISOString() ?? null,
          },
        },
      });

      return createdUser;
    });

    return {
      user,
      inviteToken,
    };
  }

  async update(input: UpdateUserInput) {
    const existing = await this.getManagedUser(input.companyId, input.userId);
    const name = input.name?.trim();
    const email = input.email?.trim().toLowerCase();

    if (input.name !== undefined && !name) {
      throw new AppError(400, 'USER_NAME_EMPTY', 'User name must not be empty');
    }

    if (email) {
      await this.ensureUniqueEmail(email, input.userId);
    }

    return this.prisma.$transaction(async (tx) => {
      const user = await tx.user.update({
        where: { id: input.userId },
        data: {
          name,
          email,
          phone: this.normalizeOptionalString(input.phone),
          role: input.role,
          isActive: input.isActive,
          passwordHash: input.password ? hashPassword(input.password) : undefined,
        },
        select: {
          id: true,
          companyId: true,
          name: true,
          email: true,
          phone: true,
          role: true,
          isActive: true,
          createdAt: true,
          inviteExpiresAt: true,
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: input.companyId,
          userId: input.actorUserId,
          action: 'user.updated',
          entityType: 'user',
          entityId: user.id,
          payload: {
            before: {
              name: existing.name,
              email: existing.email,
              phone: existing.phone,
              role: existing.role,
              isActive: existing.isActive,
              inviteExpiresAt: existing.inviteExpiresAt?.toISOString() ?? null,
            },
            after: {
              name: user.name,
              email: user.email,
              phone: user.phone,
              role: user.role,
              isActive: user.isActive,
              inviteExpiresAt: user.inviteExpiresAt?.toISOString() ?? null,
            },
          },
        },
      });

      return user;
    });
  }

  private async getManagedUser(companyId: string, userId: string) {
    const user = await this.prisma.user.findFirst({
      where: {
        id: userId,
        companyId,
      },
      select: {
        id: true,
        name: true,
        email: true,
        phone: true,
        role: true,
        isActive: true,
        inviteExpiresAt: true,
      },
    });

    if (!user) {
      throw new AppError(404, 'USER_NOT_FOUND', 'User not found');
    }

    if (user.role === UserRole.OWNER) {
      throw new AppError(409, 'OWNER_USER_PROTECTED', 'Owner user is managed separately');
    }

    return user;
  }

  private async ensureUniqueEmail(email: string, excludeUserId?: string) {
    const duplicate = await this.prisma.user.findFirst({
      where: {
        email,
        ...(excludeUserId ? { id: { not: excludeUserId } } : {}),
      },
      select: { id: true },
    });

    if (duplicate) {
      throw new AppError(409, 'USER_EMAIL_TAKEN', 'Email is already in use');
    }
  }

  private normalizeOptionalString(value?: string | null) {
    if (value === undefined) {
      return undefined;
    }

    const trimmed = value?.trim();
    return trimmed ? trimmed : null;
  }
}
