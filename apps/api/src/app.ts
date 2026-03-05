import Fastify from 'fastify';

import { loadEnv } from './config/env.js';
import { registerAuth } from './plugins/auth.js';
import { registerErrorHandler } from './plugins/error-handler.js';
import { getPrismaClient } from './plugins/prisma.js';
import { registerSecurity } from './plugins/security.js';
import { apiRoutes } from './routes/index.js';

export function buildApp(envOverrides?: NodeJS.ProcessEnv) {
  const env = loadEnv(envOverrides);
  const prisma = getPrismaClient();

  const app = Fastify({
    logger: env.nodeEnv !== 'test',
  });

  app.decorate('appEnv', env);
  app.decorate('prisma', prisma);
  registerAuth(app);
  registerSecurity(app);
  registerErrorHandler(app);

  app.addHook('onClose', async () => {
    await prisma.$disconnect();
  });

  void app.register(apiRoutes);

  return app;
}
