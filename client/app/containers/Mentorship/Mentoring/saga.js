import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

import {
  GET_USER_MENTORS_BEGIN, GET_AVAILABLE_MENTORS_BEGIN, DELETE_MENTORSHIP_BEGIN, REQUEST_MENTORSHIP_BEGIN
} from 'containers/Mentorship/Mentoring/constants';

import {
  getMentorsSuccess, getMentorsError,
  getAvailableMentorsSuccess, getAvailableMentorsError,
  deleteMentorshipSuccess, deleteMentorshipError,
  requestsMentorshipSuccess, requestsMentorshipError,
} from 'containers/Mentorship/Mentoring/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getMentors(action) {
  try {
    const { payload } = action;
    const { type, userId } = payload;

    const query = {};
    if (type === 'mentors') {
      query.mentee_id = userId;
      query.includes = ['mentor'];
    } else {
      query.mentor_id = userId;
      query.includes = ['mentee'];
    }

    const response = yield call(api.mentorings.all.bind(api.mentorings), {
      ...payload,
      ...query,
    });
    yield put(getMentorsSuccess(response.data.page));
  } catch (err) {
    yield put(getMentorsError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.mentors), options: { variant: 'warning' } }));
  }
}

export function* getAvailableMentors(action) {
  try {
    const { payload } = action;
    const { type } = payload;
    if (type === 'mentors')
      payload.query_scopes = [...(payload.query_scopes || []), 'accepting_mentor_requests'];
    else if (type === 'mentees')
      payload.query_scopes = [...(payload.query_scopes || []), 'accepting_mentee_requests'];

    delete payload.type;

    const response = yield call(api.users.all.bind(api.users), { ...payload, serializer: 'mentorship' });
    yield put(getAvailableMentorsSuccess(response.data.page));
  } catch (err) {
    yield put(getAvailableMentorsError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.available_mentors), options: { variant: 'warning' } }));
  }
}

export function* deleteMentorship(action) {
  try {
    const { payload } = action;
    const path = payload.type === 'mentors'
      ? ROUTES.user.mentorship.mentors.path(payload.userId)
      : ROUTES.user.mentorship.mentees.path(payload.userId);

    yield call(api.mentorings.removeMentorship.bind(api.mentorings), payload);

    yield put(deleteMentorshipSuccess());
    yield put(push(path));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteMentorshipError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete), options: { variant: 'warning' } }));
  }
}

export function* requestMentorship(action) {
  try {
    const { payload } = action;
    yield call(api.mentoringRequests.create.bind(api.mentoringRequests), payload);

    yield put(requestsMentorshipSuccess());
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.request), options: { variant: 'success' } }));
  } catch (err) {
    yield put(requestsMentorshipError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.request), options: { variant: 'warning' } }));
  }
}

export default function* mentorshipSaga() {
  yield takeLatest(GET_USER_MENTORS_BEGIN, getMentors);
  yield takeLatest(GET_AVAILABLE_MENTORS_BEGIN, getAvailableMentors);
  yield takeLatest(DELETE_MENTORSHIP_BEGIN, deleteMentorship);
  yield takeLatest(REQUEST_MENTORSHIP_BEGIN, requestMentorship);
}
