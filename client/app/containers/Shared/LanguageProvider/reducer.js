/*
 *
 * LanguageProvider reducer
 *
 */
import produce from 'immer';

import { CHANGE_LOCALE } from './constants';
import { DEFAULT_LOCALE } from 'i18n';

export const initialState = {
  locale: DEFAULT_LOCALE,
};

const languageProviderReducer = (state = initialState, action) => produce(state, (draft) => {
// eslint-disable-next-line default-case
  switch (action.type) {
    case CHANGE_LOCALE:
      draft.locale = action.locale;
      break;
  }
});

export default languageProviderReducer;
