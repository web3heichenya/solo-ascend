import { useChainId } from 'wagmi';
import { baseSepolia, base, Chain } from 'viem/chains';

const CHAIN_CONFIGS: Record<number, Chain> = {
  [baseSepolia.id]: baseSepolia,
  [base.id]: base,
};

export function useChainConfig() {
  const chainId = useChainId();

  const currentChainConfig = CHAIN_CONFIGS[chainId];

  const getExplorerUrl = (address: string, type: 'address' | 'tx' = 'address') => {
    if (!currentChainConfig) return null;
    return `${currentChainConfig.blockExplorers?.default.url}/${type}/${address}`;
  };

  return {
    chainId,
    chainConfig: currentChainConfig,
    getExplorerUrl,
    supportedChains: Object.values(CHAIN_CONFIGS),
  };
}
