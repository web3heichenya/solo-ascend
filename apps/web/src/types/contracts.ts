// Contract address types
export type SupportedChainId = number;
export type ContractAddressKey =
  | 'treasury'
  | 'traitRegistry'
  | 'heroClassRegistry'
  | 'forgeEffectRegistry'
  | 'oracleRegistry'
  | 'hookRegistry'
  | 'forgeItemRegistry'
  | 'metadataRenderer'
  | 'simpleOracle'
  | 'chainlinkOracle'
  | 'forgeCoordinator'
  | 'attributeForgeEffect'
  | 'amplifyForgeEffect'
  | 'enhanceForgeEffect'
  | 'mythicForgeEffect'
  | 'nftForgeEffect'
  | 'ftForgeEffect'
  | 'silverForgeItemNFT'
  | 'goldForgeItemNFT'
  | 'rainbowForgeItemNFT'
  | 'mythicForgeItemNFT'
  | 'heroContract'
  | 'forgeAnalyticsHook';

// Oracle types
export interface Oracle {
  id: number;
  address: `0x${string}` | string;
  name: string;
  type: 'free' | 'premium';
  cost: number;
  description: string;
  qualityRanges: string[];
  enabled: boolean;
  gasLimit?: number;
}

// Contract interaction types
export interface ContractConfig {
  address: `0x${string}`;
  abi: readonly unknown[];
}

// Transaction types
export interface TransactionRequest {
  to: `0x${string}`;
  value?: bigint;
  data?: `0x${string}`;
  gasLimit?: number;
}

export interface TransactionResponse {
  hash: `0x${string}`;
  blockNumber?: number;
  status?: 'success' | 'reverted';
}

// Forge request types
export interface ForgeRequest {
  heroId: number;
  oracleId: number;
  gasLimit: number;
  customValue?: number;
}
