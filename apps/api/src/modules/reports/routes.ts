import type { FastifyPluginAsync } from 'fastify';
import type {
  OpenApiComponents,
} from '@nexussklad/shared';

import { requireRoles, resolveCompanyId } from '../../lib/default-company.js';
import { toDailyReportDto, toStockReportDto } from '../../lib/dto-mappers.js';
import {
  protectedListErrorResponses,
  reportEnvelopeSchema,
} from '../../lib/response-schemas.js';
import { dailyReportSchema, stockReportSchema } from './schemas.js';
import { ReportService } from './service.js';

type OpenApiSchemas = OpenApiComponents['schemas'];

export const reportRoutes: FastifyPluginAsync = async (app) => {
  const reportService = new ReportService(app.prisma);

  app.get('/reports/daily', {
    schema: {
      ...dailyReportSchema,
      response: {
        200: reportEnvelopeSchema('daily'),
        ...protectedListErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER']);
    const companyId = resolveCompanyId(app, request);
    const query = request.query as {
      date?: string;
    };

    const item = await reportService.daily({
        companyId,
        date: query.date,
      });
    const response: OpenApiSchemas['DailyReportResponse'] = {
      item: toDailyReportDto(item),
      module: 'reports',
      report: 'daily',
    };
    return response;
  });

  app.get('/reports/stock', {
    schema: {
      ...stockReportSchema,
      response: {
        200: reportEnvelopeSchema('stock'),
        ...protectedListErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER']);
    const companyId = resolveCompanyId(app, request);
    const query = request.query as {
      categoryId?: string;
      search?: string;
      lowOnly?: boolean;
      limit?: number;
    };

    const item = await reportService.stock({
        companyId,
        categoryId: query.categoryId,
        search: query.search,
        lowOnly: query.lowOnly,
        limit: query.limit,
      });
    const response: OpenApiSchemas['StockReportResponse'] = {
      item: toStockReportDto(item),
      module: 'reports',
      report: 'stock',
    };
    return response;
  });
};
