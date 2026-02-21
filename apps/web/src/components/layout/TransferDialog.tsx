'use client';

import { useState } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { isAddress } from 'viem';
import { Loader2, Send, AlertCircle } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { showToast } from '@/lib/toast';
import { ForgeItemQuality } from '@/components/forge/ForgeItemCard';
import { IconInfoCircle } from '@tabler/icons-react';

interface TransferDialogProps {
  isOpen: boolean;
  onClose: () => void;
  item: {
    tokenId: string;
    quality: ForgeItemQuality;
    name?: string;
  };
  fromAddress: string;
  onTransfer: (toAddress: string) => void;
  isTransferring: boolean;
  transferSuccess: boolean;
  noticeKey?: string; // i18n key for the notice message
}

export function TransferDialog({
  isOpen,
  onClose,
  item,
  fromAddress,
  onTransfer,
  isTransferring,
  transferSuccess,
  noticeKey = 'transfer.directNotice', // Default notice
}: TransferDialogProps) {
  const { t } = useTranslation();
  const [toAddress, setToAddress] = useState('');
  const [error, setError] = useState('');

  const handleTransfer = () => {
    // Validate address
    if (!isAddress(toAddress)) {
      setError(t('transfer.invalidAddress'));
      return;
    }

    // Clear error
    setError('');

    // Call the provided transfer function
    onTransfer(toAddress);
  };

  // Handle successful transfer
  if (transferSuccess) {
    showToast.success(t('transfer.success'), t('transfer.successDesc', { tokenId: item.tokenId }));
    onClose();
  }

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="cyber-border bg-cyber-dark max-w-md">
        <DialogHeader>
          <DialogTitle className="font-pixel text-cyber-pink neon-text">
            {t('transfer.title')}
          </DialogTitle>
        </DialogHeader>

        <div className="space-y-4">
          {/* Item Info */}
          <div className="">
            <p className="text-cyber-blue font-pixel text-sm">
              {item.name || `${item.quality.toUpperCase()} Item #${item.tokenId}`}
            </p>
          </div>

          {/* From Address (User Wallet) */}
          <div className="space-y-2">
            <Label className="text-xs text-gray-400">{t('transfer.from')}</Label>
            <div className="cyber-border rounded bg-black/30 p-2">
              <p className="text-cyber-green font-mono text-xs break-all">{fromAddress}</p>
            </div>
          </div>

          {/* To Address Input */}
          <div className="space-y-2">
            <Label htmlFor="to-address" className="text-xs text-gray-400">
              {t('transfer.to')}
            </Label>
            <Input
              id="to-address"
              placeholder="0x..."
              value={toAddress}
              onChange={(e) => {
                setToAddress(e.target.value);
                setError('');
              }}
              className="pixel-input font-mono"
            />
            {error && (
              <div className="flex items-center gap-2 text-xs text-red-400">
                <AlertCircle className="h-3 w-3" />
                {error}
              </div>
            )}
          </div>

          {/* Notice about transfer */}
          {noticeKey && (
            <div className="flex items-center gap-1 text-xs text-yellow-400">
              <IconInfoCircle size="15px" />
              <p>{t(noticeKey)}</p>
            </div>
          )}

          {/* Action Buttons */}
          <div className="flex w-full gap-4">
            <Button
              variant="outline"
              onClick={onClose}
              disabled={isTransferring}
              className="button-transition border-cyber-blue/30 text-cyber-blue hover:bg-cyber-blue/10 hover:border-cyber-blue flex-1 rounded-lg border-2 bg-transparent px-4 py-2 text-sm font-medium tracking-wider uppercase transition-all"
            >
              {t('common.cancel')}
            </Button>
            <Button
              variant="cyber"
              onClick={handleTransfer}
              disabled={!toAddress || isTransferring}
              className="bg-cyber-blue button-transition text-cyber-dark hover:bg-cyber-blue/90 border-cyber-blue flex-1 gap-2 rounded-lg border-2 px-4 py-2 text-sm font-medium tracking-wider uppercase transition-all"
            >
              {isTransferring ? (
                <>
                  <Loader2 className="text-cyber-blue h-4 w-4 animate-spin" />
                  {t('transfer.transferring')}
                </>
              ) : (
                <>
                  <Send className="h-4 w-4" />
                  {t('transfer.transfer')}
                </>
              )}
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
