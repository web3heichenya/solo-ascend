'use client';

import { memo, useEffect, useCallback } from 'react';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { useHeroMint, useTotalSupply } from '@/hooks/useHeroContract';
import { Loader2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { showToast } from '@/lib/toast';
import { HeroMintCardProps } from '@/types';
import Image from 'next/image';

export const HeroMintCard = memo(function HeroMintCard({ className }: HeroMintCardProps) {
  const { t } = useTranslation();
  const { mint, isPending, isConfirming, isConfirmed, error } = useHeroMint();
  const { totalSupply } = useTotalSupply();

  const handleMint = useCallback(() => {
    if (isPending || isConfirming) return;
    mint();
  }, [isPending, isConfirming, mint]);

  // Show toast notifications for mint status
  useEffect(() => {
    if (error) {
      showToast.error(t('hero.mint.failed'), error.message);
    }
  }, [error, t]);

  useEffect(() => {
    if (isConfirmed) {
      showToast.success(t('hero.mint.success'));
    }
  }, [isConfirmed, t]);

  return (
    <Card
      className={`cyber-border cyber-card-glow bg-cyber-dark/20 mx-auto max-w-lg space-y-4 p-4 text-center md:space-y-6 md:p-6 ${className}`}
    >
      <div className="space-y-2">
        <h2 className="font-pixel text-cyber-pink neon-text text-base md:text-lg">
          {t('hero.mint.title')}
        </h2>
        <p className="text-cyber-blue font-pixel text-sm opacity-80">{t('hero.mint.subtitle')}</p>
        {totalSupply > 0 && (
          <p className="text-cyber-green text-xs">
            {t('hero.mint.totalMinted')}: {totalSupply}
          </p>
        )}
      </div>

      {/* Hero Icon Placeholder */}
      <div className="cyber-border bg-cyber-dark/30 mx-auto flex h-32 w-32 items-center justify-center rounded md:h-40 md:w-40">
        <Image src="/icons/logo.png" alt="" layout="fill" objectFit="contain" />
      </div>

      <div className="space-y-4">
        {/* Mint Price */}
        <div className="bg-cyber-dark/20 border-cyber-blue/20 rounded-lg border p-4 text-center">
          <div className="font-pixel text-cyber-green mb-2 text-base">{t('hero.mint.cost')}</div>
          <div className="font-pixel text-cyber-yellow neon-text text-xl md:text-2xl">
            0.00033 ETH
          </div>
          <div className="text-cyber-blue mt-1 text-sm opacity-60">{t('hero.mint.gasFee')}</div>
        </div>

        {/* Mint Button */}
        <Button
          onClick={handleMint}
          variant="cyber"
          className="font-pixel mx-auto w-full max-w-sm px-8 py-3 text-sm md:px-12 md:py-4 md:text-base"
          disabled={isPending || isConfirming}
        >
          {isPending || isConfirming ? (
            <div className="flex items-center gap-2">
              <Loader2 className="text-cyber-blue h-4 w-4 animate-spin" />
              {isPending ? t('hero.mint.confirming') : t('hero.mint.minting')}
            </div>
          ) : (
            t('hero.mint.button')
          )}
        </Button>
      </div>

      {/* Info */}
      <div className="text-cyber-blue border-cyber-blue/20 border-t pt-4 text-sm opacity-60">
        <p>{t('hero.mint.info')}</p>
        <p className="mt-2">{t('hero.mint.onePerWallet')}</p>
      </div>
    </Card>
  );
});
