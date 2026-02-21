import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { AppState, StorePersistConfig } from '@/types';

export const useAppStore = create<AppState>()(
  persist(
    (set) => ({
      // Current hero
      currentHeroId: null,
      setCurrentHeroId: (id) => set({ currentHeroId: id }),

      // User's owned hero ID
      userHeroId: null,
      setUserHeroId: (id) => set({ userHeroId: id }),

      // UI state
      isSettingsOpen: false,
      setSettingsOpen: (open) => set({ isSettingsOpen: open }),

      isInventoryOpen: false,
      setInventoryOpen: (open) => set({ isInventoryOpen: open }),

      isSearchOpen: false,
      setSearchOpen: (open) => set({ isSearchOpen: open }),

      // RPC settings
      alchemyApiKey: null,
      setAlchemyApiKey: (key) => set({ alchemyApiKey: key }),

      customRpcUrl: null,
      setCustomRpcUrl: (url) => set({ customRpcUrl: url }),

      // Language settings - will be initialized from i18n
      language: '',
      setLanguage: (lang) => set({ language: lang }),

      // Oracle fee multiplier
      feeMultiplier: 1.5,
      setFeeMultiplier: (multiplier) => set({ feeMultiplier: multiplier }),

      // Forge state management (unified)
      forgeState: {
        isForging: false,
        isConfirming: false,
        isConfirmed: false,
        forgeHash: null,
        selectedHeroId: null,
        error: null,
      },
      setForgeState: (updates) =>
        set((state) => ({
          forgeState: { ...state.forgeState, ...updates },
        })),
      clearForgeState: () =>
        set({
          forgeState: {
            isForging: false,
            isConfirming: false,
            isConfirmed: false,
            forgeHash: null,
            selectedHeroId: null,
            error: null,
          },
        }),
      executeForge: () => {
        // Placeholder - actual implementation will be in useForgeManager hook
        throw new Error('executeForge should be implemented in useForgeManager hook');
      },
    }),
    {
      name: 'solo-ascend-storage',
      partialize: (state): StorePersistConfig => ({
        alchemyApiKey: state.alchemyApiKey,
        customRpcUrl: state.customRpcUrl,
        currentHeroId: state.currentHeroId,
        userHeroId: state.userHeroId,
        language: state.language,
        feeMultiplier: state.feeMultiplier,
      }),
    }
  )
);
