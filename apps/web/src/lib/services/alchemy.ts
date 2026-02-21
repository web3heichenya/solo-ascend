// Alchemy NFT API service for fetching forger item details

export interface AlchemyNFTAttribute {
  trait_type: string;
  value: string | number;
}

export interface AlchemyNFTMetadata {
  name: string;
  description: string;
  image: string;
  attributes: AlchemyNFTAttribute[];
}

export interface AlchemyNFT {
  tokenId: string;
  tokenType: string;
  name: string;
  description: string;
  tokenUri: string;
  image: {
    cachedUrl?: string;
    thumbnailUrl?: string;
    pngUrl?: string;
    contentType?: string;
    size?: number;
    originalUrl?: string;
  };
  raw: {
    tokenUri: string;
    metadata: AlchemyNFTMetadata;
  };
  contract: {
    address: string;
    name: string;
    symbol: string;
    totalSupply?: string;
    tokenType: string;
    contractDeployer?: string;
    deployedBlockNumber?: number;
    openSeaMetadata: {
      floorPrice?: number;
      collectionName?: string;
      safelistRequestStatus?: string;
      imageUrl?: string;
      description?: string;
      externalUrl?: string;
      twitterUsername?: string;
      discordUrl?: string;
      lastIngestedAt?: string;
    };
  };
}

export interface AlchemyNFTsResponse {
  ownedNfts: AlchemyNFT[];
  totalCount: number;
  pageKey?: string;
}

export interface ForgerNFTData {
  tokenId: string;
  name: string;
  description: string;
  image: string;
  effectType: string;
  quality: string;
  attribute: string;
  value: number;
  createdAt: number;
}

/**
 * Fetches NFTs for a specific owner from a single contract address using Alchemy API
 */
export async function fetchNFTsForOwner(
  apiKey: string,
  ownerAddress: string,
  contractAddress: string,
  chainId: number = 1
): Promise<AlchemyNFT[]> {
  if (!apiKey || !ownerAddress || !contractAddress) {
    throw new Error('Missing required parameters: apiKey, ownerAddress, or contractAddress');
  }

  // Determine the chain endpoint
  const getChainEndpoint = (chainId: number) => {
    switch (chainId) {
      case 8453:
        return 'base-mainnet';
      case 84532:
        return 'base-sepolia';
      default:
        return 'base-mainnet';
    }
  };

  const chainEndpoint = getChainEndpoint(chainId);
  const baseUrl = `https://${chainEndpoint}.g.alchemy.com/nft/v3/${apiKey}/getNFTsForOwner`;

  const url = new URL(baseUrl);
  url.searchParams.set('owner', ownerAddress);
  url.searchParams.set('contractAddresses[]', contractAddress);
  // url.searchParams.set('withMetadata', 'true');
  url.searchParams.set('pageSize', '100');

  try {
    const response = await fetch(url.toString(), {
      method: 'GET',
      headers: {
        Accept: 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(`Alchemy API error: ${response.status} ${response.statusText}`);
    }

    const data: AlchemyNFTsResponse = await response.json();
    return data.ownedNfts || [];
  } catch (error) {
    console.error('Error fetching NFTs from Alchemy:', error);
    throw error;
  }
}

/**
 * Parse forger NFT metadata from Alchemy response
 */
export function parseForgerMetadata(nft: AlchemyNFT): ForgerNFTData | null {
  try {
    const metadata = nft.raw?.metadata;
    if (!metadata || !metadata.attributes) {
      return null;
    }

    // Extract attributes from the metadata
    const attributes = metadata.attributes.reduce(
      (acc, attr) => {
        acc[attr.trait_type] = attr.value;
        return acc;
      },
      {} as Record<string, string | number>
    );

    // Parse the forger-specific attributes
    const effectType = attributes['Effect Type'] as string;
    const quality = attributes['Quality'] as string;
    const attribute = attributes['Attribute'] as string;
    const value = Number(attributes['Value']) || 0;
    const createdAt = Number(attributes['Created At']) || 0;

    if (!effectType || !quality || !attribute) {
      console.warn('Missing required forger attributes in NFT:', nft.tokenId);
      return null;
    }

    return {
      tokenId: nft.tokenId,
      name: metadata.name || `Forger #${nft.tokenId}`,
      description: metadata.description || '',
      image: nft?.image?.cachedUrl || nft?.image?.originalUrl || metadata.image || '',
      effectType,
      quality,
      attribute,
      value,
      createdAt,
    };
  } catch (error) {
    console.error('Error parsing forger metadata for NFT:', nft.tokenId, error);
    return null;
  }
}

/**
 * Fetch and parse forger NFTs for a specific contract
 */
export async function fetchForgerNFTs(
  apiKey: string,
  ownerAddress: string,
  contractAddress: string,
  chainId: number = 1
): Promise<ForgerNFTData[]> {
  try {
    const nfts = await fetchNFTsForOwner(apiKey, ownerAddress, contractAddress, chainId);

    const forgerData: ForgerNFTData[] = [];
    for (const nft of nfts) {
      const parsed = parseForgerMetadata(nft);
      if (parsed) {
        forgerData.push(parsed);
      }
    }

    return forgerData;
  } catch (error) {
    console.error('Error fetching forger NFTs:', error);
    throw error;
  }
}
