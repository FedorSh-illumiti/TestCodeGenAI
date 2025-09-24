// Simple test to verify Jest setup
describe('Development Environment', () => {
  test('should be properly configured', () => {
    expect(1 + 1).toBe(2);
  });

  test('should have access to CDS', () => {
    const cds = require('@sap/cds');
    expect(cds).toBeDefined();
  });
});