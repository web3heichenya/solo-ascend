'use client';

import { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { Clock, Loader2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { useFulfillForgeManually } from '@/hooks/useForgeCoordinator';
import { useHeroPendingForge } from '@/hooks/usePendingForges';
import { useAppStore } from '@/lib/store';

import { PendingForgeButtonProps } from '@/types';

export function PendingForgeButton({ className }: PendingForgeButtonProps) {
  const { t } = useTranslation();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [activeRequestId, setActiveRequestId] = useState<string | null>(null);

  // Get current hero from store
  const { currentHeroId } = useAppStore();

  // Get pending forge for current hero
  const { pendingForge, refetch } = useHeroPendingForge(currentHeroId);

  // Manual fulfill hook
  const {
    fulfillManually,
    isPending: isFulfilling,
    isConfirming: isConfirmingFulfill,
    isConfirmed: isFulfillConfirmed,
  } = useFulfillForgeManually();

  // Check if there's a valid pending forge
  const hasPendingForge =
    pendingForge &&
    pendingForge.requestId &&
    pendingForge.requestId !== '0x0000000000000000000000000000000000000000000000000000000000000000';
  const pendingCount = hasPendingForge ? 1 : 0;

  // Update when request is fulfilled
  useEffect(() => {
    if (activeRequestId && isFulfillConfirmed) {
      setActiveRequestId(null);
      refetch(); // Refresh data
    }
  }, [activeRequestId, isFulfillConfirmed, refetch]);

  const handleOpenModal = () => {
    setIsModalOpen(true);
    if (pendingForge?.requestId) {
      setActiveRequestId(pendingForge.requestId);
    }
  };

  // Auto-refresh periodically when modal is open
  useEffect(() => {
    if (!isModalOpen) return;

    const interval = setInterval(() => {
      refetch();
    }, 10000); // Refresh every 10 seconds

    return () => clearInterval(interval);
  }, [isModalOpen, refetch]);

  const handleFulfillManually = async (requestId: string) => {
    try {
      setActiveRequestId(requestId);
      await fulfillManually(requestId);
    } catch (error) {
      console.error('Failed to fulfill manually:', error);
      setActiveRequestId(null);
    }
  };

  const formatTimestamp = (timestamp: number) => {
    if (!timestamp) return t('forge.status.unknown');
    return new Date(timestamp * 1000).toLocaleString();
  };

  const isOlderThanTwoHours = (timestamp: number) => {
    if (!timestamp) return false;
    const nowInSeconds = Math.floor(Date.now() / 1000);
    const twoHoursInSeconds = 2 * 60 * 60; // 2 hours in seconds
    return nowInSeconds - timestamp >= twoHoursInSeconds;
  };

  const getStatusText = () => {
    if (!pendingForge) return '';
    if (pendingForge.fulfilled) {
      return t('forge.status.fulfilled');
    } else {
      return t('forge.status.processing');
    }
  };

  const getStatusColor = () => {
    if (!pendingForge) return '';
    if (pendingForge.fulfilled) {
      return 'text-cyber-green';
    } else {
      return 'text-cyber-yellow';
    }
  };

  if (pendingCount === 0) {
    return null; // Don't show button if no pending forges
  }

  return (
    <>
      <Button
        variant="cyber"
        size="icon"
        onClick={handleOpenModal}
        className={`neon-text relative h-10 w-10 transition-transform hover:scale-110 md:h-12 md:w-12 ${className}`}
        title={t('forge.pending.title')}
      >
        <Clock className="h-4 w-4 md:h-5 md:w-5" />
        {pendingCount > 0 && (
          <span className="bg-cyber-pink font-pixel absolute -top-1 -right-1 flex h-5 w-5 items-center justify-center rounded-full text-xs text-white">
            {pendingCount}
          </span>
        )}
      </Button>

      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent className="bg-cyber-dark border-cyber-blue max-h-[80vh] w-[95vw] max-w-2xl overflow-y-auto rounded-lg border-2 shadow-[0_0_20px_rgba(0,255,255,0.3)] sm:w-full">
          <DialogHeader>
            <DialogTitle className="font-pixel text-cyber-pink neon-text">
              {t('forge.pending.title')}
            </DialogTitle>
          </DialogHeader>

          <div className="space-y-6">
            {pendingForge && (
              <div className="space-y-3">
                <div className="flex items-start justify-between">
                  <div>
                    <div className="font-pixel text-cyber-green">
                      {t('hero.display.hero')} #{pendingForge.heroId}
                    </div>
                    <div className="text-cyber-blue text-sm opacity-80">
                      {formatTimestamp(pendingForge.timestamp)}
                    </div>
                  </div>
                  <div className={`font-pixel text-sm ${getStatusColor()}`}>{getStatusText()}</div>
                </div>

                <div className="text-cyber-green bg-cyber-dark/50 rounded p-3 font-mono text-xs break-all">
                  {pendingForge.requestId && (
                    <div>
                      {t('forge.transaction.request')}: {pendingForge.requestId}
                    </div>
                  )}
                </div>

                {!pendingForge.fulfilled && pendingForge.requestId === activeRequestId && (
                  <div className="text-cyber-blue flex items-center gap-2">
                    <Loader2 className="h-4 w-4 animate-spin" />
                    <span className="text-sm">{t('forge.status.checking')}</span>
                  </div>
                )}

                {/* Fulfill manually button - show when not fulfilled and older than 2 hours */}
                {!pendingForge.fulfilled && isOlderThanTwoHours(pendingForge.timestamp) && (
                  <div className="flex justify-end">
                    <Button
                      variant="cyber"
                      size="sm"
                      onClick={() => handleFulfillManually(pendingForge.requestId)}
                      disabled={isFulfilling || isConfirmingFulfill}
                      className="px-4 py-2 text-xs"
                    >
                      {isFulfilling || isConfirmingFulfill ? (
                        <div className="flex items-center gap-2">
                          <Loader2 className="h-3 w-3 animate-spin" />
                          {isFulfilling
                            ? t('forge.button.fulfilling')
                            : t('forge.button.confirming')}
                        </div>
                      ) : (
                        t('forge.button.fulfillManually')
                      )}
                    </Button>
                  </div>
                )}
              </div>
            )}
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}
