'use client';

import { useReadContract, useWriteContract, useWaitForTransactionReceipt, useChainId } from 'wagmi';
import { getContractAddress } from '@/lib/contracts/config';
import { forgeCoordinatorABI } from '@/lib/contracts/abis/ForgeCoordinator';

// Hook for querying pending request for a hero
export function usePendingRequest(heroId: number | null) {
  const chainId = useChainId();

  const {
    data: pendingRequestData,
    isLoading,
    error,
    refetch,
  } = useReadContract({
    address: getContractAddress(chainId, 'forgeCoordinator'),
    abi: forgeCoordinatorABI,
    functionName: 'getPendingRequest',
    args: heroId ? [BigInt(heroId)] : undefined,
    query: {
      enabled: !!heroId,
      staleTime: 10000, // 10 seconds
      refetchInterval: 10000, // Check every 10 seconds
    },
  });

  return {
    requestId:
      pendingRequestData &&
      pendingRequestData !== '0x0000000000000000000000000000000000000000000000000000000000000000'
        ? (pendingRequestData as `0x${string}`)
        : null,
    isLoading,
    error,
    refetch,
  };
}

export function useForgeRequest(requestId: string | null) {
  const chainId = useChainId();

  const {
    data: forgeRequestData,
    isLoading,
    error,
    refetch,
  } = useReadContract({
    address: getContractAddress(chainId, 'forgeCoordinator'),
    abi: forgeCoordinatorABI,
    functionName: 'getForgeRequest',
    args: requestId ? [requestId as `0x${string}`] : undefined,
    query: {
      enabled: !!requestId,
      staleTime: 30000, // 30 seconds
    },
  });

  return {
    requester: forgeRequestData?.requester || null,
    heroId: forgeRequestData?.heroId ? Number(forgeRequestData.heroId) : null,
    fulfilled: forgeRequestData?.fulfilled || false,
    timestamp: forgeRequestData?.requestTime ? Number(forgeRequestData.requestTime) : null,
    isLoading,
    error,
    refetch,
  };
}

// Hook for manually fulfilling forge request
export function useFulfillForgeManually() {
  const { writeContract, data: hash, isPending, error } = useWriteContract();
  const chainId = useChainId();

  const { isLoading: isConfirming, isSuccess: isConfirmed } = useWaitForTransactionReceipt({
    hash,
  });

  const fulfillManually = async (requestId: string) => {
    try {
      writeContract({
        address: getContractAddress(chainId, 'forgeCoordinator'),
        abi: forgeCoordinatorABI,
        functionName: 'fulfillForgeManually',
        args: [requestId as `0x${string}`],
      });
    } catch (error) {
      console.error('Manual fulfill failed:', error);
    }
  };

  return {
    fulfillManually,
    isPending,
    isConfirming,
    isConfirmed,
    error,
    data: hash,
  };
}
