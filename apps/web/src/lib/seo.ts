import type { Metadata } from 'next';
import { getBaseUrl } from '@/lib/utils';

export const siteConfig = {
  name: 'Solo Ascend',
  title: 'Solo Ascend - Web3 Hero Forging Game',
  description:
    'Mint unique NFT heroes, forge them daily, and watch them evolve in this fully on-chain RPG game. Experience the future of Web3 gaming with blockchain-based hero evolution, forging mechanics, and token-bound accounts.',
  url: getBaseUrl(),
  ogImage: '/og-image.png',
  twitterHandle: '@web3heichen',
  keywords: [
    'Web3 Gaming',
    'NFT',
    'RPG',
    'Blockchain Game',
    'Hero NFT',
    'Forging',
    'Token Bound Accounts',
    'TBA',
    'DeFi Gaming',
    'Play to Earn',
    'Ethereum',
    'On-chain Gaming',
    'Digital Collectibles',
    'GameFi',
  ],
  authors: [{ name: 'Solo Ascend Team' }],
  creator: 'Solo Ascend',
  publisher: 'Solo Ascend',
};

export function generateMetadata({
  title,
  description,
  image,
  url,
  noIndex = false,
  keywords,
}: {
  title?: string;
  description?: string;
  image?: string;
  url?: string;
  noIndex?: boolean;
  keywords?: string[];
} = {}): Metadata {
  const metaTitle = title ? `${title} | ${siteConfig.name}` : siteConfig.title;
  const metaDescription = description || siteConfig.description;
  const metaImage = image || siteConfig.ogImage;
  const metaUrl = url ? `${siteConfig.url}${url}` : siteConfig.url;
  const metaKeywords = keywords ? [...siteConfig.keywords, ...keywords] : siteConfig.keywords;

  return {
    title: metaTitle,
    description: metaDescription,
    keywords: metaKeywords,
    authors: siteConfig.authors,
    creator: siteConfig.creator,
    publisher: siteConfig.publisher,
    robots: {
      index: !noIndex,
      follow: !noIndex,
      googleBot: {
        index: !noIndex,
        follow: !noIndex,
        'max-video-preview': -1,
        'max-image-preview': 'large',
        'max-snippet': -1,
      },
    },
    openGraph: {
      type: 'website',
      locale: 'zh_CN',
      url: metaUrl,
      title: metaTitle,
      description: metaDescription,
      siteName: siteConfig.name,
      images: [
        {
          url: metaImage,
          width: 1200,
          height: 630,
          alt: metaTitle,
        },
      ],
    },
    twitter: {
      card: 'summary_large_image',
      site: siteConfig.twitterHandle,
      creator: siteConfig.twitterHandle,
      title: metaTitle,
      description: metaDescription,
      images: [metaImage],
    },
    category: 'Gaming',
    applicationName: siteConfig.name,
    referrer: 'origin-when-cross-origin',
  };
}

export const defaultMetadata = generateMetadata();

export const rootLayoutMetadata: Metadata = {
  title: {
    default: siteConfig.title,
    template: `%s | ${siteConfig.name}`,
  },
  description: siteConfig.description,
  keywords: siteConfig.keywords,
  authors: siteConfig.authors,
  creator: siteConfig.creator,
  publisher: siteConfig.publisher,
  icons: ['/icons/logo.png'],
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  openGraph: {
    type: 'website',
    locale: 'zh_CN',
    url: siteConfig.url,
    title: siteConfig.title,
    description: siteConfig.description,
    siteName: siteConfig.name,
    images: [
      {
        url: siteConfig.ogImage,
        width: 1200,
        height: 630,
        alt: siteConfig.title,
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    site: siteConfig.twitterHandle,
    creator: siteConfig.twitterHandle,
    title: siteConfig.title,
    description: siteConfig.description,
    images: [siteConfig.ogImage],
  },
  verification: {
    google: 'your-google-site-verification-code',
  },
  category: 'Gaming',
  applicationName: siteConfig.name,
  referrer: 'origin-when-cross-origin',
};

export const pageMetadata = {
  home: {
    title: 'Home',
    description:
      'Welcome to Solo Ascend - Start your journey in the Web3 hero forging universe. Mint, forge, and evolve your unique NFT heroes.',
  },
  faq: {
    title: 'FAQ',
    description:
      'Frequently asked questions about Solo Ascend - Web3 hero forging game. Learn about minting, forging, token-bound accounts, and more.',
  },
};
