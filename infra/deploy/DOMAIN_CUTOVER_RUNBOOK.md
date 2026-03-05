# NexusSklad Domain Cutover Runbook

Этот runbook закрывает переход от IP/портов к домену и HTTPS.

## Что уже известно по серверу

- `nginx` на сервере установлен
- в `sites-available` уже есть `default` и `optpuls`
- `certbot` сейчас не установлен
- внешние контуры `NexusSklad` уже работают:
  - staging -> `http://85.239.56.248:8080`
  - production-like -> `http://85.239.56.248:8081`

## Рекомендуемая схема

- `staging.<your-domain>` -> host nginx -> `127.0.0.1:8080`
- `app.<your-domain>` -> host nginx -> `127.0.0.1:8081`

Это правильно, потому что:

- docker stack можно не перестраивать ради домена;
- TLS живет на host nginx;
- внутри docker сохраняются текущие single-origin web stacks;
- внешний cutover сводится к DNS + nginx + сертификату.

## Файлы

- `.env.domains.example`
- `render_nginx_site.sh`
- `nginx/nexussklad-staging.conf.template`
- `nginx/nexussklad-production.conf.template`

## Подготовка DNS

Нужно создать `A`-записи:

- `staging.<your-domain>` -> `85.239.56.248`
- `app.<your-domain>` -> `85.239.56.248`

Проверка после обновления DNS:

```bash
dig +short staging.<your-domain>
dig +short app.<your-domain>
```

Обе записи должны резолвиться в `85.239.56.248`.

## Рендеринг nginx-конфигов

Пример:

```bash
cd /root/nexussklad/infra/deploy
./render_nginx_site.sh staging staging.<your-domain> 8080 /tmp/nexussklad-staging.conf
./render_nginx_site.sh production app.<your-domain> 8081 /tmp/nexussklad-production.conf
```

После этого проверить содержимое и разложить:

```bash
cp /tmp/nexussklad-staging.conf /etc/nginx/sites-available/nexussklad-staging
cp /tmp/nexussklad-production.conf /etc/nginx/sites-available/nexussklad-production
ln -sf /etc/nginx/sites-available/nexussklad-staging /etc/nginx/sites-enabled/nexussklad-staging
ln -sf /etc/nginx/sites-available/nexussklad-production /etc/nginx/sites-enabled/nexussklad-production
nginx -t
systemctl reload nginx
```

## Проверка HTTP до TLS

Сначала убедиться, что домены уже отдают приложение по `http`:

```bash
curl -I http://staging.<your-domain>
curl -I http://app.<your-domain>
curl -I http://app.<your-domain>/health
```

Ожидается `200 OK`.

## HTTPS

### Вариант A: certbot через пакетный менеджер

Если сервер Ubuntu/Debian-подобный:

```bash
apt-get update
apt-get install -y certbot python3-certbot-nginx
```

Потом выпустить сертификаты:

```bash
certbot --nginx -d staging.<your-domain> -d app.<your-domain> -m admin@<your-domain> --agree-tos --redirect --no-eff-email
```

### Вариант B: если certbot ставить не хочется

Тогда нужен другой ACME-клиент, например `acme.sh`, но этот путь пока не автоматизирован в репозитории.

## Финальная проверка

После выпуска сертификатов:

```bash
curl -I https://staging.<your-domain>
curl -I https://app.<your-domain>
curl -I https://app.<your-domain>/health
```

И затем smoke:

```bash
cd /root/nexussklad/infra/deploy
./smoke_check.sh https://app.<your-domain>
```

## Замечания

- staging и production-like уже разведены по разным upstream-портам; это менять не нужно
- demo seed должен остаться только в staging-процессе
- production rollout имеет смысл делать только после того, как домен уже указывает на сервер
