'use client';

import { useState, useEffect } from 'react';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { useReadContract, useChainId } from 'wagmi';
import { oracleRegistryABI } from '@/lib/contracts/abis';
import { getContractAddress, getOracles } from '@/lib/contracts/config';
import { Loader2, DollarSign, Shuffle, Settings, Info } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { formatEther } from 'viem';
import { useForgeManager } from '@/hooks/useForgeManager';
import { useAppStore } from '@/lib/store';
import * as Popover from '@radix-ui/react-popover';
import * as HoverCard from '@radix-ui/react-hover-card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';

import { Oracle, ForgeOracleModalProps } from '@/types';

const ORACLE_TYPE_CONFIG = {
  free: {
    icon: Shuffle,
    color: 'text-cyan-400',
    bgColor: 'bg-cyan-900/20',
    badgeColor: 'bg-cyan-900/30 text-cyan-300 border-cyan-600',
  },
  premium: {
    icon: DollarSign,
    color: 'text-yellow-500',
    bgColor: 'bg-yellow-900/20',
    badgeColor: 'bg-yellow-900/30 text-yellow-300 border-yellow-600',
  },
};

export function ForgeOracleModal({ isOpen, onClose, heroId }: ForgeOracleModalProps) {
  const { t } = useTranslation();
  const [oracles, setOracles] = useState<Oracle[]>([]);
  const [selectedOracle, setSelectedOracle] = useState<Oracle | null>(null);
  const { feeMultiplier, setFeeMultiplier } = useAppStore();
  const chainId = useChainId();

  // Use unified forge manager
  const { forgeState, executeForge } = useForgeManager();
  const { isForging, isConfirming } = forgeState;

  // Read oracle fee from contract for premium oracles
  const { data: oracleFee } = useReadContract({
    address: getContractAddress(chainId, 'oracleRegistry'),
    abi: oracleRegistryABI,
    functionName: 'calculateFee',
    args:
      selectedOracle && selectedOracle.type === 'premium'
        ? [BigInt(selectedOracle.id), selectedOracle.gasLimit || 300_000]
        : undefined,
    query: {
      enabled: !!selectedOracle && selectedOracle.type === 'premium',
    },
  });

  // Load oracle data
  useEffect(() => {
    const loadOracles = async () => {
      const oracles = getOracles(chainId);

      setOracles(oracles as Oracle[]);
    };

    loadOracles();
  }, [chainId]);

  // Success handling is now done in parent component (HeroDetailsCard)

  const handleForge = () => {
    if (!selectedOracle) return;

    // Use the calculated fee from contract for premium oracles, 0 for free oracles
    const feeValue =
      selectedOracle.type === 'premium' && oracleFee
        ? BigInt(Math.ceil(Number(oracleFee) * feeMultiplier))
        : BigInt(0);

    // Call the forge function from the unified forge manager
    executeForge(heroId, selectedOracle.id, selectedOracle.gasLimit || 500_000, feeValue);
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="bg-cyber-dark border-cyber-blue w-[95vw] max-w-2xl rounded-lg border-2 shadow-[0_0_20px_rgba(0,255,255,0.3)] sm:w-full">
        <DialogHeader>
          <DialogTitle className="text-cyber-blue font-pixel neon-text text-lg font-medium">
            {t('forge.oracle.selectOracle')}
          </DialogTitle>
          <DialogDescription className="text-cyber-blue/70 text-sm">
            {t('forge.oracle.description')}
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-6 py-4">
          {/* Oracle List */}
          <div className="grid gap-3">
            {oracles.map((oracle) => {
              const config = ORACLE_TYPE_CONFIG[oracle.type];
              const Icon = config.icon;
              const isSelected = selectedOracle?.id === oracle.id;

              return (
                <Card
                  key={oracle.id}
                  className={`${config.bgColor} cursor-pointer border p-4 transition-all hover:scale-[1.02] ${
                    isSelected
                      ? 'border-cyber-pink border-2 shadow-[0_0_10px_rgba(255,0,255,0.3)]'
                      : 'border-cyber-blue/30 hover:border-cyber-blue/50'
                  }`}
                  onClick={() => setSelectedOracle(oracle)}
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <Icon className={`h-6 w-6 ${config.color}`} />
                      <div className="flex-1">
                        <h3 className="font-pixel text-cyber-blue text-sm">{oracle.name}</h3>
                        <p className="mt-1 text-xs text-gray-400">
                          {oracle.address.slice(0, 6)}...
                          {oracle.address.slice(-4)}
                        </p>
                        {oracle.type === 'premium' && (
                          <p className="mt-1 text-xs text-yellow-400">Premium Oracle</p>
                        )}
                      </div>
                    </div>
                    <Badge variant="outline" className={`${config.badgeColor} font-pixel text-xs`}>
                      {oracle.type.toUpperCase()}
                    </Badge>
                  </div>
                </Card>
              );
            })}
          </div>

          {/* Oracle Details */}
          {selectedOracle && (
            <div className="bg-cyber-darker border-cyber-blue/30 space-y-2 rounded-lg border p-4">
              <h4 className="font-pixel text-cyber-pink text-sm">
                {t('forge.oracle.selectedDetails')}
              </h4>
              <p className="text-cyber-blue text-xs">{selectedOracle.description}</p>
              <div>
                <p className="text-cyber-green mb-1 text-xs font-semibold">
                  {t('forge.oracle.expectedQuality')}:
                </p>
                <div className="grid grid-cols-2 gap-1">
                  {selectedOracle.qualityRanges.map((range, idx) => (
                    <p key={idx} className="text-xs text-gray-300">
                      {range}
                    </p>
                  ))}
                </div>
              </div>
              {selectedOracle.type === 'premium' && oracleFee && (
                <div className="flex items-center gap-2">
                  <p className="font-pixel text-sm text-yellow-400">
                    {t('forge.oracle.cost')}:{' '}
                    {formatEther(BigInt(Math.ceil(Number(oracleFee) * feeMultiplier)))} ETH
                  </p>
                  <Popover.Root>
                    <Popover.Trigger asChild>
                      <Button
                        variant="ghost"
                        size="sm"
                        className="hover:bg-cyber-blue/10 h-6 w-6 p-0"
                      >
                        <Settings className="text-cyber-blue h-4 w-4" />
                      </Button>
                    </Popover.Trigger>
                    <Popover.Portal>
                      <Popover.Content
                        side="top"
                        className="border-cyber-blue/30 bg-cyber-dark z-[10000] w-64 rounded-md border p-3 shadow-[0_0_20px_rgba(0,255,255,0.3)]"
                        sideOffset={5}
                      >
                        <div className="space-y-2">
                          <div className="flex items-center gap-1">
                            <Label
                              htmlFor="fee-multiplier"
                              className="text-cyber-blue text-xs font-medium"
                            >
                              {t('forge.oracle.feeMultiplier')}
                            </Label>
                            <HoverCard.Root>
                              <HoverCard.Trigger asChild>
                                <Info className="text-cyber-blue/70 h-3 w-3 cursor-help" />
                              </HoverCard.Trigger>
                              <HoverCard.Portal>
                                <HoverCard.Content
                                  className="border-cyber-blue/30 bg-cyber-dark z-[10001] w-64 rounded-md border p-3 shadow-[0_0_20px_rgba(0,255,255,0.3)]"
                                  sideOffset={5}
                                >
                                  <p className="text-cyber-blue/90 text-xs">
                                    {t('forge.oracle.feeMultiplierTooltip')}
                                  </p>
                                  <HoverCard.Arrow className="fill-cyber-blue/30" />
                                </HoverCard.Content>
                              </HoverCard.Portal>
                            </HoverCard.Root>
                          </div>
                          <Input
                            id="fee-multiplier"
                            type="number"
                            min="1"
                            step="0.1"
                            value={feeMultiplier}
                            onChange={(e) => {
                              const value = parseFloat(e.target.value);
                              if (!isNaN(value) && value >= 1) {
                                setFeeMultiplier(value);
                              }
                            }}
                            className="border-cyber-blue/30 bg-cyber-darker text-cyber-blue w-full"
                          />
                        </div>
                      </Popover.Content>
                    </Popover.Portal>
                  </Popover.Root>
                </div>
              )}
            </div>
          )}
        </div>

        <DialogFooter className="flex w-full gap-4">
          <Button
            variant="outline"
            onClick={onClose}
            disabled={isForging || isConfirming}
            className="button-transition border-cyber-blue/30 text-cyber-blue hover:bg-cyber-blue/10 hover:border-cyber-blue font-pixel flex-1 rounded-lg border-2 bg-transparent px-4 py-2 text-sm tracking-wider uppercase transition-all"
          >
            {t('common.cancel')}
          </Button>
          <Button
            variant="cyber"
            onClick={handleForge}
            disabled={!selectedOracle || isForging || isConfirming}
            className="bg-cyber-blue button-transition text-cyber-dark hover:bg-cyber-blue/90 font-pixel border-cyber-blue flex-1 rounded-lg border-2 px-4 py-2 text-sm tracking-wider uppercase transition-all"
          >
            {isForging || isConfirming ? (
              <>
                <Loader2 className="text-cyber-blue mr-2 h-4 w-4 animate-spin" />
                {t('forge.oracle.forging')}
              </>
            ) : (
              t('forge.oracle.startForge')
            )}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
