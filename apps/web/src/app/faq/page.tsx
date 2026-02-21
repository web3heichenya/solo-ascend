'use client';

import { useTranslation } from 'react-i18next';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';

import { getBaseUrl } from '@/lib/utils';
import { ChevronDown, ChevronRight } from 'lucide-react';
import { useState } from 'react';
import { FAQItem } from '@/types';
import {
  StructuredData,
  faqStructuredData,
  generateBreadcrumbStructuredData,
} from '@/components/seo/StructuredData';

export default function FAQ() {
  const { t } = useTranslation();
  const [openItems, setOpenItems] = useState<Set<string>>(new Set());

  const toggleItem = (id: string) => {
    const newOpenItems = new Set(openItems);
    if (newOpenItems.has(id)) {
      newOpenItems.delete(id);
    } else {
      newOpenItems.add(id);
    }
    setOpenItems(newOpenItems);
  };

  const faqItems: FAQItem[] = [
    {
      id: 'what-is-solo-ascend',
      question: t('faq.whatIsSoloAscend.question'),
      answer: t('faq.whatIsSoloAscend.answer'),
    },
    {
      id: 'how-to-mint-hero',
      question: t('faq.howToMintHero.question'),
      answer: t('faq.howToMintHero.answer'),
    },
    {
      id: 'what-is-forging',
      question: t('faq.whatIsForging.question'),
      answer: t('faq.whatIsForging.answer'),
    },
    {
      id: 'how-often-forge',
      question: t('faq.howOftenForge.question'),
      answer: t('faq.howOftenForge.answer'),
    },
    {
      id: 'what-are-oracles',
      question: t('faq.whatAreOracles.question'),
      answer: t('faq.whatAreOracles.answer'),
    },
    {
      id: 'hero-classes',
      question: t('faq.heroClasses.question'),
      answer: t('faq.heroClasses.answer'),
    },
    {
      id: 'what-is-tba',
      question: t('faq.whatIsTBA.question'),
      answer: t('faq.whatIsTBA.answer'),
    },
    {
      id: 'wallet-connection',
      question: t('faq.walletConnection.question'),
      answer: t('faq.walletConnection.answer'),
    },
    {
      id: 'network-requirements',
      question: t('faq.networkRequirements.question'),
      answer: t('faq.networkRequirements.answer'),
    },
    {
      id: 'gas-fees',
      question: t('faq.gasFees.question'),
      answer: t('faq.gasFees.answer'),
    },
    {
      id: 'api-key-setup',
      question: t('faq.apiKeySetup.question'),
      answer: t('faq.apiKeySetup.answer'),
    },
    {
      id: 'data-storage',
      question: t('faq.dataStorage.question'),
      answer: t('faq.dataStorage.answer'),
    },
    {
      id: 'future-plans',
      question: t('faq.futurePlans.question'),
      answer: t('faq.futurePlans.answer'),
    },
    {
      id: 'troubleshooting',
      question: t('faq.troubleshooting.question'),
      answer: t('faq.troubleshooting.answer'),
    },
  ];

  const breadcrumbData = generateBreadcrumbStructuredData([
    { name: 'Home', url: getBaseUrl() },
    { name: 'FAQ', url: `${getBaseUrl()}/faq` },
  ]);

  return (
    <>
      <StructuredData data={faqStructuredData} />
      <StructuredData data={breadcrumbData} />
      <div className="container mx-auto max-w-4xl">
        {/* Page Header */}
        <div className="mb-8 text-center">
          <h1 className="neon-cyan-text mb-4 text-2xl md:text-3xl">{t('faq.title')}</h1>
          <p className="text-cyber-blue text-sm opacity-80">{t('faq.subtitle')}</p>
        </div>

        {/* FAQ Items */}
        <div className="space-y-4">
          {faqItems.map((item) => (
            <Card
              key={item.id}
              className="cyber-border bg-black/60 backdrop-blur-sm transition-all duration-200 hover:bg-black/80"
            >
              <CardHeader
                className="cursor-pointer select-none"
                onClick={() => toggleItem(item.id)}
              >
                <CardTitle className="text-cyber-blue flex items-center justify-between">
                  <span className="text-sm md:text-base">{item.question}</span>
                  {openItems.has(item.id) ? (
                    <ChevronDown size={16} className="text-cyber-pink" />
                  ) : (
                    <ChevronRight size={16} className="text-cyber-pink" />
                  )}
                </CardTitle>
              </CardHeader>
              {openItems.has(item.id) && (
                <CardContent className="border-cyber-blue/20 border-t pt-4">
                  <div className="text-cyber-green/90 text-xs leading-relaxed whitespace-pre-line md:text-sm">
                    {item.answer}
                  </div>
                </CardContent>
              )}
            </Card>
          ))}
        </div>

        {/* Footer */}
        <div className="mt-12 text-center">
          <Card className="cyber-border bg-black/60 backdrop-blur-sm">
            <CardContent className="py-6">
              <h3 className="neon-cyan-text mb-2 text-lg">{t('faq.needMoreHelp.title')}</h3>
              <p className="text-cyber-blue mb-4 text-sm">{t('faq.needMoreHelp.description')}</p>
              <div className="flex flex-wrap justify-center gap-4">
                <Button className="pixel-button cyber-border text-xs">
                  {t('faq.needMoreHelp.discord')}
                </Button>
                <Button className="pixel-button cyber-border text-xs">
                  {t('faq.needMoreHelp.github')}
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </>
  );
}
