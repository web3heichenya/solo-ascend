// Business-specific types and interfaces

// FAQ related types
export interface FAQItem {
  id: string;
  question: string;
  answer: string;
}

// Forge related business types
export type ForgeItemQuality = 'silver' | 'gold' | 'rainbow' | 'mythic';

export interface ForgeItem {
  tokenId: string;
  quality: ForgeItemQuality;
  name: string;
  effectType?: string;
  attribute?: string;
  value?: number;
  createdAt?: number;
  image?: string;
  hasRealData?: boolean;
  attributes?: Record<string, number>;
}

// Pending forge display types (from PendingForgeButton.tsx)
export interface PendingForgeDisplay {
  heroId: number;
  txHash: string;
  timestamp: number;
  fulfilled?: boolean;
  requestId?: string;
}

// Forge result types (from useForgePolling.ts)
export interface ForgeResult {
  status: 'pending' | 'success' | 'failed';
  timestamp: number;
  txHash?: string;
  attributeChanges?: Partial<import('./hero').Hero['attributes']>;
  itemsReceived?: Array<{
    type: 'silver' | 'gold' | 'rainbow' | 'mythic';
    tokenId: number;
    name: string;
  }>;
}

// Inventory item types (from InventoryModal.tsx)
export interface InventoryItem {
  tokenId: string;
  quality: 'rainbow' | 'mythic';
  name: string;
  effectType?: string;
  attribute?: string;
  value?: number;
  createdAt?: number;
  image?: string;
  hasRealData: boolean;
}
