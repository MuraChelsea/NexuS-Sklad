import type { FastifyPluginAsync } from 'fastify';
import type {
  OpenApiComponents,
} from '@nexussklad/shared';

import { requireRoles, resolveActor, resolveCompanyId } from '../../lib/default-company.js';
import { toInventoryItemDto, toInventorySessionDto } from '../../lib/dto-mappers.js';
import {
  conflictErrorResponses,
  itemEnvelopeSchema,
  protectedReadErrorResponses,
  protectedWriteErrorResponses,
} from '../../lib/response-schemas.js';
import {
  finishInventorySchema,
  inventoryItemParamsSchema,
  inventoryParamsSchema,
  startInventorySchema,
  updateInventoryItemSchema,
} from './schemas.js';
import { InventoryService } from './service.js';

type OpenApiSchemas = OpenApiComponents['schemas'];

export const inventoryRoutes: FastifyPluginAsync = async (app) => {
  const inventoryService = new InventoryService(app.prisma);

  app.post('/inventory/start', {
    schema: {
      ...startInventorySchema,
      response: {
        200: itemEnvelopeSchema('inventory', 'start'),
        ...protectedWriteErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER']);
    const { companyId, userId } = resolveActor(app, request);
    const body = request.body as OpenApiSchemas['StartInventoryRequest'];

    const item = await inventoryService.start({
        companyId,
        userId,
        categoryId: body.categoryId,
        productIds: body.productIds,
        comment: body.comment,
      });
    const response: OpenApiSchemas['InventoryStartResponse'] = {
      item: toInventorySessionDto(item),
      module: 'inventory',
      action: 'start',
    };
    return response;
  });

  app.get('/inventory/:inventoryId', {
    schema: {
      ...inventoryParamsSchema,
      response: {
        200: itemEnvelopeSchema('inventory'),
        ...protectedReadErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER', 'STAFF']);
    const companyId = resolveCompanyId(app, request);
    const params = request.params as { inventoryId: string };

    const item = await inventoryService.getById(companyId, params.inventoryId);
    const response: OpenApiSchemas['InventoryResponse'] = {
      item: toInventorySessionDto(item),
      module: 'inventory',
    };
    return response;
  });

  app.patch(
    '/inventory/:inventoryId/items/:itemId',
    {
      schema: {
        ...updateInventoryItemSchema,
        response: {
          200: itemEnvelopeSchema('inventory', 'update-item'),
          ...protectedReadErrorResponses,
        },
      },
    },
    async (request) => {
      requireRoles(app, request, ['OWNER', 'MANAGER', 'STAFF']);
      const { companyId, userId } = resolveActor(app, request);
      const params = request.params as {
        inventoryId: string;
        itemId: string;
      };
      const body = request.body as OpenApiSchemas['UpdateInventoryItemRequest'];

      const item = await inventoryService.updateItem({
          companyId,
          userId,
          inventoryId: params.inventoryId,
          itemId: params.itemId,
          actualQty: body.actualQty,
          comment: body.comment,
        });
      const response: OpenApiSchemas['InventoryItemResponse'] = {
        item: toInventoryItemDto(item),
        module: 'inventory',
        action: 'update-item',
      };
      return response;
    },
  );

  app.post('/inventory/:inventoryId/finish', {
    schema: {
      ...finishInventorySchema,
      response: {
        200: itemEnvelopeSchema('inventory', 'finish'),
        ...conflictErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER']);
    const { companyId, userId } = resolveActor(app, request);
    const params = request.params as { inventoryId: string };
    const body = request.body as OpenApiSchemas['FinishInventoryRequest'];

    const item = await inventoryService.finish({
        companyId,
        userId,
        inventoryId: params.inventoryId,
        comment: body.comment,
      });
    const response: OpenApiSchemas['InventoryFinishResponse'] = {
      item: toInventorySessionDto(item),
      module: 'inventory',
      action: 'finish',
    };
    return response;
  });
};
