import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_RESPONSE_BEGIN,
  GET_RESPONSES_BEGIN,
} from './constants';

import {
  getResponseSuccess, getResponseError,
  getResponsesSuccess, getResponsesError,
} from './actions';

export function* getResponse(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getResponseSuccess(response.data));
  } catch (err) {
    yield put(getResponseError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.response, options: { variant: 'warning' } }));
  }
}

export function* getResponses(action) {
  try {
    const response = yield call(api.pollResponses.all.bind(api.pollResponses), action.payload);

    yield put(getResponsesSuccess(response.data.page));
  } catch (err) {
    yield put(getResponsesError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.responses, options: { variant: 'warning' } }));
  }
}


export default function* ResponseSaga() {
  yield takeLatest(GET_RESPONSE_BEGIN, getResponse);
  yield takeLatest(GET_RESPONSES_BEGIN, getResponses);
}
