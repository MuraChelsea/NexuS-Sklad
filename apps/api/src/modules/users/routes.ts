import type { FastifyPluginAsync } from 'fastify';
import { UserRole } from '@prisma/client';
import type {
  OpenApiComponents,
} from '@nexussklad/shared';

import { requireRoles, resolveActor, resolveCompanyId } from '../../lib/default-company.js';
import { toCompanyUserDto } from '../../lib/dto-mappers.js';
import {
  inviteResponseSchema,
  itemEnvelopeSchema,
  listEnvelopeSchema,
  protectedListErrorResponses,
  protectedWriteErrorResponses,
} from '../../lib/response-schemas.js';
import { createUserSchema, inviteUserSchema, updateUserSchema } from './schemas.js';
import { UserService } from './service.js';

type OpenApiSchemas = OpenApiComponents['schemas'];

export const userRoutes: FastifyPluginAsync = async (app) => {
  const userService = new UserService(app.prisma);

  app.get('/users', {
    schema: {
      response: {
        200: listEnvelopeSchema('users'),
        ...protectedListErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER']);
    const companyId = resolveCompanyId(app, request);

    const items = await userService.list(companyId);
    const response: OpenApiSchemas['UserListResponse'] = {
      items: items.map(toCompanyUserDto),
      module: 'users',
    };
    return response;
  });

  app.post('/users', {
    schema: {
      ...createUserSchema,
      response: {
        200: itemEnvelopeSchema('users', 'create'),
        ...protectedWriteErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER']);
    const { companyId, userId } = resolveActor(app, request);
    const body = request.body as OpenApiSchemas['CreateUserRequest'];

    const item = await userService.create({
        companyId,
        actorUserId: userId,
        name: body.name,
        email: body.email,
        phone: body.phone,
        password: body.password,
        role: body.role === 'MANAGER' ? UserRole.MANAGER : UserRole.STAFF,
      });
    const response: OpenApiSchemas['UserResponse'] = {
      item: toCompanyUserDto(item),
      module: 'users',
      action: 'create',
    };
    return response;
  });

  app.post('/users/invite', {
    schema: {
      ...inviteUserSchema,
      response: {
        200: inviteResponseSchema,
        ...protectedWriteErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER']);
    const { companyId, userId: actorUserId } = resolveActor(app, request);
    const body = request.body as OpenApiSchemas['InviteUserRequest'];

    const invited = await userService.invite({
        companyId,
        actorUserId,
        email: body.email,
        role: body.role === 'MANAGER' ? UserRole.MANAGER : UserRole.STAFF,
      });
    const response: OpenApiSchemas['InviteUserResponse'] = {
      user: toCompanyUserDto(invited.user),
      inviteToken: invited.inviteToken,
      module: 'users',
      action: 'invite',
    };
    return response;
  });

  app.patch('/users/:userId', {
    schema: {
      ...updateUserSchema,
      response: {
        200: itemEnvelopeSchema('users', 'update'),
        ...protectedWriteErrorResponses,
      },
    },
  }, async (request) => {
    requireRoles(app, request, ['OWNER']);
    const { companyId, userId: actorUserId } = resolveActor(app, request);
    const params = request.params as { userId: string };
    const body = request.body as OpenApiSchemas['UpdateUserRequest'];

    const item = await userService.update({
        companyId,
        actorUserId,
        userId: params.userId,
        name: body.name,
        email: body.email,
        phone: body.phone,
        password: body.password,
        role:
          body.role === undefined
            ? undefined
            : body.role === 'MANAGER'
            ? UserRole.MANAGER
            : UserRole.STAFF,
        isActive: body.isActive,
      });
    const response: OpenApiSchemas['UserUpdateResponse'] = {
      item: toCompanyUserDto(item),
      module: 'users',
      action: 'update',
    };
    return response;
  });
};
