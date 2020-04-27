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
import { createEventSuccess, deleteEventSuccess } from 'containers/Event/actions';

export function* getPoll(action) {
  try {
    const response = yield call(api.polls.get.bind(api.polls), action.payload.id);

    yield put(getPollSuccess(response.data));
  } catch (err) {
    yield put(getPollError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get poll', options: { variant: 'warning' } }));
  }
}

export function* getPolls(action) {
  try {
    const response = yield call(api.polls.all.bind(api.polls), action.payload);

    yield put(getPollsSuccess(response.data.page));
  } catch (err) {
    yield put(getPollsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get polls', options: { variant: 'warning' } }));
  }
}

export function* createPoll(action) {
  try {
    const payload = { poll: action.payload };

    const response = yield call(api.polls.create.bind(api.polls), payload);

    yield put(createPollSuccess({}));
    yield put(push(ROUTES.admin.include.polls.index.path()));
    yield put(showSnackbar({ message: 'Successfully created poll', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createPollError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create poll', options: { variant: 'warning' } }));
  }
}

export function* updatePoll(action) {
  try {
    const payload = { poll: action.payload };

    const response = yield call(api.polls.update.bind(api.polls), action.payload.id, payload);

    yield put(updatePollSuccess({}));
    yield put(push(ROUTES.admin.include.polls.index.path()));
    yield put(showSnackbar({ message: 'Successfully updated poll', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updatePollError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update poll', options: { variant: 'warning' } }));
  }
}

export function* deletePoll(action) {
  try {
    yield call(api.polls.destroy.bind(api.polls), action.payload.id);
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
