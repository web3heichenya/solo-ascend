'use client';

import { HeroDisplay } from '@/components/hero/HeroDisplay';
import { FixedButtons } from '@/components/layout/FixedButtons';
import { SettingsModal } from '@/components/layout/SettingsModal';
import { InventoryModal } from '@/components/layout/InventoryModal';
import { HeroSearchModal } from '@/components/hero/HeroSearchModal';

export default function Home() {
  return (
    <>
      <div className="container mx-auto h-full">
        <HeroDisplay />
      </div>

      {/* Fixed UI Elements for Home Page */}
      <FixedButtons />
      <SettingsModal />
      <InventoryModal />
      <HeroSearchModal />
    </>
  );
}
