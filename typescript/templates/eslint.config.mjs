// @ts-check

// https://typescript-eslint.io/getting-started/typed-linting

import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  eslint.configs.recommended,
  // // v1
  // ...tseslint.configs.recommended,
  
  // // v2
  // ...tseslint.configs.strict,
  // ...tseslint.configs.stylistic,

  // v3
  ...tseslint.configs.strictTypeChecked,
  ...tseslint.configs.stylisticTypeChecked,
  {
    files: ['**/*.{js,mjs,cjs,ts}'],
    ignores: ['dist/**/*', 'eslint.config.mjs', 'prettier.config.mjs'],
    languageOptions: {
      parserOptions: {
        project: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
  },
);