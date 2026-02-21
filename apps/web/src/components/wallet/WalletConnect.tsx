'use client';

import { ConnectButton } from '@rainbow-me/rainbowkit';
import { Button } from '@/components/ui/button';
import Image from 'next/image';
import { useTranslation } from 'react-i18next';
import { IconWallet, IconLink, IconUser } from '@tabler/icons-react';

export function WalletConnect() {
  const { t } = useTranslation();
  return (
    <ConnectButton.Custom>
      {({
        account,
        chain,
        openAccountModal,
        openChainModal,
        openConnectModal,
        authenticationStatus,
        mounted,
      }) => {
        const ready = mounted && authenticationStatus !== 'loading';
        const connected =
          ready &&
          account &&
          chain &&
          (!authenticationStatus || authenticationStatus === 'authenticated');

        return (
          <div
            {...(!ready && {
              'aria-hidden': true,
              style: {
                opacity: 0,
                pointerEvents: 'none',
                userSelect: 'none',
              },
            })}
          >
            {(() => {
              if (!connected) {
                return (
                  <>
                    <Button
                      onClick={openConnectModal}
                      variant="cyber"
                      className="font-pixel hidden sm:block"
                    >
                      {t('wallet.connect')}
                    </Button>
                    <Button
                      onClick={openConnectModal}
                      variant="cyber"
                      size="sm"
                      className="font-pixel h-10 w-10 p-0 sm:hidden"
                    >
                      <IconWallet className="h-4 w-4" />
                    </Button>
                  </>
                );
              }

              if (chain.unsupported) {
                return (
                  <Button
                    onClick={openChainModal}
                    variant="cyber"
                    className="font-pixel text-cyber-red"
                  >
                    {t('wallet.wrongNetwork')}
                  </Button>
                );
              }

              return (
                <div className="flex gap-2">
                  {/* Desktop version */}
                  <Button
                    onClick={openChainModal}
                    variant="outline"
                    size="sm"
                    className="font-pixel text-cyber-blue hover:bg-cyber-blue hover:text-cyber-dark hidden text-xs sm:flex"
                  >
                    {chain.hasIcon && (
                      <div
                        className="mr-1 h-3 w-3 overflow-hidden rounded-full"
                        style={{
                          background: chain.iconBackground,
                        }}
                      >
                        {chain.iconUrl && (
                          <Image
                            alt={chain.name ?? 'Chain icon'}
                            src={chain.iconUrl}
                            width={12}
                            height={12}
                            className="h-3 w-3"
                          />
                        )}
                      </div>
                    )}
                    {chain.name}
                  </Button>

                  <Button
                    onClick={openAccountModal}
                    variant="cyber"
                    size="sm"
                    className="font-pixel hidden text-xs sm:flex"
                  >
                    {account.displayName}
                    {account.displayBalance && (
                      <span className="ml-1 opacity-80">{account.displayBalance}</span>
                    )}
                  </Button>

                  {/* Mobile version - icons only */}
                  <Button
                    onClick={openChainModal}
                    variant="outline"
                    size="sm"
                    className="font-pixel text-cyber-blue hover:bg-cyber-blue hover:text-cyber-dark h-10 w-10 p-0 sm:hidden"
                  >
                    <IconLink className="h-4 w-4" />
                  </Button>

                  <Button
                    onClick={openAccountModal}
                    variant="cyber"
                    size="sm"
                    className="font-pixel h-10 w-10 p-0 sm:hidden"
                  >
                    <IconUser className="h-4 w-4" />
                  </Button>
                </div>
              );
            })()}
          </div>
        );
      }}
    </ConnectButton.Custom>
  );
}
