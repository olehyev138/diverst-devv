/*
Global mocks, mocks will be mocked for all testing suites
 */

// Intl mock
const mockIntl = jest.mock('containers/Shared/LanguageProvider/GlobalLanguageProvider', () => ({
  intl: {
    formatMessage: jest.fn(),
  },
}));

global.intl = mockIntl

