import '../styles/globals.css';
import { Providers } from '@/lib/providers';
import { Toaster } from '@/components/ui/toaster';
import { ParticleBackground } from '@/components/effects/ParticleBackground';
import Header from '@/components/header';
import BattleHeroesBackground from '@/components/effects/BattleHeroesBackground';
import GroundEffect from '@/components/effects/GroundEffect';
import '@radix-ui/themes/styles.css';
import { rootLayoutMetadata } from '@/lib/seo';
import {
  StructuredData,
  websiteStructuredData,
  gameStructuredData,
  organizationStructuredData,
} from '@/components/seo/StructuredData';
import { ProgressBar } from '@/components/ui/progress-bar';

export const metadata = rootLayoutMetadata;

export const viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
  colorScheme: 'dark',
  themeColor: [
    { media: '(prefers-color-scheme: light)', color: '#0a0a0a' },
    { media: '(prefers-color-scheme: dark)', color: '#0a0a0a' },
  ],
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="zh" className="dark">
      <head>
        <StructuredData data={websiteStructuredData} />
        <StructuredData data={gameStructuredData} />
        <StructuredData data={organizationStructuredData} />
      </head>
      <body className="antialiased">
        <Providers>
          <ProgressBar />
          <ParticleBackground />
          <div className="relative flex h-screen flex-col overflow-hidden">
            {/* Battle Heroes Background */}
            <BattleHeroesBackground />

            {/* Ground Effect */}
            <GroundEffect />

            {/* Header */}
            <Header />

            {/* Main Content */}
            <main className="flex-1 overflow-y-auto px-2 pb-16 md:px-4 md:pb-20">{children}</main>
          </div>
          <Toaster />
        </Providers>
      </body>
    </html>
  );
}
