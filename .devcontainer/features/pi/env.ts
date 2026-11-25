import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  const env = process.env;
  const baseUrl = env.PI_ENV_PROVIDER_BASE_URL?.trim();
  const model = env.PI_ENV_PROVIDER_MODEL?.trim();

  if (!baseUrl || !model) return; // not configured: do nothing

  const api = env.PI_ENV_PROVIDER_API?.trim() || "anthropic-messages";
  const contextWindow = Number(env.PI_ENV_PROVIDER_CONTEXT) || 32768;
  const maxTokens = Number(env.PI_ENV_PROVIDER_MAX_TOKENS) || 8192;

  const reasoning = env.PI_ENV_PROVIDER_REASONING == "1";

  pi.registerProvider("env", {
    name: "env",
    baseUrl,
    api,
    // pi hides providers without a credential, so keep a dummy for keyless servers
    apiKey: env.PI_ENV_PROVIDER_API_KEY || "dummy",
    models: [{
      id: model,
      name: model,
      reasoning: reasoning,
      input: ["text"],
      cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
      contextWindow,
      maxTokens,
    }],
  } as any);
}
