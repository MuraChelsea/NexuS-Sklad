import type { FastifyPluginAsync } from 'fastify';
import type {
  OpenApiComponents,
} from '@nexussklad/shared';

import { MovementType } from '@prisma/client';

import {
  requireRoles,
  resolveActor,
  resolveCompanyId,
} from '../../lib/default-company.js';
import { toStockMovementDto } from '../../lib/dto-mappers.js';
import {
  conflictErrorResponses,
  itemEnvelopeSchema,
  listEnvelopeSchema,
  protectedListErrorResponses,
  protectedWriteErrorResponses,
} from '../../lib/response-schemas.js';
import {
  createAdjustmentSchema,
  createExpenseSchema,
  createIncomeSchema,
  listMovementsSchema,
} from './schemas.js';
import { MovementService } from './service.js';

type OpenApiSchemas = OpenApiComponents['schemas'];

export const movementRoutes: FastifyPluginAsync = async (app) => {
  const movementService = new MovementService(app.prisma);

  app.get('/movements', {
    schema: {
      ...listMovementsSchema,
      response: {
        200: listEnvelopeSchema('movements'),
        ...protectedListErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER', 'STAFF']);
    const companyId = resolveCompanyId(app, request);
    const query = request.query as {
      productId?: string;
      movementType?: MovementType;
      limit?: number;
      offset?: number;
      dateFrom?: string;
      dateTo?: string;
    };

    const items = await movementService.list({
      companyId,
      productId: query.productId,
      movementType: query.movementType,
      limit: query.limit,
      offset: query.offset,
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
    });

    const response: OpenApiSchemas['MovementListResponse'] = {
      items: items.map(toStockMovementDto),
      module: 'movements',
    };
    return response;
  });

  app.post('/movements/income', {
    schema: {
      ...createIncomeSchema,
      response: {
        200: itemEnvelopeSchema('movements', 'income'),
        ...protectedWriteErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER', 'STAFF']);
    const { companyId, userId } = resolveActor(app, request);
    const body = request.body as OpenApiSchemas['CreateMovementRequest'];

    const item = await movementService.createIncome({
        companyId,
        userId,
        productId: body.productId,
        quantity: body.quantity,
        comment: body.comment,
      });
    const response: OpenApiSchemas['MovementIncomeResponse'] = {
      item: toStockMovementDto(item),
      module: 'movements',
      action: 'income',
    };
    return response;
  });

  app.post('/movements/expense', {
    schema: {
      ...createExpenseSchema,
      response: {
        200: itemEnvelopeSchema('movements', 'expense'),
        ...conflictErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER', 'STAFF']);
    const { companyId, userId } = resolveActor(app, request);
    const body = request.body as OpenApiSchemas['CreateMovementRequest'];

    const item = await movementService.createExpense({
        companyId,
        userId,
        productId: body.productId,
        quantity: body.quantity,
        comment: body.comment,
      });
    const response: OpenApiSchemas['MovementExpenseResponse'] = {
      item: toStockMovementDto(item),
      module: 'movements',
      action: 'expense',
    };
    return response;
  });

  app.post('/movements/adjustment', {
    schema: {
      ...createAdjustmentSchema,
      response: {
        200: itemEnvelopeSchema('movements', 'adjustment'),
        ...protectedWriteErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER']);
    const { companyId, userId } = resolveActor(app, request);
    const body = request.body as OpenApiSchemas['CreateAdjustmentRequest'];

    const item = await movementService.createAdjustment({
        companyId,
        userId,
        productId: body.productId,
        targetQty: body.targetQty,
        comment: body.comment,
      });
    const response: OpenApiSchemas['MovementAdjustmentResponse'] = {
      item: toStockMovementDto(item),
      module: 'movements',
      action: 'adjustment',
    };
    return response;
  });
};
