import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';


import {
  GET_LOGS_BEGIN
} from 'containers/Log/constants';

import {
  getLogsSuccess, getLogsError,
} from 'containers/Log/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getLogs(action) {
  try {
    console.log('saga');
    const response = yield call(api.activities.all.bind(api.activities), action.payload);
    console.log(response);
    yield put(getLogsSuccess(response.data.page));
  } catch (err) {
    // console.log(err);
    // console.log(err.response);
    yield put(getLogsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load logs', options: { variant: 'warning' } }));
  }
}

export default function* segmentsSaga() {
  yield takeLatest(GET_LOGS_BEGIN, getLogs);
}
