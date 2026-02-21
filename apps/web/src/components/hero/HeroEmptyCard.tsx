import { Card } from '@/components/ui/card';
import { useTranslation } from 'react-i18next';

export function HeroEmptyCard() {
  const { t } = useTranslation();

  return (
    <Card className="cyber-border cyber-card-glow bg-cyber-dark/20 mx-auto max-w-4xl p-6 md:p-8 lg:p-10">
      <div className="space-y-6 py-8 text-center">
        <div className="space-y-2">
          <h2 className="font-pixel text-cyber-pink neon-text text-lg">
            {t('hero.display.notFound')}
          </h2>
          <p className="text-cyber-blue opacity-80">{t('hero.display.checkId')}</p>
        </div>

        <div className="cyber-border bg-cyber-dark/30 mx-auto flex h-32 w-32 items-center justify-center rounded">
          <div className="text-6xl opacity-60">❓</div>
        </div>
      </div>
    </Card>
  );
}
