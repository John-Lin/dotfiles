// Shared model fragments for OpenCode providers
local reasoningVariants = {
  low: { reasoningEffort: 'low', reasoningSummary: 'auto' },
  medium: { reasoningEffort: 'medium', reasoningSummary: 'auto' },
  high: { reasoningEffort: 'high', reasoningSummary: 'auto' },
  xhigh: { reasoningEffort: 'xhigh', reasoningSummary: 'auto' },
};

{
  reasoningVariants:: reasoningVariants,

  'claude-opus-4.6':: {
    name: 'Claude Opus 4.6',
    limit: { context: 200000, input: 136000, output: 64000 },
    cost: { input: 5.0, output: 25.0 },
  },
  'claude-opus-4.5':: {
    name: 'Claude Opus 4.5',
    cost: { input: 5.0, output: 25.0 },
  },
  'claude-sonnet-4.6':: {
    name: 'Claude Sonnet 4.6',
    cost: { input: 3.0, output: 15.0 },
  },
  'gpt-5.4':: {
    name: 'GPT-5.4',
    limit: { context: 1050000, input: 922000, output: 128000 },
    cost: { input: 2.5, output: 15 },
    temperature: false,
    reasoning: true,
    tool_call: true,
    modalities: {
      input: ['text', 'image'],
      output: ['text'],
    },
    variants: reasoningVariants,
  },
  'gpt-5.2-pro':: {
    name: 'GPT 5.2 Pro',
  },
  'gpt-5.3-codex':: {
    name: 'GPT 5.3 Codex',
    cost: { input: 1.75, output: 14 },
    variants: reasoningVariants,
  },
}
