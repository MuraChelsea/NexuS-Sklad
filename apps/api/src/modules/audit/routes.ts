import type { FastifyPluginAsync } from 'fastify';
import type { OpenApiComponents } from '@nexussklad/shared';

import { requireRoles, resolveCompanyId } from '../../lib/default-company.js';
import { toAuditLogDto } from '../../lib/dto-mappers.js';
import {
  listEnvelopeSchema,
  protectedListErrorResponses,
} from '../../lib/response-schemas.js';
import { listAuditLogsSchema } from './schemas.js';
import { AuditService } from './service.js';

type OpenApiSchemas = OpenApiComponents['schemas'];

export const auditRoutes: FastifyPluginAsync = async (app) => {
  const auditService = new AuditService(app.prisma);

  app.get('/audit', {
    schema: {
      ...listAuditLogsSchema,
      response: {
        200: listEnvelopeSchema('audit'),
        ...protectedListErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER']);
    const companyId = resolveCompanyId(app, request);
    const query = request.query as {
      userId?: string;
      entityType?: string;
      action?: string;
      limit?: number;
      offset?: number;
    };

    const items = await auditService.list({
      companyId,
      userId: query.userId,
      entityType: query.entityType,
      action: query.action,
      limit: query.limit,
      offset: query.offset,
    });

    const response: OpenApiSchemas['AuditListResponse'] = {
      items: items.map(toAuditLogDto),
      module: 'audit',
    };
    return response;
  });
};
