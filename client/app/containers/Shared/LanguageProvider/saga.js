import { takeLatest } from 'redux-saga/effects';

import { CHANGE_LOCALE } from './constants';

import { getLanguageStringFromLocaleString } from 'utils/localeHelpers';

const axios = require('axios');

export function* changeLocale(action) {
  const { locale } = action;
  axios.defaults.headers.common['Diverst-Locale'] = getLanguageStringFromLocaleString(locale);
}

export default function* languageProviderSaga() {
  yield takeLatest(CHANGE_LOCALE, changeLocale);
}
