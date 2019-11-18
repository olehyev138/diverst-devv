import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_SESSION_BEGIN,
  GET_LEADING_SESSIONS_BEGIN,
  GET_PARTICIPATING_SESSIONS_BEGIN,
  CREATE_SESSION_BEGIN,
  UPDATE_SESSION_BEGIN,
  DELETE_SESSION_BEGIN,
} from './constants';

import {
  getSessionSuccess, getSessionError,
  getLeadingSessionsSuccess, getLeadingSessionsError,
  getParticipatingSessionsSuccess, getParticipatingSessionsError,
  createSessionSuccess, createSessionError,
  updateSessionSuccess, updateSessionError,
  deleteSessionSuccess, deleteSessionError,
} from './actions';

export function* getSession(action) {
  try {
    const response = yield call(api.mentoringSessions.get.bind(api.mentoringSessions), action.payload.id);

    yield put(getSessionSuccess(response.data));
  } catch (err) {
    yield put(getSessionError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get session', options: { variant: 'warning' } }));
  }
}

export function* getLeadingSessions(action) {
  try {
    const { payload } = action;
    payload.creator_id = payload.userId;
    payload.delete('userId');

    const response = yield call(api.mentoringSessions.all.bind(api.mentoringSessions), payload);

    yield put(getLeadingSessionsSuccess(response.data.page));
  } catch (err) {
    yield put(getLeadingSessionsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get leading sessions', options: { variant: 'warning' } }));
  }
}

export function* getParticipatingSessions(action) {
  try {
    const { payload } = action;
    payload.user_id = payload.userId;
    payload.delete('userId');

    const response = yield call(api.mentorshipSessions.all.bind(api.mentorshipSessions), payload);

    yield put(getParticipatingSessionsSuccess(response.data.page));
  } catch (err) {
    yield put(getParticipatingSessionsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get participating sessions', options: { variant: 'warning' } }));
  }
}

export function* createSession(action) {
  try {
    const payload = { mentoring_sessions: action.payload };
    const response = yield call(api.groups.create.bind(api.groups), payload.group.id, payload);

    yield put(createSessionSuccess());
    yield put(showSnackbar({ message: 'Successfully created session', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createSessionError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create session', options: { variant: 'warning' } }));
  }
}

export function* updateSession(action) {
  try {
    const payload = { mentoring_sessions: action.payload };
    const response = yield call(api.groups.update.bind(api.groups), payload.group.id, payload);

    yield put(updateSessionSuccess());
    yield put(showSnackbar({ message: 'Successfully updated session', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateSessionError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update session', options: { variant: 'warning' } }));
  }
}

export function* deleteSession(action) {
  try {
    const { userId } = action.payload;

    yield call(api.groups.destroy.bind(api.groups), action.payload.id);
    yield put(push('/'));

    yield put(deleteSessionSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted session', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteSessionError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete session', options: { variant: 'warning' } }));
  }
}


export default function* SessionSaga() {
  yield takeLatest(GET_SESSION_BEGIN, getSession);
  yield takeLatest(GET_LEADING_SESSIONS_BEGIN, getLeadingSessions);
  yield takeLatest(GET_PARTICIPATING_SESSIONS_BEGIN, getParticipatingSessions);
  yield takeLatest(CREATE_SESSION_BEGIN, createSession);
  yield takeLatest(UPDATE_SESSION_BEGIN, updateSession);
  yield takeLatest(DELETE_SESSION_BEGIN, deleteSession);
}
