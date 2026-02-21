'use client';

import { useState, useEffect } from 'react';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover';
import { HeroClass, HeroStage, HeroDetailsCardProps } from '@/types';
import { useForgeAvailability } from '@/hooks/useHeroContract';
import { useForgeManager } from '@/hooks/useForgeManager';
import { usePendingRequest, useFulfillForgeManually } from '@/hooks/useForgeCoordinator';
import { HeroSvg } from './HeroSvg';
import { ForgeOracleModal } from '@/components/forge/ForgeOracleModal';
import { TBAAssetsModal } from '@/components/tba/TBAAssetsModal';
import { getAttributeDifference, getClassDefaultAttribute } from '@/lib/hero/classData';
import {
  Sword,
  Shield,
  Heart,
  Zap,
  Eye,
  Loader2,
  Clock,
  Package,
  Activity,
  Sparkles,
  Crosshair,
  Wind,
  Gauge,
  Droplets,
  ShieldCheck,
  Target,
  CircleDot,
  RefreshCw,
  Brain,
} from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { showToast } from '@/lib/toast';
import { useChainConfig } from '@/hooks/useChainConfig';
import { ExternalLink } from 'lucide-react';

// Hero attribute icons mapping - Updated for new enum structure
const ATTRIBUTE_ICONS = {
  hp: Heart, // 0: Health Points
  hpRegen: Activity, // 1: Health Regeneration - pulse/activity icon
  ad: Sword, // 2: Attack Damage - sword
  ap: Sparkles, // 3: Ability Power - magic sparkles
  attackSpeed: Crosshair, // 4: Attack Speed - crosshair/targeting
  crit: Eye, // 5: Critical Strike Chance - eye for precision
  armor: Shield, // 6: Armor (Physical Resistance) - shield
  mr: Zap, // 7: Magic Resistance - lightning bolt (anti-magic)
  cdr: Gauge, // 8: Cooldown Reduction - gauge/meter
  moveSpeed: Wind, // 9: Movement Speed - wind
  lifesteal: Droplets, // 10: Lifesteal - droplets (life absorption)
  tenacity: ShieldCheck, // 11: Tenacity - shield with check (resistance to CC)
  penetration: Target, // 12: Penetration - target (piercing defenses)
  mana: CircleDot, // 13: Mana - circle with dot (mana orb)
  manaRegen: RefreshCw, // 14: Mana Regeneration - refresh/regeneration
  intelligence: Brain, // 15: Intelligence - brain
} as const;

export function HeroDetailsCard({
  heroId,
  hero,
  refetchHeroData,
  className,
}: HeroDetailsCardProps) {
  const { t } = useTranslation();
  const { getExplorerUrl } = useChainConfig();
  const [isOracleModalOpen, setIsOracleModalOpen] = useState(false);
  const [isTBAModalOpen, setIsTBAModalOpen] = useState(false);
  const [dynamicTimeLeft, setDynamicTimeLeft] = useState(0);

  const {
    available: forgeAvailable,
    timeLeft,
    refetch: refetchForgeAvailability,
  } = useForgeAvailability(heroId);

  // Use unified forge manager instead of individual hooks
  const { forgeState, clearForgeState } = useForgeManager();

  // Extract states for easier access (backward compatibility)
  const {
    isForging: forging,
    isConfirming: confirmingForge,
    isConfirmed: forgeConfirmed,
    forgeHash,
  } = forgeState;

  // Query pending request from ForgeCoordinator
  const { requestId: pendingRequestId, refetch: refetchPendingRequest } = usePendingRequest(heroId);

  // Listen for global fulfill confirmations to refetch pending request
  const { isConfirmed: anyFulfillConfirmed } = useFulfillForgeManually();

  // Dynamic countdown timer
  useEffect(() => {
    setDynamicTimeLeft(timeLeft);

    if (timeLeft > 0) {
      const interval = setInterval(() => {
        setDynamicTimeLeft((prev) => {
          if (prev <= 1) {
            clearInterval(interval);
            refetchForgeAvailability(); // Refetch when countdown reaches zero
            return 0;
          }
          return prev - 1;
        });
      }, 1000);

      return () => clearInterval(interval);
    }
  }, [timeLeft, refetchForgeAvailability]);

  const handleForge = () => {
    if (heroId && forgeAvailable) {
      setIsOracleModalOpen(true);
    }
  };

  // Refresh forge availability and hero data after successful forge
  useEffect(() => {
    if (forgeConfirmed && forgeHash) {
      // Close oracle modal and show success toast
      setIsOracleModalOpen(false);
      showToast.success(t('forge.oracle.forgeStarted'), t('forge.oracle.forgeStartedDesc'));

      // Delay refetch to allow blockchain state to update
      const refreshData = async () => {
        try {
          // Sequential refetch with delays to avoid race conditions
          await Promise.allSettled([
            refetchForgeAvailability(),
            refetchPendingRequest(),
            refetchHeroData(),
          ]);
        } catch (error) {
          console.error('Error refreshing data after forge:', error);
        }
      };

      // Start refresh after a short delay to allow transaction to be mined
      setTimeout(refreshData, 1000);

      // Clear forge state after processing
      setTimeout(() => {
        clearForgeState();
      }, 4000); // Longer delay to ensure all refetches complete
    }
  }, [
    forgeConfirmed,
    forgeHash,
    refetchForgeAvailability,
    refetchHeroData,
    clearForgeState,
    refetchPendingRequest,
    t,
  ]);

  // Refresh pending request when any fulfill is confirmed
  useEffect(() => {
    if (anyFulfillConfirmed) {
      refetchPendingRequest();
    }
  }, [anyFulfillConfirmed, refetchPendingRequest]);

  // Format time left for display
  const formatTimeLeft = (seconds: number) => {
    if (seconds <= 0) return null;
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const remainingSeconds = seconds % 60;

    if (hours > 0) {
      return `${hours}h ${minutes}m`;
    } else if (minutes > 0) {
      return `${minutes}m ${remainingSeconds}s`;
    } else {
      return `${remainingSeconds}s`;
    }
  };

  return (
    <>
      <Card
        className={`cyber-border cyber-card-glow bg-cyber-dark/20 p-3 md:p-4 lg:p-5 ${className}`}
      >
        <div className="space-y-3 md:space-y-4 lg:space-y-5">
          {/* Hero Header */}
          <div className="space-y-1 text-center md:space-y-2">
            <h1 className="font-pixel text-cyber-pink neon-text text-base md:text-lg lg:text-xl">
              {t('hero.display.hero')} #{heroId}
            </h1>
            <div className="flex flex-wrap justify-center gap-2 text-xs md:gap-3 md:text-sm lg:gap-4">
              <span className="text-cyber-green font-pixel">
                {t(`hero.classes.${HeroClass[hero.classId]}`)}
              </span>
              <span className="text-cyber-yellow font-pixel">
                {t(`hero.stages.${HeroStage[hero.stage]}`)}
              </span>
            </div>
          </div>

          {/* Hero SVG */}
          <div className="flex justify-center">
            <div className="cyber-border bg-cyber-dark/50 flex h-28 w-28 items-center justify-center overflow-hidden rounded md:h-32 md:w-32 lg:h-36 lg:w-36">
              <HeroSvg heroId={heroId} className="h-full w-full" />
            </div>
          </div>

          {/* Attributes Grid */}
          <div className="grid grid-cols-3 gap-2 sm:grid-cols-4 md:grid-cols-5 md:gap-3 lg:grid-cols-6 lg:gap-4">
            {Object.entries(hero.attributes)
              .filter(([, value]) => value !== undefined && value !== null)
              .map(([key, value]) => {
                const IconComponent = ATTRIBUTE_ICONS[key as keyof typeof ATTRIBUTE_ICONS];
                const attributeName = t(`hero.attributes.${key}`);
                const defaultValue = getClassDefaultAttribute(
                  hero.classId,
                  key as keyof typeof hero.attributes
                );
                const difference = getAttributeDifference(
                  hero.classId,
                  key as keyof typeof hero.attributes,
                  value as number
                );

                if (!IconComponent) return null;

                return (
                  <Popover key={key}>
                    <PopoverTrigger asChild>
                      <div className="cyber-border bg-cyber-dark/50 hover:bg-cyber-blue/10 group cursor-help rounded-lg p-2 text-center transition-colors md:p-3 lg:p-3">
                        <IconComponent
                          className={`${difference > 0 ? 'text-cyber-pink' : 'text-cyber-blue'} group-hover:text-cyber-pink mx-auto mb-1 h-4 w-4 transition-colors md:h-5 md:w-5 lg:h-5 lg:w-5`}
                        />
                        <div className="font-pixel text-cyber-green text-xs md:text-sm lg:text-sm">
                          {value}
                        </div>
                      </div>
                    </PopoverTrigger>
                    <PopoverContent className="bg-cyber-dark border-cyber-blue/30 shadow-cyber-blue/20 border p-3 text-xs shadow-lg">
                      <div className="space-y-2">
                        <div className="font-pixel text-cyber-pink text-sm">{attributeName}</div>
                        <div className="space-y-1">
                          <div className="flex justify-between">
                            <span className="text-cyber-blue/80">
                              {t('hero.attributes.comparison.current')}:
                            </span>
                            <span className="font-pixel text-cyber-green">{value}</span>
                          </div>
                          <div className="flex justify-between">
                            <span className="text-cyber-blue/80">
                              {t('hero.attributes.comparison.base')}:
                            </span>
                            <span className="font-pixel text-cyber-yellow">{defaultValue}</span>
                          </div>
                          {difference !== 0 && (
                            <div className="border-cyber-blue/20 flex justify-between border-t pt-1">
                              <span className="text-cyber-blue/80">
                                {t('hero.attributes.comparison.bonus')}:
                              </span>
                              <span
                                className={`font-pixel ${
                                  difference > 0 ? 'text-cyber-green' : 'text-cyber-red'
                                }`}
                              >
                                {difference > 0 ? '+' : ''}
                                {difference}
                              </span>
                            </div>
                          )}
                        </div>
                      </div>
                    </PopoverContent>
                  </Popover>
                );
              })}
          </div>

          {/* Forge Section */}
          <div className="border-cyber-blue/20 flex flex-col items-center justify-center gap-6 border-t pt-6 sm:flex-row md:gap-8 lg:gap-10">
            <div className="text-center">
              <div className="font-pixel text-cyber-green mb-2 text-sm md:text-base">
                {t('hero.display.forgeCount')}
              </div>
              <div className="font-pixel text-cyber-yellow neon-text text-xl md:text-2xl lg:text-3xl">
                {hero.totalForges}
              </div>
            </div>

            <Button
              variant="cyber"
              onClick={handleForge}
              className="font-pixel forge-button-pulse px-6 py-3 text-sm md:px-8 md:py-4 md:text-base lg:px-10"
              disabled={
                !forgeAvailable ||
                forging ||
                confirmingForge ||
                hero.stage !== HeroStage.Forging ||
                !!pendingRequestId ||
                isOracleModalOpen
              }
            >
              {forging || confirmingForge || isOracleModalOpen ? (
                <div className="flex items-center gap-2">
                  <Loader2 className="text-cyber-blue h-4 w-4 animate-spin" />
                  {forging ? t('hero.display.confirming') : t('hero.display.forging')}
                </div>
              ) : !forgeAvailable && dynamicTimeLeft > 0 ? (
                <div className="flex items-center gap-2">
                  <Clock className="h-4 w-4" />
                  {formatTimeLeft(dynamicTimeLeft)}
                </div>
              ) : hero.stage !== HeroStage.Forging ? (
                t('hero.display.forgeCompleted')
              ) : (
                t('hero.display.dailyForge')
              )}
            </Button>
          </div>

          {/* TBA Info */}
          <div className="border-cyber-blue/20 border-t pt-6 text-center">
            <div className="text-cyber-blue font-pixel mb-3 text-sm opacity-60 md:text-base">
              Token Bound Account
            </div>
            <div className="text-cyber-green bg-cyber-dark/50 border-cyber-blue/20 group relative mb-4 rounded-lg border p-3 font-mono text-xs break-all md:text-sm lg:text-base">
              <a
                href={getExplorerUrl(hero.tokenBoundAccount, 'address') || '#'}
                target="_blank"
                rel="noopener noreferrer"
                className="hover:text-cyber-pink flex cursor-pointer items-center justify-center gap-2 transition-colors"
                title={t('hero.display.viewOnExplorer')}
              >
                {hero.tokenBoundAccount}
                <ExternalLink className="mt-0.5 h-3 w-3 flex-shrink-0 opacity-0 transition-opacity group-hover:opacity-100" />
              </a>
            </div>
            <Button
              variant="cyber"
              size="sm"
              onClick={() => setIsTBAModalOpen(true)}
              className="gap-2 px-4 py-2 text-sm md:px-6 md:py-3 md:text-base"
            >
              <Package className="h-4 w-4 md:h-5 md:w-5" />
              {t('tba.viewAssets')}
            </Button>
          </div>
        </div>
      </Card>

      {/* Forge Oracle Modal */}
      <ForgeOracleModal
        isOpen={isOracleModalOpen}
        onClose={() => setIsOracleModalOpen(false)}
        heroId={heroId}
      />

      {/* TBA Assets Modal */}
      <TBAAssetsModal
        isOpen={isTBAModalOpen}
        onClose={() => setIsTBAModalOpen(false)}
        tbaAddress={hero.tokenBoundAccount}
        heroId={heroId}
        refetchHeroData={refetchHeroData}
      />
    </>
  );
}
