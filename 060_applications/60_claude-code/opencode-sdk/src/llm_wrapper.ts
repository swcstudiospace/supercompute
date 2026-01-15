import { createOpencodeClient } from '@opencode-ai/sdk';
import type { SessionPromptRequestBody } from '@opencode-ai/sdk';
import { DataPrimitiveClass } from './data_primitive';
import type { RainforestProtocol } from './claude_integration';
import { CLAUDEIntegration } from './claude_integration';

export class LLMWrapper {
  private client: any;
  private sessionId: string;
  private apiKey: string;

  constructor(apiKey: string, baseUrl = 'http://localhost:4096') {
    this.apiKey = apiKey;
    this.client = createOpencodeClient({ baseUrl });
    this.sessionId = '';
  }

  async initSession(projectPath: string): Promise<string> {
    await this.client.auth.set({
      path: { id: 'openrouter' },
      body: { type: 'api', key: this.apiKey },
    });

    const session = await this.client.session.create({ body: { title: 'Grok 4.1 Fast - Supercompute Claude' } });
    this.sessionId = session.data.id;
    return this.sessionId;
  }

  async prompt(prompt: string, model = 'xai/grok-beta'): Promise<string> {
    if (!this.sessionId) throw new Error('Session not initialized. Call initSession first.');
    const body: SessionPromptRequestBody = {
      model: { providerID: 'openrouter', modelID: model },
      parts: [{ type: 'text', text: prompt }],
    };
    const response = await this.client.session.prompt({
      path: { id: this.sessionId },
      body,
    });
    return response.data.parts[0]?.text || '';
  }

  async chatWithData(data: DataPrimitive, prompt: string, protocol: RainforestProtocol): Promise<string> {
    const enhanced = CLAUDEIntegration.enhancePrompt(prompt, data, protocol);
    return this.prompt(enhanced, 'xai/grok-beta');
  }
}