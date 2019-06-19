import languageProviderReducer from 'containers/Shared/LanguageProvider/reducer';
import { CHANGE_LOCALE } from 'containers/Shared/LanguageProvider/constants';
import { DEFAULT_LOCALE } from 'i18n';

/* eslint-disable default-case, no-param-reassign */
describe('languageProviderReducer', () => {
  it('returns the initial state with default locale', () => {
    expect(languageProviderReducer(undefined, {})).toEqual({
      locale: DEFAULT_LOCALE
    });
  });

  it('handles CHANGE_LOCALE', () => {
    expect(
      languageProviderReducer(undefined, {
        type: CHANGE_LOCALE,
        locale: 'de',
      }),
    ).toEqual({
      locale: 'de',
    });
  });
});
