import { buildApp } from './app.js';

async function start() {
  const app = buildApp();

  try {
    await app.listen({
      host: app.appEnv.host,
      port: app.appEnv.port,
    });
  } catch (error) {
    app.log.error(error);
    process.exit(1);
  }
}

void start();
