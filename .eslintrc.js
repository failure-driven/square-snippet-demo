module.exports = {
    "env": {
        "browser": true,
        "es2021": true,
        "jest": true,
        "node": true,
    },
    "extends": ["eslint:recommended", "plugin:import/recommended"],
    "overrides": [
      {
        "files": "**/*.svelte",
        "processor": "svelte3/svelte3"
      }
    ],
    "parserOptions": {
      "ecmaVersion": 12, // 2019, // 12
      "sourceType": "module",
    },
    "rules": {
    },
    "plugins": ["import", "svelte3"] 
};
