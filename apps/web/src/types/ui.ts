import { ReactNode } from 'react';

// Common UI Props
export interface BaseComponentProps {
  className?: string;
}

// Layout and Container Props
export interface ProvidersProps {
  children: ReactNode;
}

export interface HeroDisplayProps {
  className?: string;
}

export interface HeroLoadingCardProps {
  className?: string;
}

export interface HeroMintCardProps {
  className?: string;
}

export interface HeroDetailsCardProps {
  heroId: number;
  hero: import('./hero').Hero;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  refetchHeroData: () => Promise<any>;
  className?: string;
}

// Particle system types
export interface Particle {
  x: number;
  y: number;
  vx: number;
  vy: number;
  size: number;
  alpha: number;
  color: string;
}

// Modal and Dialog Props
export interface ForgeOracleModalProps {
  isOpen: boolean;
  onClose: () => void;
  heroId: number;
}

export interface TBAAssetsModalProps {
  isOpen: boolean;
  onClose: () => void;
  tbaAddress: string;
  heroId: number;
  refetchHeroData?: () => void;
}

export interface TransferDialogProps {
  isOpen: boolean;
  onClose: () => void;
  onTransfer: (recipient: string, amount?: string) => void;
  transferType: 'eth' | 'item';
  itemName?: string;
  balance?: string;
  isTransferring?: boolean;
}

// Button and Form Props
export interface PendingForgeButtonProps {
  className?: string;
}

export interface ForgeItemCardProps {
  quality: 'silver' | 'gold' | 'rainbow' | 'mythic';
  tokenId: string;
  name?: string;
  effectType?: string;
  attribute?: string;
  value?: number;
  createdAt?: number;
  image?: string;
  attributes?: Record<string, number>; // Keep for backward compatibility
  onTransfer?: () => void;
  showTransferButton?: boolean;
  className?: string;
}

// Hero SVG Props
export interface HeroSvgProps {
  className?: string;
}
