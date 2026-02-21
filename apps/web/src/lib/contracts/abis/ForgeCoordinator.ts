// ForgeCoordinator ABI
// Generated automatically from foundry build output

export const forgeCoordinatorABI = [
  {
    type: 'constructor',
    inputs: [
      {
        name: 'admin',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'forgeEffectRegistry',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'forgeItemRegistry',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'oracleRegistry',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'hookRegistry',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'treasury',
        type: 'address',
        internalType: 'address',
      },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'FORGE_EFFECT_REGISTRY',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'address',
        internalType: 'contract IForgeEffectRegistry',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'FORGE_ITEM_REGISTRY',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'address',
        internalType: 'contract IForgeItemRegistry',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'HOOK_REGISTRY',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'address',
        internalType: 'contract IHookRegistry',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'ORACLE_REGISTRY',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'address',
        internalType: 'contract IOracleRegistry',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'TREASURY',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'address',
        internalType: 'contract ITreasury',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'calculateForgeCost',
    inputs: [
      {
        name: 'heroId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'gasLimit',
        type: 'uint32',
        internalType: 'uint32',
      },
    ],
    outputs: [
      {
        name: 'cost',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'decreaseHeroAttribute',
    inputs: [
      {
        name: 'heroId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'attribute',
        type: 'uint8',
        internalType: 'enum GameConstants.HeroAttribute',
      },
      {
        name: 'value',
        type: 'uint32',
        internalType: 'uint32',
      },
      {
        name: 'isPercentage',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'distributeTreasuryReward',
    inputs: [
      {
        name: 'recipient',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'rewardBps',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'fulfillForge',
    inputs: [
      {
        name: 'requestId',
        type: 'bytes32',
        internalType: 'bytes32',
      },
      {
        name: 'randomSeed',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'effectTypeId',
        type: 'uint8',
        internalType: 'enum GameConstants.ForgeEffectType',
      },
      {
        name: 'effectId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'newAttributes',
        type: 'tuple',
        internalType: 'struct GameConstants.HeroAttributes',
        components: [
          {
            name: 'hp',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'hpRegen',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'ad',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'ap',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'attackSpeed',
            type: 'uint16',
            internalType: 'uint16',
          },
          {
            name: 'crit',
            type: 'uint16',
            internalType: 'uint16',
          },
          {
            name: 'armor',
            type: 'uint16',
            internalType: 'uint16',
          },
          {
            name: 'mr',
            type: 'uint16',
            internalType: 'uint16',
          },
          {
            name: 'cdr',
            type: 'uint16',
            internalType: 'uint16',
          },
          {
            name: 'moveSpeed',
            type: 'uint16',
            internalType: 'uint16',
          },
        ],
      },
      {
        name: 'newStage',
        type: 'uint8',
        internalType: 'enum GameConstants.HeroStage',
      },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'fulfillForgeManually',
    inputs: [
      {
        name: 'requestId',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    outputs: [
      {
        name: 'effectTypeId',
        type: 'uint8',
        internalType: 'enum GameConstants.ForgeEffectType',
      },
      {
        name: 'effectId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'newAttributes',
        type: 'tuple',
        internalType: 'struct GameConstants.HeroAttributes',
        components: [
          {
            name: 'hp',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'hpRegen',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'ad',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'ap',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'attackSpeed',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'crit',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'armor',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'mr',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'cdr',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'moveSpeed',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'lifesteal',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'tenacity',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'penetration',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'mana',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'manaRegen',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'intelligence',
            type: 'uint32',
            internalType: 'uint32',
          },
        ],
      },
      {
        name: 'newStage',
        type: 'uint8',
        internalType: 'enum GameConstants.HeroStage',
      },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'getForgeRequest',
    inputs: [
      {
        name: 'requestId',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    outputs: [
      {
        name: 'request',
        type: 'tuple',
        internalType: 'struct IForgeCoordinator.ForgeRequest',
        components: [
          {
            name: 'heroId',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'oracleId',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'totalForges',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'randomSeed',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'effectId',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'requester',
            type: 'address',
            internalType: 'address',
          },
          {
            name: 'requestTime',
            type: 'uint64',
            internalType: 'uint64',
          },
          {
            name: 'fulfilled',
            type: 'bool',
            internalType: 'bool',
          },
        ],
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getHeroIdByAccount',
    inputs: [
      {
        name: 'account',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [
      {
        name: 'heroId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getHeroTokenBoundAccount',
    inputs: [
      {
        name: 'heroId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'address',
        internalType: 'address',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getPendingRequest',
    inputs: [
      {
        name: 'heroId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'requestId',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'handleForgeItemUpdate',
    inputs: [
      {
        name: 'from',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'to',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'effectType',
        type: 'uint8',
        internalType: 'enum GameConstants.ForgeEffectType',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'hasPendingForge',
    inputs: [
      {
        name: 'heroId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'hasPending',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'increaseHeroAllAttributes',
    inputs: [
      {
        name: 'heroId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'value',
        type: 'uint32',
        internalType: 'uint32',
      },
      {
        name: 'isPercentage',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'increaseHeroAttribute',
    inputs: [
      {
        name: 'heroId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'attribute',
        type: 'uint8',
        internalType: 'enum GameConstants.HeroAttribute',
      },
      {
        name: 'value',
        type: 'uint32',
        internalType: 'uint32',
      },
      {
        name: 'isPercentage',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'initiateForgeAndRequestAuto',
    inputs: [
      {
        name: 'heroId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'requester',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'gasLimit',
        type: 'uint32',
        internalType: 'uint32',
      },
    ],
    outputs: [
      {
        name: 'requestId',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    name: 'mintForgeItem',
    inputs: [
      {
        name: 'recipient',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'quality',
        type: 'uint8',
        internalType: 'enum GameConstants.ForgeQuality',
      },
      {
        name: 'effectType',
        type: 'uint8',
        internalType: 'enum GameConstants.ForgeEffectType',
      },
      {
        name: 'attribute',
        type: 'uint8',
        internalType: 'enum GameConstants.HeroAttribute',
      },
      {
        name: 'value',
        type: 'uint32',
        internalType: 'uint32',
      },
    ],
    outputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'owner',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'address',
        internalType: 'address',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'renounceOwnership',
    inputs: [],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'setHeroContract',
    inputs: [
      {
        name: 'newHeroContract',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'transferOwnership',
    inputs: [
      {
        name: 'newOwner',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'triggerHook',
    inputs: [
      {
        name: 'phase',
        type: 'uint8',
        internalType: 'enum IHookRegistry.HookPhase',
      },
      {
        name: 'data',
        type: 'bytes',
        internalType: 'bytes',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'updateHeroStage',
    inputs: [
      {
        name: 'heroId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'newStage',
        type: 'uint8',
        internalType: 'enum GameConstants.HeroStage',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'event',
    name: 'EffectApplied',
    inputs: [
      {
        name: 'heroId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'effectTypeId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'effectId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'ForgeCompleted',
    inputs: [
      {
        name: 'requestId',
        type: 'bytes32',
        indexed: true,
        internalType: 'bytes32',
      },
      {
        name: 'heroId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'effectTypeId',
        type: 'uint8',
        indexed: false,
        internalType: 'enum GameConstants.ForgeEffectType',
      },
      {
        name: 'effectId',
        type: 'uint256',
        indexed: false,
        internalType: 'uint256',
      },
      {
        name: 'quality',
        type: 'uint8',
        indexed: false,
        internalType: 'enum GameConstants.ForgeQuality',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'ForgeInitiated',
    inputs: [
      {
        name: 'requestId',
        type: 'bytes32',
        indexed: true,
        internalType: 'bytes32',
      },
      {
        name: 'heroId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'requester',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'oracleId',
        type: 'uint256',
        indexed: false,
        internalType: 'uint256',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'ForgeItemCreated',
    inputs: [
      {
        name: 'forgeContract',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'tokenId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'recipient',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'quality',
        type: 'uint8',
        indexed: false,
        internalType: 'enum GameConstants.ForgeQuality',
      },
      {
        name: 'effectType',
        type: 'uint8',
        indexed: false,
        internalType: 'enum GameConstants.ForgeEffectType',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'ForgeQualityDetermined',
    inputs: [
      {
        name: 'requestId',
        type: 'bytes32',
        indexed: true,
        internalType: 'bytes32',
      },
      {
        name: 'quality',
        type: 'uint8',
        indexed: false,
        internalType: 'enum GameConstants.ForgeQuality',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'OwnershipTransferred',
    inputs: [
      {
        name: 'previousOwner',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'newOwner',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'TreasuryRewardDistributed',
    inputs: [
      {
        name: 'recipient',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'amount',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
    ],
    anonymous: false,
  },
  {
    type: 'error',
    name: 'EffectApplicationFailed',
    inputs: [],
  },
  {
    type: 'error',
    name: 'EffectGenerationFailed',
    inputs: [],
  },
  {
    type: 'error',
    name: 'ForgeItemContractNotFound',
    inputs: [],
  },
  {
    type: 'error',
    name: 'HeroContractNotSet',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidForgeItem',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidForgeParameters',
    inputs: [],
  },
  {
    type: 'error',
    name: 'NoAvailableEffectTypes',
    inputs: [],
  },
  {
    type: 'error',
    name: 'OwnableInvalidOwner',
    inputs: [
      {
        name: 'owner',
        type: 'address',
        internalType: 'address',
      },
    ],
  },
  {
    type: 'error',
    name: 'OwnableUnauthorizedAccount',
    inputs: [
      {
        name: 'account',
        type: 'address',
        internalType: 'address',
      },
    ],
  },
  {
    type: 'error',
    name: 'ReentrancyGuardReentrantCall',
    inputs: [],
  },
  {
    type: 'error',
    name: 'RequestAlreadyFulfilled',
    inputs: [],
  },
  {
    type: 'error',
    name: 'RequestNotFound',
    inputs: [],
  },
  {
    type: 'error',
    name: 'UnauthorizedCaller',
    inputs: [],
  },
] as const;

export type forgeCoordinatorABIType = typeof forgeCoordinatorABI;
