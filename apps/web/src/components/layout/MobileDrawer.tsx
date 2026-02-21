'use client';

import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import Link from 'next/link';
import { HelpCircle, Menu, X, Home } from 'lucide-react';

export function MobileDrawer() {
  const { t } = useTranslation();
  const [isOpen, setIsOpen] = useState(false);

  const navigationItems = [
    {
      id: 'home',
      label: t('navigation.home'),
      icon: Home,
      path: '/',
    },
    {
      id: 'faq',
      label: t('ui.faq'),
      icon: HelpCircle,
      path: '/faq',
    },
  ];

  return (
    <>
      {/* Mobile Menu Button - only visible on mobile */}
      <div className="md:hidden">
        <button
          onClick={() => setIsOpen(true)}
          className="text-cyber-blue hover:text-cyber-pink p-2 transition-colors"
        >
          <Menu size={20} />
        </button>
      </div>

      {/* Drawer Overlay */}
      {isOpen && (
        <div
          className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm md:hidden"
          onClick={() => setIsOpen(false)}
        />
      )}

      {/* Drawer */}
      <div
        className={`fixed top-0 right-0 z-50 h-full w-80 transform bg-black/95 backdrop-blur-sm transition-transform duration-300 ease-in-out md:hidden ${
          isOpen ? 'translate-x-0' : 'translate-x-full'
        }`}
      >
        {/* Drawer Header */}
        <div className="flex items-center justify-between p-4">
          <h2 className="neon-cyan-text text-lg font-bold">{t('navigation.menu')}</h2>
          <button
            onClick={() => setIsOpen(false)}
            className="text-cyber-blue hover:text-cyber-pink p-2 transition-colors"
          >
            <X size={20} />
          </button>
        </div>

        {/* Navigation Items */}
        <nav className="p-4">
          <div className="space-y-2">
            {navigationItems.map((item) => {
              const IconComponent = item.icon;
              return (
                <Link
                  key={item.id}
                  href={item.path}
                  onClick={() => setIsOpen(false)}
                  className="text-cyber-blue hover:text-cyber-pink font-pixel flex w-full items-center justify-start gap-3 p-3 text-sm transition-colors"
                >
                  <IconComponent size={18} />
                  <span>{item.label}</span>
                </Link>
              );
            })}
          </div>
        </nav>
      </div>
    </>
  );
}
