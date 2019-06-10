import { selectLanguage, makeSelectLocale } from '../selectors';

describe('LanguageProvider selectors', () => {
  describe('selectLanguage', () => {
    it('should select the language state domain', () => {
      const mockedState = { language: {} };
      const selected = selectLanguage(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('makeSelectLocale', () => {
    it('should select the locale', () => {
      const mockedState = { locale: 'en' };
      const selected = makeSelectLocale().resultFunc(mockedState);

      expect(selected).toEqual('en');
    });
  });
});
