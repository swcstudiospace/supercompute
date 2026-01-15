import { z } from 'zod';
import type { DataPrimitive } from './data_primitive';

export const RainforestProtocolSchema = z.object({
  consciousness: z.enum(['alpha', 'beta', 'gamma', 'delta', 'omega']),
  module: z.string(),
  etd: z.number().optional(),
  protocol: z.string(),
});

export type RainforestProtocol = z.infer<typeof RainforestProtocolSchema>;

export class CLAUDEIntegration {
  static enhancePrompt(prompt: string, data: DataPrimitive, protocol: RainforestProtocol): string {
    const ctx = RainforestProtocolSchema.parse(protocol);
    return `&lt;rainforest consciousness="${ctx.consciousness}" module="${ctx.module}"&gt;
${JSON.stringify(data, null, 2)}
${prompt}
&lt;/rainforest&gt;`;
  }
}