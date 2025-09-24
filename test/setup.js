// Jest setup file for CAP project
// This file is run before each test file

// Set test environment
process.env.NODE_ENV = 'test';
process.env.CDS_TEST_ENV_CHECK = 'y';

// Global test timeout
jest.setTimeout(20000);