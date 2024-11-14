const fs = require('fs');
const path = require('path');

const prettierOptions = JSON.parse(
  fs.readFileSync(path.resolve(process.cwd(), '.prettierrc'), 'utf8'),
);

module.exports = {
  parser: '@babel/eslint-parser',
  extends: ['airbnb', 'prettier', 'prettier/react'],
  plugins: ['prettier', 'react', 'react-hooks', 'jsx-a11y'],
  env: {
    jest: true,
    browser: true,
    node: true,
    es6: true,
  },
  parserOptions: {
    ecmaVersion: 6,
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
      modules: true,
    },
  },
  rules: {
    'prettier/prettier': ['error', prettierOptions],
    'react/prop-types': 0,
    'jsx-a11y/no-static-element-interactions': 0,
    'jsx-a11y/click-events-have-key-events': 0,
    'no-param-reassign': 0,
    camelcase: 0,
  },
  settings: {
    'import/resolver': {
      webpack: {
        config: './config/webpack/development.js',
      },
    },
  },
};
