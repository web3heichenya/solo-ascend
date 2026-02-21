import { dirname } from "path";
import { fileURLToPath } from "url";
import { FlatCompat } from "@eslint/eslintrc";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const compat = new FlatCompat({
  baseDirectory: __dirname,
});

const eslintConfig = [
  {
    ignores: [
      "node_modules/**",
      ".pnpm-store/**",
      "build/**",
      "dist/**",
      ".next/**",
      "out/**",
      ".DS_Store",
      "*.pem",
      "npm-debug.log*",
      "yarn-debug.log*",
      "yarn-error.log*",
      "pnpm-debug.log*",
      ".env*",
      ".turbo/**",
      "*.tsbuildinfo",
      "tailwind.config.ts"
    ]
  },
  ...compat.extends("next/core-web-vitals", "next/typescript"),
];

export default eslintConfig;
