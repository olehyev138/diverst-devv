import { createSelector } from 'reselect';
import { initialState } from 'containers/Shared/LanguageProvider/reducer';

/**
 * Direct selector to the languageToggle state domain
 */
const selectLanguage = state => state.language || initialState;

/**
 * Select the language locale
 */

const selectLocale = () => createSelector(
  selectLanguage,
  languageState => languageState.locale,
);

export { selectLanguage, selectLocale };
