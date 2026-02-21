'use client';

import { useState } from 'react';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { useAppStore } from '@/lib/store';
import { Label } from '@/components/ui/label';
import { useTranslation } from 'react-i18next';

export function SettingsModal() {
  const { t } = useTranslation();
  const {
    isSettingsOpen,
    setSettingsOpen,
    alchemyApiKey,
    setAlchemyApiKey,
    customRpcUrl,
    setCustomRpcUrl,
  } = useAppStore();

  const [tempAlchemyKey, setTempAlchemyKey] = useState(alchemyApiKey || '');
  const [tempRpcUrl, setTempRpcUrl] = useState(customRpcUrl || '');

  const handleSave = () => {
    setAlchemyApiKey(tempAlchemyKey || null);
    setCustomRpcUrl(tempRpcUrl || null);
    setSettingsOpen(false);
  };

  const handleCancel = () => {
    setTempAlchemyKey(alchemyApiKey || '');
    setTempRpcUrl(customRpcUrl || '');
    setSettingsOpen(false);
  };

  return (
    <Dialog open={isSettingsOpen} onOpenChange={setSettingsOpen}>
      <DialogContent className="bg-cyber-dark border-cyber-blue w-[95vw] max-w-lg rounded-lg border-2 shadow-[0_0_20px_rgba(0,255,255,0.3)] sm:w-full">
        <DialogHeader>
          <DialogTitle className="text-cyber-blue text-lg font-medium">
            {t('settings.title')}
          </DialogTitle>
          <DialogDescription className="text-cyber-blue/70 text-sm">
            {t('settings.subtitle')}
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-8 py-6">
          <div className="space-y-2">
            <Label className="text-cyber-blue text-xs font-medium tracking-wider uppercase">
              {t('settings.alchemyKey')}
            </Label>
            <Input
              placeholder={t('settings.alchemyPlaceholder')}
              value={tempAlchemyKey}
              onChange={(e) => setTempAlchemyKey(e.target.value)}
              className="pixel-input"
              type="password"
            />
            <p className="text-cyber-blue/50 text-xs">{t('settings.alchemyInfo')}</p>
          </div>

          <div className="space-y-2">
            <Label className="text-cyber-blue text-xs font-medium tracking-wider uppercase">
              {t('settings.customRpc')}
            </Label>
            <Input
              placeholder={t('settings.customRpcPlaceholder')}
              value={tempRpcUrl}
              onChange={(e) => setTempRpcUrl(e.target.value)}
              className="pixel-input"
            />
            <p className="text-cyber-blue/50 text-xs">{t('settings.customRpcInfo')}</p>
          </div>
        </div>

        <DialogFooter className="flex w-full gap-4">
          <Button
            variant="outline"
            onClick={handleCancel}
            className="button-transition border-cyber-blue/30 text-cyber-blue hover:bg-cyber-blue/10 hover:border-cyber-blue flex-1 rounded-lg border-2 bg-transparent px-4 py-2 text-sm font-medium tracking-wider uppercase transition-all"
          >
            {t('ui.cancel')}
          </Button>
          <Button
            variant="cyber"
            onClick={handleSave}
            className="bg-cyber-blue button-transition text-cyber-dark hover:bg-cyber-blue/90 border-cyber-blue flex-1 rounded-lg border-2 px-4 py-2 text-sm font-medium tracking-wider uppercase transition-all"
          >
            {t('ui.save')}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
