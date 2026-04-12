// OpenCode configuration
// Renders to ~/.config/opencode/opencode.json
//
// Usage:
//   Personal only:  jsonnet opencode.jsonnet
//   With work:      jsonnet --tla-str env=work opencode.jsonnet
function(env='personal')
  local isWork = env == 'work';

  local personal = import 'opencode_personal.libsonnet';
  local work = import 'opencode_work.libsonnet';

  {
    '$schema': 'https://opencode.ai/config.json',
    theme: 'system',
    plugin: if isWork then ['@devtheops/opencode-plugin-otel'] else [],
    enabled_providers: personal.enabled_providers
                       + (if isWork then work.enabled_providers else []),
    provider: personal.provider
              + (if isWork then work.provider else {}),
    mcp: personal.mcp
         + (if isWork then work.mcp else {}),
  }
