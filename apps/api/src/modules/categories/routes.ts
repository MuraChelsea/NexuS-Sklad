import type { FastifyPluginAsync } from 'fastify';
import type {
  OpenApiComponents,
} from '@nexussklad/shared';

import { requireRoles, resolveActor, resolveCompanyId } from '../../lib/default-company.js';
import { toCategoryDto } from '../../lib/dto-mappers.js';
import {
  deleteResponseSchemas,
  itemEnvelopeSchema,
  listEnvelopeSchema,
  protectedListErrorResponses,
  protectedReadErrorResponses,
  protectedWriteErrorResponses,
} from '../../lib/response-schemas.js';
import {
  categoryParamsSchema,
  createCategorySchema,
  updateCategorySchema,
} from './schemas.js';
import { CategoryService } from './service.js';

type OpenApiSchemas = OpenApiComponents['schemas'];

export const categoryRoutes: FastifyPluginAsync = async (app) => {
  const categoryService = new CategoryService(app.prisma);

  app.get('/categories', {
    schema: {
      response: {
        200: listEnvelopeSchema('categories'),
        ...protectedListErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER', 'STAFF']);
    const companyId = resolveCompanyId(app, request);
    const items = await categoryService.list(companyId);

    const response: OpenApiSchemas['CategoryListResponse'] = {
      items: items.map(toCategoryDto),
      module: 'categories',
    };
    return response;
  });

  app.get('/categories/:categoryId', {
    schema: {
      ...categoryParamsSchema,
      response: {
        200: itemEnvelopeSchema('categories'),
        ...protectedReadErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER', 'STAFF']);
    const companyId = resolveCompanyId(app, request);
    const params = request.params as { categoryId: string };
    const item = await categoryService.getById(companyId, params.categoryId);

    const response: OpenApiSchemas['CategoryResponse'] = {
      item: toCategoryDto(item),
      module: 'categories',
    };
    return response;
  });

  app.post('/categories', {
    schema: {
      ...createCategorySchema,
      response: {
        200: itemEnvelopeSchema('categories', 'create'),
        ...protectedWriteErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER']);
    const { companyId, userId } = resolveActor(app, request);
    const body = request.body as OpenApiSchemas['CreateCategoryRequest'];

    const item = await categoryService.create({
      companyId,
      userId,
      name: body.name,
      parentId: body.parentId,
    });

    const response: OpenApiSchemas['CategoryResponse'] = {
      item: toCategoryDto(item),
      module: 'categories',
      action: 'create',
    };
    return response;
  });

  app.patch('/categories/:categoryId', {
    schema: {
      ...updateCategorySchema,
      response: {
        200: itemEnvelopeSchema('categories', 'update'),
        ...protectedWriteErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER']);
    const { companyId, userId } = resolveActor(app, request);
    const params = request.params as { categoryId: string };
    const body = request.body as OpenApiSchemas['UpdateCategoryRequest'];

    const item = await categoryService.update({
      companyId,
      userId,
      categoryId: params.categoryId,
      name: body.name,
      parentId: body.parentId,
    });

    const response: OpenApiSchemas['CategoryUpdateResponse'] = {
      item: toCategoryDto(item),
      module: 'categories',
      action: 'update',
    };
    return response;
  });

  app.delete('/categories/:categoryId', {
    schema: {
      ...categoryParamsSchema,
      response: deleteResponseSchemas,
    },
  }, async (request, reply) => {
    requireRoles(app, request, ['OWNER']);
    const { companyId, userId } = resolveActor(app, request);
    const params = request.params as { categoryId: string };

    await categoryService.remove(companyId, userId, params.categoryId);

    return reply.status(204).send();
  });
};
