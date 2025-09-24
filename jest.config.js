module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  testTimeout: 20000,
  collectCoverageFrom: [
    'srv/**/*.{js,ts}',
    'db/**/*.{js,ts}',
    '!**/*.d.ts',
    '!**/node_modules/**',
    '!**/gen/**',
    '!**/dist/**'
  ],
  testMatch: [
    '**/test/**/*.test.{js,ts}',
    '**/tests/**/*.test.{js,ts}',
    '**/__tests__/**/*.{js,ts}'
  ],
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json'],
  transform: {
    '^.+\\.(ts|tsx)$': 'ts-jest',
    '^.+\\.(js|jsx)$': 'babel-jest'
  },
  setupFilesAfterEnv: ['<rootDir>/test/setup.js'],
  testPathIgnorePatterns: [
    '/node_modules/',
    '/gen/',
    '/dist/'
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  verbose: true
};