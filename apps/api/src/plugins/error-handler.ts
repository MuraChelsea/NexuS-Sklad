import type { FastifyError, FastifyInstance, FastifyReply, FastifyRequest } from 'fastify';

import { AppError } from '../lib/app-error.js';

function sendErrorEnvelope(
  reply: FastifyReply,
  statusCode: number,
  code: string,
  message: string,
) {
  return reply.status(statusCode).send({
    error: {
      code,
      message,
    },
  });
}

export function registerErrorHandler(app: FastifyInstance) {
  app.setNotFoundHandler((_request, reply) => {
    return sendErrorEnvelope(reply, 404, 'NOT_FOUND', 'Route not found');
  });

  app.setErrorHandler(
    (error: FastifyError, _request: FastifyRequest, reply: FastifyReply) => {
      const isValidationError =
        Array.isArray((error as FastifyError & { validation?: unknown[] }).validation) ||
        error.code === 'FST_ERR_VALIDATION';

      if (error instanceof AppError && error.statusCode < 500) {
        app.log.warn({
          code: error.code,
          message: error.message,
          statusCode: error.statusCode,
        });
      } else {
        app.log.error(error);
      }

      const statusCode =
        error instanceof AppError
          ? error.statusCode
          : typeof error.statusCode === 'number' && error.statusCode >= 400
          ? error.statusCode
          : 500;

      return sendErrorEnvelope(
        reply,
        statusCode,
        isValidationError
          ? 'VALIDATION_ERROR'
          : error instanceof AppError
          ? error.code
          : error.code ?? 'INTERNAL_SERVER_ERROR',
        error.message,
      );
    },
  );
}
