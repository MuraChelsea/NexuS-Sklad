import { createHmac, timingSafeEqual } from 'node:crypto';

import type { AppUserRole } from '../config/env.js';
import { AppError } from './app-error.js';

type TokenType = 'access' | 'refresh';

export type AuthTokenPayload = {
  sub: string;
  companyId: string;
  role: AppUserRole;
  tokenVersion: number;
  type: TokenType;
  exp: number;
};

export function signAuthToken(
  payload: Omit<AuthTokenPayload, 'exp'>,
  secret: string,
  expiresInSeconds: number,
) {
  const fullPayload: AuthTokenPayload = {
    ...payload,
    exp: Math.floor(Date.now() / 1000) + expiresInSeconds,
  };

  const encodedPayload = encodeBase64Url(JSON.stringify(fullPayload));
  const signature = signValue(encodedPayload, secret);

  return `${encodedPayload}.${signature}`;
}

export function verifyAuthToken(token: string, secret: string, expectedType: TokenType) {
  const [encodedPayload, signature] = token.split('.');

  if (!encodedPayload || !signature) {
    throw new AppError(401, 'AUTH_TOKEN_INVALID', 'Invalid auth token');
  }

  const expectedSignature = signValue(encodedPayload, secret);
  const providedSignature = Buffer.from(signature);
  const expectedSignatureBuffer = Buffer.from(expectedSignature);

  if (
    providedSignature.length !== expectedSignatureBuffer.length ||
    !timingSafeEqual(providedSignature, expectedSignatureBuffer)
  ) {
    throw new AppError(401, 'AUTH_TOKEN_INVALID', 'Invalid auth token signature');
  }

  const payload = JSON.parse(decodeBase64Url(encodedPayload)) as AuthTokenPayload;

  if (payload.type !== expectedType) {
    throw new AppError(401, 'AUTH_TOKEN_TYPE_INVALID', 'Invalid auth token type');
  }

  if (payload.exp <= Math.floor(Date.now() / 1000)) {
    throw new AppError(401, 'AUTH_TOKEN_EXPIRED', 'Auth token expired');
  }

  return payload;
}

function signValue(value: string, secret: string) {
  return createHmac('sha256', secret).update(value).digest('base64url');
}

function encodeBase64Url(value: string) {
  return Buffer.from(value, 'utf8').toString('base64url');
}

function decodeBase64Url(value: string) {
  return Buffer.from(value, 'base64url').toString('utf8');
}
