'use client';

import { useEffect } from 'react';
import { Card } from '@/components/ui/card';
import { useAccount } from 'wagmi';
import { useAppStore } from '@/lib/store';
import { useHeroData, useHasMinted } from '@/hooks/useHeroContract';
import { HeroMintCard } from './HeroMintCard';
import { HeroLoadingCard } from './HeroLoadingCard';
import { HeroDetailsCard } from './HeroDetailsCard';
import { useTranslation } from 'react-i18next';
import { HeroEmptyCard } from './HeroEmptyCard';
import { HeroDisplayProps } from '@/types';

export function HeroDisplay({ className }: HeroDisplayProps) {
  const { t } = useTranslation();
  const { address } = useAccount();
  const { currentHeroId, setCurrentHeroId, userHeroId: persistedHeroId } = useAppStore();

  // Check if user has minted a hero
  const { heroId: contractHeroId, hasMinted } = useHasMinted(address);

  // Use persisted hero ID first, then contract hero ID
  const userHeroId = persistedHeroId || contractHeroId;

  // Set user's hero as current if no hero is selected
  useEffect(() => {
    if (userHeroId && !currentHeroId) {
      setCurrentHeroId(userHeroId);
    }
  }, [userHeroId, currentHeroId, setCurrentHeroId]);

  // Get hero data for current hero ID
  const displayHeroId = currentHeroId || userHeroId;
  const { hero, isLoading: heroLoading, refetch: refetchHeroData } = useHeroData(displayHeroId);

  if (!address) {
    return (
      <div className="flex min-h-[200px] items-center justify-center px-4 md:min-h-[250px]">
        <Card className="cyber-border bg-cyber-dark/80 mx-auto max-w-xs p-3 text-center backdrop-blur-sm md:p-4">
          <h2 className="font-pixel text-cyber-pink neon-text mb-2 text-sm md:text-base">
            {t('app.title')}
          </h2>
          <p className="text-cyber-blue mb-3 text-xs opacity-80">{t('wallet.connectToStart')}</p>
        </Card>
      </div>
    );
  }

  if (heroLoading) {
    return (
      <div className={`mx-auto max-w-xl p-3 md:p-4 lg:p-5 ${className}`}>
        <HeroLoadingCard />
      </div>
    );
  }

  // Show mint card if user hasn't minted a hero and no hero ID is set
  if (!hasMinted && !currentHeroId) {
    return (
      <div className={`mx-auto max-w-xl p-3 md:p-4 lg:p-5 ${className}`}>
        <HeroMintCard />
      </div>
    );
  }

  return (
    <div className={`mx-auto max-w-3xl p-3 md:p-4 lg:p-5 ${className}`}>
      {displayHeroId && hero ? (
        <HeroDetailsCard
          heroId={displayHeroId}
          hero={hero}
          refetchHeroData={refetchHeroData}
          className="mx-auto max-w-2xl"
        />
      ) : (
        <HeroEmptyCard />
      )}
    </div>
  );
}
