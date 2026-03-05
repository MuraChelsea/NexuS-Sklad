import { UserRole, type PrismaClient } from '@prisma/client';

import { AppError } from '../../lib/app-error.js';
import { compareInviteToken } from '../../lib/invite-token.js';
import { hashPassword, verifyPassword } from '../../lib/password.js';
import { signAuthToken, verifyAuthToken } from '../../lib/token.js';

type LoginInput = {
  email: string;
  password: string;
};

type RegisterInput = {
  companyName: string;
  companyCity?: string | null;
  companyPhone?: string | null;
  ownerName: string;
  email: string;
  phone?: string | null;
  password: string;
};

type AcceptInviteInput = {
  inviteToken: string;
  name: string;
  phone?: string | null;
  password: string;
};

type TokenSecrets = {
  accessSecret: string;
  refreshSecret: string;
};

type AuthUserView = {
  id: string;
  companyId: string;
  name: string;
  email: string | null;
  phone: string | null;
  role: UserRole;
  company: { id: string; name: string };
};

type AuthSubject = {
  userId: string;
  companyId: string;
  role: UserRole;
  tokenVersion: number;
};

export class AuthService {
  constructor(private readonly prisma: PrismaClient) {}

  async register(input: RegisterInput, secrets: TokenSecrets, options?: { allowPublicRegistration?: boolean }) {
    await this.assertRegistrationAllowed(options?.allowPublicRegistration ?? true);

    const companyName = input.companyName.trim();
    const ownerName = input.ownerName.trim();
    const email = input.email.trim().toLowerCase();

    if (!companyName) {
      throw new AppError(400, 'COMPANY_NAME_EMPTY', 'Company name must not be empty');
    }

    if (!ownerName) {
      throw new AppError(400, 'OWNER_NAME_EMPTY', 'Owner name must not be empty');
    }

    await this.ensureGlobalUniqueEmail(email);

    const created = await this.prisma.$transaction(async (tx) => {
      const company = await tx.company.create({
        data: {
          name: companyName,
          city: this.normalizeOptionalString(input.companyCity) ?? null,
          phone: this.normalizeOptionalString(input.companyPhone) ?? null,
        },
      });

      const owner = await tx.user.create({
        data: {
          companyId: company.id,
          name: ownerName,
          email,
          phone: this.normalizeOptionalString(input.phone) ?? null,
          passwordHash: hashPassword(input.password),
          role: UserRole.OWNER,
          isActive: true,
        },
        include: {
          company: {
            select: {
              id: true,
              name: true,
            },
          },
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: company.id,
          userId: owner.id,
          action: 'auth.register',
          entityType: 'company',
          entityId: company.id,
          payload: {
            companyName: company.name,
            ownerEmail: owner.email,
          },
        },
      });

      return owner;
    });

    return this.buildAuthResponse(
      {
        userId: created.id,
        companyId: created.companyId,
        role: created.role,
        tokenVersion: created.refreshTokenVersion,
      },
      this.toAuthUserView(created),
      secrets,
    );
  }

  async login(input: LoginInput, secrets: TokenSecrets) {
    const email = input.email.trim().toLowerCase();
    const user = await this.prisma.user.findFirst({
      where: {
        email,
        isActive: true,
      },
      include: {
        company: {
          select: {
            id: true,
            name: true,
          },
        },
      },
    });

    if (!user || !verifyPassword(input.password, user.passwordHash)) {
      throw new AppError(401, 'AUTH_INVALID_CREDENTIALS', 'Invalid email or password');
    }

    return this.buildAuthResponse(
      {
        userId: user.id,
        companyId: user.companyId,
        role: user.role,
        tokenVersion: user.refreshTokenVersion,
      },
      this.toAuthUserView(user),
      secrets,
    );
  }

  async refresh(refreshToken: string, secrets: TokenSecrets) {
    const payload = verifyAuthToken(refreshToken, secrets.refreshSecret, 'refresh');
    const user = await this.getActiveUser(payload.sub, payload.companyId);
    this.assertRefreshTokenVersion(payload.tokenVersion, user.refreshTokenVersion);

    return this.buildAuthResponse(
      {
        userId: user.id,
        companyId: user.companyId,
        role: user.role,
        tokenVersion: user.refreshTokenVersion,
      },
      this.toAuthUserView(user),
      secrets,
    );
  }

  async logout(refreshToken: string, secrets: Pick<TokenSecrets, 'refreshSecret'>) {
    const payload = verifyAuthToken(refreshToken, secrets.refreshSecret, 'refresh');
    const user = await this.getActiveUser(payload.sub, payload.companyId);
    this.assertRefreshTokenVersion(payload.tokenVersion, user.refreshTokenVersion);

    await this.prisma.$transaction(async (tx) => {
      await tx.user.update({
        where: { id: user.id },
        data: {
          refreshTokenVersion: {
            increment: 1,
          },
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: user.companyId,
          userId: user.id,
          action: 'auth.logout',
          entityType: 'user',
          entityId: user.id,
          payload: {
            refreshTokenVersionBefore: user.refreshTokenVersion,
            refreshTokenVersionAfter: user.refreshTokenVersion + 1,
          },
        },
      });
    });
  }

  async acceptInvite(input: AcceptInviteInput, secrets: TokenSecrets) {
    const inviteToken = input.inviteToken.trim();
    const name = input.name.trim();

    if (!name) {
      throw new AppError(400, 'USER_NAME_EMPTY', 'User name must not be empty');
    }

    const candidates = await this.prisma.user.findMany({
      where: {
        isActive: false,
        inviteTokenHash: { not: null },
        inviteExpiresAt: { gt: new Date() },
      },
      include: {
        company: {
          select: {
            id: true,
            name: true,
          },
        },
      },
    });

    const invitedUser = candidates.find(
      (user) => user.inviteTokenHash && compareInviteToken(inviteToken, user.inviteTokenHash),
    );

    if (!invitedUser) {
      throw new AppError(401, 'INVITE_INVALID', 'Invite token is invalid or expired');
    }

    const acceptedUser = await this.prisma.$transaction(async (tx) => {
      const user = await tx.user.update({
        where: { id: invitedUser.id },
        data: {
          name,
          phone: this.normalizeOptionalString(input.phone) ?? null,
          passwordHash: hashPassword(input.password),
          isActive: true,
          inviteTokenHash: null,
          inviteExpiresAt: null,
          refreshTokenVersion: 0,
        },
        include: {
          company: {
            select: {
              id: true,
              name: true,
            },
          },
        },
      });

      await tx.auditLog.create({
        data: {
          companyId: user.companyId,
          userId: user.id,
          action: 'auth.invite.accepted',
          entityType: 'user',
          entityId: user.id,
          payload: {
            email: user.email,
            role: user.role,
          },
        },
      });

      return user;
    });

    return this.buildAuthResponse(
      {
        userId: acceptedUser.id,
        companyId: acceptedUser.companyId,
        role: acceptedUser.role,
        tokenVersion: acceptedUser.refreshTokenVersion,
      },
      this.toAuthUserView(acceptedUser),
      secrets,
    );
  }

  async me(userId: string, companyId: string) {
    const user = await this.getActiveUser(userId, companyId);
    return this.toAuthUserView(user);
  }

  private async getActiveUser(userId: string, companyId: string) {
    const user = await this.prisma.user.findFirst({
      where: {
        id: userId,
        companyId,
        isActive: true,
      },
      include: {
        company: {
          select: {
            id: true,
            name: true,
          },
        },
      },
    });

    if (!user) {
      throw new AppError(401, 'AUTH_USER_NOT_FOUND', 'Authenticated user not found');
    }

    return user;
  }

  private buildAuthResponse(subject: AuthSubject, user: AuthUserView, secrets: TokenSecrets) {
    const accessToken = signAuthToken(
      {
        sub: subject.userId,
        companyId: subject.companyId,
        role: subject.role,
        tokenVersion: subject.tokenVersion,
        type: 'access',
      },
      secrets.accessSecret,
      60 * 30,
    );

    const refreshToken = signAuthToken(
      {
        sub: subject.userId,
        companyId: subject.companyId,
        role: subject.role,
        tokenVersion: subject.tokenVersion,
        type: 'refresh',
      },
      secrets.refreshSecret,
      60 * 60 * 24 * 14,
    );

    return {
      accessToken,
      refreshToken,
      user,
    };
  }

  private toAuthUserView(user: {
    id: string;
    companyId: string;
    name: string;
    email: string | null;
    phone: string | null;
    role: UserRole;
    company: { id: string; name: string };
  }): AuthUserView {
    return {
      id: user.id,
      companyId: user.companyId,
      name: user.name,
      email: user.email,
      phone: user.phone,
      role: user.role,
      company: user.company,
    };
  }

  private assertRefreshTokenVersion(tokenVersion: number, userTokenVersion: number) {
    if (tokenVersion !== userTokenVersion) {
      throw new AppError(401, 'AUTH_REFRESH_REVOKED', 'Refresh token is no longer valid');
    }
  }

  private async ensureGlobalUniqueEmail(email: string, excludeUserId?: string) {
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


  private async assertRegistrationAllowed(allowPublicRegistration: boolean) {
    if (allowPublicRegistration) {
      return;
    }

    const companyCount = await this.prisma.company.count();
    if (companyCount > 0) {
      throw new AppError(403, 'AUTH_REGISTRATION_DISABLED', 'Public registration is disabled');
    }
  }

  private normalizeOptionalString(value?: string | null) {
    const trimmed = value?.trim();
    return trimmed ? trimmed : null;
  }
}
