// SoloAscendHero ABI
// Generated automatically from foundry build output

export const soloAscendHeroABI = [
  {
    type: 'constructor',
    inputs: [
      {
        name: 'admin',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'heroClassRegistry',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'forgeCoordinator',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'forgeEffectRegistry',
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
      {
        name: 'erc6551Registry',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'erc6551Implementation',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'svgRenderer',
        type: 'address',
        internalType: 'address',
      },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'ERC6551_IMPLEMENTATION',
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
    name: 'ERC6551_REGISTRY',
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
    name: 'FORGE_COORDINATOR',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'address',
        internalType: 'contract IForgeCoordinator',
      },
    ],
    stateMutability: 'view',
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
    name: 'HERO_CLASS_REGISTRY',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'address',
        internalType: 'contract IHeroClassRegistry',
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
    name: 'approve',
    inputs: [
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
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'balanceOf',
    inputs: [
      {
        name: 'owner',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'decreaseHeroAttributeFromCoordinator',
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
    name: 'getApproved',
    inputs: [
      {
        name: 'tokenId',
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
    name: 'getHero',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'hero',
        type: 'tuple',
        internalType: 'struct GameConstants.Hero',
        components: [
          {
            name: 'tokenBoundAccount',
            type: 'address',
            internalType: 'address',
          },
          {
            name: 'lastForgeTime',
            type: 'uint64',
            internalType: 'uint64',
          },
          {
            name: 'totalForges',
            type: 'uint32',
            internalType: 'uint32',
          },
          {
            name: 'mintTime',
            type: 'uint64',
            internalType: 'uint64',
          },
          {
            name: 'classId',
            type: 'uint8',
            internalType: 'enum GameConstants.HeroClass',
          },
          {
            name: 'stage',
            type: 'uint8',
            internalType: 'enum GameConstants.HeroStage',
          },
          {
            name: 'attributes',
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
    name: 'getHeroName',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'name',
        type: 'string',
        internalType: 'string',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getSVGRenderer',
    inputs: [],
    outputs: [
      {
        name: 'renderer',
        type: 'address',
        internalType: 'address',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getTokenBoundAccount',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'account',
        type: 'address',
        internalType: 'address',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'hasMinted',
    inputs: [
      {
        name: 'account',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'increaseHeroAllAttributesFromCoordinator',
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
    name: 'increaseHeroAttributeFromCoordinator',
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
    name: 'isApprovedForAll',
    inputs: [
      {
        name: 'owner',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'operator',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'isForgeAvailable',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'available',
        type: 'bool',
        internalType: 'bool',
      },
      {
        name: 'timeLeft',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'mint',
    inputs: [],
    outputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    name: 'name',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'string',
        internalType: 'string',
      },
    ],
    stateMutability: 'view',
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
    name: 'ownerOf',
    inputs: [
      {
        name: 'tokenId',
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
    name: 'performDailyForge',
    inputs: [
      {
        name: 'tokenId',
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
    outputs: [],
    stateMutability: 'payable',
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
    name: 'revokeCustomName',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'royaltyInfo',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'salePrice',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'receiver',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'amount',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'safeTransferFrom',
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
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'safeTransferFrom',
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
    name: 'setApprovalForAll',
    inputs: [
      {
        name: 'operator',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'approved',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'setHeroName',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'name',
        type: 'string',
        internalType: 'string',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'setSVGRenderer',
    inputs: [
      {
        name: 'renderer',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'supportsInterface',
    inputs: [
      {
        name: 'interfaceId',
        type: 'bytes4',
        internalType: 'bytes4',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'symbol',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'string',
        internalType: 'string',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'tokenURI',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: '',
        type: 'string',
        internalType: 'string',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'totalSupply',
    inputs: [],
    outputs: [
      {
        name: '',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'transferFrom',
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
    name: 'updateHeroStageFromCoordinator',
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
    type: 'function',
    name: 'withdrawAllRevenue',
    inputs: [
      {
        name: 'to',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'withdrawRevenue',
    inputs: [
      {
        name: 'to',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'amount',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'event',
    name: 'Approval',
    inputs: [
      {
        name: 'owner',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'approved',
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
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'ApprovalForAll',
    inputs: [
      {
        name: 'owner',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'operator',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'approved',
        type: 'bool',
        indexed: false,
        internalType: 'bool',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'AttributesUpdated',
    inputs: [
      {
        name: 'heroId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'newAttributes',
        type: 'tuple',
        indexed: false,
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
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'ForgeCompleted',
    inputs: [
      {
        name: 'heroId',
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
      {
        name: 'effectTypeId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'ForgeUsed',
    inputs: [
      {
        name: 'forgeId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'heroId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'HeroMinted',
    inputs: [
      {
        name: 'owner',
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
        name: 'className',
        type: 'string',
        indexed: false,
        internalType: 'string',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'HeroNameRevoked',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'admin',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'oldName',
        type: 'string',
        indexed: false,
        internalType: 'string',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'HeroNameSet',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'owner',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'newName',
        type: 'string',
        indexed: false,
        internalType: 'string',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'HeroStageChanged',
    inputs: [
      {
        name: 'heroId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'newStage',
        type: 'uint8',
        indexed: false,
        internalType: 'enum GameConstants.HeroStage',
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
    name: 'RevenueWithdrawn',
    inputs: [
      {
        name: 'to',
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
    type: 'event',
    name: 'Transfer',
    inputs: [
      {
        name: 'from',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'to',
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
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'TreasuryDeposit',
    inputs: [
      {
        name: 'token',
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
    type: 'event',
    name: 'TreasuryReward',
    inputs: [
      {
        name: 'recipient',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'token',
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
    name: 'AlreadyMinted',
    inputs: [],
  },
  {
    type: 'error',
    name: 'DailyForgeExhausted',
    inputs: [],
  },
  {
    type: 'error',
    name: 'ERC2981InvalidDefaultRoyalty',
    inputs: [
      {
        name: 'numerator',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'denominator',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
  },
  {
    type: 'error',
    name: 'ERC2981InvalidDefaultRoyaltyReceiver',
    inputs: [
      {
        name: 'receiver',
        type: 'address',
        internalType: 'address',
      },
    ],
  },
  {
    type: 'error',
    name: 'ERC2981InvalidTokenRoyalty',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'numerator',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'denominator',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
  },
  {
    type: 'error',
    name: 'ERC2981InvalidTokenRoyaltyReceiver',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'receiver',
        type: 'address',
        internalType: 'address',
      },
    ],
  },
  {
    type: 'error',
    name: 'ERC721IncorrectOwner',
    inputs: [
      {
        name: 'sender',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'owner',
        type: 'address',
        internalType: 'address',
      },
    ],
  },
  {
    type: 'error',
    name: 'ERC721InsufficientApproval',
    inputs: [
      {
        name: 'operator',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
  },
  {
    type: 'error',
    name: 'ERC721InvalidApprover',
    inputs: [
      {
        name: 'approver',
        type: 'address',
        internalType: 'address',
      },
    ],
  },
  {
    type: 'error',
    name: 'ERC721InvalidOperator',
    inputs: [
      {
        name: 'operator',
        type: 'address',
        internalType: 'address',
      },
    ],
  },
  {
    type: 'error',
    name: 'ERC721InvalidOwner',
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
    name: 'ERC721InvalidReceiver',
    inputs: [
      {
        name: 'receiver',
        type: 'address',
        internalType: 'address',
      },
    ],
  },
  {
    type: 'error',
    name: 'ERC721InvalidSender',
    inputs: [
      {
        name: 'sender',
        type: 'address',
        internalType: 'address',
      },
    ],
  },
  {
    type: 'error',
    name: 'ERC721NonexistentToken',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
  },
  {
    type: 'error',
    name: 'ForgeAlreadyUsed',
    inputs: [],
  },
  {
    type: 'error',
    name: 'ForgeNotReady',
    inputs: [
      {
        name: 'timeLeft',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
  },
  {
    type: 'error',
    name: 'InsufficientPayment',
    inputs: [
      {
        name: 'required',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'provided',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
  },
  {
    type: 'error',
    name: 'InsufficientTreasuryFunds',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidAttributeIndex',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidForgeEffect',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidHeroId',
    inputs: [
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
  },
  {
    type: 'error',
    name: 'InvalidHeroName',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidInput',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidQualityDistribution',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidStage',
    inputs: [
      {
        name: 'currentStage',
        type: 'uint8',
        internalType: 'enum GameConstants.HeroStage',
      },
    ],
  },
  {
    type: 'error',
    name: 'MythicSupplyExhausted',
    inputs: [],
  },
  {
    type: 'error',
    name: 'OracleRequestFailed',
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
    name: 'TransferFailed',
    inputs: [],
  },
  {
    type: 'error',
    name: 'UnauthorizedAccess',
    inputs: [],
  },
] as const;

export type soloAscendHeroABIType = typeof soloAscendHeroABI;
