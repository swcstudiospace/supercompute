import { z } from 'zod';

export const DataPrimitiveSchema = z.object({
  id: z.string().uuid(),
  type: z.enum(['string', 'number', 'boolean', 'object', 'array', 'null']),
  value: z.union([z.string(), z.number(), z.boolean(), z.record(z.any()), z.array(z.any()), z.null()]),
  metadata: z.record(z.any()).optional(),
  timestamp: z.string().datetime().optional(),
});

export type DataPrimitive = z.infer<typeof DataPrimitiveSchema>;

export class DataPrimitiveClass {
  static create(data: Omit<DataPrimitive, 'id'> & { id?: string }): DataPrimitive {
    const id = data.id || crypto.randomUUID().toString();
    return DataPrimitiveSchema.parse({ ...data, id });
  }

  static fromJSON(json: string): DataPrimitive {
    return DataPrimitiveSchema.parse(JSON.parse(json));
  }

  toJSON(): string {
    return JSON.stringify(this);
  }
}