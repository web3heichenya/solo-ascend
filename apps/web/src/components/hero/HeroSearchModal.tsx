'use client';

import { useState } from 'react';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { useTranslation } from 'react-i18next';
import { useAppStore } from '@/lib/store';

export function HeroSearchModal() {
  const { t } = useTranslation();
  const { isSearchOpen, setSearchOpen, setCurrentHeroId, setUserHeroId } = useAppStore();
  const [heroIdInput, setHeroIdInput] = useState('');

  const handleSearch = () => {
    const heroId = parseInt(heroIdInput);
    if (!isNaN(heroId) && heroId > 0) {
      setCurrentHeroId(heroId);
      setHeroIdInput('');
      setSearchOpen(false);
    }
  };

  const handleClearRecord = () => {
    // 清除所有英雄记录，回到mint状态
    setCurrentHeroId(null);
    setUserHeroId(null);
    setHeroIdInput('');
    setSearchOpen(false);
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      handleSearch();
    }
  };

  return (
    <Dialog open={isSearchOpen} onOpenChange={setSearchOpen}>
      <DialogContent className="bg-cyber-dark border-cyber-blue w-[95vw] max-w-md rounded-lg border-2 shadow-[0_0_20px_rgba(0,255,255,0.3)] sm:w-full">
        <DialogHeader>
          <DialogTitle className="text-cyber-blue font-pixel neon-text text-center text-lg font-medium">
            {t('hero.search.title')}
          </DialogTitle>
          <DialogDescription className="text-cyber-blue/70 text-center text-sm">
            {t('hero.search.description')}
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-6 py-4">
          {/* 搜索输入框 */}
          <div className="space-y-2">
            <Input
              placeholder={t('hero.search.placeholder')}
              value={heroIdInput}
              onChange={(e) => setHeroIdInput(e.target.value)}
              onKeyDown={handleKeyDown}
              className="pixel-input text-center"
              type="number"
              min="1"
            />
          </div>

          {/* 按钮组 */}
          <div className="flex gap-3">
            <Button
              variant="outline"
              onClick={handleClearRecord}
              className="font-pixel border-cyber-pink text-cyber-pink hover:bg-cyber-pink hover:text-cyber-dark flex-1 text-xs"
            >
              {t('hero.search.clearRecord')}
            </Button>
            <Button
              variant="cyber"
              onClick={handleSearch}
              disabled={!heroIdInput || isNaN(parseInt(heroIdInput)) || parseInt(heroIdInput) <= 0}
              className="font-pixel flex-1 text-xs"
            >
              {t('hero.search.confirm')}
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
