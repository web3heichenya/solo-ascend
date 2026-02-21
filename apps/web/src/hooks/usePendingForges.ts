'use client';

import { usePendingRequest, useForgeRequest } from './useForgeCoordinator';

// Hook to fetch pending forge for a specific hero
export function useHeroPendingForge(heroId: number | null) {
  const { requestId, refetch: refetchRequest } = usePendingRequest(heroId);
  const { requester, fulfilled, timestamp, refetch: refetchForge } = useForgeRequest(requestId);

  const refetch = () => {
    refetchRequest();
    if (requestId) {
      refetchForge();
    }
  };

  if (!heroId || !requestId) {
    return {
      pendingForge: null,
      isLoading: false,
      refetch,
    };
  }

  return {
    pendingForge: {
      heroId,
      requestId,
      requester: requester || '',
      timestamp: timestamp || 0,
      fulfilled: fulfilled || false,
    },
    isLoading: false,
    refetch,
  };
}
