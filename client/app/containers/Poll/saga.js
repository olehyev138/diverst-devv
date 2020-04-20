import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_POLL_BEGIN,
  GET_POLLS_BEGIN,
  CREATE_POLL_BEGIN,
  UPDATE_POLL_BEGIN,
  DELETE_POLL_BEGIN,
} from './constants';

import {
  getPollSuccess, getPollError,
  getPollsSuccess, getPollsError,
  createPollSuccess, createPollError,
  updatePollSuccess, updatePollError,
  deletePollSuccess, deletePollError,
} from './actions';

export function* getPoll(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getPollSuccess(response.data));
  } catch (err) {
    yield put(getPollError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get poll', options: { variant: 'warning' } }));
  }
}

export function* getPolls(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getPollsSuccess(response.data.page));
  } catch (err) {
    yield put(getPollsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get polls', options: { variant: 'warning' } }));
  }
}

export function* createPoll(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(createPollSuccess({}));
    yield put(showSnackbar({ message: 'Successfully created poll', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createPollError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create poll', options: { variant: 'warning' } }));
  }
}

export function* updatePoll(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(updatePollSuccess({}));
    yield put(showSnackbar({ message: 'Successfully updated poll', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updatePollError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update poll', options: { variant: 'warning' } }));
  }
}

export function* deletePoll(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(deletePollSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted poll', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deletePollError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete poll', options: { variant: 'warning' } }));
  }
}


export default function* PollSaga() {
  yield takeLatest(GET_POLL_BEGIN, getPoll);
  yield takeLatest(GET_POLLS_BEGIN, getPolls);
  yield takeLatest(CREATE_POLL_BEGIN, createPoll);
  yield takeLatest(UPDATE_POLL_BEGIN, updatePoll);
  yield takeLatest(DELETE_POLL_BEGIN, deletePoll);
}
