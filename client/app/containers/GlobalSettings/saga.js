import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';
import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_SSOSETTING_BEGIN, UPDATE_SSOSETTING_BEGIN, SSOSETTING_UNMOUNT
} from 'containers/GlobalSettings/constants';

import {
  getSSOSettingBegin, getSSOSettingError,
  getSSOSettingSuccess, updateSSOSettingBegin,
  updateSSOSettingSuccess, updateSSOSettingError
} from 'containers/GlobalSettings/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getSSOSetting(action) {
  try {
    const response = yield call(api.settings.getSSOSetting.bind(api.settings));
    yield put(getSSOSettingSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getSSOSettingError(err));
    yield put(showSnackbar({ message: 'Failed to get sSOSetting', options: { variant: 'warning' } }));
  }
}

export function* updateSSOSetting(action) {
  try {
    const payload = { ssoSetting: action.payload };
    const response = yield call(api.settings.updateSSOSetting.bind(api.settings), payload);

    yield put(updateSSOSettingSuccess());
    // yield put(push(ROUTES.admin.manage.groups.index.path()));
    yield put(showSnackbar({ message: 'SSOSetting updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateSSOSettingError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update SSOSetting', options: { variant: 'warning' } }));
  }
}

export default function* configurationSaga() {
  yield takeLatest(GET_SSOSETTING_BEGIN, getSSOSetting);
  yield takeLatest(UPDATE_SSOSETTING_BEGIN, updateSSOSetting);
}
