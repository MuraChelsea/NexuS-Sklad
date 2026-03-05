import type { FastifyPluginAsync } from 'fastify';
import type {
  OpenApiComponents,
} from '@nexussklad/shared';

import { requireRoles, resolveActor, resolveCompanyId } from '../../lib/default-company.js';
import { toProductDto } from '../../lib/dto-mappers.js';
import {
  deleteResponseSchemas,
  itemEnvelopeSchema,
  listEnvelopeSchema,
  protectedListErrorResponses,
  protectedReadErrorResponses,
  protectedWriteErrorResponses,
} from '../../lib/response-schemas.js';
import {
  createProductSchema,
  listProductsSchema,
  productParamsSchema,
  updateProductSchema,
} from './schemas.js';
import { ProductService } from './service.js';

type OpenApiSchemas = OpenApiComponents['schemas'];

export const productRoutes: FastifyPluginAsync = async (app) => {
  const productService = new ProductService(app.prisma);

  app.get('/products', {
    schema: {
      ...listProductsSchema,
      response: {
        200: listEnvelopeSchema('products'),
        ...protectedListErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER', 'STAFF']);
    const companyId = resolveCompanyId(app, request);
    const query = request.query as {
      search?: string;
      categoryId?: string;
    };
    const items = await productService.list({
      companyId,
      search: query.search,
      categoryId: query.categoryId,
    });

    const response: OpenApiSchemas['ProductListResponse'] = {
      items: items.map(toProductDto),
      module: 'products',
    };
    return response;
  });

  app.get('/products/:productId', {
    schema: {
      ...productParamsSchema,
      response: {
        200: itemEnvelopeSchema('products'),
        ...protectedReadErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER', 'STAFF']);
    const companyId = resolveCompanyId(app, request);
    const params = request.params as { productId: string };

    const item = await productService.getById(companyId, params.productId);

    const response: OpenApiSchemas['ProductResponse'] = {
      item: toProductDto(item),
      module: 'products',
    };
    return response;
  });

  app.post('/products', {
    schema: {
      ...createProductSchema,
      response: {
        200: itemEnvelopeSchema('products', 'create'),
        ...protectedWriteErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER']);
    const { companyId, userId } = resolveActor(app, request);
    const body = request.body as OpenApiSchemas['CreateProductRequest'];

    const item = await productService.create({
      companyId,
      userId,
      categoryId: body.categoryId,
      name: body.name,
      sku: body.sku,
      barcode: body.barcode,
      unit: body.unit,
      description: body.description,
      minStock: body.minStock,
      currentStock: body.currentStock,
    });

    const response: OpenApiSchemas['ProductResponse'] = {
      item: toProductDto(item),
      module: 'products',
      action: 'create',
    };
    return response;
  });

  app.patch('/products/:productId', {
    schema: {
      ...updateProductSchema,
      response: {
        200: itemEnvelopeSchema('products', 'update'),
        ...protectedWriteErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER']);
    const { companyId, userId } = resolveActor(app, request);
    const params = request.params as { productId: string };
    const body = request.body as OpenApiSchemas['UpdateProductRequest'];

    const item = await productService.update({
      companyId,
      userId,
      productId: params.productId,
      categoryId: body.categoryId,
      name: body.name,
      sku: body.sku,
      barcode: body.barcode,
      unit: body.unit,
      description: body.description,
      minStock: body.minStock,
    });

    const response: OpenApiSchemas['ProductUpdateResponse'] = {
      item: toProductDto(item),
      module: 'products',
      action: 'update',
    };
    return response;
  });

  app.delete('/products/:productId', {
    schema: {
      ...productParamsSchema,
      response: deleteResponseSchemas,
    },
  }, async (request, reply) => {
    requireRoles(app, request, ['OWNER']);
    const { companyId, userId } = resolveActor(app, request);
    const params = request.params as { productId: string };

    await productService.remove(companyId, userId, params.productId);

    return reply.status(204).send();
  });
};
