const REQUIRED_KEYS = [
  'DATABASE_URL',
  'JWT_ACCESS_SECRET',
  'JWT_REFRESH_SECRET',
] as const;

const PLACEHOLDER_SECRET_PATTERNS = [
  'replace-me',
  'replace-with-',
  'change-me',
];

export type AppUserRole = 'OWNER' | 'MANAGER' | 'STAFF';

export type AppEnv = {
  nodeEnv: string;
  allowDevAuthFallback: boolean;
  host: string;
  port: number;
  databaseUrl: string;
  jwtAccessSecret: string;
  jwtRefreshSecret: string;
  authRateLimitMax: number;
  authRateLimitWindowMs: number;
  allowPublicRegistration: boolean;
  defaultCompanyId?: string;
  defaultUserId?: string;
  defaultUserRole?: AppUserRole;
};

export function loadEnv(env: NodeJS.ProcessEnv = process.env): AppEnv {
  const nodeEnv = env.NODE_ENV ?? 'development';
  if (env === process.env && nodeEnv === 'development') {
    process.loadEnvFile?.();
  }

  const missing = REQUIRED_KEYS.filter((key) => !env[key]);
  if (missing.length > 0) {
    throw new Error(`Missing required environment variables: ${missing.join(', ')}`);
  }

  const port = Number(env.PORT ?? '4000');
  if (Number.isNaN(port) || port <= 0) {
    throw new Error('PORT must be a positive number');
  }

  const authRateLimitMax = Number(env.AUTH_RATE_LIMIT_MAX ?? '10');
  if (Number.isNaN(authRateLimitMax) || authRateLimitMax <= 0) {
    throw new Error('AUTH_RATE_LIMIT_MAX must be a positive number');
  }

  const authRateLimitWindowMs = Number(env.AUTH_RATE_LIMIT_WINDOW_MS ?? '60000');
  if (Number.isNaN(authRateLimitWindowMs) || authRateLimitWindowMs <= 0) {
    throw new Error('AUTH_RATE_LIMIT_WINDOW_MS must be a positive number');
  }

  const allowPublicRegistrationRaw = env.ALLOW_PUBLIC_REGISTRATION ?? ((nodeEnv === 'development' || nodeEnv === 'test') ? 'true' : 'false');
  if (allowPublicRegistrationRaw !== 'true' && allowPublicRegistrationRaw != 'false') {
    throw new Error('ALLOW_PUBLIC_REGISTRATION must be either true or false');
  }

  const allowDevAuthFallback = nodeEnv === 'development';
  if (!allowDevAuthFallback) {
    const forbiddenDevFallbackKeys = [
      'DEFAULT_COMPANY_ID',
      'DEFAULT_USER_ID',
      'DEFAULT_USER_ROLE',
    ].filter((key) => env[key]);

    if (forbiddenDevFallbackKeys.length > 0) {
      throw new Error(
        `Development auth fallback variables are not allowed outside development: ${forbiddenDevFallbackKeys.join(', ')}`,
      );
    }

    assertRuntimeSecret('JWT_ACCESS_SECRET', env.JWT_ACCESS_SECRET!);
    assertRuntimeSecret('JWT_REFRESH_SECRET', env.JWT_REFRESH_SECRET!);

    if (env.JWT_ACCESS_SECRET === env.JWT_REFRESH_SECRET) {
      throw new Error('JWT_ACCESS_SECRET and JWT_REFRESH_SECRET must be different outside development');
    }
  }

  return {
    nodeEnv,
    allowDevAuthFallback,
    host: env.HOST ?? '0.0.0.0',
    port,
    databaseUrl: env.DATABASE_URL!,
    jwtAccessSecret: env.JWT_ACCESS_SECRET!,
    jwtRefreshSecret: env.JWT_REFRESH_SECRET!,
    authRateLimitMax,
    authRateLimitWindowMs,
    allowPublicRegistration: allowPublicRegistrationRaw === 'true',
    defaultCompanyId: env.DEFAULT_COMPANY_ID,
    defaultUserId: env.DEFAULT_USER_ID,
    defaultUserRole: env.DEFAULT_USER_ROLE as AppUserRole | undefined,
  };
}

function assertRuntimeSecret(name: string, value: string) {
  if (value.length < 24) {
    throw new Error(`${name} must be at least 24 characters outside development`);
  }

  const normalized = value.toLowerCase();
  if (PLACEHOLDER_SECRET_PATTERNS.some((pattern) => normalized.includes(pattern))) {
    throw new Error(`${name} must not use placeholder values outside development`);
  }
}
