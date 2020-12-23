import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';
import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { setUserData } from 'containers/Shared/App/actions';

import {
  GET_ENTERPRISE_BEGIN, UPDATE_ENTERPRISE_BEGIN, CONFIGURATION_UNMOUNT, UPDATE_BRANDING_BEGIN
} from 'containers/GlobalSettings/EnterpriseConfiguration/constants';

import {
  getEnterpriseBegin, getEnterpriseError,
  getEnterpriseSuccess, updateEnterpriseBegin,
  updateEnterpriseSuccess, updateEnterpriseError,
  updateBrandingSuccess, updateBrandingError
} from 'containers/GlobalSettings/EnterpriseConfiguration/actions';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

export function* getEnterprise(action) {
  try {
    const response = yield call(api.enterprises.getEnterprise.bind(api.enterprises));
    yield put(getEnterpriseSuccess(response.data));
    yield put(setUserData({ enterprise: response.data.enterprise }, true));
  } catch (err) {
    yield put(getEnterpriseError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.load, options: { variant: 'warning' } }));
  }
}

export function* updateEnterprise(action) {
  try {
    const payload = { enterprise: action.payload };
    const response = yield call(api.enterprises.updateEnterprise.bind(api.enterprises), payload);

    yield put(updateEnterpriseSuccess());
    yield put(setUserData({ enterprise: response.data.enterprise }, true));
    yield put(showSnackbar({ message: messages.snackbars.success.update, options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateEnterpriseError(err));

    yield put(showSnackbar({ message: messages.snackbars.errors.update, options: { variant: 'warning' } }));
  }
}

export function* updateBranding(action) {
  try {
    const payload = { enterprise: action.payload };
    const response = yield call(api.enterprises.updateBranding.bind(api.enterprises), payload);

    yield put(updateBrandingSuccess());
    yield put(setUserData({ enterprise: response.data.enterprise }, true));
    yield put(showSnackbar({ message: messages.snackbars.success.update, options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateBrandingError(err));

    yield put(showSnackbar({ message: messages.snackbars.errors.update, options: { variant: 'warning' } }));
  }
}

export default function* configurationSaga() {
  yield takeLatest(GET_ENTERPRISE_BEGIN, getEnterprise);
  yield takeLatest(UPDATE_ENTERPRISE_BEGIN, updateEnterprise);
  yield takeLatest(UPDATE_BRANDING_BEGIN, updateBranding);
}
