# @nexussklad/shared

Language-agnostic contract source for `NexusSklad`.

## Purpose

This package is the first shared layer between:

- `apps/api`
- `apps/mobile`
- future `apps/web`

## What is here

- API envelope types
- core DTOs for auth, audit, company, users, products, movements, inventory, reports
- response shapes that mirror the current backend payloads
- generated OpenAPI TypeScript types

## Current scope

At this stage, contracts are defined as TypeScript source-of-truth.

The mobile app still keeps its own Dart domain models, but transport parsing is now
contract-driven and validates response envelopes explicitly.

## Codegen

Generate TypeScript types from the repository OpenAPI spec:

```bash
cd nexussklad/packages/shared
npm run codegen:openapi
```

Generated file:

- `packages/shared/src/generated/openapi.ts`

Verify that generated TypeScript artifacts are in sync with `docs/openapi_v1.yaml`:

```bash
cd nexussklad/packages/shared
npm run codegen:openapi:check
```

Repository-level contract integrity check:

```bash
cd nexussklad
./check_contract_integrity.sh
```

## Next step

1. generate JSON schema or OpenAPI from the same source
2. generate Dart models from the contract layer
3. gradually remove duplicate manual JSON parsing from mobile
