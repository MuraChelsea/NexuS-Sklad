# NexusSklad UI Smoke Report

Дата: 3 марта 2026
Окружение: staging
Проверяющий: automated baseline

## Контекст

- URL: `http://85.239.56.248:8080`
- Роль: `OWNER`, `MANAGER`, `STAFF`
- Устройство: server-side API checks + external IP checks
- Сеть: external IP-only rollout

## Automated baseline

### Infra

- [x] `GET /` на `8080`
- [x] `GET /health` на `8080`
- [x] `GET /` на `8081`
- [x] `GET /health` на `8081`

### Auth and role matrix

- [x] owner login
- [x] manager login
- [x] staff login
- [x] `auth/me` для owner/manager/staff
- [x] `products` доступны owner/manager/staff
- [x] `movements` доступны owner/manager/staff
- [x] `reports` доступны owner/manager и закрыты для staff
- [x] `users` доступны только owner
- [x] `audit` доступен только owner
- [x] `adjustment` закрыт для staff

## Manual UI pass

Статус: pending

### Owner

- [ ] login
- [ ] dashboard
- [ ] products/categories
- [ ] movements
- [ ] inventory
- [ ] company/team
- [ ] reports/export
- [ ] audit

### Manager

- [ ] login
- [ ] dashboard
- [ ] products create/update
- [ ] movements
- [ ] inventory
- [ ] owner-only restrictions confirmed

### Staff mobile

- [ ] login
- [ ] dashboard
- [ ] products read
- [ ] movements read/write
- [ ] inventory item update
- [ ] owner-only restrictions confirmed

### Empty/error states

- [ ] web empty states verified
- [ ] mobile empty states verified
- [ ] retry/error states verified

### Offline visibility

- [ ] pending queues visible
- [ ] retry works
- [ ] discard works
- [ ] conflict message understandable

## Findings

| Severity | Area | Screen | Summary | Repro | Expected | Actual |
|---|---|---|---|---|---|---|
| | | | | | | |

## Decision

- [ ] Ready for next demo pass
- [ ] Needs fixes before next pass

## Notes

- Automated baseline green as of 3 марта 2026.
- Full GUI pass still required.
