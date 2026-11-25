import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type AnyModel = Record<string, any> & { id: string; name?: string };

async function loadAnthropicModels(): Promise<AnyModel[]> {
  const mod: any = await import("@earendil-works/pi-ai/providers/all");
  return mod.builtinModels().getModels("anthropic");
}

export default async function (pi: ExtensionAPI) {
  const env = process.env;
  const baseUrl = env.ANTHROPIC_BASE_URL?.trim();
  const authToken = env.ANTHROPIC_AUTH_TOKEN?.trim();
  const modelPrefix = env.PI_ANTHROPIC_MODEL_PREFIX?.trim();

  if (!baseUrl || !authToken) return; // not configured: do nothing

  const builtinModels = await loadAnthropicModels();

  const models = builtinModels
    .filter((m) => !m.api || m.api === "anthropic-messages")
    .map((m) => {
    const { provider: _p, baseUrl: _b, api: _a, ...rest } = m;
    return {
      ...rest, // keeps reasoning, input, cost, contextWindow, maxTokens, thinkingLevelMap, compat, ...
      id: `${modelPrefix}${m.id}`,
      name: `${modelPrefix}${m.name ?? m.id}`,
    };
  });

  pi.registerProvider("anthropic", {
    name: "Anthropic",
    baseUrl: baseUrl,
    apiKey: authToken,
    api: "anthropic-messages",
    models,
  } as any);
}
