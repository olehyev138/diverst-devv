import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  UPDATE_SSO_SETTINGS_BEGIN,
} from './constants';

import {
  updateSsoSettingsSuccess, updateSsoSettingsError,
} from './actions';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from 'containers/GlobalSettings/EnterpriseConfiguration/messages';

export function* updateSsoSettings(action) {
  try {
    const payload = { enterprise: action.payload };
    const response = yield call(api.enterprises.updateSSO.bind(api.enterprises), payload);


    yield put(updateSsoSettingsSuccess({}));
    yield put(showSnackbar({ message: messages.snackbars.success.update, options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateSsoSettingsError(err));

    yield put(showSnackbar({ message: messages.snackbars.errors.update, options: { variant: 'warning' } }));
  }
}


export default function* SSOSettingsSaga() {
  yield takeLatest(UPDATE_SSO_SETTINGS_BEGIN, updateSsoSettings);
}
