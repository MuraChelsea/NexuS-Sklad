import type { FastifyPluginAsync } from 'fastify';

import { authRoutes } from '../modules/auth/routes.js';
import { auditRoutes } from '../modules/audit/routes.js';
import { categoryRoutes } from '../modules/categories/routes.js';
import { companyRoutes } from '../modules/company/routes.js';
import { healthRoutes } from '../modules/health/routes.js';
import { inventoryRoutes } from '../modules/inventory/routes.js';
import { movementRoutes } from '../modules/movements/routes.js';
import { productRoutes } from '../modules/products/routes.js';
import { reportRoutes } from '../modules/reports/routes.js';
import { userRoutes } from '../modules/users/routes.js';

export const apiRoutes: FastifyPluginAsync = async (app) => {
  await app.register(healthRoutes);
  await app.register(authRoutes, { prefix: '/v1' });
  await app.register(auditRoutes, { prefix: '/v1' });
  await app.register(companyRoutes, { prefix: '/v1' });
  await app.register(categoryRoutes, { prefix: '/v1' });
  await app.register(productRoutes, { prefix: '/v1' });
  await app.register(movementRoutes, { prefix: '/v1' });
  await app.register(inventoryRoutes, { prefix: '/v1' });
  await app.register(reportRoutes, { prefix: '/v1' });
  await app.register(userRoutes, { prefix: '/v1' });
};
