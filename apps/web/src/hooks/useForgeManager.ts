'use client';

import { useEffect } from 'react';
import { useWriteContract, useWaitForTransactionReceipt, useChainId } from 'wagmi';
import { useAppStore } from '@/lib/store';
import { getContractAddress } from '@/lib/contracts/config';
import { soloAscendHeroABI } from '@/lib/contracts/abis';
import { showToast } from '@/lib/toast';

/**
 * Unified forge manager hook that integrates store state management with wagmi
 */
export function useForgeManager() {
  const { forgeState, setForgeState, clearForgeState } = useAppStore();

  const chainId = useChainId();
  const { writeContract, data: hash, isPending, error } = useWriteContract();

  const { isLoading: isConfirming, isSuccess: isConfirmed } = useWaitForTransactionReceipt({
    hash,
  });

  // Update store state when wagmi states change
  useEffect(() => {
    setForgeState({
      isForging: isPending,
      isConfirming: isConfirming,
      isConfirmed: isConfirmed,
      forgeHash: hash || null,
      error: error?.message || null,
    });
  }, [isPending, isConfirming, isConfirmed, hash, error, setForgeState]);

  // Clear selected hero after transaction is submitted
  useEffect(() => {
    if (hash && forgeState.selectedHeroId) {
      // Clear selected hero after transaction submission
      setForgeState({ selectedHeroId: null });
    }
  }, [hash, forgeState.selectedHeroId, setForgeState]);

  const executeForge = async (
    heroId: number,
    oracleId: number = 1,
    gasLimit: number = 500_000,
    customValue?: number | bigint
  ) => {
    try {
      // Set selected hero ID for tracking
      setForgeState({
        selectedHeroId: heroId,
        error: null,
      });

      // Use custom value if provided, otherwise use default
      const value = customValue !== undefined ? BigInt(customValue) : BigInt(0);

      writeContract({
        address: getContractAddress(chainId, 'heroContract'),
        abi: soloAscendHeroABI,
        functionName: 'performDailyForge',
        args: [BigInt(heroId), BigInt(oracleId), gasLimit],
        value,
      });
    } catch (error) {
      showToast.error(
        'Forge failed',
        error instanceof Error ? error.message : 'Unknown error occurred'
      );
      setForgeState({
        selectedHeroId: null,
        error: error instanceof Error ? error.message : 'Unknown error occurred',
      });
    }
  };

  return {
    // State
    forgeState,

    // Actions
    executeForge,
    clearForgeState,

    // Legacy compatibility (for gradual migration)
    forge: executeForge,
    isPending: forgeState.isForging,
    isConfirming: forgeState.isConfirming,
    isConfirmed: forgeState.isConfirmed,
    error: forgeState.error,
    data: forgeState.forgeHash,
  };
}
