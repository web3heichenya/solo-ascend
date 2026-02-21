'use client';

import NextNProgress from 'nextjs-progressbar';

export function ProgressBar() {
  return (
    <NextNProgress
      color="#3b82f6"
      startPosition={0.1}
      stopDelayMs={500}
      height={3}
      showOnShallow={true}
      options={{
        showSpinner: false,
      }}
    />
  );
}
