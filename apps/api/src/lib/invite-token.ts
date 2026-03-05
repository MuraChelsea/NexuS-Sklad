import { createHash, randomBytes, timingSafeEqual } from 'node:crypto';

export function generateInviteToken() {
  return randomBytes(24).toString('base64url');
}

export function hashInviteToken(token: string) {
  return createHash('sha256').update(token).digest('hex');
}

export function compareInviteToken(token: string, tokenHash: string) {
  const hashed = Buffer.from(hashInviteToken(token), 'hex');
  const stored = Buffer.from(tokenHash, 'hex');

  if (hashed.length !== stored.length) {
    return false;
  }

  return timingSafeEqual(hashed, stored);
}
