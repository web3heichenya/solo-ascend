'use client';

import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { WagmiProvider, createConfig, http } from 'wagmi';
import { RainbowKitProvider, darkTheme, getDefaultWallets } from '@rainbow-me/rainbowkit';
import '@rainbow-me/rainbowkit/styles.css';
import '../styles/rainbowkit-custom.css';

import { baseSepolia } from 'viem/chains';
import { ReactNode, useState, useEffect, useMemo } from 'react';
import { I18nextProvider } from 'react-i18next';
import i18n from './i18n';
import { useAppStore } from './store';
import { Theme } from '@radix-ui/themes';

const customTheme = darkTheme({
  accentColor: '#00ffff',
  borderRadius: 'medium',
  fontStack: 'rounded',
  overlayBlur: 'small',
});

// Override specific RainbowKit styles to match cyberpunk theme
customTheme.colors = {
  ...customTheme.colors,
  actionButtonBorder: '#00ffff',
  actionButtonBorderMobile: '#00ffff',
  actionButtonSecondaryBackground: '#0a0a0a',
  closeButton: '#00ffff',
  closeButtonBackground: '#0a0a0a',
  connectButtonBackground: '#0a0a0a',
  connectButtonBackgroundError: '#ff3300',
  connectButtonInnerBackground: '#050505',
  connectButtonText: '#00ffff',
  connectButtonTextError: '#ff3300',
  connectionIndicator: '#00ff41',
  downloadBottomCardBackground: '#050505',
  downloadTopCardBackground: '#0a0a0a',
  error: '#ff3300',
  generalBorder: '#00ffff',
  generalBorderDim: 'rgba(0, 255, 255, 0.3)',
  menuItemBackground: '#0a0a0a',
  modalBackdrop: 'rgba(0, 0, 0, 0.8)',
  modalBackground: '#0a0a0a',
  modalBorder: '#00ffff',
  modalText: '#00ffff',
  modalTextDim: 'rgba(0, 255, 255, 0.7)',
  modalTextSecondary: '#ffffff',
  profileAction: '#050505',
  profileActionHover: 'rgba(0, 255, 255, 0.1)',
  profileForeground: '#0a0a0a',
  selectedOptionBorder: '#ff00ff',
  standby: 'rgba(0, 255, 255, 0.5)',
};

customTheme.radii = {
  ...customTheme.radii,
  actionButton: '8px',
  connectButton: '8px',
  menuButton: '8px',
  modal: '8px',
  modalMobile: '8px',
};

customTheme.fonts = {
  ...customTheme.fonts,
  body: '"JetBrains Mono", "Zpix", monospace',
};

// Suppress console warnings in development
if (typeof window !== 'undefined' && process.env.NODE_ENV === 'development') {
  const originalWarn = console.warn;
  console.warn = (...args: unknown[]) => {
    // Suppress specific warnings
    const message = args[0]?.toString() || '';
    if (
      message.includes('Lit is in dev mode') ||
      message.includes('Failed to fetch remote project configuration')
    ) {
      return;
    }
    originalWarn.apply(console, args);
  };
}

import { ProvidersProps } from '@/types';

export function Providers({ children }: ProvidersProps) {
  const [queryClient] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 60 * 1000, // 1 minute
            gcTime: 10 * 60 * 1000, // 10 minutes
          },
        },
      })
  );

  const wagmiConfig = useMemo(() => {
    const { connectors } = getDefaultWallets({
      appName: 'Solo Ascend',
      projectId: process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID || 'demo-project-id',
    });

    return createConfig({
      chains: [baseSepolia],
      connectors,
      transports: {
        [baseSepolia.id]: http(),
      },
      ssr: true,
    });
  }, []);

  return (
    <Theme appearance="dark" accentColor="cyan" grayColor="slate" radius="medium" scaling="100%">
      <WagmiProvider config={wagmiConfig}>
        <QueryClientProvider client={queryClient}>
          <RainbowKitProvider theme={customTheme}>
            <I18nextProvider i18n={i18n}>
              <I18nSync>{children}</I18nSync>
            </I18nextProvider>
          </RainbowKitProvider>
        </QueryClientProvider>
      </WagmiProvider>
    </Theme>
  );
}

// Component to sync i18n with Zustand store
function I18nSync({ children }: { children: ReactNode }) {
  const { language, setLanguage } = useAppStore();
  const [isReady, setIsReady] = useState(false);

  useEffect(() => {
    // Wait for i18n to be ready
    if (i18n.isInitialized) {
      // Sync initial language from store
      if (language && i18n.language !== language) {
        i18n.changeLanguage(language);
      }

      // Set initial language in store if not set
      if (!language && i18n.language) {
        setLanguage(i18n.language);
      }

      setIsReady(true);
    } else {
      // Wait for i18n initialization
      i18n.on('initialized', () => {
        setIsReady(true);
      });
    }
  }, [language, setLanguage]);

  if (!isReady) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-[var(--background)]">
        <div className="text-center">
          <div className="border-cyber-blue mx-auto mb-4 h-8 w-8 animate-spin rounded-full border-2 border-t-transparent"></div>
          <p className="text-cyber-blue font-pixel text-sm">Loading...</p>
        </div>
      </div>
    );
  }

  return <>{children}</>;
}
