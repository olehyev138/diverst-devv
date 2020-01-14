import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  UPDATE_FIELD_DATA_BEGIN,
} from './constants';

import {
  updateFieldDataSuccess, updateFieldDataError,
} from './actions';

export function* updateFieldData(action) {
  try {
    const payload = { field_data: { field_data: action.payload.field_data } };
    const response = yield call(api.fieldData.updateFieldData.bind(api.fieldData), payload);

    yield put(updateFieldDataSuccess());
    yield put(showSnackbar({ message: 'Fields updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateFieldDataError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update fields', options: { variant: 'warning' } }));
  }
}

export default function* FieldDataSaga() {
  yield takeLatest(UPDATE_FIELD_DATA_BEGIN, updateFieldData);
}
