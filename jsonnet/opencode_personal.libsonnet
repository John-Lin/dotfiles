// Personal OpenCode config (safe to commit publicly)
local models = import 'opencode_models.libsonnet';

{
  enabled_providers: ['openai', 'github-copilot', 'national-team-openai'],

  provider: {
    'national-team-openai': {
      name: 'national-team-openai',
      npm: '@ai-sdk/openai',
      options: {
        apiKey: '{env:AZURE_OPENAI_API_KEY}',
        baseURL: '{env:NATIONAL_TEAM_OPENAI_BASE_URL}',
      },
      models: {
        'gpt-5.4': { name: 'GPT 5.4' },
        'gpt-5.3-codex': models['gpt-5.3-codex'],
      },
    },
  },

  mcp: {
    'sequential-thinking': {
      type: 'local',
      command: ['npx', '-y', '@modelcontextprotocol/server-sequential-thinking'],
      environment: {},
      enabled: true,
    },
    context7: {
      type: 'remote',
      url: 'https://mcp.context7.com/mcp',
      headers: { CONTEXT7_API_KEY: '{env:CTX7_API_KEY}' },
      enabled: false,
    },
    'private-journal': {
      type: 'local',
      command: ['npx', '-y', 'github:John-Lin/private-journal-mcp'],
      environment: {},
      enabled: true,
    },
  },
}
