import { defineConfig } from 'prisma/config';
import { existsSync } from 'node:fs';

if (existsSync('.env')) {
  process.loadEnvFile?.();
}

export default defineConfig({
  schema: 'prisma/schema.prisma',
  migrations: {
    seed: 'tsx prisma/seed.ts',
  },
});
