import { baseSepolia } from 'viem/chains';

export const CONTRACT_ADDRESSES = {
  [baseSepolia.id]: {
    treasury: '0x3fdc4531D451fc7C26b2e45Da26FE3f27679366F',
    traitRegistry: '0x848B6264A320F344D08545f2071d1BB0Ee948c61',
    heroClassRegistry: '0x1b2b8fFA619a72804d4a77Cf1D14b167700dD3D7',
    forgeEffectRegistry: '0x8c7C236A9fEfE059DCAAE62Bc3451A55D1bA5E43',
    oracleRegistry: '0x8eb7686E46CB2bA60f4A022E149E993145f8277D',
    hookRegistry: '0x4897D3703f13d200Ef5Ce26Ecad35f65AA1dd882',
    forgeItemRegistry: '0x556349ea62806A170300D8E086ACeCAd915990B4',
    metadataRenderer: '0x5Ae79FC9848bD0DBA9741Ee997EEDA9825d437f0',
    simpleOracle: '0x73AD60D8f480eBF554a8fE533569F6162b3a5995',
    chainlinkOracle: '0xA289e41A6339A3B31b5B234e2e7e702C895C8CD2',
    forgeCoordinator: '0x44B55eBDDF1fa3082936EfC9ee1e06E7D7E3EF11',
    attributeForgeEffect: '0x765940084188811A6d1c132DaDfaCaaBD37F90e8',
    amplifyForgeEffect: '0xbBa2690Ad128Bf8416798Da0d3dAEFf57DD21E28',
    enhanceForgeEffect: '0xDd1257518e5c78447812fE4380f644E51d22cbAd',
    mythicForgeEffect: '0x74C950923661c736433FD6b3cA84C7c4a4e00e08',
    ftForgeEffect: '0x2999F2e9A535c6dB822cE7d927998CB6fF6F0e0b',
    silverForgeItemNFT: '0x1bc661491f4Ad69a89903F53766475A253981b28',
    goldForgeItemNFT: '0x8eEf30B5A9dfE4AbA87802B155d7ce8d9ecBA58d',
    rainbowForgeItemNFT: '0x74e9051964f972CEbF65E4b5deC9f6f7b886106e',
    mythicForgeItemNFT: '0x9Bd6d2059fB6b9c00948f7Bc89DBBA6e3FE34E26',
    heroContract: '0x20F053A56b9fBd5920D3Aec1Ae968bF62a5A07a3',
    forgeAnalyticsHook: '0x4381f9f6880b2B4040E8Aa90d7F8F538C4D31c28',
  },
} as const;

// Export types
export type SupportedChainId = keyof typeof CONTRACT_ADDRESSES;
export type ContractAddressKey = keyof (typeof CONTRACT_ADDRESSES)[SupportedChainId];

// Helper to get contract address with type safety
export function getContractAddress(chainId: number, contract: ContractAddressKey): `0x${string}` {
  const supportedChainId = chainId as SupportedChainId;
  const chainAddresses = CONTRACT_ADDRESSES[supportedChainId];
  if (!chainAddresses) {
    throw new Error(
      `Unsupported chain ID: ${chainId}. Supported chains: ${Object.keys(CONTRACT_ADDRESSES).join(', ')}`
    );
  }
  return chainAddresses[contract] as `0x${string}`;
}

// Helper to get all addresses for a chain
export function getChainAddresses(chainId: number) {
  const supportedChainId = chainId as SupportedChainId;
  const addresses = CONTRACT_ADDRESSES[supportedChainId];
  if (!addresses) {
    throw new Error(
      `Unsupported chain ID: ${chainId}. Supported chains: ${Object.keys(CONTRACT_ADDRESSES).join(', ')}`
    );
  }
  return addresses;
}

// Helper to check if a chain is supported
export function isSupportedChain(chainId: number): chainId is SupportedChainId {
  return chainId in CONTRACT_ADDRESSES;
}

export const ORACLES = {
  [baseSepolia.id]: [
    {
      id: 1,
      address: getContractAddress(baseSepolia.id, 'simpleOracle'),
      name: 'Pseudo Random Oracle',
      type: 'free',
      cost: 0,
      description:
        'Uses blockchain-based pseudo-random number generation. Free to use but less secure randomness.',
      qualityRanges: ['Silver (100%)', 'Gold (0%)', 'Rainbow (0%)', 'Mythic (0%)'],
      enabled: true,
      gasLimit: 300_000,
    },
    {
      id: 2,
      address: getContractAddress(baseSepolia.id, 'chainlinkOracle'),
      name: 'Chainlink VRF Oracle',
      type: 'premium',
      cost: 0,
      description:
        'Uses Chainlink VRF for truly verifiable random number generation. Provides better randomness quality.',
      qualityRanges: ['Silver (0%)', 'Gold (66%)', 'Rainbow (33%)', 'Mythic (1%)'],
      enabled: true,
      gasLimit: 900_000,
    },
  ],
};

export const getOracles = (chainId: number) => {
  const supportedChainId = chainId as SupportedChainId;
  const oracles = ORACLES[supportedChainId];
  if (!oracles) {
    return [];
  }
  return oracles;
};
