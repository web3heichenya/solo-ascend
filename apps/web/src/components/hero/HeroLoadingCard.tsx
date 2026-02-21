'use client';

import { memo } from 'react';
import { Card } from '@/components/ui/card';
import { Loader2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { HeroLoadingCardProps } from '@/types';

export const HeroLoadingCard = memo(function HeroLoadingCard({ className }: HeroLoadingCardProps) {
  const { t } = useTranslation();

  return (
    <Card
      className={`cyber-border cyber-card-glow bg-cyber-dark/20 p-6 md:p-8 lg:p-10 ${className}`}
    >
      <div className="flex items-center justify-center py-12 md:py-16">
        <div className="text-cyber-blue flex items-center gap-2">
          <Loader2 className="text-cyber-blue h-5 w-5 animate-spin" />
          <span className="font-pixel text-sm">{t('hero.display.loadingHero')}</span>
        </div>
      </div>
    </Card>
  );
});
