import { getDefaultConfig } from '@rainbow-me/rainbowkit';
import { baseSepolia } from 'viem/chains';

export const config = getDefaultConfig({
  appName: 'Solo Ascend',
  projectId: process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID || 'demo-project-id', // Use your own project ID
  chains: [baseSepolia],
  ssr: true,
});
