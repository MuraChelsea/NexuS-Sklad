const importMetaEnv = (import.meta as ImportMeta & {
  env?: Record<string, string | undefined>;
}).env;

export const appConfig = {
  apiBaseUrl: importMetaEnv?.VITE_NEXUSSKLAD_API_BASE_URL ?? 'http://localhost:4000',
};
