import type { Config } from 'tailwindcss';

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        background: 'var(--background)',
        foreground: 'var(--foreground)',
      },
      fontFamily: {
        pixel: ["'Zpix'", "'Press Start 2P'", 'monospace'],
        mono: ["'JetBrains Mono'", 'monospace'],
      },
      animation: {
        'neon-flicker': 'neon-flicker 0.15s infinite linear',
      },
      keyframes: {
        'neon-flicker': {
          '0%, 100%': { opacity: '1' },
          '50%': { opacity: '0.8' },
        },
      },
      backgroundImage: {
        'cyber-grid':
          'linear-gradient(rgba(0,255,255,0.1) 1px, transparent 1px), linear-gradient(90deg, rgba(0,255,255,0.1) 1px, transparent 1px)',
        'rainbow-gradient':
          'linear-gradient(45deg, #ff0040, #ff00ff, #8b00ff, #00ffff, #00ff41, #ffff00, #ff0040)',
      },
      backgroundSize: {
        grid: '20px 20px',
      },
    },
  },
  plugins: [],
};
export default config;
