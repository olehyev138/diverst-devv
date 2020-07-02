import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_QUESTIONNAIRE_BY_TOKEN_BEGIN,
  SUBMIT_RESPONSE_BEGIN,
} from './constants';

import {
  getQuestionnaireByTokenSuccess, getQuestionnaireByTokenError,
  submitResponseSuccess, submitResponseError,
} from './actions';

export function* getQuestionnaireByToken(action) {
  try {
    const response = yield call(api.pollResponses.getQuestionnaire.bind(api.pollResponses), action.payload);

    yield put(getQuestionnaireByTokenSuccess(response.data));
  } catch (err) {
    yield put(getQuestionnaireByTokenError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: err.response.data, options: { variant: 'warning' } }));
    yield put(push(ROUTES.user.home.path()));
  }
}

export function* submitResponse(action) {
  try {
    const response = yield call(api.pollResponses.create.bind(api.pollResponses), action.payload);;

    yield put(submitResponseSuccess({}));
    yield put(showSnackbar({ message: 'Successfully submitted response', options: { variant: 'success' } }));
  } catch (err) {
    yield put(submitResponseError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: err.response.data, options: { variant: 'warning' } }));
    if (err.response.status === 400)
      yield put(push(ROUTES.user.home.path()));
  }
}


export default function* PollResponseSaga() {
  yield takeLatest(GET_QUESTIONNAIRE_BY_TOKEN_BEGIN, getQuestionnaireByToken);
  yield takeLatest(SUBMIT_RESPONSE_BEGIN, submitResponse);
}
