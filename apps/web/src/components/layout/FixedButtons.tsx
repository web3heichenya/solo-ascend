'use client';

import { Button } from '@/components/ui/button';
import { Settings, Package, Search } from 'lucide-react';
import { useAppStore } from '@/lib/store';
import { useTranslation } from 'react-i18next';
import { useAccount } from 'wagmi';
import { useHasMinted } from '@/hooks/useHeroContract';
import { PendingForgeButton } from './PendingForgeButton';

export function FixedButtons() {
  const { t } = useTranslation();
  const { address } = useAccount();
  const { setSettingsOpen, setInventoryOpen, setSearchOpen, currentHeroId } = useAppStore();
  const { hasMinted } = useHasMinted(address);

  return (
    <div className="fixed right-4 bottom-4 z-50 flex flex-col gap-2 md:right-6 md:bottom-6 md:gap-3">
      {/* Pending Forge Button - 只在有英雄时显示 */}
      {(hasMinted || currentHeroId) && <PendingForgeButton />}

      {/* Search Button - 只在有英雄时显示 */}
      {(hasMinted || currentHeroId) && (
        <Button
          variant="cyber"
          size="icon"
          onClick={() => setSearchOpen(true)}
          className="neon-text h-10 w-10 transition-transform hover:scale-110 md:h-12 md:w-12"
          title={t('hero.search.title')}
        >
          <Search className="h-4 w-4 md:h-5 md:w-5" />
        </Button>
      )}

      <Button
        variant="cyber"
        size="icon"
        onClick={() => setInventoryOpen(true)}
        className="neon-text h-10 w-10 transition-transform hover:scale-110 md:h-12 md:w-12"
        title={t('ui.inventory')}
      >
        <Package className="h-4 w-4 md:h-5 md:w-5" />
      </Button>

      <Button
        variant="cyber"
        size="icon"
        onClick={() => setSettingsOpen(true)}
        className="neon-text h-10 w-10 transition-transform hover:scale-110 md:h-12 md:w-12"
        title={t('ui.settings')}
      >
        <Settings className="h-4 w-4 md:h-5 md:w-5" />
      </Button>
    </div>
  );
}
