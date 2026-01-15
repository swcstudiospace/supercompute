#!/usr/bin/env node
require('dotenv').config();

import { LLMWrapper } from './llm_wrapper';
import { DataPrimitiveClass } from './data_primitive';
import { RainforestProtocolSchema } from './claude_integration';

async function main() {
  const API_KEY = process.env.OPENROUTER_KEY!;
  const wrapper = new LLMWrapper(API_KEY);

  await wrapper.initSession('/home/ubuntu/src/repos/supercompute');

  const data = DataPrimitiveClass.create({
    type: 'string',
    value: 'Supercompute Claude Code restored with Grok 4.1 integration',
    metadata: { source: 'opencode-sdk', rainforest: true },
  });

  const protocol = RainforestProtocolSchema.parse({
    consciousness: 'gamma',
    module: 'rainforest-foundation-modules',
    protocol: 'quantum-germination',
  });

  const response = await wrapper.chatWithData(data, 'Confirm integration with CLAUDE.md protocols and suggest next evolution step.', protocol);
  console.log('Grok Response:', response);
}

main().catch(console.error);
