export const erc6551ExecutableABI = [
  {
    inputs: [
      {
        name: 'to',
        type: 'address',
      },
      {
        name: 'value',
        type: 'uint256',
      },
      {
        name: 'data',
        type: 'bytes',
      },
      {
        name: 'operation',
        type: 'uint8',
      },
    ],
    name: 'execute',
    outputs: [
      {
        name: '',
        type: 'bytes',
      },
    ],
    stateMutability: 'payable',
    type: 'function',
  },
] as const;
