import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';
import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_ENTERPRISE_BEGIN, UPDATE_ENTERPRISE_BEGIN, CONFIGURATION_UNMOUNT
} from 'containers/GlobalSettings/EnterpriseConfiguration/constants';

import {
  getEnterpriseBegin, getEnterpriseError,
  getEnterpriseSuccess, updateEnterpriseBegin,
  updateEnterpriseSuccess, updateEnterpriseError
} from 'containers/GlobalSettings/EnterpriseConfiguration/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getEnterprise(action) {
  try {
    const response = yield call(api.enterprises.get.bind(api.enterprises), action.payload.id);
    yield put(getEnterpriseSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getEnterpriseError(err));
    yield put(showSnackbar({ message: 'Failed to get enterprise', options: { variant: 'warning' } }));
  }
}

export function* updateEnterprise(action) {
  try {
    const payload = { group: action.payload };
    const response = yield call(api.enterprises.update.bind(api.enterprises), payload.enterprise.id, payload);

    yield put(updateEnterpriseSuccess());
    yield put(push(ROUTES.admin.manage.groups.index.path()));
    yield put(showSnackbar({ message: 'Enterprise updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateEnterpriseError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update enterprise', options: { variant: 'warning' } }));
  }
}

export default function* configurationSaga() {
  yield takeLatest(GET_ENTERPRISE_BEGIN, getEnterprise);
  yield takeLatest(UPDATE_ENTERPRISE_BEGIN, updateEnterprise);
}
