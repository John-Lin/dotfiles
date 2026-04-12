// OpenCode configuration
// Renders to ~/.config/opencode/opencode.json
//
// Usage:
//   Personal only:  jsonnet opencode.jsonnet
//   With LY Corp:   jsonnet --tla-str env=lycorp opencode.jsonnet
function(env='personal')
  local isLycorp = env == 'lycorp';

  local personal = import 'opencode_personal.libsonnet';
  local corporate = import 'opencode_lycorp.libsonnet';

  {
    '$schema': 'https://opencode.ai/config.json',
    theme: 'system',
    plugin: if isLycorp then ['@devtheops/opencode-plugin-otel'] else [],
    enabled_providers: personal.enabled_providers
                       + (if isLycorp then corporate.enabled_providers else []),
    provider: personal.provider
              + (if isLycorp then corporate.provider else {}),
    mcp: personal.mcp
         + (if isLycorp then corporate.mcp else {}),
  }
