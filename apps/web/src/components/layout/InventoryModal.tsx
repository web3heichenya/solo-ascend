'use client';

import { useState, useEffect } from 'react';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { useAppStore } from '@/lib/store';
import { useTranslation } from 'react-i18next';
import { IconDiamond, IconSparkles } from '@tabler/icons-react';
import {
  useAccount,
  useReadContracts,
  useChainId,
  useWriteContract,
  useWaitForTransactionReceipt,
} from 'wagmi';
import { forgeItemNFTABI } from '@/lib/contracts/abis';
import { getContractAddress } from '@/lib/contracts/config';
import { ForgeItemCard } from '@/components/forge/ForgeItemCard';
import { Loader2, RefreshCw } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { fetchForgerNFTs } from '@/lib/services/alchemy';
import { InventoryItem } from '@/types/business';
import { TransferDialog } from './TransferDialog';
import { ForgeItemQuality } from '@/components/forge/ForgeItemCard';

export function InventoryModal() {
  const { t } = useTranslation();
  const { isInventoryOpen, setInventoryOpen, alchemyApiKey } = useAppStore();
  const { address } = useAccount();
  const chainId = useChainId();

  const [rainbowItems, setRainbowItems] = useState<InventoryItem[]>([]);
  const [mythicItems, setMythicItems] = useState<InventoryItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [selectedItem, setSelectedItem] = useState<InventoryItem | null>(null);
  const [isTransferDialogOpen, setIsTransferDialogOpen] = useState(false);

  // Read balances for rainbow and mythic items
  const { data: balancesData, refetch: refetchBalances } = useReadContracts({
    contracts: [
      {
        address: getContractAddress(chainId, 'rainbowForgeItemNFT'),
        abi: forgeItemNFTABI,
        functionName: 'balanceOf',
        args: address ? [address] : undefined,
      },
      {
        address: getContractAddress(chainId, 'mythicForgeItemNFT'),
        abi: forgeItemNFTABI,
        functionName: 'balanceOf',
        args: address ? [address] : undefined,
      },
    ],
    query: { enabled: !!address && isInventoryOpen },
  });

  // Write contract for direct transfer
  const { writeContract, data: txHash, isPending: isTransferring } = useWriteContract();

  // Wait for transaction
  const { isSuccess: transferSuccess } = useWaitForTransactionReceipt({
    hash: txHash,
  });

  // Handle successful transfer
  useEffect(() => {
    if (transferSuccess) {
      // Refetch balances and reload items
      refetchBalances();
      setLoading(true);
      setRainbowItems([]);
      setMythicItems([]);
    }
  }, [transferSuccess, refetchBalances]);

  // Extract individual balances
  const rainbowBalance = Number(balancesData?.[0]?.result || 0);
  const mythicBalance = Number(balancesData?.[1]?.result || 0);

  // Load items when modal opens
  useEffect(() => {
    if (!isInventoryOpen || !address) return;

    const loadItems = async () => {
      setLoading(true);

      const rainbowList: InventoryItem[] = [];
      const mythicList: InventoryItem[] = [];

      try {
        if (alchemyApiKey && address) {
          // Fetch rainbow forger NFTs
          const rainbowContract = getContractAddress(chainId, 'rainbowForgeItemNFT');
          if (rainbowContract) {
            const rainbowForgers = await fetchForgerNFTs(
              alchemyApiKey,
              address,
              rainbowContract,
              chainId
            );
            rainbowForgers.forEach((forger) => {
              rainbowList.push({
                tokenId: forger.tokenId,
                quality: 'rainbow',
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

          // Fetch mythic forger NFTs
          const mythicContract = getContractAddress(chainId, 'mythicForgeItemNFT');
          if (mythicContract) {
            const mythicForgers = await fetchForgerNFTs(
              alchemyApiKey,
              address,
              mythicContract,
              chainId
            );
            mythicForgers.forEach((forger) => {
              mythicList.push({
                tokenId: forger.tokenId,
                quality: 'mythic',
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
        // Fall back to empty lists when there's an error
      }

      setRainbowItems(rainbowList);
      setMythicItems(mythicList);
      setLoading(false);
    };

    loadItems();
  }, [isInventoryOpen, address, alchemyApiKey, chainId]);

  const handleRefresh = () => {
    refetchBalances();
    // Reload items
    setLoading(true);
    setRainbowItems([]);
    setMythicItems([]);
  };

  const handleTransfer = (item: InventoryItem) => {
    setSelectedItem(item);
    setIsTransferDialogOpen(true);
  };

  const handleDirectTransfer = (toAddress: string) => {
    if (!selectedItem || !address) return;

    const contractAddress = getContractAddress(
      chainId,
      selectedItem.quality === 'rainbow' ? 'rainbowForgeItemNFT' : 'mythicForgeItemNFT'
    );

    // Execute direct transfer from user wallet to recipient
    writeContract({
      address: contractAddress,
      abi: forgeItemNFTABI,
      functionName: 'safeTransferFrom',
      args: [address as `0x${string}`, toAddress as `0x${string}`, BigInt(selectedItem.tokenId)],
    });
  };

  return (
    <>
      <Dialog open={isInventoryOpen} onOpenChange={setInventoryOpen}>
        <DialogContent className="bg-cyber-dark border-cyber-blue flex max-h-[90vh] w-[95vw] max-w-4xl flex-col overflow-hidden rounded-lg border-2 shadow-[0_0_20px_rgba(0,255,255,0.3)] sm:max-h-[80vh] sm:w-full">
          <DialogHeader className="flex flex-row items-center justify-between">
            <div>
              <div className="flex flex-row items-center">
                <DialogTitle className="text-cyber-blue font-pixel neon-text text-lg font-medium">
                  {t('inventory.title')}
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
                {t('inventory.subtitle')}
              </DialogDescription>
            </div>
          </DialogHeader>

          <div className="flex flex-1 flex-col overflow-hidden py-6">
            <Tabs defaultValue="rainbow" className="flex min-h-0 flex-1 flex-col">
              <TabsList className="bg-cyber-darker/50 grid w-full flex-shrink-0 grid-cols-2 rounded-lg p-1">
                <TabsTrigger
                  value="rainbow"
                  className="data-[state=active]:bg-cyber-blue! data-[state=active]:text-cyber-dark! data-[state=active]:border-cyber-blue! rounded-md text-xs tracking-wider uppercase"
                >
                  <IconDiamond className="mr-1 h-3 w-3" />
                  {t('inventory.rainbow')} ({rainbowBalance})
                </TabsTrigger>
                <TabsTrigger
                  value="mythic"
                  className="data-[state=active]:bg-cyber-blue! data-[state=active]:text-cyber-dark! data-[state=active]:border-cyber-blue! rounded-md text-xs tracking-wider uppercase"
                >
                  <IconSparkles className="mr-1 h-3 w-3" />
                  {t('inventory.mythic')} ({mythicBalance})
                </TabsTrigger>
              </TabsList>

              <TabsContent value="rainbow" className="mt-6 min-h-0 flex-1 overflow-y-auto">
                <div className="space-y-4">
                  {loading ? (
                    <div className="flex items-center justify-center py-12">
                      <Loader2 className="text-cyber-blue h-8 w-8 animate-spin" />
                    </div>
                  ) : !alchemyApiKey ? (
                    <div className="py-12 text-center">
                      <IconDiamond className="mx-auto mb-3 h-12 w-12 text-gray-600" />
                      <p className="mb-2 text-gray-400">{t('inventory.needsApiKey')}</p>
                      <p className="text-sm text-gray-500">{t('inventory.configureApiKey')}</p>
                    </div>
                  ) : rainbowItems.length === 0 ? (
                    <div className="py-12 text-center">
                      <IconDiamond className="mx-auto mb-3 h-12 w-12 text-gray-600" />
                      <p className="text-gray-400">{t('inventory.noItems')}</p>
                    </div>
                  ) : (
                    <div className="grid grid-cols-1 gap-4 pb-6 md:grid-cols-2">
                      {rainbowItems.map((item) => (
                        <ForgeItemCard
                          key={item.tokenId}
                          quality={item.quality}
                          tokenId={item.tokenId}
                          name={item.name}
                          effectType={item.effectType}
                          attribute={item.attribute}
                          value={item.value}
                          createdAt={item.createdAt}
                          image={item.image}
                          onTransfer={() => handleTransfer(item)}
                          showTransferButton={true}
                        />
                      ))}
                    </div>
                  )}
                </div>
              </TabsContent>

              <TabsContent value="mythic" className="mt-6 min-h-0 flex-1 overflow-y-auto">
                <div className="space-y-4">
                  {loading ? (
                    <div className="flex items-center justify-center py-12">
                      <Loader2 className="text-cyber-blue h-8 w-8 animate-spin" />
                    </div>
                  ) : !alchemyApiKey ? (
                    <div className="py-12 text-center">
                      <IconSparkles className="mx-auto mb-3 h-12 w-12 text-gray-600" />
                      <p className="mb-2 text-gray-400">{t('inventory.needsApiKey')}</p>
                      <p className="text-sm text-gray-500">{t('inventory.configureApiKey')}</p>
                    </div>
                  ) : mythicItems.length === 0 ? (
                    <div className="py-12 text-center">
                      <IconSparkles className="mx-auto mb-3 h-12 w-12 text-gray-600" />
                      <p className="text-gray-400">{t('inventory.noItems')}</p>
                    </div>
                  ) : (
                    <div className="grid grid-cols-1 gap-4 pb-6 md:grid-cols-2">
                      {mythicItems.map((item) => (
                        <ForgeItemCard
                          key={item.tokenId}
                          quality={item.quality}
                          tokenId={item.tokenId}
                          name={item.name}
                          effectType={item.effectType}
                          attribute={item.attribute}
                          value={item.value}
                          createdAt={item.createdAt}
                          image={item.image}
                          onTransfer={() => handleTransfer(item)}
                          showTransferButton={true}
                        />
                      ))}
                    </div>
                  )}
                </div>
              </TabsContent>
            </Tabs>
          </div>

          <div className="border-cyber-blue/20 border-t py-4 text-center">
            <p className="text-cyber-blue/50 text-xs">{t('inventory.info')}</p>
          </div>
        </DialogContent>
      </Dialog>

      {/* Transfer Dialog */}
      {selectedItem && address && (
        <TransferDialog
          isOpen={isTransferDialogOpen}
          onClose={() => {
            setIsTransferDialogOpen(false);
            setSelectedItem(null);
          }}
          item={{
            tokenId: selectedItem.tokenId,
            quality: selectedItem.quality as ForgeItemQuality,
            name: selectedItem.name,
          }}
          fromAddress={address}
          onTransfer={handleDirectTransfer}
          isTransferring={isTransferring}
          transferSuccess={transferSuccess}
          noticeKey="transfer.directNotice"
        />
      )}
    </>
  );
}
