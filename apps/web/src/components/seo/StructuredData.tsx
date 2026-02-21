import { getBaseUrl } from '@/lib/utils';

export interface StructuredDataProps {
  data: Record<string, unknown>;
}

export function StructuredData({ data }: StructuredDataProps) {
  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{
        __html: JSON.stringify(data, null, 2),
      }}
    />
  );
}

export const websiteStructuredData = {
  '@context': 'https://schema.org',
  '@type': 'WebSite',
  name: 'Solo Ascend',
  url: getBaseUrl(),
  description:
    'Mint unique NFT heroes, forge them daily, and watch them evolve in this fully on-chain RPG game.',
  inLanguage: 'zh-CN',
  author: {
    '@type': 'Organization',
    name: 'Solo Ascend Team',
    url: getBaseUrl(),
  },
  publisher: {
    '@type': 'Organization',
    name: 'Solo Ascend',
    url: getBaseUrl(),
  },
  potentialAction: {
    '@type': 'SearchAction',
    target: {
      '@type': 'EntryPoint',
      urlTemplate: `${getBaseUrl()}/search?q={search_term_string}`,
    },
    'query-input': 'required name=search_term_string',
  },
};

export const gameStructuredData = {
  '@context': 'https://schema.org',
  '@type': 'VideoGame',
  name: 'Solo Ascend',
  url: getBaseUrl(),
  description:
    'A Web3 hero forging game where players mint unique NFT heroes and evolve them through blockchain-based gameplay.',
  genre: ['RPG', 'Strategy', 'Blockchain Gaming'],
  gamePlatform: 'Web Browser',
  applicationCategory: 'Game',
  operatingSystem: 'Web Browser',
  author: {
    '@type': 'Organization',
    name: 'Solo Ascend Team',
  },
  publisher: {
    '@type': 'Organization',
    name: 'Solo Ascend',
  },
  offers: {
    '@type': 'Offer',
    price: '0',
    priceCurrency: 'USD',
    availability: 'https://schema.org/InStock',
  },
  gameItem: [
    {
      '@type': 'Thing',
      name: 'Hero NFT',
      description: 'Unique collectible heroes that can be forged and evolved',
    },
    {
      '@type': 'Thing',
      name: 'Forge Items',
      description: 'Items used to upgrade and evolve heroes',
    },
  ],
};

export const organizationStructuredData = {
  '@context': 'https://schema.org',
  '@type': 'Organization',
  name: 'Solo Ascend',
  url: getBaseUrl(),
  logo: `${getBaseUrl()}/logo.png`,
  description:
    'Web3 gaming platform specializing in NFT hero forging and blockchain-based RPG experiences.',
  sameAs: ['https://twitter.com/web3heichen'],
  contactPoint: {
    '@type': 'ContactPoint',
    contactType: 'Customer Service',
    availableLanguage: ['Chinese', 'English'],
  },
};

export const faqStructuredData = {
  '@context': 'https://schema.org',
  '@type': 'FAQPage',
  mainEntity: [
    {
      '@type': 'Question',
      name: 'What is Solo Ascend?',
      acceptedAnswer: {
        '@type': 'Answer',
        text: 'Solo Ascend is a fully on-chain Web3 RPG game where players mint unique hero NFTs, forge them daily to improve their stats and evolve their appearance, and experience blockchain-based gaming mechanics.',
      },
    },
    {
      '@type': 'Question',
      name: 'How do I mint a hero?',
      acceptedAnswer: {
        '@type': 'Answer',
        text: 'Connect your Web3 wallet (like MetaMask), ensure you have enough ETH for gas fees and minting cost, then click the "Mint Hero" button to create your unique hero NFT.',
      },
    },
    {
      '@type': 'Question',
      name: 'What is forging?',
      acceptedAnswer: {
        '@type': 'Answer',
        text: 'Forging is the core mechanic where you can upgrade your hero daily. Each forge operation uses an oracle to randomly determine stat improvements and potential visual evolutions.',
      },
    },
    {
      '@type': 'Question',
      name: 'What are Token Bound Accounts (TBA)?',
      acceptedAnswer: {
        '@type': 'Answer',
        text: 'TBA allows your hero NFTs to own other assets like tokens and NFTs, creating a richer gaming experience where heroes can have their own inventories and possessions.',
      },
    },
  ],
};

export function generateBreadcrumbStructuredData(items: Array<{ name: string; url?: string }>) {
  return {
    '@context': 'https://schema.org',
    '@type': 'BreadcrumbList',
    itemListElement: items.map((item, index) => ({
      '@type': 'ListItem',
      position: index + 1,
      name: item.name,
      ...(item.url && { item: item.url }),
    })),
  };
}
