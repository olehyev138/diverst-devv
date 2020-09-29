import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_SESSION_BEGIN,
  GET_HOSTING_SESSIONS_BEGIN,
  GET_PARTICIPATING_SESSIONS_BEGIN,
  GET_PARTICIPATING_USERS_BEGIN,
  CREATE_SESSION_BEGIN,
  UPDATE_SESSION_BEGIN,
  DELETE_SESSION_BEGIN,
  ACCEPT_INVITATION_BEGIN,
  DECLINE_INVITATION_BEGIN,
} from './constants';

import {
  getSessionSuccess, getSessionError,
  getHostingSessionsSuccess, getHostingSessionsError,
  getParticipatingSessionsSuccess, getParticipatingSessionsError,
  getParticipatingUsersSuccess, getParticipatingUsersError,
  createSessionSuccess, createSessionError,
  updateSessionSuccess, updateSessionError,
  deleteSessionSuccess, deleteSessionError,
  acceptInvitationSuccess, acceptInvitationError,
  declineInvitationSuccess, declineInvitationError,
} from './actions';

export function* getSession(action) {
  try {
    const response = yield call(api.mentoringSessions.get.bind(api.mentoringSessions), action.payload.id);

    yield put(getSessionSuccess(response.data));
  } catch (err) {
    yield put(getSessionError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.session, options: { variant: 'warning' } }));
  }
}

export function* getHostingSessions(action) {
  try {
    const { payload } = action;
    payload.creator_id = payload.userId;
    delete payload.userId;

    const response = yield call(api.mentoringSessions.all.bind(api.mentoringSessions), payload);

    yield put(getHostingSessionsSuccess(response.data.page));
  } catch (err) {
    yield put(getHostingSessionsError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.hosting, options: { variant: 'warning' } }));
  }
}

export function* getParticipatingSessions(action) {
  try {
    const { payload } = action;
    payload.user_id = payload.userId;
    payload.includes = ['mentoring_session'];
    delete payload.userId;

    const response = yield call(api.mentorshipSessions.all.bind(api.mentorshipSessions), payload);

    yield put(getParticipatingSessionsSuccess(response.data.page));
  } catch (err) {
    yield put(getParticipatingSessionsError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.participating, options: { variant: 'warning' } }));
  }
}

export function* getParticipatingUsers(action) {
  try {
    const { payload } = action;
    payload.mentoring_session_id = payload.sessionId;
    payload.includes = ['user'];
    delete payload.sessionId;

    const response = yield call(api.mentorshipSessions.all.bind(api.mentorshipSessions), payload);

    yield put(getParticipatingUsersSuccess(response.data.page));
  } catch (err) {
    yield put(getParticipatingUsersError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.participating_users, options: { variant: 'warning' } }));
  }
}

export function* createSession(action) {
  try {
    const payload = { mentoring_session: action.payload };
    const response = yield call(api.mentoringSessions.create.bind(api.mentoringSessions), payload);

    yield put(createSessionSuccess());
    yield put(push(ROUTES.user.mentorship.sessions.hosting.path(action.payload.creator_id)));
    yield put(showSnackbar({ message: messages.snackbars.success.create, options: { variant: 'success' } }));
  } catch (err) {
    yield put(createSessionError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.create, options: { variant: 'warning' } }));
  }
}

export function* updateSession(action) {
  try {
    const payload = { mentoring_session: action.payload };
    const response = yield call(api.mentoringSessions.update.bind(api.mentoringSessions), payload.mentoring_session.id, payload);

    yield put(updateSessionSuccess());
    yield put(push(ROUTES.user.mentorship.sessions.hosting.path(action.payload.creator_id)));
    yield put(showSnackbar({ message: messages.snackbars.success.update, options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateSessionError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.update, options: { variant: 'warning' } }));
  }
}

export function* deleteSession(action) {
  try {
    const { userId } = action.payload;

    yield call(api.mentoringSessions.destroy.bind(api.mentoringSessions), action.payload.id);

    yield put(deleteSessionSuccess());
    yield put(showSnackbar({ message: messages.snackbars.success.delete, options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteSessionError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.delete, options: { variant: 'warning' } }));
  }
}

export function* acceptInvitation(action) {
  try {
    const response = yield call(api.mentorshipSessions.acceptInvite.bind(api.mentorshipSessions), action.payload);

    yield put(acceptInvitationSuccess());
    yield put(showSnackbar({ message: messages.snackbars.success.accept, options: { variant: 'success' } }));
  } catch (err) {
    yield put(acceptInvitationError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.accept, options: { variant: 'warning' } }));
  }
}

export function* declineInvitation(action) {
  try {
    const response = yield call(api.mentorshipSessions.declineInvite.bind(api.mentorshipSessions), action.payload);

    yield put(declineInvitationSuccess());
    yield put(showSnackbar({ message: messages.snackbars.success.decline, options: { variant: 'success' } }));
  } catch (err) {
    yield put(declineInvitationError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.decline, options: { variant: 'warning' } }));
  }
}


export default function* SessionSaga() {
  yield takeLatest(GET_SESSION_BEGIN, getSession);
  yield takeLatest(GET_HOSTING_SESSIONS_BEGIN, getHostingSessions);
  yield takeLatest(GET_PARTICIPATING_SESSIONS_BEGIN, getParticipatingSessions);
  yield takeLatest(GET_PARTICIPATING_USERS_BEGIN, getParticipatingUsers);
  yield takeLatest(CREATE_SESSION_BEGIN, createSession);
  yield takeLatest(UPDATE_SESSION_BEGIN, updateSession);
  yield takeLatest(DELETE_SESSION_BEGIN, deleteSession);
  yield takeLatest(ACCEPT_INVITATION_BEGIN, acceptInvitation);
  yield takeLatest(DECLINE_INVITATION_BEGIN, declineInvitation);
}
