import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';


import {
  GET_LOGS_BEGIN, EXPORT_LOGS_BEGIN
} from 'containers/Log/constants';

import {
  getLogsSuccess, getLogsError,
  exportLogsError, exportLogsSuccess
} from 'containers/Log/actions';

export function* getLogs(action) {
  try {
    const response = yield call(api.activities.all.bind(api.activities), action.payload);
    console.log(response.data.page);
    yield put(getLogsSuccess(response.data.page));
  } catch (err) {
    console.log(err.response);
    yield put(getLogsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load logs', options: { variant: 'warning' } }));
  }
}

export function* exportLogs(action) {
  try {
    const response = yield call(api.activities.csvExport.bind(api.activities), action.payload);

    yield put(exportLogsSuccess({}));
    yield put(showSnackbar({ message: 'Successfully exported logs', options: { variant: 'success' } }));
  } catch (err) {
    yield put(exportLogsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to export logs', options: { variant: 'warning' } }));
  }
}

export default function* segmentsSaga() {
  yield takeLatest(GET_LOGS_BEGIN, getLogs);
  yield takeLatest(EXPORT_LOGS_BEGIN, exportLogs);
}
