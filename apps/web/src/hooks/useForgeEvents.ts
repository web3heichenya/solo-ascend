'use client';

import { useState, useCallback } from 'react';
import { usePublicClient, useChainId } from 'wagmi';
import { getContractAddress } from '@/lib/contracts/config';
import { showToast } from '@/lib/toast';

export function useForgeEvents() {
  const publicClient = usePublicClient();
  const chainId = useChainId();
  const [isProcessing, setIsProcessing] = useState(false);

  // Parse transaction to extract ForgeInitiated event
  const parseForgeTransaction = useCallback(
    async (txHash: string): Promise<string | null> => {
      if (!publicClient) return null;

      try {
        setIsProcessing(true);

        // Wait for transaction receipt with retries
        let receipt = null;
        let attempts = 0;
        const maxAttempts = 10;
        const delayMs = 2000; // 2 seconds between attempts

        while (!receipt && attempts < maxAttempts) {
          try {
            receipt = await publicClient.getTransactionReceipt({
              hash: txHash as `0x${string}`,
            });
            if (receipt) break;
          } catch (error: unknown) {
            // If the error is specifically about transaction not found, wait and retry
            if (
              (error as Error).message?.includes('could not be found') ||
              (error as Error).message?.includes('not be processed')
            ) {
              attempts++;
              console.log(
                `Transaction not yet confirmed, attempt ${attempts}/${maxAttempts}. Waiting ${delayMs}ms...`
              );
              if (attempts < maxAttempts) {
                await new Promise((resolve) => setTimeout(resolve, delayMs));
                continue;
              }
            }
            throw error; // Re-throw if it's a different error
          }
        }

        if (!receipt) {
          console.log('Transaction receipt not found after maximum attempts');
          showToast.warning(
            'Transaction Pending',
            'Transaction is still being processed. Please wait a moment and try again.'
          );
          return null;
        }

        if (!receipt || !receipt.logs) {
          console.log('No logs found in transaction receipt');
          return null;
        }

        // Look for ForgeInitiated event
        // Event signature: ForgeInitiated(bytes32 indexed requestId, uint256 indexed heroId, address indexed requester, uint256 oracleId)
        // Topic: 0x9e2b96efa3f47889a9a54d52d89d7f31f24b580a4375b613ec393a594d7b390a
        const forgeInitiatedTopic =
          '0x9e2b96efa3f47889a9a54d52d89d7f31f24b580a4375b613ec393a594d7b390a';

        for (const log of receipt.logs) {
          if (
            log.address.toLowerCase() ===
            getContractAddress(chainId, 'forgeCoordinator').toLowerCase()
          ) {
            try {
              // Check if this is a ForgeInitiated event
              if (log.topics && log.topics[0] === forgeInitiatedTopic && log.topics.length >= 2) {
                const requestId = log.topics[1]; // First indexed parameter (requestId)
                if (requestId) {
                  console.log('Found ForgeInitiated event, requestId:', requestId);
                  return requestId;
                }
              }
            } catch (error) {
              console.error('Error parsing log:', error);
            }
          }
        }

        return null;
      } catch (error) {
        console.error('Error parsing forge transaction:', error);
        showToast.error(
          'Transaction Processing Failed',
          'The transaction could not be processed. It may have failed or not been confirmed yet.'
        );
        return null;
      } finally {
        setIsProcessing(false);
      }
    },
    [publicClient, chainId]
  );

  return {
    parseForgeTransaction,
    isProcessing,
  };
}
