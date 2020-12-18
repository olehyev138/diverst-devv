import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import messages from 'containers/Shared/CsvFile/messages';

import {
  CREATE_CSV_FILE_BEGIN,
} from './constants';

import {
  createCsvFileSuccess, createCsvFileError,
} from './actions';

export function* createCsvFile(action) {
  try {
    const payload = { csvfile: action.payload };

    const response = yield call(api.csvFiles.create.bind(api.csvFiles), payload);

    yield put(createCsvFileSuccess({}));
    yield put(showSnackbar({ message: messages.snackbars.success.create, options: { variant: 'success' } }));
    yield put(showSnackbar({ message: messages.snackbars.success.upload, options: { variant: 'success' } }));
  } catch (err) {
    yield put(createCsvFileError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: messages.snackbars.errors.create, options: { variant: 'warning' } }));
  }
}


export default function* CsvFileSaga() {
  yield takeLatest(CREATE_CSV_FILE_BEGIN, createCsvFile);
}
