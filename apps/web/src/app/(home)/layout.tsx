import { pageMetadata } from '@/lib/seo';

export const metadata = pageMetadata.home;

export default function HomeLayout({ children }: { children: React.ReactNode }) {
  return children;
}
