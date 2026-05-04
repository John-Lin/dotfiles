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
    limit: { context: 1000000, input: 872000, output: 128000 },
    cost: { input: 5.0, output: 25.0 },
  },
  'claude-sonnet-4.6':: {
    name: 'Claude Sonnet 4.6',
    limit: { context: 1000000, input: 936000, output: 64000 },
    cost: { input: 3.0, output: 15.0 },
  },
  'claude-haiku-4.5':: {
    name: 'Claude Haiku 4.5',
    limit: { context: 200000, input: 136000, output: 64000 },
    cost: { input: 1.0, output: 5.0 },
  },
  // GPT-5.4 / 5.5 input limits are capped at 220K (vs. native 922K) so
  // OpenCode's auto compaction kicks in around 200K tokens, before the
  // long-context surcharge (>200K) doubles input pricing.
  'gpt-5.4':: {
    name: 'GPT-5.4',
    limit: { context: 1050000, input: 220000, output: 128000 },
    cost: { input: 2.5, output: 15 },
    temperature: false,
    reasoning: true,
    tool_call: true,
    variants: reasoningVariants,
  },
  'gpt-5.5':: {
    name: 'GPT-5.5',
    limit: { context: 1050000, input: 220000, output: 128000 },
    cost: { input: 5.0, output: 30.0 },
    temperature: false,
    reasoning: true,
    tool_call: true,
    variants: reasoningVariants,
  },
  'gpt-5.2-pro':: {
    name: 'GPT 5.2 Pro',
    limit: { context: 400000, input: 272000, output: 128000 },
    cost: { input: 21.0, output: 168.0 },
    temperature: false,
    reasoning: true,
    tool_call: true,
  },
  'gpt-5.3-codex':: {
    name: 'GPT 5.3 Codex',
    limit: { context: 400000, input: 272000, output: 128000 },
    cost: { input: 1.75, output: 14 },
    temperature: false,
    reasoning: true,
    tool_call: true,
    variants: reasoningVariants,
  },
}
