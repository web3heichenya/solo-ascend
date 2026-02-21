// HeroSVGRenderer ABI
// Generated automatically from foundry build output

export const svgRendererABI = [
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
        name: '_heroAvatarLib',
        type: 'address',
        internalType: 'address',
      },
    ],
    stateMutability: 'nonpayable',
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
    name: 'generateMetadata',
    inputs: [
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
        ],
      },
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'customName',
        type: 'string',
        internalType: 'string',
      },
    ],
    outputs: [
      {
        name: 'metadata',
        type: 'string',
        internalType: 'string',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'generateMetadata',
    inputs: [
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
        ],
      },
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'metadata',
        type: 'string',
        internalType: 'string',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'generateSVG',
    inputs: [
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
        ],
      },
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'svg',
        type: 'string',
        internalType: 'string',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getImageURI',
    inputs: [
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
        ],
      },
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'dataURI',
        type: 'string',
        internalType: 'string',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getStageBorderColor',
    inputs: [
      {
        name: 'stage',
        type: 'uint8',
        internalType: 'enum GameConstants.HeroStage',
      },
    ],
    outputs: [
      {
        name: 'color',
        type: 'string',
        internalType: 'string',
      },
    ],
    stateMutability: 'pure',
  },
  {
    type: 'function',
    name: 'getTokenURI',
    inputs: [
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
        ],
      },
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'dataURI',
        type: 'string',
        internalType: 'string',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getTokenURI',
    inputs: [
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
        ],
      },
      {
        name: 'tokenId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'customName',
        type: 'string',
        internalType: 'string',
      },
    ],
    outputs: [
      {
        name: 'dataURI',
        type: 'string',
        internalType: 'string',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'heroAvatarLib',
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
    name: 'setHeroAvatarLib',
    inputs: [
      {
        name: 'newHeroAvatarLib',
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
    type: 'event',
    name: 'ClassImageUpdated',
    inputs: [
      {
        name: 'classId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'imageData',
        type: 'string',
        indexed: false,
        internalType: 'string',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'HeroAvatarLibUpdated',
    inputs: [
      {
        name: 'oldLib',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'newLib',
        type: 'address',
        indexed: true,
        internalType: 'address',
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
    name: 'RendererUpdated',
    inputs: [
      {
        name: 'newRenderer',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
    ],
    anonymous: false,
  },
  {
    type: 'error',
    name: 'ClassNotFound',
    inputs: [
      {
        name: 'classId',
        type: 'uint8',
        internalType: 'enum GameConstants.HeroClass',
      },
    ],
  },
  {
    type: 'error',
    name: 'ImageDataTooLarge',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidAddress',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidHeroData',
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
    name: 'UnsupportedClass',
    inputs: [],
  },
] as const;

export type svgRendererABIType = typeof svgRendererABI;
