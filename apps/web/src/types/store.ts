// Store state types
export interface ForgeState {
  isForging: boolean;
  isConfirming: boolean;
  isConfirmed: boolean;
  forgeHash: string | null;
  selectedHeroId: number | null;
  error: string | null;
}

// Main app state interface
export interface AppState {
  // Current hero being displayed
  currentHeroId: number | null;
  setCurrentHeroId: (id: number | null) => void;

  // User's owned hero ID (for persistence)
  userHeroId: number | null;
  setUserHeroId: (id: number | null) => void;

  // UI state
  isSettingsOpen: boolean;
  setSettingsOpen: (open: boolean) => void;

  isInventoryOpen: boolean;
  setInventoryOpen: (open: boolean) => void;

  isSearchOpen: boolean;
  setSearchOpen: (open: boolean) => void;

  // RPC settings
  alchemyApiKey: string | null;
  setAlchemyApiKey: (key: string | null) => void;

  customRpcUrl: string | null;
  setCustomRpcUrl: (url: string | null) => void;

  // Language settings
  language: string;
  setLanguage: (lang: string) => void;

  // Oracle fee multiplier
  feeMultiplier: number;
  setFeeMultiplier: (multiplier: number) => void;

  // Forge state management (unified)
  forgeState: ForgeState;
  setForgeState: (updates: Partial<ForgeState>) => void;
  clearForgeState: () => void;
  executeForge: (heroId: number, oracleId: number, gasLimit: number, customValue?: number) => void;
}

// Store persistence configuration
export interface StorePersistConfig {
  alchemyApiKey: string | null;
  customRpcUrl: string | null;
  currentHeroId: number | null;
  userHeroId: number | null;
  language: string;
  feeMultiplier: number;
}
