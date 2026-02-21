'use client';
import { useTranslation } from 'react-i18next';
import Link from 'next/link';
import { LanguageSwitcher } from '../ui/LanguageSwitcher';
import { WalletConnect } from '../wallet/WalletConnect';
import { MobileDrawer } from '../layout/MobileDrawer';

const Header = () => {
  const { t } = useTranslation();

  return (
    <header className="flex flex-shrink-0 items-center justify-between p-4 md:p-6">
      <div className="flex items-center gap-10">
        {/* Logo */}
        <Link href="/" className="flex cursor-pointer flex-col items-center justify-center">
          <h1 className="neon-cyan-text text-lg md:text-xl">{t('app.title')}</h1>
          <p className="text-cyber-blue mt-1 text-xs opacity-80">{t('app.subtitle')}</p>
        </Link>

        {/* Desktop Navigation */}
        <nav className="hidden items-center gap-6 md:flex">
          <Link
            href="/faq"
            className="text-cyber-blue hover:text-cyber-pink font-pixel cursor-pointer text-sm transition-colors"
          >
            {t('ui.faq')}
          </Link>
        </nav>
      </div>

      <div className="flex flex-shrink-0 items-center gap-3">
        <LanguageSwitcher />
        <WalletConnect />
        <MobileDrawer />
      </div>
    </header>
  );
};

export default Header;
