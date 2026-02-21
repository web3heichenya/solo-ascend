import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';

// Import language resources directly
import enCommon from '../../public/locales/en/common.json';
import zhCommon from '../../public/locales/zh/common.json';

// Helper function to determine initial language
const getInitialLanguage = () => {
  // Check localStorage first (user preference)
  const savedLang = typeof window !== 'undefined' ? localStorage.getItem('i18nextLng') : null;
  if (savedLang && ['en', 'zh'].includes(savedLang)) {
    return savedLang;
  }

  // Check browser language
  if (typeof window !== 'undefined') {
    const browserLang = navigator.language || navigator.languages?.[0] || '';

    // Check for Chinese variants
    if (browserLang.startsWith('zh')) {
      return 'zh';
    }

    // Check for English variants
    if (browserLang.startsWith('en')) {
      return 'en';
    }
  }

  // Default fallback to English for non-Chinese/English browsers
  return 'en';
};

// Initialize i18next synchronously
i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    lng: getInitialLanguage(),
    fallbackLng: 'en',
    debug: false,

    interpolation: {
      escapeValue: false, // React already escapes values
    },

    detection: {
      // Language detection options
      order: ['localStorage', 'navigator', 'htmlTag'],
      caches: ['localStorage'],
      lookupLocalStorage: 'i18nextLng',
    },

    resources: {
      en: { common: enCommon },
      zh: { common: zhCommon },
    },

    // Set default namespace
    defaultNS: 'common',
    ns: ['common'],

    // Make sure initialization is complete
    initImmediate: false,
  });

export default i18n;
