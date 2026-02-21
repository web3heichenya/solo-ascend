// OracleRegistry ABI
// Generated automatically from foundry build output

export const oracleRegistryABI = [
  {
    type: 'constructor',
    inputs: [
      {
        name: 'admin',
        type: 'address',
        internalType: 'address',
      },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'calculateFee',
    inputs: [
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
        name: 'totalFee',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'deactivateOracle',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'determineQuality',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'randomSeed',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'quality',
        type: 'uint8',
        internalType: 'enum GameConstants.ForgeQuality',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getOracle',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'oracleData',
        type: 'tuple',
        internalType: 'struct IOracleRegistry.OracleData',
        components: [
          {
            name: 'name',
            type: 'string',
            internalType: 'string',
          },
          {
            name: 'description',
            type: 'string',
            internalType: 'string',
          },
          {
            name: 'implementation',
            type: 'address',
            internalType: 'address',
          },
          {
            name: 'isActive',
            type: 'bool',
            internalType: 'bool',
          },
          {
            name: 'createdAt',
            type: 'uint64',
            internalType: 'uint64',
          },
          {
            name: 'fixedFee',
            type: 'uint256',
            internalType: 'uint256',
          },
        ],
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getOracleImplementation',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'implementation',
        type: 'address',
        internalType: 'address',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getQualitySupport',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'quality',
        type: 'uint8',
        internalType: 'enum GameConstants.ForgeQuality',
      },
    ],
    outputs: [
      {
        name: 'supported',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getQualityWeight',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'quality',
        type: 'uint8',
        internalType: 'enum GameConstants.ForgeQuality',
      },
    ],
    outputs: [
      {
        name: 'weight',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'isAuthorizedOracle',
    inputs: [
      {
        name: 'oracleAddress',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [
      {
        name: 'authorized',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'isOracleRegistered',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'registered',
        type: 'bool',
        internalType: 'bool',
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
    name: 'reactivateOracle',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'registerOracle',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'name',
        type: 'string',
        internalType: 'string',
      },
      {
        name: 'description',
        type: 'string',
        internalType: 'string',
      },
      {
        name: 'implementation',
        type: 'address',
        internalType: 'address',
      },
      {
        name: 'fixedFee',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'supportedQualities',
        type: 'uint8[]',
        internalType: 'enum GameConstants.ForgeQuality[]',
      },
      {
        name: 'distributionWeights',
        type: 'uint256[]',
        internalType: 'uint256[]',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
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
    name: 'setQualitySupport',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'quality',
        type: 'uint8',
        internalType: 'enum GameConstants.ForgeQuality',
      },
      {
        name: 'supported',
        type: 'bool',
        internalType: 'bool',
      },
      {
        name: 'weight',
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
    name: 'updateOracleFees',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'fixedFee',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'updateOracleImplementation',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'newImplementation',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'event',
    name: 'OracleDeactivated',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'OracleFeesUpdated',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'fixedFee',
        type: 'uint256',
        indexed: false,
        internalType: 'uint256',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'OracleReactivated',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'OracleRegistered',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'name',
        type: 'string',
        indexed: false,
        internalType: 'string',
      },
      {
        name: 'implementation',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'OracleUpdated',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'newImplementation',
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
    name: 'QualityDistributionUpdated',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'quality',
        type: 'uint8',
        indexed: false,
        internalType: 'enum GameConstants.ForgeQuality',
      },
      {
        name: 'weight',
        type: 'uint256',
        indexed: false,
        internalType: 'uint256',
      },
    ],
    anonymous: false,
  },
  {
    type: 'event',
    name: 'QualitySupportUpdated',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        indexed: true,
        internalType: 'uint256',
      },
      {
        name: 'quality',
        type: 'uint8',
        indexed: false,
        internalType: 'enum GameConstants.ForgeQuality',
      },
      {
        name: 'supported',
        type: 'bool',
        indexed: false,
        internalType: 'bool',
      },
    ],
    anonymous: false,
  },
  {
    type: 'error',
    name: 'InvalidImplementation',
    inputs: [],
  },
  {
    type: 'error',
    name: 'InvalidOracleData',
    inputs: [],
  },
  {
    type: 'error',
    name: 'OracleAlreadyRegistered',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
  },
  {
    type: 'error',
    name: 'OracleInactive',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
  },
  {
    type: 'error',
    name: 'OracleNotFound',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
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
    name: 'QualityNotSupported',
    inputs: [
      {
        name: 'oracleId',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'quality',
        type: 'uint8',
        internalType: 'enum GameConstants.ForgeQuality',
      },
    ],
  },
] as const;

export type oracleRegistryABIType = typeof oracleRegistryABI;
