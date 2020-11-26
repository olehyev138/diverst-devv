import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import messages from './messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

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

    yield put(getLogsSuccess(response.data.page));
  } catch (err) {
    yield put(getLogsError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.logs, options: { variant: 'warning' } }));
  }
}

export function* exportLogs(action) {
  try {
    const response = yield call(api.activities.csvExport.bind(api.activities), action.payload);

    yield put(exportLogsSuccess({}));
    yield put(showSnackbar({ message: messages.snackbars.success.export, options: { variant: 'success' } }));
  } catch (err) {
    yield put(exportLogsError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.export, options: { variant: 'warning' } }));
  }
}

export default function* segmentsSaga() {
  yield takeLatest(GET_LOGS_BEGIN, getLogs);
  yield takeLatest(EXPORT_LOGS_BEGIN, exportLogs);
}
