# NexusSklad OpenAPI / Codegen Workflow

## Current state

- `packages/shared` is the contract source-of-truth for DTO names and payload shape.
- `apps/api` now serializes route responses through explicit DTO mappers.
- `docs/openapi_v1.yaml` is the first repository-tracked OpenAPI export.
- `packages/shared` will host generated TypeScript artifacts from OpenAPI.
- `docs/openapi_v1.yaml` now also tracks shared error responses:
  - `UnauthorizedError`
  - `ForbiddenError`
  - `NotFoundError`
  - `ConflictError`
  - `InternalServerError`

## Why this step exists

Without a machine-readable spec, `mobile` and future `web` keep duplicating JSON parsing
and drift risk stays high.

## Recommended next move

1. Keep `packages/shared` as the semantic contract layer.
2. Maintain `docs/openapi_v1.yaml` as the transport contract layer.
3. Introduce generation from OpenAPI into:
   - Dart models/client for `apps/mobile`
   - TypeScript client for future `apps/web`

## Practical rollout

### Step 1

Stabilize `docs/openapi_v1.yaml` against the current API.

### Step 2

Current practical generator:

- `openapi-typescript` for generated TypeScript path/component types

Command:

```bash
cd nexussklad/packages/shared
npm run codegen:openapi
```

Drift check:

```bash
cd nexussklad/packages/shared
npm run codegen:openapi:check
```

Generated artifact:

- `packages/shared/src/generated/openapi.ts`

Future generators:

- `orval` for TypeScript clients
- `openapi-generator` / `dart-dio` for Dart clients

Repository scaffold for Dart generation is now prepared in:

- `apps/mobile/tool/generate_openapi_client.sh`
- `apps/mobile/openapi-generator-config.yaml`
- `docs/dart_codegen_strategy.md`

It is now exercised in the repository:

- generated Dart package lives in `apps/mobile/generated/openapi_client`
- держим его вне `apps/mobile/lib/`, иначе `flutter test` ловит language-version конфликт в generated `part` files
- `auth` mobile flow already consumes generated transport types first-class

Repository-level integrity gate:

```bash
cd nexussklad
./check_contract_integrity.sh
```

### Step 3

Generate read-only clients first from the spec:

- auth
- company
- users
- products
- movements
- inventory
- reports

### Step 4

Replace manual parsing in `apps/mobile/lib/features/**/data/*_repository.dart`
incrementally, not in one large rewrite.

### Step 5

Adopt generated Dart transport types in a hybrid way:

- generated transport models
- hand-written domain models
- explicit mapping between them

Current adoption:

- `auth` — first-class generated transport types
- `products/movements/inventory/team` — hand-written transport split, ready for replacement

## Constraint

Do not switch to generated clients until the spec is treated as part of the backend
definition and updated in the same change set as route payload changes.
