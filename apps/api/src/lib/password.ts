import { randomBytes, scryptSync, timingSafeEqual } from 'node:crypto';

const KEY_LENGTH = 64;

export function hashPassword(password: string) {
  const normalized = password.trim();
  if (!normalized) {
    throw new Error('Password must not be empty');
  }

  const salt = randomBytes(16).toString('hex');
  const derivedKey = scryptSync(normalized, salt, KEY_LENGTH).toString('hex');

  return `scrypt$${salt}$${derivedKey}`;
}

export function verifyPassword(password: string, storedHash: string) {
  const normalized = password.trim();
  const [algorithm, salt, hash] = storedHash.split('$');

  if (algorithm !== 'scrypt' || !salt || !hash) {
    return false;
  }

  const derivedKey = scryptSync(normalized, salt, KEY_LENGTH);
  const hashBuffer = Buffer.from(hash, 'hex');

  if (derivedKey.length !== hashBuffer.length) {
    return false;
  }

  return timingSafeEqual(derivedKey, hashBuffer);
}
