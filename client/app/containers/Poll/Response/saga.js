import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_RESPONSE_BEGIN,
  GET_RESPONSES_BEGIN,
  CREATE_RESPONSE_BEGIN,
  UPDATE_RESPONSE_BEGIN,
  DELETE_RESPONSE_BEGIN,
} from './constants';

import {
  getResponseSuccess, getResponseError,
  getResponsesSuccess, getResponsesError,
  createResponseSuccess, createResponseError,
  updateResponseSuccess, updateResponseError,
  deleteResponseSuccess, deleteResponseError,
} from './actions';

export function* getResponse(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getResponseSuccess(response.data));
  } catch (err) {
    yield put(getResponseError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get response', options: { variant: 'warning' } }));
  }
}

export function* getResponses(action) {
  try {
    const response = yield call(api.pollResponses.all.bind(api.pollResponses), action.payload);

    yield put(getResponsesSuccess(response.data.page));
  } catch (err) {
    yield put(getResponsesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get responses', options: { variant: 'warning' } }));
  }
}

export function* createResponse(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(createResponseSuccess({}));
    yield put(showSnackbar({ message: 'Successfully created response', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createResponseError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create response', options: { variant: 'warning' } }));
  }
}

export function* updateResponse(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(updateResponseSuccess({}));
    yield put(showSnackbar({ message: 'Successfully updated response', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateResponseError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update response', options: { variant: 'warning' } }));
  }
}

export function* deleteResponse(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(deleteResponseSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted response', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteResponseError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete response', options: { variant: 'warning' } }));
  }
}


export default function* ResponseSaga() {
  yield takeLatest(GET_RESPONSE_BEGIN, getResponse);
  yield takeLatest(GET_RESPONSES_BEGIN, getResponses);
  yield takeLatest(CREATE_RESPONSE_BEGIN, createResponse);
  yield takeLatest(UPDATE_RESPONSE_BEGIN, updateResponse);
  yield takeLatest(DELETE_RESPONSE_BEGIN, deleteResponse);
}
