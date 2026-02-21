'use client';

import Image from 'next/image';
import { useTranslation } from 'react-i18next';

import { Card } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Sparkles, Zap, Gem, Crown, Send } from 'lucide-react';

import type { ForgeItemQuality, ForgeItemCardProps } from '@/types';
export type { ForgeItemQuality };

const QUALITY_CONFIG = {
  silver: {
    icon: Zap,
    color: 'text-gray-400',
    bgColor: 'bg-gradient-to-br from-gray-900 to-gray-800',
    borderGlow: 'shadow-[0_0_20px_rgba(156,163,175,0.5)]',
    badge: 'bg-gray-700 text-gray-200',
  },
  gold: {
    icon: Sparkles,
    color: 'text-yellow-500',
    bgColor: 'bg-gradient-to-br from-yellow-900/50 to-amber-900/50',
    borderGlow: 'shadow-[0_0_30px_rgba(250,204,21,0.5)]',
    badge: 'bg-yellow-700 text-yellow-200',
  },
  rainbow: {
    icon: Gem,
    color: 'text-transparent bg-gradient-to-r from-red-500 via-yellow-500 to-blue-500 bg-clip-text',
    bgColor: 'bg-gradient-to-br from-red-900/30 via-yellow-900/30 to-blue-900/30',
    borderGlow: 'shadow-[0_0_40px_rgba(255,255,255,0.3)]',
    badge: 'bg-gradient-to-br from-red-600 via-yellow-600 to-blue-600 text-white',
  },
  mythic: {
    icon: Crown,
    color: 'text-purple-500',
    bgColor: 'bg-gradient-to-br from-purple-900/50 to-pink-900/50',
    borderGlow: 'shadow-[0_0_50px_rgba(168,85,247,0.5)]',
    badge: 'bg-purple-700 text-purple-200',
  },
};

export function ForgeItemCard({
  quality,
  tokenId,
  name,
  effectType,
  attribute,
  value,
  createdAt,
  image: _image, // TODO: Implement image display for forgers
  attributes,
  onTransfer,
  showTransferButton = false,
  className = '',
}: ForgeItemCardProps) {
  const { t } = useTranslation();
  const config = QUALITY_CONFIG[quality];
  const Icon = config.icon;

  return (
    <Card
      className={`cyber-border ${config.bgColor} ${config.borderGlow} relative overflow-hidden p-4 transition-all ${className} `}
    >
      {/* Quality Badge */}
      <Badge className={`absolute top-2 right-2 ${config.badge} font-pixel text-xs`}>
        {quality.toUpperCase()}
      </Badge>

      {/* Icon and Title */}
      <div className="mb-3 flex items-start gap-3">
        <div
          className={`cyber-border flex h-12 w-12 items-center justify-center rounded bg-black/30`}
        >
          {_image ? (
            <Image
              src={_image}
              alt=""
              width={48}
              height={48}
              unoptimized
              className="h-full w-full object-contain"
            />
          ) : (
            <Icon className={`h-6 w-6 ${config.color}`} />
          )}
        </div>
        <div className="flex-1">
          <h3 className="font-pixel text-cyber-blue text-sm">
            {name || t('forge.item.defaultName', { tokenId })}
          </h3>
          <p className="mt-1 text-xs text-gray-400">
            {t('forge.item.tokenId')}: {tokenId}
          </p>
        </div>
      </div>

      {/* Forger Details */}
      {(effectType ||
        attribute ||
        value !== undefined ||
        createdAt ||
        (attributes && Object.keys(attributes).length > 0)) && (
        <div className="mb-3 space-y-1">
          {/* Real forger data */}
          {effectType && (
            <div className="flex justify-between text-xs">
              <span className="text-gray-400">{t('forge.item.effect')}:</span>
              <span className="text-cyber-green">{effectType}</span>
            </div>
          )}
          {attribute && (
            <div className="flex justify-between text-xs">
              <span className="text-gray-400">{t('forge.item.attribute')}:</span>
              <span className="text-cyber-green">{attribute}</span>
            </div>
          )}
          {value !== undefined && (
            <div className="flex justify-between text-xs">
              <span className="text-gray-400">{t('forge.item.value')}:</span>
              <span className="text-cyber-green">+{value}</span>
            </div>
          )}
          {createdAt && (
            <div className="flex justify-between text-xs">
              <span className="text-gray-400">{t('forge.item.created')}:</span>
              <span className="text-gray-500">
                {new Date(createdAt * 1000).toLocaleDateString()}
              </span>
            </div>
          )}

          {/* Legacy attributes for backward compatibility */}
          {attributes && Object.keys(attributes).length > 0 && (
            <>
              {Object.entries(attributes).map(([key, value]) => (
                <div key={key} className="flex justify-between text-xs">
                  <span className="text-gray-400">{key}:</span>
                  <span className="text-cyber-green">+{value}</span>
                </div>
              ))}
            </>
          )}
        </div>
      )}

      {/* Transfer Button */}
      {showTransferButton && (quality === 'rainbow' || quality === 'mythic') && (
        <Button variant="cyber" size="sm" onClick={onTransfer} className="w-full gap-2">
          <Send className="h-3 w-3" />
          {t('transfer.transfer')}
        </Button>
      )}

      {/* Animated Background Effect */}
      <div
        className="pointer-events-none absolute inset-0 opacity-30"
        style={{
          background: `radial-gradient(circle at 50% 50%, ${
            quality === 'rainbow'
              ? 'rgba(255,255,255,0.1)'
              : quality === 'mythic'
                ? 'rgba(168,85,247,0.1)'
                : quality === 'gold'
                  ? 'rgba(250,204,21,0.1)'
                  : 'rgba(156,163,175,0.1)'
          } 0%, transparent 70%)`,
          animation: 'pulse 3s ease-in-out infinite',
        }}
      />
    </Card>
  );
}
