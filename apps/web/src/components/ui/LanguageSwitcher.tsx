'use client';

import { useTranslation } from 'react-i18next';
import { useAppStore } from '@/lib/store';
import { Languages, ChevronDown } from 'lucide-react';
import * as Select from '@radix-ui/react-select';
import { cn } from '@/lib/utils';
import { useMemo, useEffect } from 'react';

const languages = [
  { code: 'zh', name: '中文', flag: '🇨🇳' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
];

export function LanguageSwitcher() {
  const { i18n } = useTranslation();
  const { language, setLanguage } = useAppStore();

  // Initialize store language from i18n on mount
  useEffect(() => {
    if (!language && i18n.language) {
      setLanguage(i18n.language);
    }
  }, [language, i18n.language, setLanguage]);

  // 使用 useMemo 稳定化 currentLanguage 计算，避免无限循环
  const currentLanguage = useMemo(() => {
    return languages.find((lang) => lang.code === (language || i18n.language)) || languages[0];
  }, [language, i18n.language]);

  const handleLanguageChange = (langCode: string) => {
    // 避免不必要的更新
    if (langCode === language || langCode === i18n.language) return;

    i18n.changeLanguage(langCode);
    setLanguage(langCode);
  };

  return (
    <Select.Root value={currentLanguage.code} onValueChange={handleLanguageChange}>
      <Select.Trigger
        className={cn(
          'font-pixel text-cyber-blue hover:bg-cyber-blue hover:text-cyber-dark focus:ring-cyber-blue flex flex-shrink-0 cursor-pointer items-center justify-center rounded border bg-transparent text-xs focus:ring-2 focus:outline-none',
          // Desktop: 带文字和下拉箭头的完整按钮
          'h-8 w-[72px] gap-1 px-2 sm:gap-1',
          // Mobile: 方形按钮，只显示图标
          'h-10 w-10 p-0 sm:h-8 sm:w-[72px] sm:px-2'
        )}
      >
        <Languages className="h-4 w-4 flex-shrink-0 sm:h-3 sm:w-3" />
        <span className="font-pixel hidden text-xs leading-none sm:inline">
          <Select.Value>{currentLanguage.code.toUpperCase()}</Select.Value>
        </span>
        <Select.Icon className="hidden sm:block">
          <ChevronDown className="h-3 w-3 flex-shrink-0" />
        </Select.Icon>
      </Select.Trigger>

      <Select.Portal>
        <Select.Content
          className="border-cyber-blue z-[200] max-h-[calc(100vh-100px)] min-w-[120px] overflow-hidden rounded border-2 bg-[var(--background)] shadow-lg"
          position="popper"
          side="bottom"
          align="end"
          sideOffset={4}
        >
          <Select.Viewport className="p-1">
            {languages.map((lang) => (
              <Select.Item
                key={lang.code}
                value={lang.code}
                className={cn(
                  'hover:bg-cyber-blue/20 focus:bg-cyber-blue/20 flex w-full cursor-pointer items-center gap-2 rounded px-3 py-2 text-left text-xs transition-colors focus:outline-none',
                  currentLanguage.code === lang.code ? 'text-cyber-pink' : 'text-cyber-blue'
                )}
              >
                <span className="text-sm leading-none">{lang.flag}</span>
                <Select.ItemText>
                  <span className="font-pixel text-xs leading-none">{lang.name}</span>
                </Select.ItemText>
              </Select.Item>
            ))}
          </Select.Viewport>
        </Select.Content>
      </Select.Portal>
    </Select.Root>
  );
}
