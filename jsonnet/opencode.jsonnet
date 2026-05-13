// OpenCode configuration
// Renders to ~/.config/opencode/opencode.json
//
// Usage:
//   Personal only:  jsonnet opencode.jsonnet
//   With work:      jsonnet -J /path/to/private-opencode-config -J jsonnet --tla-str env=work opencode.jsonnet
//   Via Makefile:   make sync-opencode
//                   OPENCODE_WORK_CONFIG=/path/to/private-opencode-config make sync-opencode
function(env='personal')
  local isWork = env == 'work';

  local personal = import 'opencode_personal.libsonnet';
  // This import is only evaluated when work settings are merged.
  local work = import 'opencode_work.libsonnet';

  {
    '$schema': 'https://opencode.ai/config.json',
    theme: 'system',
    share: 'disabled',
    plugin: if isWork then ['@devtheops/opencode-plugin-otel'] else [],
    enabled_providers: personal.enabled_providers
                       + (if isWork then work.enabled_providers else []),
    provider: personal.provider
              + (if isWork then work.provider else {}),
    mcp: personal.mcp
         + (if isWork then work.mcp else {}),
  }
