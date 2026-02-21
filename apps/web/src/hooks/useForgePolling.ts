'use client';

import { useEffect, useState } from 'react';
import { useWatchContractEvent, useReadContract, useChainId } from 'wagmi';
import { forgeCoordinatorABI, soloAscendHeroABI } from '@/lib/contracts/abis';
import { getContractAddress } from '@/lib/contracts/config';
import { ForgeResult } from '@/types';
import { usePendingRequest } from './useForgeCoordinator';

export function useForgeResultPolling(heroId: number | null) {
  const [forgeResults, setForgeResults] = useState<Record<number, ForgeResult>>({});
  const chainId = useChainId();

  // Check if there's a pending request for this hero directly from the chain
  const { requestId: pendingRequestId } = usePendingRequest(heroId);
  const hasPendingRequest =
    !!pendingRequestId &&
    pendingRequestId !== '0x0000000000000000000000000000000000000000000000000000000000000000';

  // Watch for ForgeCompleted events
  useWatchContractEvent({
    address: getContractAddress(chainId, 'forgeCoordinator'),
    abi: forgeCoordinatorABI,
    eventName: 'ForgeCompleted',
    onLogs(logs) {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      logs.forEach((log: any) => {
        const args = log.args as {
          heroId: bigint;
          success: boolean;
          items?: Array<{ contractAddress: string; tokenId: bigint; name?: string }>;
        };
        const { heroId: eventHeroId, success, items } = args;
        const heroIdNum = Number(eventHeroId);

        if (heroIdNum === heroId) {
          setForgeResults((prev) => ({
            ...prev,
            [heroIdNum]: {
              status: success ? 'success' : 'failed',
              timestamp: Date.now(),
              txHash: log.transactionHash,
              itemsReceived: items?.map((item) => ({
                type: getItemType(item.contractAddress),
                tokenId: Number(item.tokenId),
                name: item.name || 'Unknown Item',
              })),
            },
          }));
        }
      });
    },
    enabled: !!heroId && hasPendingRequest,
  });

  // Poll hero data for attribute changes
  const { refetch } = useReadContract({
    address: getContractAddress(chainId, 'heroContract'),
    abi: soloAscendHeroABI,
    functionName: 'getHero',
    args: heroId ? [BigInt(heroId)] : undefined,
    query: {
      enabled: !!heroId && hasPendingRequest,
      refetchInterval: hasPendingRequest ? 5000 : undefined, // Poll every 5 seconds if pending
    },
  });

  useEffect(() => {
    if (hasPendingRequest && heroId && !forgeResults[heroId]) {
      setForgeResults((prev) => ({
        ...prev,
        [heroId]: {
          status: 'pending',
          timestamp: Date.now(),
          txHash: pendingRequestId || '',
        },
      }));
    }
  }, [hasPendingRequest, heroId, pendingRequestId, forgeResults]);

  // Helper to determine item type from contract address
  const getItemType = (address: string): 'silver' | 'gold' | 'rainbow' | 'mythic' => {
    const lowerAddress = address.toLowerCase();
    if (lowerAddress === getContractAddress(chainId, 'silverForgeItemNFT').toLowerCase())
      return 'silver';
    if (lowerAddress === getContractAddress(chainId, 'goldForgeItemNFT').toLowerCase())
      return 'gold';
    if (lowerAddress === getContractAddress(chainId, 'rainbowForgeItemNFT').toLowerCase())
      return 'rainbow';
    if (lowerAddress === getContractAddress(chainId, 'mythicForgeItemNFT').toLowerCase())
      return 'mythic';
    return 'silver'; // Default
  };

  return {
    currentResult: heroId ? forgeResults[heroId] : null,
    isPolling: hasPendingRequest,
    refetchHero: refetch,
  };
}

// Hook to get the latest forge result for display
export function useLatestForgeResult(heroId: number | null) {
  const [latestResult, setLatestResult] = useState<ForgeResult | null>(null);
  const chainId = useChainId();

  // Watch for recent forge events for this hero
  useWatchContractEvent({
    address: getContractAddress(chainId, 'forgeCoordinator'),
    abi: forgeCoordinatorABI,
    eventName: 'ForgeCompleted',
    onLogs(logs) {
      const recentLog = logs
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        .filter((log: any) => {
          const args = log.args as {
            heroId: bigint;
            success: boolean;
            items?: Array<{ contractAddress: string; tokenId: bigint; name?: string }>;
          };
          const { heroId: eventHeroId } = args;
          return Number(eventHeroId) === heroId;
        })
        .sort((a, b) => Number(b.blockNumber || 0) - Number(a.blockNumber || 0))[0];

      if (recentLog) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const args = (recentLog as any).args as {
          heroId: bigint;
          success: boolean;
          items?: Array<{ contractAddress: string; tokenId: bigint; name?: string }>;
        };
        const { success, items } = args;
        setLatestResult({
          status: success ? 'success' : 'failed',
          timestamp: Date.now(),
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          txHash: (recentLog as any).transactionHash,
          itemsReceived: items?.map((item) => ({
            type: getItemType(item.contractAddress),
            tokenId: Number(item.tokenId),
            name: item.name || 'Unknown Item',
          })),
        });
      }
    },
    enabled: !!heroId,
  });

  const getItemType = (address: string): 'silver' | 'gold' | 'rainbow' | 'mythic' => {
    const lowerAddress = address.toLowerCase();
    if (lowerAddress === getContractAddress(chainId, 'silverForgeItemNFT').toLowerCase())
      return 'silver';
    if (lowerAddress === getContractAddress(chainId, 'goldForgeItemNFT').toLowerCase())
      return 'gold';
    if (lowerAddress === getContractAddress(chainId, 'rainbowForgeItemNFT').toLowerCase())
      return 'rainbow';
    if (lowerAddress === getContractAddress(chainId, 'mythicForgeItemNFT').toLowerCase())
      return 'mythic';
    return 'silver';
  };

  return latestResult;
}
