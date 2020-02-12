import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

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
    yield put(showSnackbar({ message: 'Successfully uploaded csv file', options: { variant: 'success' } }));
    yield put(showSnackbar({ message: 'Users will be imported shortly, and we\'ll email you the results', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createCsvFileError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to uploaded csv file', options: { variant: 'warning' } }));
  }
}


export default function* CsvFileSaga() {
  yield takeLatest(CREATE_CSV_FILE_BEGIN, createCsvFile);
}
