import { changeLocale } from '../actions';

import { CHANGE_LOCALE } from '../constants';

describe('LanguageProvider actions', () => {
  describe('Change Locale Action', () => {
    it('has a type of CHANGE_LOCALE and sets given locale', () => {
      const expected = {
        type: CHANGE_LOCALE,
        locale: 'de',
      };
      expect(changeLocale('de')).toEqual(expected);
    });
  });
});
