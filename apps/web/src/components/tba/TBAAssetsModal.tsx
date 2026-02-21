'use client';

import { useState, useEffect, useMemo } from 'react';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { useReadContracts, useChainId } from 'wagmi';
import { forgeItemNFTABI } from '@/lib/contracts/abis';
import { getContractAddress } from '@/lib/contracts/config';
import { ForgeItemCard, ForgeItemQuality } from '@/components/forge/ForgeItemCard';
import { TransferDialog } from '@/components/layout/TransferDialog';
import { useWriteContract, useWaitForTransactionReceipt } from 'wagmi';
import { encodeFunctionData } from 'viem';
import { erc6551ExecutableABI } from '@/lib/contracts/abis';
import { Loader2, Package, RefreshCw, ExternalLink } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { useChainConfig } from '@/hooks/useChainConfig';
import { useAppStore } from '@/lib/store';
import { fetchForgerNFTs } from '@/lib/services/alchemy';

import { TBAAssetsModalProps, ForgeItem } from '@/types';

export function TBAAssetsModal({
  isOpen,
  onClose,
  tbaAddress,
  refetchHeroData,
}: TBAAssetsModalProps) {
  const { t } = useTranslation();
  const { getExplorerUrl } = useChainConfig();
  const [items, setItems] = useState<ForgeItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedItem, setSelectedItem] = useState<ForgeItem | null>(null);
  const [isTransferDialogOpen, setIsTransferDialogOpen] = useState(false);
  const [activeTab, setActiveTab] = useState<ForgeItemQuality>('silver');
  const { alchemyApiKey } = useAppStore();
  const chainId = useChainId();

  // Contract addresses for each quality
  const qualityContracts = useMemo(
    () => ({
      silver: getContractAddress(chainId, 'silverForgeItemNFT'),
      gold: getContractAddress(chainId, 'goldForgeItemNFT'),
      rainbow: getContractAddress(chainId, 'rainbowForgeItemNFT'),
      mythic: getContractAddress(chainId, 'mythicForgeItemNFT'),
    }),
    [chainId]
  );

  // Read balances for all qualities at once
  const { data: balancesData, refetch: refetchBalances } = useReadContracts({
    contracts: [
      {
        address: qualityContracts.silver,
        abi: forgeItemNFTABI,
        functionName: 'balanceOf',
        args: [tbaAddress as `0x${string}`],
      },
      {
        address: qualityContracts.gold,
        abi: forgeItemNFTABI,
        functionName: 'balanceOf',
        args: [tbaAddress as `0x${string}`],
      },
      {
        address: qualityContracts.rainbow,
        abi: forgeItemNFTABI,
        functionName: 'balanceOf',
        args: [tbaAddress as `0x${string}`],
      },
      {
        address: qualityContracts.mythic,
        abi: forgeItemNFTABI,
        functionName: 'balanceOf',
        args: [tbaAddress as `0x${string}`],
      },
    ],
    query: { enabled: isOpen },
  });

  // Write contract for TBA transfer
  const { writeContract, data: txHash, isPending: isTransferring } = useWriteContract();

  // Wait for transaction
  const { isSuccess: transferSuccess } = useWaitForTransactionReceipt({
    hash: txHash,
  });

  // Handle successful transfer
  useEffect(() => {
    if (transferSuccess) {
      // Refetch balances and hero data after successful transfer
      refetchBalances();
      refetchHeroData?.();
      // Reload items for current tab
      setItems([]);
      setLoading(true);
    }
  }, [transferSuccess, refetchBalances, refetchHeroData]);

  // Extract individual balances from the results
  const silverBalance = balancesData?.[0]?.result;
  const goldBalance = balancesData?.[1]?.result;
  const rainbowBalance = balancesData?.[2]?.result;
  const mythicBalance = balancesData?.[3]?.result;

  // Load items for active tab
  useEffect(() => {
    if (!isOpen) return;

    const loadItems = async () => {
      setLoading(true);
      const itemsList: ForgeItem[] = [];

      try {
        if (alchemyApiKey && tbaAddress) {
          // Use Alchemy API to fetch detailed NFT data
          const contractAddress = qualityContracts[activeTab];
          if (contractAddress) {
            const forgerData = await fetchForgerNFTs(
              alchemyApiKey,
              tbaAddress,
              contractAddress,
              chainId
            );

            // Convert forger data to ForgeItem format
            forgerData.forEach((forger) => {
              itemsList.push({
                tokenId: forger.tokenId,
                quality: activeTab,
                name: forger.name,
                effectType: forger.effectType,
                attribute: forger.attribute,
                value: forger.value,
                createdAt: forger.createdAt,
                image: forger.image,
                hasRealData: true,
              });
            });
          }
        }
      } catch (error) {
        console.error('Error fetching NFT data from Alchemy:', error);
        // Fall back to empty list when there's an error
      }

      setItems(itemsList);
      setLoading(false);
    };

    loadItems();
  }, [isOpen, activeTab, alchemyApiKey, tbaAddress, chainId, qualityContracts]);

  const handleTransfer = (item: ForgeItem) => {
    setSelectedItem(item);
    setIsTransferDialogOpen(true);
  };

  const handleRefresh = () => {
    // Trigger reload
    setItems([]);
    setLoading(true);
    refetchBalances();
  };

  const handleTBATransfer = (toAddress: string) => {
    if (!selectedItem) return;

    const contractAddress = qualityContracts[selectedItem.quality];

    // Encode the NFT transfer call data
    const transferCalldata = encodeFunctionData({
      abi: forgeItemNFTABI,
      functionName: 'safeTransferFrom',
      args: [tbaAddress as `0x${string}`, toAddress as `0x${string}`, BigInt(selectedItem.tokenId)],
    });

    // Execute transfer through TBA's execute function
    writeContract({
      address: tbaAddress as `0x${string}`, // TBA address
      abi: erc6551ExecutableABI,
      functionName: 'execute',
      args: [
        contractAddress as `0x${string}`, // NFT contract address
        BigInt(0), // value (0 for ERC721 transfer)
        transferCalldata, // encoded transfer function call
        0, // operation type: CALL
      ],
    });
  };

  const balances = {
    silver: Number(silverBalance || 0),
    gold: Number(goldBalance || 0),
    rainbow: Number(rainbowBalance || 0),
    mythic: Number(mythicBalance || 0),
  };

  return (
    <>
      <Dialog open={isOpen} onOpenChange={onClose}>
        <DialogContent className="bg-cyber-dark border-cyber-blue flex max-h-[90vh] w-[95vw] max-w-4xl flex-col overflow-hidden rounded-lg border-2 shadow-[0_0_20px_rgba(0,255,255,0.3)] sm:max-h-[80vh] sm:w-full">
          <DialogHeader className="flex flex-row items-center justify-between">
            <div>
              <div className="flex flex-row items-center">
                <DialogTitle className="text-cyber-blue font-pixel neon-text text-lg font-medium">
                  {t('tba.assets.title')}
                </DialogTitle>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={handleRefresh}
                  className="hover:text-cyber-blue gap-1 text-gray-400 hover:bg-transparent"
                >
                  <RefreshCw className="h-4 w-4" />
                  {t('common.refresh')}
                </Button>
              </div>

              <DialogDescription className="text-cyber-blue/70 text-sm">
                {t('tba.assets.subtitle')}
              </DialogDescription>
            </div>
          </DialogHeader>

          <div className="flex flex-1 flex-col overflow-hidden py-6">
            {/* TBA Address */}
            <div className="mb-6 flex-shrink-0 space-y-2">
              <p className="text-cyber-blue text-xs font-medium tracking-wider uppercase">
                {t('tba.assets.address')}
              </p>
              <div className="bg-cyber-darker border-cyber-blue/30 group rounded-lg border p-3">
                <a
                  href={getExplorerUrl(tbaAddress, 'address') || '#'}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-cyber-green hover:text-cyber-pink flex cursor-pointer items-center gap-2 font-mono text-xs break-all transition-colors"
                  title={t('hero.display.viewOnExplorer')}
                >
                  {tbaAddress}
                  <ExternalLink className="mt-0.5 h-3 w-3 flex-shrink-0 opacity-0 transition-opacity group-hover:opacity-100" />
                </a>
              </div>
            </div>

            {/* Tabs for different qualities */}
            <Tabs
              value={activeTab}
              onValueChange={(v) => setActiveTab(v as ForgeItemQuality)}
              className="flex min-h-0 flex-1 flex-col"
            >
              <TabsList className="bg-cyber-darker/50 grid w-full flex-shrink-0 grid-cols-4 rounded-lg p-1">
                <TabsTrigger
                  value="silver"
                  className="data-[state=active]:bg-cyber-blue! data-[state=active]:text-cyber-dark! data-[state=active]:border-cyber-blue! rounded-md text-xs tracking-wider uppercase"
                >
                  Silver ({balances.silver})
                </TabsTrigger>
                <TabsTrigger
                  value="gold"
                  className="data-[state=active]:bg-cyber-blue! data-[state=active]:text-cyber-dark! data-[state=active]:border-cyber-blue! rounded-md text-xs tracking-wider uppercase"
                >
                  Gold ({balances.gold})
                </TabsTrigger>
                <TabsTrigger
                  value="rainbow"
                  className="data-[state=active]:bg-cyber-blue! data-[state=active]:text-cyber-dark! data-[state=active]:border-cyber-blue! rounded-md text-xs tracking-wider uppercase"
                >
                  Rainbow ({balances.rainbow})
                </TabsTrigger>
                <TabsTrigger
                  value="mythic"
                  className="data-[state=active]:bg-cyber-blue! data-[state=active]:text-cyber-dark! data-[state=active]:border-cyber-blue! rounded-md text-xs tracking-wider uppercase"
                >
                  Mythic ({balances.mythic})
                </TabsTrigger>
              </TabsList>

              <TabsContent value={activeTab} className="mt-6 min-h-0 flex-1 overflow-y-auto">
                {loading ? (
                  <div className="flex items-center justify-center py-12">
                    <Loader2 className="text-cyber-blue h-8 w-8 animate-spin" />
                  </div>
                ) : !alchemyApiKey ? (
                  <div className="py-12 text-center">
                    <Package className="mx-auto mb-3 h-12 w-12 text-gray-600" />
                    <p className="mb-2 text-gray-400">{t('tba.assets.needsApiKey')}</p>
                    <p className="text-sm text-gray-500">{t('tba.assets.configureApiKey')}</p>
                  </div>
                ) : items.length === 0 ? (
                  <div className="py-12 text-center">
                    <Package className="mx-auto mb-3 h-12 w-12 text-gray-600" />
                    <p className="text-gray-400">{t('tba.assets.noItems')}</p>
                  </div>
                ) : (
                  <div className="grid grid-cols-1 gap-4 pb-3 md:grid-cols-2">
                    {items.map((item) => (
                      <ForgeItemCard
                        key={`${item.quality}-${item.tokenId}`}
                        quality={item.quality}
                        tokenId={item.tokenId}
                        name={item.name}
                        effectType={item.effectType}
                        attribute={item.attribute}
                        value={item.value}
                        createdAt={item.createdAt}
                        image={item.image}
                        onTransfer={() => handleTransfer(item)}
                        showTransferButton={item.quality === 'rainbow'}
                      />
                    ))}
                  </div>
                )}
              </TabsContent>
            </Tabs>
          </div>

          {/* Alchemy API Notice */}
          {!alchemyApiKey && (
            <div className="border-cyber-blue/20 border-t py-4 text-center">
              <p className="text-xs text-yellow-400">{t('tba.assets.alchemyNotice')}</p>
            </div>
          )}
        </DialogContent>
      </Dialog>

      {/* Transfer Dialog */}
      {selectedItem && (
        <TransferDialog
          isOpen={isTransferDialogOpen}
          onClose={() => {
            setIsTransferDialogOpen(false);
            setSelectedItem(null);
          }}
          item={selectedItem}
          fromAddress={tbaAddress}
          onTransfer={handleTBATransfer}
          isTransferring={isTransferring}
          transferSuccess={transferSuccess}
          noticeKey="transfer.tbaNotice"
        />
      )}
    </>
  );
}
