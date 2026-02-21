'use client';

import { useState, useEffect } from 'react';
import { useReadContract, useChainId } from 'wagmi';
import { soloAscendHeroABI } from '@/lib/contracts/abis';
import { getContractAddress } from '@/lib/contracts/config';
import { Loader2, RefreshCw } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useTranslation } from 'react-i18next';

interface HeroSvgProps {
  heroId: number;
  className?: string;
}

export function HeroSvg({ heroId, className = '' }: HeroSvgProps) {
  const { t } = useTranslation();
  const [svgContent, setSvgContent] = useState<string | null>(null);
  const [, setRetryCount] = useState(0);
  const [fallbackToTokenURI, setFallbackToTokenURI] = useState(false);
  const chainId = useChainId();

  // For now, skip SVG renderer and go directly to tokenURI
  // In production, you would need to call generateSVG with the full hero struct
  const rendererSvg = null;
  const rendererLoading = false;
  const rendererError = true; // Force fallback to tokenURI

  // Fallback to tokenURI if renderer fails
  const { data: tokenURI, isLoading: tokenURILoading } = useReadContract({
    address: getContractAddress(chainId, 'heroContract'),
    abi: soloAscendHeroABI,
    functionName: 'tokenURI',
    args: [BigInt(heroId)],
    query: {
      enabled: heroId > 0 && fallbackToTokenURI,
      retry: 1,
    },
  });

  // Process SVG data from renderer or tokenURI
  useEffect(() => {
    if (rendererSvg) {
      setSvgContent(rendererSvg as string);
    } else if (tokenURI) {
      // Parse tokenURI for SVG content
      const uriString = tokenURI as string;
      if (uriString.startsWith('data:application/json;base64,')) {
        try {
          // Decode base64 and clean up potential JSON formatting issues
          let jsonString = atob(uriString.slice(29));

          // Remove potential trailing commas that cause JSON parse errors
          jsonString = jsonString.replace(/,(\s*[}\]])/g, '$1');

          // Clean up potential double commas
          jsonString = jsonString.replace(/,,+/g, ',');

          const json = JSON.parse(jsonString);
          if (json.image) {
            if (json.image.startsWith('data:image/svg+xml;base64,')) {
              setSvgContent(atob(json.image.slice(26)));
            } else if (json.image.startsWith('data:image/svg+xml,')) {
              setSvgContent(decodeURIComponent(json.image.slice(19)));
            }
          }
        } catch (e) {
          console.error('Failed to parse tokenURI:', e);
          // Log the raw string for debugging
          try {
            const rawJson = atob(uriString.slice(29));
            console.error('Raw JSON string:', rawJson.substring(0, 200) + '...');
          } catch (decodeError) {
            console.error('Failed to decode base64:', decodeError);
          }
        }
      }
    }
  }, [rendererSvg, tokenURI]);

  // Handle renderer error by falling back to tokenURI
  useEffect(() => {
    if (rendererError && !fallbackToTokenURI) {
      setFallbackToTokenURI(true);
    }
  }, [rendererError, fallbackToTokenURI]);

  const handleRetry = () => {
    setRetryCount((prev) => prev + 1);
    setSvgContent(null);
    setFallbackToTokenURI(false);
    // Force refetch by triggering a new contract call
    window.location.reload();
  };

  const isLoading = rendererLoading || (fallbackToTokenURI && tokenURILoading);

  if (isLoading) {
    return (
      <div className={`flex items-center justify-center ${className}`}>
        <div className="text-center">
          <Loader2 className="text-cyber-blue mx-auto mb-2 h-8 w-8 animate-spin" />
          <div className="font-pixel text-cyber-blue text-xs opacity-60">
            {t('hero.svg.loading')}
          </div>
        </div>
      </div>
    );
  }

  if (!svgContent) {
    return (
      <div className={`flex flex-col items-center justify-center gap-4 ${className}`}>
        <div className="text-center">
          <div className="mb-2 text-4xl opacity-60">⚔️</div>
          <div className="font-pixel text-cyber-red mb-4 text-xs">{t('hero.svg.failed')}</div>
        </div>
        <Button variant="cyber" size="sm" onClick={handleRetry} className="gap-2">
          <RefreshCw className="h-4 w-4" />
          {t('hero.svg.retry')}
        </Button>
      </div>
    );
  }

  return (
    <div
      className={`hero-svg-container ${className}`}
      dangerouslySetInnerHTML={{ __html: svgContent }}
      style={{
        animation: 'pixelFadeIn 0.5s ease-out',
      }}
    />
  );
}
