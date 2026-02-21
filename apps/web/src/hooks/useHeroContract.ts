'use client';

import { useReadContract, useWriteContract, useWaitForTransactionReceipt, useChainId } from 'wagmi';
import { parseEther } from 'viem';
import { getContractAddress } from '@/lib/contracts/config';
import { soloAscendHeroABI } from '@/lib/contracts/abis';
import { useAppStore } from '@/lib/store';
import { useMemo, useEffect } from 'react';
import { showToast } from '@/lib/toast';
import { useForgeManager } from './useForgeManager';

// Hook for reading hero data
export function useHeroData(heroId: number | null) {
  const chainId = useChainId();
  const {
    data: heroData,
    isLoading,
    error,
    refetch,
  } = useReadContract({
    address: getContractAddress(chainId, 'heroContract'),
    abi: soloAscendHeroABI,
    functionName: 'getHero',
    args: heroId ? [BigInt(heroId)] : undefined,
    query: {
      enabled: !!heroId,
      staleTime: 30000, // 30 seconds
    },
  });

  const hero = useMemo(() => {
    if (!heroData) return null;

    return {
      tokenBoundAccount: heroData.tokenBoundAccount,
      lastForgeTime: Number(heroData.lastForgeTime),
      totalForges: Number(heroData.totalForges),
      mintTime: Number(heroData.mintTime),
      classId: heroData.classId,
      stage: heroData.stage,
      attributes: {
        hp: Number(heroData.attributes.hp),
        hpRegen: Number(heroData.attributes.hpRegen),
        ad: Number(heroData.attributes.ad),
        ap: Number(heroData.attributes.ap),
        attackSpeed: Number(heroData.attributes.attackSpeed),
        crit: Number(heroData.attributes.crit),
        armor: Number(heroData.attributes.armor),
        mr: Number(heroData.attributes.mr),
        cdr: Number(heroData.attributes.cdr),
        moveSpeed: Number(heroData.attributes.moveSpeed),
        lifesteal: Number(heroData.attributes.lifesteal),
        tenacity: Number(heroData.attributes.tenacity),
        penetration: Number(heroData.attributes.penetration),
        mana: Number(heroData.attributes.mana),
        manaRegen: Number(heroData.attributes.manaRegen),
        intelligence: Number(heroData.attributes.intelligence),
      },
    };
  }, [heroData]);

  return {
    hero,
    isLoading,
    error,
    refetch,
  };
}

// Hook for checking if user has minted a hero
export function useHasMinted(address: string | undefined) {
  const { setUserHeroId } = useAppStore();
  const chainId = useChainId();

  const { data: heroId, isSuccess } = useReadContract({
    address: getContractAddress(chainId, 'heroContract'),
    abi: soloAscendHeroABI,
    functionName: 'hasMinted',
    args: address ? [address as `0x${string}`] : undefined,
    query: {
      enabled: !!address,
      staleTime: 60000, // 1 minute
    },
  });

  const userHeroId = heroId ? Number(heroId) : null;
  const hasMinted = userHeroId && userHeroId > 0;

  // Persist user's hero ID when successfully fetched
  useEffect(() => {
    if (isSuccess && userHeroId && userHeroId > 0) {
      setUserHeroId(userHeroId);
    }
  }, [isSuccess, userHeroId, setUserHeroId]);

  return {
    heroId: userHeroId,
    hasMinted: !!hasMinted,
  };
}

// Hook for checking forge availability
export function useForgeAvailability(heroId: number | null) {
  const chainId = useChainId();
  const { data: forgeData, refetch } = useReadContract({
    address: getContractAddress(chainId, 'heroContract'),
    abi: soloAscendHeroABI,
    functionName: 'isForgeAvailable',
    args: heroId ? [BigInt(heroId)] : undefined,
    query: {
      enabled: !!heroId,
      refetchInterval: 60000, // Refetch every minute
    },
  });

  return {
    available: forgeData ? forgeData[0] : false,
    timeLeft: forgeData ? Number(forgeData[1]) : 0,
    refetch,
  };
}

// Hook for minting a hero
export function useHeroMint() {
  const { writeContract, data: hash, isPending, error } = useWriteContract();
  const { setCurrentHeroId } = useAppStore();
  const chainId = useChainId();

  const {
    isLoading: isConfirming,
    isSuccess: isConfirmed,
    data: receipt,
  } = useWaitForTransactionReceipt({
    hash,
  });

  const mint = async () => {
    try {
      writeContract({
        address: getContractAddress(chainId, 'heroContract'),
        abi: soloAscendHeroABI,
        functionName: 'mint',
        value: parseEther('0.00033'), // Mint price
      });
    } catch (error) {
      showToast.error(
        'Mint failed',
        error instanceof Error ? error.message : 'Unknown error occurred'
      );
    }
  };

  // Extract hero ID from mint transaction receipt
  const mintedHeroId = useMemo(() => {
    if (!receipt?.logs) return null;

    for (const log of receipt.logs) {
      try {
        // Look for Transfer event from mint
        if (
          log.topics[0] === '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
        ) {
          const tokenId = BigInt(log.topics[3] || '0');
          return Number(tokenId);
        }
      } catch {
        // Skip invalid logs
      }
    }
    return null;
  }, [receipt]);

  // Auto-set the minted hero as current
  useEffect(() => {
    if (mintedHeroId && isConfirmed) {
      setCurrentHeroId(mintedHeroId);
    }
  }, [mintedHeroId, isConfirmed, setCurrentHeroId]);

  return {
    mint,
    isPending,
    isConfirming,
    isConfirmed,
    error,
    mintedHeroId,
  };
}

// Hook for daily forging (now using unified forge manager)
export function useDailyForge() {
  // Re-export useForgeManager for backward compatibility
  // This allows existing components to continue using useDailyForge
  // while gradually migrating to the new architecture
  const forgeManager = useForgeManager();

  return {
    forge: forgeManager.executeForge,
    isPending: forgeManager.isPending,
    isConfirming: forgeManager.isConfirming,
    isConfirmed: forgeManager.isConfirmed,
    error: forgeManager.error,
    data: forgeManager.data,
  };
}

// Hook for getting total supply
export function useTotalSupply() {
  const chainId = useChainId();
  const { data: totalSupply } = useReadContract({
    address: getContractAddress(chainId, 'heroContract'),
    abi: soloAscendHeroABI,
    functionName: 'totalSupply',
    query: {
      staleTime: 60000, // 1 minute
    },
  });

  return {
    totalSupply: totalSupply ? Number(totalSupply) : 0,
  };
}
