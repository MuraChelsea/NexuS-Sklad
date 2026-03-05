import type { FastifyPluginAsync } from 'fastify';
import type {
  OpenApiComponents,
} from '@nexussklad/shared';

import { requireRoles, resolveActor, resolveCompanyId } from '../../lib/default-company.js';
import { toCompanyDto } from '../../lib/dto-mappers.js';
import {
  itemEnvelopeSchema,
  protectedListErrorResponses,
  protectedWriteErrorResponses,
} from '../../lib/response-schemas.js';
import { updateCompanySchema } from './schemas.js';
import { CompanyService } from './service.js';

type OpenApiSchemas = OpenApiComponents['schemas'];

export const companyRoutes: FastifyPluginAsync = async (app) => {
  const companyService = new CompanyService(app.prisma);

  app.get('/company', {
    schema: {
      response: {
        200: itemEnvelopeSchema('company'),
        ...protectedListErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER', 'MANAGER', 'STAFF']);
    const companyId = resolveCompanyId(app, request);
    const item = await companyService.getById(companyId);

    const response: OpenApiSchemas['CompanyResponse'] = {
      item: toCompanyDto(item),
      module: 'company',
    };
    return response;
  });

  app.patch('/company', {
    schema: {
      ...updateCompanySchema,
      response: {
        200: itemEnvelopeSchema('company', 'update'),
        ...protectedWriteErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER']);
    const { companyId, userId } = resolveActor(app, request);
    const body = request.body as OpenApiSchemas['UpdateCompanyRequest'];

    const item = await companyService.update({
        companyId,
        userId,
        name: body.name,
        city: body.city,
        phone: body.phone,
      });
    const response: OpenApiSchemas['CompanyUpdateResponse'] = {
      item: toCompanyDto(item),
      module: 'company',
      action: 'update',
    };
    return response;
  });
};
